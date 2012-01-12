// ***************************************************************
//  SystemAPI                 version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  demo to show a special mode (9x only) system wide API hooking 
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
BOOL (WINAPI *CreateProcessNextHook)(LPCTSTR               lpApplicationName,
                                     LPTSTR                lpCommandLine,
                                     LPSECURITY_ATTRIBUTES lpProcessAttributes,
                                     LPSECURITY_ATTRIBUTES lpThreadAttributes,
                                     BOOL                  bInheritHandles,
                                     DWORD                 dwCreationFlags,
                                     LPVOID                lpEnvironment,
                                     LPCTSTR               lpCurrentDirectory,
                                     LPSTARTUPINFO         lpStartupInfo,
                                     LPPROCESS_INFORMATION lpProcessInformation);

// this function is our hook callback function, which will (system wide!) receive
// all calls to the original CreateProcess function, as soon as we've hooked it
// the hook function must have *exactly* the same parameters and calling
// convention as the original function
BOOL WINAPI CreateProcessHookProc(LPCTSTR               lpApplicationName,
                                  LPTSTR                lpCommandLine,
                                  LPSECURITY_ATTRIBUTES lpProcessAttributes,
                                  LPSECURITY_ATTRIBUTES lpThreadAttributes,
                                  BOOL                  bInheritHandles,
                                  DWORD                 dwCreationFlags,
                                  LPVOID                lpEnvironment,
                                  LPCTSTR               lpCurrentDirectory,
                                  LPSTARTUPINFO         lpStartupInfo,
                                  LPPROCESS_INFORMATION lpProcessInformation)
{
  char arrCh [9];

  // this function will be called from several processes, so we can't use
  // any vars, functions or consts that are only accessible in our own process
  // so we have to set up strings manually, painful...
  arrCh[0] = 'E';
  arrCh[1] = 'x';
  arrCh[2] = 'e';
  arrCh[3] = 'c';
  arrCh[4] = 'u';
  arrCh[5] = 't';
  arrCh[6] = 'e';
  arrCh[7] = '?';
  arrCh[8] = 0;
  // CAUTION!!
  // this function will be called from every process that calls CreateProcess
  // some processes might have imported kernel32.dll, but NOT user32.dll
  // and in such a process we can't call MessageBox, because it's in user32.dll
  // as a result that means, you should only call APIs of kernel32.dll in your
  // callback function, because only this dll is loaded in really every process
  // but for our demo we are ignorant and do what we should not do namely call
  // a non-kernel32.dll API in our system wide hook callback function
  if (MessageBox(0, lpCommandLine, arrCh, MB_YESNO | MB_ICONQUESTION) != IDYES) {
    // well, the user decided that the CreateProcess call should not be executed
    // so we need to set up a correct LastError value
    SetLastError(ERROR_ACCESS_DENIED);
    return false;
  } else
    // the user decided to let the CreateProcess call happen, so we do it
    // if we would call CreateProcess here, we would end up calling ourselves again
    // so we call "CreateProcessNextHook" of course
    return CreateProcessNextHook(lpApplicationName, lpCommandLine,
                                 lpProcessAttributes, lpThreadAttributes,
                                 bInheritHandles, dwCreationFlags,
                                 lpEnvironment, lpCurrentDirectory,
                                 lpStartupInfo, lpProcessInformation);
}

// ***************************************************************

int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR     lpCmdLine,
                   int       nCmdShow)
{
  if (GetVersion() & 0x80000000) {

    // InitializeMadCHook is needed only if you're using the static madCHook.lib
    InitializeMadCHook();

    // we install our API hook with a special flag (SYSTEM_WIDE_9X)
    // this works only in win9x and only for "shared APIs"
    // that are all exported APIs of dlls whose module handle is >= $80000000
    HookAPI("kernel32.dll", "CreateProcessA", CreateProcessHookProc, (PVOID*) &CreateProcessNextHook, SYSTEM_WIDE_9X);
    // now let's show a message box
    // while this message box is shown, you can start programs from the shell
    // to check whether our system wide hook is *really* system wide
    MessageBox(0, "the hook is installed\n\n" \
                  "please note that the winME shell uses\n" \
                  "ShellExecute instead of CreateProcess\n" \
                  "so our demo doesn''t hook the ME shell\n\n" \
                  "press \"ok\" to uninstall the hook again",
                  "information...", 0);
    // now we can decide: either we unhook again or not
    // if we don't, the hook remains installed (and keeps working!!) even after
    // our program has terminated
    // but in this demo we want to unhook again, so let's do it
    UnhookAPI((PVOID*) &CreateProcessNextHook);

    // FinalizeMadCHook is needed only if you're using the static madCHook.lib
    FinalizeMadCHook();

  } else
    MessageBox(0, "this demo works in win9x only", "information...", 0);

  return true;
}
