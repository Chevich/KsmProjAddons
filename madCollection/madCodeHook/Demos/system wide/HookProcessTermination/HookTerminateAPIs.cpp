// ***************************************************************
//  HookTerminateAPIs.dll     version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  hook (Nt)TerminateProcess and notify application about calls
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

// ***************************************************************

#include <windows.h>
#include "madCHook.h"

// ***************************************************************

typedef struct
  // this is the information we send to our application
  TTerminationRequest {
    BYTE bSystem;
    CHAR szProcess1 [MAX_PATH + 1];
    CHAR szProcess2 [MAX_PATH + 1];
  } *PTerminationRequest;

BOOL IsAllowed(HANDLE hProcess)
// ask the user whether the current process may terminate the specified process
{
  TTerminationRequest tr;
  unsigned short arrChW [MAX_PATH + 1];
  BOOL  result;
  DWORD session;
  CHAR  arrChA [MAX_PATH];

  if ((hProcess) && (hProcess != GetCurrentProcess())) {
    tr.bSystem = AmSystemProcess();
    if (!(GetVersion() & 0x80000000)) {
      GetModuleFileNameW(NULL, arrChW, MAX_PATH);
      WideToAnsi(arrChW, tr.szProcess1);
    } else
      GetModuleFileNameA(NULL, tr.szProcess1, MAX_PATH);
    ProcessIdToFileName(ProcessHandleToId(hProcess), tr.szProcess2);
    // which terminal server (XP fast user switching) session shall we contact?
    if ((AmSystemProcess()) && (!GetCurrentSessionId()))
      // some system processes are independent of sessions
      // so let's contact the HookProcessTermination application instance
      // which is running in the current input session
      session = GetInputSessionId();
    else
      // we're an application running in a specific session
      // let's contact the HookProcessTermination application instance
      // which runs in the same session as we do
      session = GetCurrentSessionId();
    // contact our application, which then will ask the user for confirmation
    // hopefully there's an instance running in the specified session
    wsprintf(arrChA, "HookProcessTermination%u", session);
    if (!SendIpcMessage(arrChA,
                        &tr,     sizeof(tr),        // our message
                        &result, sizeof(result)))   // the answer
      // we can't reach our application, so we allow the termination
      result = true;
    return result;
  } else
    // our process may terminate itself
    // this happens during normal closing, so we have to allow it
    return true;
}

// ***************************************************************

BOOL  (WINAPI   *TerminateProcessNext) (HANDLE hProcess,
                                        UINT   uExitCode);
DWORD (WINAPI *NtTerminateProcessNext) (HANDLE hProcess,
                                        UINT   uExitCode);

#define STATUS_ACCESS_DENIED 0xC0000022

// ***************************************************************

BOOL WINAPI TerminateProcessCallback(HANDLE hProcess,
                                     UINT   uExitCode)
{
  if (!IsAllowed(hProcess)) {
    // the user doesn't like this TerminateProcess call, so we block it
    SetLastError(ERROR_ACCESS_DENIED);
    return false;
  } else
    // the user gave his okay
    return TerminateProcessNext(hProcess, uExitCode);
}

DWORD WINAPI NtTerminateProcessCallback(HANDLE hProcess,
                                        UINT   uExitCode)
{
  if (!IsAllowed(hProcess))
       return STATUS_ACCESS_DENIED;
  else return NtTerminateProcessNext(hProcess, uExitCode);
}

// ***************************************************************

// ***************************************************************

BOOL WINAPI DllMain(HANDLE hModule, DWORD fdwReason, LPVOID lpReserved)
{
  if (fdwReason == DLL_PROCESS_ATTACH) {
    // InitializeMadCHook is needed only if you're using the static madCHook.lib
    InitializeMadCHook();

    // the XP task manager's "end process" calls TerminateProcess but "end task"
    // calls NtTerminateProcess, so we hook the lower level API in the NT family
    // the 9x task manager doesn't use any official API, so we can't hook it  :-(
    if (!(GetVersion() & 0x80000000))
         HookAPI(   "ntdll.dll", "NtTerminateProcess", NtTerminateProcessCallback, (PVOID*) &NtTerminateProcessNext);
    else HookAPI("kernel32.dll",   "TerminateProcess",   TerminateProcessCallback, (PVOID*)   &TerminateProcessNext);

  } else if (fdwReason == DLL_PROCESS_DETACH)
    // FinalizeMadCHook is needed only if you're using the static madCHook.lib
    FinalizeMadCHook();

  return true;
}