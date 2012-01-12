// ***************************************************************
//  RemoteCmdLine             version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  demo: executing code in the context of another process
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

// ***************************************************************

// MSVC++ users please don't use "/GZ" when using "RemoteExecute"
// or "CopyFunction", because that adds additional stuff into the
// to-be-copied function, which is not available in the target
// process.

// ***************************************************************

#include <windows.h>
#include "madCHook.h"

// ***************************************************************

// this is our remote function
// it can be executed in the context of any desired process
DWORD WINAPI RemoteGetCmdLine(LPTSTR pBuffer)
{
  // let's copy the command line of the current process to the specified buffer
  lstrcpyA(pBuffer, GetCommandLine());

  return 0;
}

// this function can give us the command line of any specified 32bit process
void GetProcessCmdLine(HANDLE hProcess, LPTSTR pBuffer)
{
  DWORD dummy;

  // we simply execute "GetCmdLineThread" in the context of the target process
  // if it succeeds, "pBuffer" will contain the command line 
  if (!RemoteExecute(hProcess, (PREMOTE_EXECUTE_ROUTINE) &RemoteGetCmdLine, &dummy, pBuffer, MAX_PATH))
    // if it didn't work we clean the result string
    pBuffer[0] = 0;
}

void ShowExplorerCmdLine()
// this demo shows us the command line of the explorer
// this is not possible when using normal win32 APIs
{
  HWND   wnd;
  DWORD  pid;
  HANDLE ph;
  char   arrCh [MAX_PATH + 1];

  // first we ask the taskbar's window handle and the corresponding process ID
  wnd = FindWindow("Shell_TrayWnd", "");
  GetWindowThreadProcessId(wnd, &pid);

  // then we open the process, which is the explorer, of course
  ph = OpenProcess(PROCESS_ALL_ACCESS, false, pid);

  // next we ask the command line of the explorer
  GetProcessCmdLine(ph, arrCh);

  // and finally we show it's command line
  MessageBox(0, arrCh, "explorer's command line...", 0);

  // I like it the clean style
  CloseHandle(ph);
}

// ***************************************************************

int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR     lpCmdLine,
                   int       nCmdShow)
{
  // InitializeMadCHook is needed only if you're using the static madCHook.lib
  InitializeMadCHook();

  ShowExplorerCmdLine();

  // FinalizeMadCHook is needed only if you're using the static madCHook.lib
  FinalizeMadCHook();

  return true;
}
