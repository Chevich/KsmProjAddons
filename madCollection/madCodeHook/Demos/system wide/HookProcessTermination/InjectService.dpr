// ***************************************************************
//  InjectService             version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  a little service which handles dll (un)injection requests
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

program InjectService;

{$R ..\..\mad.res}
{$R ..\..\needAdminRights.res}

uses Windows, madCodeHook, madStrings;

// ***************************************************************
// win32 service constant/type/function definitions

const
  SERVICE_WIN32_OWN_PROCESS   = $00000010;
  SERVICE_AUTO_START          = $00000002;
  SERVICE_ERROR_NORMAL        = $00000001;

  SERVICE_ACCEPT_STOP         = 1;

  SERVICE_CONTROL_STOP        = 1;
  SERVICE_CONTROL_SHUTDOWN    = 5;
  SERVICE_CONTROL_INTERROGATE = 4;

  SC_MANAGER_ALL_ACCESS       = STANDARD_RIGHTS_REQUIRED or $3f;
  SERVICE_ALL_ACCESS          = $01ff;

  SERVICE_STOPPED             = 1;
  SERVICE_START_PENDING       = 2;
  SERVICE_STOP_PENDING        = 3;
  SERVICE_RUNNING             = 4;

type
  TServiceStatus = packed record
    dwServiceType             : dword;
    dwCurrentState            : dword;
    dwControlsAccepted        : dword;
    dwWin32ExitCode           : dword;
    dwServiceSpecificExitCode : dword;
    dwCheckpoint              : dword;
    dwWaitHint                : dword;
  end;
  
  TQueryServiceConfig = packed record
    serviceType               : dword;
    startType                 : dword;
    errorControl              : dword;
    pathName                  : pchar;
    loadOrderGroup            : pchar;
    tagId                     : dword;
    dependencies              : pchar;
    startName                 : pchar;
    displayName               : pchar;
  end;

  TServiceTable = array [0..1] of packed record
    lpServiceName : pchar;
    lpServiceProc : pointer;
  end;

function CloseServiceHandle (handle: dword) : bool; stdcall; external 'advapi32.dll';
function ControlService (service, control: dword; var ss: TServiceStatus) : bool; stdcall; external 'advapi32.dll';
function DeleteService (service: dword) : bool; stdcall; external 'advapi32.dll';
function OpenSCManagerA (machine, database: pchar; access: dword) : dword; stdcall; external 'advapi32.dll';
function OpenServiceA (scMan: dword; service: pchar; access: dword) : dword; stdcall; external 'advapi32.dll';
function RegisterServiceCtrlHandlerA (service: pchar; handler: pointer) : dword; stdcall; external 'advapi32.dll';
function SetServiceStatus (handle: dword; var ss: TServiceStatus) : bool; stdcall; external 'advapi32.dll';
function StartServiceCtrlDispatcherA (var st: TServiceTable) : bool; stdcall; external 'advapi32.dll';
function StartServiceA (service: dword; argCnt: dword; args: pointer) : bool; stdcall; external 'advapi32.dll';
function CreateServiceA (scMan: dword; service, display: pchar;
                         access, serviceType, startType, errorControl: dword;
                         pathName, loadOrderGroup: pchar; tagId: pointer;
                         dependencies, startName, password: pchar) : dword; stdcall; external 'advapi32.dll';
function ChangeServiceConfigA (service, serviceType, startType, errorControl: dword;
                               pathName, loadOrderGroup: pchar; tagId: pointer;
                               dependencies, startName, password, displayName: pchar) : bool; stdcall; external 'advapi32.dll';
function QueryServiceConfigA (service: dword; var buf: TQueryServiceConfig;
                              size: dword; var needed: dword) : bool; stdcall; external 'advapi32.dll';

// ***************************************************************

// these are our service parameters
const CServiceName  : PAnsiChar = 'madDllInjectServiceDemo';
      CServiceDescr : PAnsiChar = 'madCodeHook service demo';
      CServiceType  = SERVICE_WIN32_OWN_PROCESS;
      CServiceStart = SERVICE_AUTO_START;

type
  // this is the information record which we receive via Ipc
  TDllInjectRequest = packed record
    inject  : bool;
    timeOut : dword;
    session : dword;
  end;

procedure DllInjectIpcHandler(name       : pchar;
                              const dir  : TDllInjectRequest;
                              messageLen : dword;
                              var answer : bool;
                              answerLen  : dword); stdcall;
