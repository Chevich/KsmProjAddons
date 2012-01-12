// ***************************************************************
//  HookProcessCreation.dll   version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  hook all process creation calls and ask for confirmation
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

library HookProcessCreation;

{$IMAGEBASE $57800000}

uses Windows, madCodeHook;

// ***************************************************************

function IsAllowed(appNameA, cmdLineA: pchar; appNameW, cmdLineW: PWideChar) : boolean;
// ask the user whether the current process may execute the specified command line
var arrChA   : array [0..MAX_PATH] of char;
    arrChW   : array [0..500] of wideChar;
    pc       : pchar;
    question : array [0..500] of char;
    i1, i2   : integer;
begin
  if not AmSystemProcess then begin
    // ask the name of the current process
    if GetVersion and $80000000 = 0 then begin
      GetModuleFileNameW(0, arrChW, MAX_PATH);
      WideToAnsi(arrChW, arrChA);
    end else
      GetModuleFileNameA(0, arrChA, MAX_PATH);
    // we only want the file name
    i2 := 0;
    for i1 := lstrlenA(arrChA) - 1 downto 0 do
      if arrChA[i1] = '\' then begin
        i2 := i1 + 1;
        break;
      end;
    lstrcpyA(question, 'May the process ');
    lstrcatA(question, @arrChA[i2]);
    lstrcatA(question, ' execute the following line?' + #$D#$A + #$D#$A);
    // let's get a command line string which we can show to the user
    try
      if cmdLineA <> nil then begin
        pc := pointer(LocalAlloc(LPTR, lstrlenA(cmdLineA) + 1));
        lstrcpyA(pc, cmdLineA);
      end else
        if cmdLineW <> nil then begin
          pc := pointer(LocalAlloc(LPTR, lstrlenW(cmdLineW) + 1));
          WideToAnsi(cmdLineW, pc)
        end else
          if appNameA <> nil then begin
            pc := pointer(LocalAlloc(LPTR, lstrlenA(appNameA) + 1));
            lstrcpyA(pc, appNameA);
          end else begin
            pc := pointer(LocalAlloc(LPTR, lstrlenW(appNameW) + 1));
            WideToAnsi(appNameW, pc);
          end;
      if lstrlenA(pc) > MAX_PATH then
        pc[MAX_PATH] := #0;
      lstrcatA(question, pc);
      LocalFree(dword(pc));
    except
      lstrcatA(question, '??? (invalid command line!)');
    end;
    // finally let's ask the user
    if GetVersion and $80000000 = 0 then begin
      AnsiToWide(question, arrChW);
      result := MessageBoxW(0, arrChW, 'Question', MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL or MB_TOPMOST) = ID_YES;
    end else
      result := MessageBoxA(0, question, 'Question', MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL or MB_TOPMOST) = ID_YES;
  end else
    // let's allow system processes to execute whatever they want
    result := true;
end;

// ***************************************************************

var
  CreateProcessANext  : function (appName, cmdLine: pchar;
                                  processAttr, threadAttr: PSecurityAttributes;
                                  inheritHandles: bool; creationFlags: dword;
                                  environment: pointer; currentDir: pchar;
                                  const startupInfo: TStartupInfo;
                                  var processInfo: TProcessInformation) : bool; stdcall;
  CreateProcessWNext  : function (appName, cmdLine: pwidechar;
                                  processAttr, threadAttr: PSecurityAttributes;
                                  inheritHandles: bool; creationFlags: dword;
                                  environment: pointer; currentDir: pwidechar;
                                  const startupInfo: TStartupInfo;
                                  var processInfo: TProcessInformation) : bool; stdcall;
  WinExecNext         : function (cmdLine: pchar; show: dword) : dword; stdcall;

function CreateProcessACallback(appName, cmdLine: pchar;
                                processAttr, threadAttr: PSecurityAttributes;
                                inheritHandles: bool; creationFlags: dword;
                                environment: pointer; currentDir: pchar;
                                const startupInfo: TStartupInfo;
                                var processInfo: TProcessInformation) : bool; stdcall;
begin
  if not IsAllowed(appName, cmdLine, nil, nil) then begin
    // the user doesn't like this CreateProcess call, so we block it
    result := false;
    SetLastError(ERROR_ACCESS_DENIED);
  end else begin
    // this CreateProcess call is okay
    result := CreateProcessANext(appName, cmdLine, processAttr, threadAttr,
                                 inheritHandles, creationFlags,
                                 environment, currentDir,
                                 startupInfo, processInfo);
    // CreateProcess hooks are used very often, so to be sure we renew the hook
    RenewHook(@CreateProcessANext);
  end;
end;

function CreateProcessWCallback(appName, cmdLine: pwidechar;
                                processAttr, threadAttr: PSecurityAttributes;
                                inheritHandles: bool; creationFlags: dword;
                                environment: pointer; currentDir: pwidechar;
                                const startupInfo: TStartupInfo;
                                var processInfo: TProcessInformation) : bool; stdcall;
begin
  if not IsAllowed(nil, nil, appName, cmdLine) then begin
    result := false;
    SetLastError(ERROR_ACCESS_DENIED);
  end else begin
    result := CreateProcessWNext(appName, cmdLine, processAttr, threadAttr,
                                 inheritHandles, creationFlags,
                                 environment, currentDir,
                                 startupInfo, processInfo);
    RenewHook(@CreateProcessWNext);
  end;
end;

function WinExecCallback(cmdLine: pchar; show: dword) : dword; stdcall;
begin
  if not IsAllowed(nil, cmdLine, nil, nil) then
    result := ERROR_ACCESS_DENIED
  else begin
    result := WinExecNext(cmdLine, show);
    RenewHook(@WinExecNext);
  end;
end;

// ***************************************************************

begin
  HookAPI('kernel32.dll', 'CreateProcessA', @CreateProcessACallback, @CreateProcessANext);
  HookAPI('kernel32.dll', 'CreateProcessW', @CreateProcessWCallback, @CreateProcessWNext);
  HookAPI('kernel32.dll', 'WinExec',        @WinExecCallback,        @WinExecNext       );
end.
