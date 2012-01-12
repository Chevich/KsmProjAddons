// ***************************************************************
//  HookProcessTermination    version:  1.0a  ·  date: 2005-06-06
//  -------------------------------------------------------------
//  ask user for confirmation for each (Nt)TerminateProcess call
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2005 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2005-06-06 1.0a added an ExitProcess hook to deny remote thread tricks
// 2003-06-15 1.0  initial release

program HookProcessTermination;

{$R ..\..\mad.res}

uses Windows, Messages, SysUtils, madCodeHook, madStrings;

// ***************************************************************

type
  // this is the information record which our dll sends us
  TTerminationRequest = record
    system             : boolean;
    process1, process2 : array [0..MAX_PATH] of char;
  end;

procedure HandleProcessTerminationRequest(name       : pchar;
                                          messageBuf : pointer;
                                          messageLen : dword;
                                          answerBuf  : pointer;
                                          answerLen  : dword); stdcall;
// this function is called by the ipc message whenever our dll contacts us
var s1, s2, s3 : string;
begin
  if AmUsingInputDesktop then begin
    // our process is running in the current input desktop, so we ask the user
    with TTerminationRequest(messageBuf^) do begin
      // first extract the file names only
      s1 := ExtractFileName(process1);
      s2 := ExtractFileName(process2);
      // does the request come from a normal process or from a system process?
      if system then
           s3 := 'system process '
      else s3 := 'process ';
      s3 := 'May the ' + s3 + s1 + ' terminate the following process?' + #$D#$A + #$D#$A + s2;
    end;
    // ask the user for confirmation and return the answer to our dll
    boolean(answerBuf^) := MessageBox(0, pchar(s3), 'Question...',
                                      MB_ICONQUESTION or MB_YESNO or MB_TOPMOST) = ID_YES;
  end else
    // our process is *not* running in the current input desktop
    // if we would call MessageBox, it would not be visible to the user
    // so doing that makes no sense, it could even freeze up the whole OS
    boolean(answerBuf^) := true;
end;

// ***************************************************************

procedure HideMeFrom9xTaskList;
// quick hack which hides our process from task manager (works only in win9x)
var rsp : function (processID: cardinal; flags: integer) : integer; stdcall;
begin
  rsp := GetProcAddress(GetModuleHandle(kernel32), 'RegisterServiceProcess');
  if @rsp <> nil then
    rsp(0, 1);
end;

// ***************************************************************

function InfoBoxWndProc(window, msg: dword; wParam, lParam: integer) : integer; stdcall;
// this is our info box' window proc, quite easy actually
begin
  result := 0;
  case msg of
    WM_CLOSE   : ;                       // we don't accept WM_CLOSE
    WM_COMMAND : DestroyWindow(window);  // we close when the button is pressed
    else         result := DefWindowProc(window, msg, wParam, lParam);
  end;
end;

procedure ShowInfoWindow;
// show our little info box, nothing special here
var wndClass : TWndClass;
    infoBox  : dword;
    static   : dword;
    button   : dword;
    font     : dword;
    msg      : TMsg;
    r1       : TRect;