// our application contacted us, so let's fulfill the dll injection request
begin
  // we want session wide injection, but our application may run in a different
  // session than our service, so our application tells us into which session
  // it wants to have the dll injected
  if dir.inject then
       answer :=   InjectLibrarySession(dir.session, true, 'HookTerminateAPIs.dll', dir.timeOut)
  else answer := UninjectLibrarySession(dir.session, true, 'HookTerminateAPIs.dll', dir.timeOut);
end;

// ***************************************************************

// we need this handle is several functions, so we have to make it global
var statusHandle : dword;

procedure UpdateStatus(status: dword);
// update the status of our service
var ss : TServiceStatus;
begin
  ZeroMemory(@ss, sizeOf(ss));
  ss.dwServiceType      := CServiceType;
  ss.dwCurrentState     := status;
  ss.dwControlsAccepted := SERVICE_ACCEPT_STOP;
  ss.dwWaitHint         := 8000;
  SetServiceStatus(statusHandle, ss);
end;

procedure ServiceHandler(control: dword); stdcall;
// this function gets called when our service shall be stopped or started
var event : dword;
begin
  if (control = SERVICE_CONTROL_STOP) or (control = SERVICE_CONTROL_SHUTDOWN) then begin
    // our service is about to stop
    UpdateStatus(SERVICE_STOP_PENDING);
    // first we close the ipc queue
    DestroyIpcQueue(CServiceName);
    // then we set our shutdown event
    event := OpenGlobalEvent(pchar(CServiceName + 'ShutdownEvent'));
    SetEvent(event);
    CloseHandle(event);
  end else
    UpdateStatus(SERVICE_RUNNING);
end;

procedure ServiceProc(argCnt: dword; args: pointer); stdcall;
// this is the main function of our service, we do all the work here...
var event  : dword;
    c1, c2 : dword;
begin
  // the first thing we shall do here is to register a service control handler
  statusHandle := RegisterServiceCtrlHandlerA(CServiceName, @ServiceHandler);
  if statusHandle <> 0 then begin
    UpdateStatus(SERVICE_START_PENDING);
    // now we create our ipc queue
    if CreateIpcQueue(CServiceName, @DllInjectIpcHandler) then begin
      // create a shutdown event, which we need later
      event := CreateGlobalEvent(pchar(CServiceName + 'ShutdownEvent'), true, false);
      // okay, initialization is done
      UpdateStatus(SERVICE_RUNNING);
      // here our service does the real work
      // our injection service does nothing but listen to our ipc queue
      // the ipc queue has its own thread, so we just wait for the shutdown event
      WaitForSingleObject(event, INFINITE);
      CloseHandle(event);
    end else begin
      // creating the ipc queue didn't work for whatever reason
      // so we remove ourselves again
      c1 := OpenSCManagerA(nil, nil, SC_MANAGER_ALL_ACCESS);
      if c1 <> 0 then begin
        c2 := OpenServiceA(c1, CServiceName, SERVICE_ALL_ACCESS or _DELETE);
        if c2 <> 0 then begin
          DeleteService(c2);
          CloseServiceHandle(c2);
        end;
        CloseServiceHandle(c1);
      end;
    end;
    UpdateStatus(SERVICE_STOPPED);
  end;
end;

procedure RunService;
// this is the main thread of our injection service
// we have to call StartServiceCtrlDispatcher as soon as possible here
var st : TServiceTable;
begin
  ZeroMemory(@st, sizeOf(st));
  st[0].lpServiceName := CServiceName;
  st[0].lpServiceProc := @ServiceProc;
  StartServiceCtrlDispatcherA(st);
end;

// ***************************************************************

procedure InstallService;
// this function is executed, if someone starts our service exe manually
// if our service is installed, we uninstall it and vice versa
var arrCh      : array [0..MAX_PATH] of char;
    c1, c2, c3 : dword;
    qsc        : ^TQueryServiceConfig;
    ss         : TServiceStatus;
    i1         : integer;
    b1         : boolean;
