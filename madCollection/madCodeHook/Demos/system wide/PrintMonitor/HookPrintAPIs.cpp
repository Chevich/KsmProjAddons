// ***************************************************************
//  HookPrintAPIs.dll         version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  hook several print APIs and notify application about calls
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

// ***************************************************************

#include <windows.h>
#include "madCHook.h"

// ***************************************************************

typedef struct
  TPrintNotification {
    CHAR szProcess [MAX_PATH + 1];
    CHAR szApi     [MAX_PATH + 1];
    CHAR szParams  [MAX_PATH + 1];
    CHAR szResult  [MAX_PATH + 1];
  } *PPrintNotification;

void NotifyApplication(LPCSTR         pApi,
                       LPCSTR         pDeviceA,
                       LPCWSTR        pDeviceW,
                       HDC            hDC,
                       CONST DOCINFOA *pDiA,
                       CONST DOCINFOW *pDiW,
                       DWORD          dwJob,
                       BOOL           bResult)
// this function composes all the strings and sends them to our log window
{
  TPrintNotification pn;
  char           arrChA [MAX_PATH + 1];
  unsigned short arrChW [MAX_PATH + 1];
  DWORD session;

  // fill the "process" and "api" strings, the format is independent of the API
  if (!(GetVersion() & 0x80000000)) {
    GetModuleFileNameW(NULL, arrChW, MAX_PATH);
    WideToAnsi(arrChW, pn.szProcess);
  } else
    GetModuleFileNameA(NULL, pn.szProcess, MAX_PATH);
  lstrcpyA(pn.szApi, pApi);
  if ((pDeviceA) || (pDeviceW)) {
    // this is the CreateDCA/W API
    if (pDeviceA) {
      lstrcpyA(arrChA, pDeviceA);
      arrChA[11] = 0;
      if (!lstrcmpA("\\\\.\\DISPLAY", arrChA))
        // no, we don't want to display dcs!
        return;
      lstrcpyA(arrChA, pDeviceA);
    } else {
      lstrcpyW(arrChW, pDeviceW);
      arrChW[11] = 0;
      if (!lstrcmpW(L"\\\\.\\DISPLAY", arrChW))
        return;
      WideToAnsi(pDeviceW, arrChA);
    }
    // we output one parameter, namely the printer name
    lstrcpyA(pn.szParams, "printer: \"");
    lstrcatA(pn.szParams, arrChA);
    lstrcatA(pn.szParams, "\"");
    // the result is either a valid dc handle or a failure indicator
    if (hDC)
         wsprintf(pn.szResult, "dc: $%x", hDC);
    else lstrcpyA(pn.szResult, "error");
  } else {
    // all other APIs have a "dc" paramter, so we output it first
    wsprintf(pn.szParams, "dc: $%x", hDC);
    if ((pDiA) || (pDiW)) {
      // this is the StartDocA/W API, it has an additional "doc" parameter
      if (pDiA) {
        // ansi version
        if (pDiA->lpszDocName) {
          lstrcatA(pn.szParams, "; doc: \"");
          lstrcatA(pn.szParams, pDiA->lpszDocName);
          lstrcatA(pn.szParams, "\"");
        }
        if (pDiA->lpszOutput) {
          lstrcatA(pn.szParams, "; output: \"");
          lstrcatA(pn.szParams, pDiA->lpszOutput);
          lstrcatA(pn.szParams, "\"");
        }
      } else {
        // wide version
        if (pDiW->lpszDocName) {
          WideToAnsi(pDiW->lpszDocName, arrChA);
          lstrcatA(pn.szParams, "; doc: \"");
          lstrcatA(pn.szParams, arrChA);
          lstrcatA(pn.szParams, "\"");
        }
        if (pDiW->lpszOutput) {
          WideToAnsi(pDiW->lpszOutput, arrChA);
          lstrcatA(pn.szParams, "; output: \"");
          lstrcatA(pn.szParams, arrChA);
          lstrcatA(pn.szParams, "\"");
        }
      }
      // the result is either a valid job identifier or a failure indicator
      if (dwJob)
           wsprintf(pn.szResult, "job: $%x", dwJob);
      else lstrcpyA(pn.szResult, "error");
    } else
      // all the other ideas have only a boolean result
      if (bResult)
           lstrcpyA(pn.szResult, "success");
      else lstrcpyA(pn.szResult, "error"  );
  }
  // which terminal server (XP fast user switching) session shall we contact?
  if ((AmSystemProcess()) && (!GetCurrentSessionId()))
    // some system processes are independent of sessions
    // so let's contact the PrintMonitor application instance
    // which is running in the current input session
    session = GetInputSessionId();
  else
    // we're an application running in a specific session
    // let's contact the PrintMonitor application instance
    // which runs in the same session as we do
    session = GetCurrentSessionId();
  // now send the composed strings to our log window
  // hopefully there's an instance running in the specified session
  wsprintf(arrChA, "PrintMonitor%u", session);
  SendIpcMessage(arrChA, &pn, sizeof(pn));
}

// ***************************************************************

HDC (WINAPI *CreateDCANext) (LPCTSTR        lpszDriver,
                             LPCTSTR        lpszDevice,
                             LPCTSTR        lpszOutput,
                             CONST DEVMODEA *lpInitData);