begin
  // first let's register our window class
  ZeroMemory(@wndClass, sizeOf(TWndClass));
  with wndClass do begin
    lpfnWndProc   := @InfoBoxWndProc;
    hInstance     := SysInit.HInstance;
    hbrBackground := COLOR_BTNFACE + 1;
    lpszClassname := 'HookProcessTerminationInfoWindow';
    hCursor       := LoadCursor(0, IDC_ARROW);
  end;
  RegisterClass(wndClass);
  // next we create our window
  r1.Left   := 0;
  r1.Top    := 0;
  r1.Right  := 224;
  r1.Bottom := 142;
  AdjustWindowRectEx(r1, WS_CAPTION, false, WS_EX_WINDOWEDGE or WS_EX_DLGMODALFRAME);
  r1.Right  := r1.Right  - r1.Left;
  r1.Bottom := r1.Bottom - r1.Top;
  r1.Left   := (GetSystemMetrics(SM_CXSCREEN) - r1.Right ) div 2;
  r1.Top    := (GetSystemMetrics(SM_CYSCREEN) - r1.Bottom) div 2;
  infoBox := CreateWindowEx(WS_EX_WINDOWEDGE or WS_EX_DLGMODALFRAME,
                            wndClass.lpszClassname, 'information...',
                            WS_CAPTION, r1.Left, r1.Top, r1.Right, r1.Bottom, 0, 0, HInstance, nil);
  // now we create the controls
  static := CreateWindow('Static', 'the process termination hook is installed' + #$D#$A + #$D#$A +
                                   'please note that the win9x taskmanager' + #$D#$A +
                                   'doesn''t use the "TerminateProcess" API' + #$D#$A +
                                   'so please use something else for testing',
                         WS_CHILD or WS_VISIBLE or SS_LEFT,
                         16, 16, 196, 70, infoBox, 0, HInstance, nil);
  button := CreateWindow('Button', 'unhook and close',
                         WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,
                         14, 98, 196, 28, infoBox, 0, HInstance, nil); 
  // the controls need a nice font
  font := CreateFont(-12, 0, 0, 0, 400, 0, 0, 0, DEFAULT_CHARSET,
                     OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
                     DEFAULT_PITCH or FF_DONTCARE, 'MS Sans Serif');
  SendMessage(static, WM_SETFONT, integer(font), 0);
  SendMessage(button, WM_SETFONT, integer(font), 0);
  // finally show our window
  ShowWindow(infoBox, SW_SHOWNORMAL);
  SetFocus(button);
  while IsWindow(infoBox) do
    // this loop construction ignores WM_QUIT messages
    if GetMessage(msg, 0, 0, 0) and (not IsDialogMessage(infoBox, msg)) then begin
      TranslateMessage(msg);
      DispatchMessage(msg);
    end;
  // let's Windows clean up the font etc for us
end;

// ***************************************************************

function WaitForService(serviceName: string) : boolean;
// when the PC boots up and your program is in the autostart
// it may happen that your program runs before the service is ready
// so this function makes sure that the service is up and running
const SERVICE_START               = $10;
      SERVICE_CONTROL_INTERROGATE = 4;
      SERVICE_STOPPED             = 1;
      SERVICE_START_PENDING       = 2;
      SERVICE_RUNNING             = 4;
var c1, c2 : dword;
    ss     : array [0..6] of dword;
    i1     : integer;
    dll    : dword;
    OpenSCManagerA     : function (machine, database: pchar; access: dword) : dword; stdcall;
    OpenServiceA       : function (scMan: dword; service: pchar; access: dword) : dword; stdcall;
    ControlService     : function (service, control: dword; status: pointer) : bool; stdcall;
    StartServiceA      : function (service: dword; argCnt: dword; args: pointer) : bool; stdcall;
    CloseServiceHandle : function (handle: dword) : bool; stdcall;