begin
  GetModuleFileName(HInstance, arrCh, MAX_PATH);
  // first we contact the service control manager
  c1 := OpenSCManagerA(nil, nil, SC_MANAGER_ALL_ACCESS);
  if c1 = 0 then
    // didn't work, maybe we asked for too many access rights?
    c1 := OpenSCManagerA(nil, nil, 0);
  if c1 <> 0 then begin
    // okay, that worked, now we try to open our service
    c2 := OpenServiceA(c1, CServiceName, SERVICE_ALL_ACCESS or _DELETE);
    if c2 <> 0 then begin
      // our service is already installed, let's check the parameters
      b1 := false;
      c3 := 0;
      QueryServiceConfigA(c2, TQueryServiceConfig(nil^), 0, c3);
      if c3 <> 0 then begin
        qsc := pointer(LocalAlloc(LPTR, c3 * 2));
        b1 := QueryServiceConfigA(c2, qsc^, c3 * 2, c3) and
              ( (qsc^.serviceType <> CServiceType ) or
                (qsc^.startType   <> CServiceStart) or
                (PosText(qsc^.pathName, arrCh) = 0) or
                (not IsTextEqual(qsc^.displayName, CServiceDescr)) );
        LocalFree(dword(qsc));
      end;
      if not ControlService(c2, SERVICE_CONTROL_INTERROGATE, ss) then
        ss.dwCurrentState := SERVICE_STOPPED;
      if (not b1) and (ss.dwCurrentState = SERVICE_RUNNING) then begin
        // the parameters are correct, so we try to stop and remove it
        if ControlService(c2, SERVICE_CONTROL_STOP, ss) then begin
          if DeleteService(c2) then
               MessageBox(0, 'the service is removed again',                'information...', MB_ICONINFORMATION)
          else MessageBox(0, 'the service is stopped, but removing failed', 'warning...',     MB_ICONWARNING);
        end else
          MessageBox(0, 'stopping failed', 'warning...', MB_ICONWARNING);
      end else begin
        if b1 then
          // not all parameters are correct, so we try to correct them
          if ChangeServiceConfigA(c2, CServiceType, CServiceStart, SERVICE_ERROR_NORMAL,
                                  arrCh, nil, nil, nil, nil, nil, CServiceDescr) then
               MessageBox(0, 'correction of service parameters succeeded', 'information...', MB_ICONINFORMATION)
          else MessageBox(0, 'correction of service parameters failed',    'warning...',     MB_ICONWARNING);
        if ss.dwCurrentState <> SERVICE_RUNNING then
          // our service was installed, but not running, so we start it
          if StartServiceA(c2, 0, nil) then
               MessageBox(0, 'the service was restarted', 'information...', MB_ICONINFORMATION)
          else MessageBox(0, 'restarting failed',         'warning...',     MB_ICONWARNING);
      end;
      CloseServiceHandle(c2);
    end else begin
      // probably our service is not installed yet, so we do that now
      c2 := CreateServiceA(c1, CServiceName, CServiceDescr,
                           SERVICE_ALL_ACCESS or STANDARD_RIGHTS_ALL,
                           CServiceType, CServiceStart,
                           SERVICE_ERROR_NORMAL, arrCh, nil, nil, nil, nil, nil);
      if c2 <> 0 then begin
        // installation went smooth
        // we want to give everyone full access to our service
        if not AddAccessForEveryone(c2, SERVICE_ALL_ACCESS or _DELETE) then
          MessageBox(0, 'access manipulation didn''t work', 'warning...', MB_ICONWARNING);
        // now let's start the service
        if StartServiceA(c2, 0, nil) then begin
          // starting succeeded, but does the service run through?
          // the service tries to create an ipc queue
          // if that fails, it stops and removes itself
          for i1 := 1 to 50 do begin
            if not ControlService(c2, SERVICE_CONTROL_INTERROGATE, ss) then
              ss.dwCurrentState := SERVICE_STOPPED;
            if (ss.dwCurrentState = SERVICE_RUNNING) or (ss.dwCurrentState = SERVICE_STOPPED) then
              break;
            Sleep(50);
          end;
          if ss.dwCurrentState = SERVICE_RUNNING then
               MessageBox(0, 'the service is installed now',      'information...', MB_ICONINFORMATION)
          else MessageBox(0, 'installation failed (ipc failure)', 'warning...',     MB_ICONWARNING);
        end else
          MessageBox(0, 'installation succeeded, but starting failed', 'warning...', MB_ICONWARNING);
        CloseServiceHandle(c2);
      end else
        MessageBox(0, 'you don''t have enough privileges', 'sorry...', MB_ICONWARNING);
    end;
    CloseServiceHandle(c1);
  end else
    MessageBox(0, 'you don''t have enough privileges', 'sorry...', MB_ICONWARNING);
end;

// ***************************************************************

begin
  if AmSystemProcess then
       RunService       // we're the real service running in the system account
  else InstallService;  // the user started us manually
end.