HDC (WINAPI *CreateDCWNext) (LPCWSTR        lpszDriver,
                             LPCWSTR        lpszDevice,
                             LPCWSTR        lpszOutput,
                             CONST DEVMODEW *lpInitData);
int (WINAPI *StartDocANext) (HDC            hdc,
                             CONST DOCINFOA *lpdi);
int (WINAPI *StartDocWNext) (HDC            hdc,
                             CONST DOCINFOW *lpdi);
int (WINAPI *EndDocNext)    (HDC            hdc);
int (WINAPI *StartPageNext) (HDC            hdc);
int (WINAPI *EndPageNext)   (HDC            hdc);
int (WINAPI *AbortDocNext)  (HDC            hdc);

// ***************************************************************

HDC WINAPI CreateDCACallback(LPCTSTR        lpszDriver,
                             LPCTSTR        lpszDevice,
                             LPCTSTR        lpszOutput,
                             CONST DEVMODEA *lpInitData)
{
  HDC result = CreateDCANext(lpszDriver, lpszDevice, lpszOutput, lpInitData);
  // we log this call only if it is a printer DC creation
  if ((lpszDevice) && (!IsBadReadPtr(lpszDevice, 1)) && (lpszDevice[0] != 0))
    NotifyApplication("CreateDCA", lpszDevice, NULL, result, NULL, NULL, 0, false);
  return result;
}

HDC WINAPI CreateDCWCallback(LPCWSTR        lpszDriver,
                             LPCWSTR        lpszDevice,
                             LPCWSTR        lpszOutput,
                             CONST DEVMODEW *lpInitData)
{
  HDC result = CreateDCWNext(lpszDriver, lpszDevice, lpszOutput, lpInitData);
  // we log this call only if it is a printer DC creation
  if ((lpszDevice) && (!IsBadReadPtr(lpszDevice, 2)) && (lpszDevice[0] != 0))
    NotifyApplication("CreateDCW", NULL, lpszDevice, result, NULL, NULL, 0, false);
  return result;
}

int WINAPI StartDocACallback(HDC            hdc,
                             CONST DOCINFOA *lpdi)
{
  int result = StartDocANext(hdc, lpdi);
  NotifyApplication("StartDocA", NULL, NULL, hdc, lpdi, NULL, result, false);
  return result;
}

int WINAPI StartDocWCallback(HDC            hdc,
                             CONST DOCINFOW *lpdi)
{
  int result = StartDocWNext(hdc, lpdi);
  NotifyApplication("StartDocW", NULL, NULL, hdc, NULL, lpdi, result, false);
  return result;
}

int WINAPI EndDocCallback(HDC hdc)
{
  int result = EndDocNext(hdc);
  NotifyApplication("EndDoc", NULL, NULL, hdc, NULL, NULL, 0, result);
  return result;
}

int WINAPI StartPageCallback(HDC hdc)
{
  int result = StartPageNext(hdc);
  NotifyApplication("StartPage", NULL, NULL, hdc, NULL, NULL, 0, result);
  return result;
}

int WINAPI EndPageCallback(HDC hdc)
{
  int result = EndPageNext(hdc);
  NotifyApplication("EndPage", NULL, NULL, hdc, NULL, NULL, 0, result);
  return result;
}

int WINAPI AbortDocCallback(HDC hdc)
{
  int result = AbortDocNext(hdc);
  NotifyApplication("AbortDoc", NULL, NULL, hdc, NULL, NULL, 0, result);
  return result;
}

// ***************************************************************

BOOL WINAPI DllMain(HANDLE hModule, DWORD fdwReason, LPVOID lpReserved)
{
  if (fdwReason == DLL_PROCESS_ATTACH) {
    // InitializeMadCHook is needed only if you're using the static madCHook.lib
    InitializeMadCHook();

    // collecting hooks can improve the hook installation performance in win9x
    CollectHooks();
    HookAPI("gdi32.dll", "CreateDCA", CreateDCACallback, (PVOID*) &CreateDCANext);
    HookAPI("gdi32.dll", "CreateDCW", CreateDCWCallback, (PVOID*) &CreateDCWNext);
    HookAPI("gdi32.dll", "StartDocA", StartDocACallback, (PVOID*) &StartDocANext);
    HookAPI("gdi32.dll", "StartDocW", StartDocWCallback, (PVOID*) &StartDocWNext);
    HookAPI("gdi32.dll", "EndDoc",    EndDocCallback,    (PVOID*) &EndDocNext   );
    HookAPI("gdi32.dll", "StartPage", StartPageCallback, (PVOID*) &StartPageNext);
    HookAPI("gdi32.dll", "EndPage",   EndPageCallback,   (PVOID*) &EndPageNext  );
    HookAPI("gdi32.dll", "AbortDoc",  AbortDocCallback,  (PVOID*) &AbortDocNext );
    FlushHooks();

  } else if (fdwReason == DLL_PROCESS_DETACH)
    // FinalizeMadCHook is needed only if you're using the static madCHook.lib
    FinalizeMadCHook();

  return true;
}
