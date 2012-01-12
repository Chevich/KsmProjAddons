// ***************************************************************
//  ProcessAPI                version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  simple demo to show process wide API hooking
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

// ***************************************************************

#include <windows.h>
#include "madCHook.h"

// ***************************************************************

// variable for the "next hook", which we then call in the callback function
// it must have *exactly* the same parameters and calling convention as the
// original function
// besides, it's also the parameter that you need to undo the code hook again
UINT (WINAPI *WinExecNextHook)(LPCSTR lpCmdLine, UINT uCmdShow);

// this function is our hook callback function, which will receive
// all calls to the original SomeFunc function, as soon as we've hooked it
// the hook function must have *exactly* the same parameters and calling
// convention as the original function
UINT WINAPI WinExecHookProc(LPCSTR lpCmdLine, UINT uCmdShow)
{
  // check the input parameters and ask whether the call should be executed
  if (MessageBox(0, lpCmdLine, "Execute?", MB_YESNO | MB_ICONQUESTION) == IDYES)
    // it shall be executed, so let's do it
    return WinExecNextHook(lpCmdLine, uCmdShow);
  else
    // we don't execute the call, but we should at least return a valid value
    return ERROR_ACCESS_DENIED;
}

// ***************************************************************

int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR     lpCmdLine,
                   int       nCmdShow)
{
  // InitializeMadCHook is needed only if you're using the static madCHook.lib
  InitializeMadCHook();

  // we install our hook on the API...
  // please note that in this demo the hook only effects our own process!
  HookAPI("kernel32.dll", "WinExec", WinExecHookProc, (PVOID*) &WinExecNextHook);
  // now call the original (but hooked) API
  // as a result of the hook the user will receive our messageBox etc
  WinExec("notepad.exe", SW_SHOWNORMAL);
  // we like clean programming, don't we?
  // so we cleanly unhook again
  UnhookAPI((PVOID*) &WinExecNextHook);

  // FinalizeMadCHook is needed only if you're using the static madCHook.lib
  FinalizeMadCHook();

  return true;
}
