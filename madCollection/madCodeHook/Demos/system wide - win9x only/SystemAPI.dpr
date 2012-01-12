// ***************************************************************
//  SystemAPI                 version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  demo to show a special mode (9x only) system wide API hooking 
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

program SystemAPI;

{$R ..\mad.res}

uses Windows, madCodeHook;

// ***************************************************************

// variable for the "next hook", which we then call in the callback function
// it must have *exactly* the same parameters and calling convention as the
// original function
// besides, it's also the parameter that you need to undo the code hook again
var CreateProcessNextHook : function (applicationName   : pchar;
                                      commandLine       : pchar;
                                      processAttr       : PSecurityAttributes;
                                      threadAttr        : PSecurityAttributes;
                                      inheritHandles    : bool;
                                      creationFlags     : dword;
                                      environment       : pointer;
                                      currentDirectory  : pchar;
                                      const startupInfo : TStartupInfo;
                                      var processInfo   : TProcessInformation) : bool; stdcall;

// this function is our hook callback function, which will (system wide!) receive
// all calls to the original CreateProcess API, as soon as we've hooked it
// the hook function must have *exactly* the same parameters and calling
// convention as the original API
function CreateProcessHookProc(applicationName   : pchar;
                               commandLine       : pchar;
                               processAttr       : PSecurityAttributes;
                               threadAttr        : PSecurityAttributes;
                               inheritHandles    : bool;
                               creationFlags     : dword;
                               environment       : pointer;
                               currentDirectory  : pchar;
                               const startupInfo : TStartupInfo;
                               var processInfo   : TProcessInformation) : bool; stdcall;
var arrCh : array [0..8] of char;
begin
  // this function will be called from several processes, so we can't use
  // any vars, functions or consts that are only accessible in our own process
  // so we have to set up strings manually, painful...
  arrCh[0] := 'E';
  arrCh[1] := 'x';
  arrCh[2] := 'e';
  arrCh[3] := 'c';
  arrCh[4] := 'u';
  arrCh[5] := 't';
  arrCh[6] := 'e';
  arrCh[7] := '?';
  arrCh[8] := #0;
  // CAUTION!!
  // this function will be called from every process that calls CreateProcess
  // some processes might have imported kernel32.dll, but NOT user32.dll
  // and in such a process we can't call MessageBox, because it's in user32.dll
  // as a result that means, you should only call APIs of kernel32.dll in your
  // callback function, because only this dll is loaded in really every process
  // but for our demo we are ignorant and do what we should not do namely call
  // a non-kernel32.dll API in our system wide hook callback function
  if MessageBox(0, commandLine, arrCh, MB_YESNO or MB_ICONQUESTION) <> IDYES then begin
    // well, the user decided that the CreateProcess call should not be executed
    // so we need to set up a correct LastError value
    SetLastError(ERROR_ACCESS_DENIED);
    result := false;
  end else
    // the user decided to let the CreateProcess call happen, so we do it
    // if we would call CreateProcess here, we would end up calling ourselves again
    // so we call "CreateProcessNextHook" of course
    result := CreateProcessNextHook(applicationNAme, commandLine,
                                    processAttr, threadAttr,
                                    inheritHandles, creationFlags,
                                    environment, currentDirectory,
                                    startupInfo, processInfo);
end;

begin
  if GetVersion and $80000000 <> 0 then begin
    // we install our API hook with a special flag (SYSTEM_WIDE_9X)
    // this works only in win9x and only for "shared APIs"
    // that are all exported APIs of dlls whose module handle is >= $80000000
    HookAPI('kernel32.dll', 'CreateProcessA', @CreateProcessHookProc, @CreateProcessNextHook, SYSTEM_WIDE_9X);
    // now let's show a message box
    // while this message box is shown, you can start programs from the shell
    // to check whether our system wide hook is *really* system wide
    MessageBox(0, 'the hook is installed' + #$D#$A + #$D#$A +
                  'please start a program now to check' + #$D#$A +
                  'whether the hook works as intended' + #$D#$A + #$D#$A +
                  'press "ok" to uninstall the hook again',
                  'information...', 0);
    // now we can decide: either we unhook again or not
    // if we don't, the hook remains installed (and keeps working!!) even after
    // our program has terminated
    // but in this demo we want to unhook again, so let's do it
    UnhookAPI(@CreateProcessNextHook);
  end else
    MessageBox(0, 'this demo works in win9x only', 'information...', 0);
end.
