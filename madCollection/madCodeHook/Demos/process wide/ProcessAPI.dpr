// ***************************************************************
//  ProcessAPI                version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  simple demo to show process wide API hooking
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

program ProcessAPI;

{$R ..\mad.res}

uses Windows, madCodeHook;

// variable for the "next hook", which we then call in the callback function
// it must have *exactly* the same parameters and calling convention as the
// original function
// besides, it's also the parameter that you need to undo the code hook again
var WinExecNextHook : function (cmdLine: pchar; showCmd: dword) : dword; stdcall;

// this function is our hook callback function, which will receive
// all calls to the original WinExec API, as soon as we've hooked it
// the hook function must have *exactly* the same parameters and calling
// convention as the original API
function WinExecHookProc(cmdLine: pchar; showCmd: dword) : dword; stdcall;
begin
  // check the input parameters and ask whether the call should be executed
  if MessageBox(0, cmdLine, 'Execute?', MB_YESNO or MB_ICONQUESTION) = IDYES then
    // it shall be executed, so let's do it
    result := WinExecNextHook(cmdLine, showCmd)
  else
    // we don't execute the call, but we should at least return a valid value
    result := ERROR_ACCESS_DENIED;
end;

begin
  // we install our hook on the API...
  // please note that in this demo the hook only effects our own process!
  HookAPI('kernel32.dll', 'WinExec', @WinExecHookProc, @WinExecNextHook);
  // now call the original (but hooked) API
  // as a result of the hook the user will receive our messageBox etc
  WinExec('notepad.exe', SW_SHOWNORMAL);
  // we like clean programming, don't we?
  // so we cleanly unhook again
  UnhookAPI(@WinExecNextHook);
end.