begin
  result := false;
  // dynamic advapi32 API linking
  dll := LoadLibrary('advapi32.dll');
  OpenSCManagerA     := GetProcAddress(dll, 'OpenSCManagerA');
  OpenServiceA       := GetProcAddress(dll, 'OpenServiceA');
  ControlService     := GetProcAddress(dll, 'ControlService');
  StartServiceA      := GetProcAddress(dll, 'StartServiceA');
  CloseServiceHandle := GetProcAddress(dll, 'CloseServiceHandle');
  if (@OpenSCManagerA     <> nil) and
     (@OpenServiceA       <> nil) and
     (@ControlService     <> nil) and
     (@StartServiceA      <> nil) and
     (@CloseServiceHandle <> nil) then begin
    // first we contact the service control manager
    c1 := OpenSCManagerA(nil, nil, 0);
    if c1 <> 0 then begin
      // okay, that worked, now we try to open our service
      c2 := OpenServiceA(c1, pchar(serviceName), GENERIC_READ or SERVICE_START);
      if c2 <> 0 then begin
        // that worked, too, let's check its state
        if ControlService(c2, SERVICE_CONTROL_INTERROGATE, @ss) then begin
          if ss[1] = SERVICE_STOPPED then
            // the service is stopped (for whatever reason), so let's start it
            StartServiceA(c2, 0, nil);
          // now we wait until the process is in a clear state (timeout 15 sec)
          for i1 := 1 to 300 do begin
            if (not ControlService(c2, SERVICE_CONTROL_INTERROGATE, @ss)) or
               (ss[1] <> SERVICE_START_PENDING) then
              break;
            Sleep(50);
          end;
          // is it finally running or not?
          result := ss[1] = SERVICE_RUNNING;
        end;
        CloseServiceHandle(c2);
      end;
      CloseServiceHandle(c1);
    end;
  end;
  FreeLibrary(dll);
end;

// ***************************************************************

type
  // this is the information record which we send to our injection service
  TDllInjectRequest = packed record
    inject  : bool;
    timeOut : dword;
    session : dword;
  end;

function Inject(inject: boolean) : boolean;
// (un)inject our dll system wide
var dir : TDllInjectRequest;
    res : bool;
begin
  // first let's try to inject the dlls without the help of the service
  if inject then
       result :=   InjectLibrary(CURRENT_SESSION or SYSTEM_PROCESSES, 'HookTerminateAPIs.dll')
  else result := UninjectLibrary(CURRENT_SESSION or SYSTEM_PROCESSES, 'HookTerminateAPIs.dll');
  if not result then begin
    // didn't work, so let's try to ask our service for help
    // first of all we wait until the service is ready to go
    WaitForService('madDllInjectServiceDemo');
    // then we prepare a dll injection request record
    dir.inject  := inject;
    dir.timeOut := 5000;
    dir.session := GetCurrentSessionId;
    // now we try to contact our injection service
    result := SendIpcMessage('madDllInjectServiceDemo', @dir, sizeOf(dir), @res, sizeOf(res), 15000, true) and res;
  end;
end;

// ***************************************************************

var ExitProcessNext : procedure (exitCode: dword); stdcall;

procedure ExitProcessCallback(exitCode: dword); stdcall;
begin
  // this can't be a proper shutdown
  // our demo can be closed with a simple button click
  // there's no reason to use bad tricks to close us
  SetLastError(ERROR_ACCESS_DENIED);
end;

// ***************************************************************

begin
  // create an ipc queue, through which our dll can contact us
  if CreateIpcQueue(pchar('HookProcessTermination' + IntToStr(GetCurrentSessionId)),
                    HandleProcessTerminationRequest) then begin
    // the 9x task manager doesn't use TerminateProcess, so we hide from it
    HideMeFrom9xTaskList;
    // now inject our dll into all processes system wide
    if Inject(true) then begin
      // hook ExitProcess, so that other processes can't create a remote thread
      // in which they execute ExitProcess to terminate our process
      HookAPI(kernel32, 'ExitProcess', @ExitProcessCallback, @ExitProcessNext);
      // as long as the following box is shown, the hook remains installed
      ShowInfoWindow;
      // unhook the ExitProcess hook again, otherwise Windows can't properly
      // end our process
      UnhookAPI(@ExitProcessNext);
      // remove our dll again
      Inject(false);
    end else
      // if you want your stuff to run in under-privileges user accounts, too,
      // you have to do write a little service for the NT family
      // an example for that can be found in the "HookProcessTermination" demo
      MessageBox(0, 'the "InjectService" must be installed first' + #$D#$A +
                    'otherwise only administrators can run this demo',
                 'information...', MB_ICONINFORMATION);
  end else
    // ooops, we have no ipc queue! probably another instance is already up
    MessageBox(0, 'please don''t start me twice', 'information...', MB_ICONINFORMATION);
end.
