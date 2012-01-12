// ***************************************************************
//  HookProcessTermination    version:  1.0a  ·  date: 2005-06-06
//  -------------------------------------------------------------
//  ask user for confirmation for each (Nt)TerminateProcess call
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2005 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2005-06-06 1.0a added an ExitProcess hook to deny remote thread tricks
// 2003-06-15 1.0  initial release

// ***************************************************************

#include <windows.h>
#include "madCHook.h"

// ***************************************************************

typedef struct
  // this is the information record which our dll sends us
  TTerminationRequest {
    BYTE bSystem;
    CHAR szProcess1 [MAX_PATH + 1];
    CHAR szProcess2 [MAX_PATH + 1];
  } *PTerminationRequest;

void WINAPI HandleProcessTerminationRequest(LPCSTR  pIpc,
                                            PVOID   pMessageBuf,
                                            DWORD   dwMessageLen,
                                            PVOID   pAnswerBuf,
                                            DWORD   dwAnswerLen)
// this function is called by the ipc message whenever our dll contacts us
{
  PBOOL answer = (PBOOL) pAnswerBuf;
  if (AmUsingInputDesktop()) {
    // our process is running in the current input desktop, so we ask the user
    LPCSTR pc1, pc2, pc3;
    PTerminationRequest ptr = (PTerminationRequest) pMessageBuf;
    CHAR question [MAX_PATH + 1];

    // first extract the file names only
    for (pc1 = ptr->szProcess1 + lstrlenA(ptr->szProcess1) - 1; pc1 > ptr->szProcess1; pc1--)
      if (*pc1 == '\\') {
        pc1++;
        break;
      }
    for (pc2 = ptr->szProcess2 + lstrlenA(ptr->szProcess2) - 1; pc2 > ptr->szProcess2; pc2--)
      if (*pc2 == '\\') {
        pc2++;
        break;
      }
    // does the request come from a normal process or from a system process?
    if (ptr->bSystem)
         pc3 = "system process ";
    else pc3 = "process ";
    lstrcpyA(question, "May the ");
    lstrcatA(question, pc3);
    lstrcatA(question, pc1);
    lstrcatA(question, " terminate the following process?\n\n");
    lstrcatA(question, pc2);
    // ask the user for confirmation and return the answer to our dll
    *answer = (MessageBox(0, question, "Question...", MB_ICONQUESTION | MB_YESNO | MB_TOPMOST) == IDYES);
  } else
    // our process is *not* running in the current input desktop
    // if we would call MessageBox, it would not be visible to the user
    // so doing that makes no sense, it could even freeze up the whole OS
    *answer = true;
}

// ***************************************************************

void HideMeFrom9xTaskList()
// quick hack which hides our process from task manager (works only in win9x)
{
  typedef INT (WINAPI *TRegisterServiceProcess)(DWORD pid, DWORD flags);

  TRegisterServiceProcess rsp = (TRegisterServiceProcess) GetProcAddress(GetModuleHandle("kernel32.dll"), "RegisterServiceProcess");
  if (rsp) 
    rsp(0, 1);
}

// ***************************************************************

INT WINAPI InfoBoxWndProc(HWND window, DWORD msg, INT wParam, INT lParam)
// this is our info box' window proc, quite easy actually
{
  if (msg == WM_CLOSE)
    return 0;                      // we don't accept WM_CLOSE
  else if (msg == WM_COMMAND) {
    DestroyWindow(window);         // we close when the button is pressed
    return 0;
  } else
    return DefWindowProc(window, msg, wParam, lParam);
}

void ShowInfoWindow()
// show our little info box, nothing special here
{
  WNDCLASS wndClass;
  HWND infoBox, label, button;
  HFONT font;
  MSG msg;
  RECT r1;

  // first let's register our window class
  ZeroMemory(&wndClass, sizeof(WNDCLASS));
  wndClass.lpfnWndProc   = (WNDPROC) &InfoBoxWndProc;
  wndClass.hInstance     = GetModuleHandle(NULL);
  wndClass.hbrBackground = (HBRUSH) (COLOR_BTNFACE + 1);
  wndClass.lpszClassName = "HookProcessTerminationInfoWindow";
  wndClass.hCursor       = LoadCursor(0, IDC_ARROW);
  RegisterClass(&wndClass);
  // next we create our window
  r1.left   = 0;
  r1.top    = 0;
  r1.right  = 224;
  r1.bottom = 142;
  AdjustWindowRectEx(&r1, WS_CAPTION, false, WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME);
  r1.right  = r1.right  - r1.left;
  r1.bottom = r1.bottom - r1.top;
  r1.left   = (GetSystemMetrics(SM_CXSCREEN) - r1.right ) / 2;
  r1.top    = (GetSystemMetrics(SM_CYSCREEN) - r1.bottom) / 2;
  infoBox = CreateWindowEx(WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME,
                           wndClass.lpszClassName, "information...",
                           WS_CAPTION, r1.left, r1.top, r1.right, r1.bottom, 0, 0, GetModuleHandle(NULL), NULL);
  // now we create the controls
  label = CreateWindow("Static", "the process termination hook is installed\n\n" \
                                 "please note that the win9x taskmanager\n" \
                                 "doesn't use the \"TerminateProcess\" API\n" \
                                 "so please use something else for testing",
                       WS_CHILD | WS_VISIBLE | SS_LEFT,
                       16, 16, 196, 70, infoBox, 0, GetModuleHandle(NULL), NULL);
  button = CreateWindow("Button", "unhook and close",
                        WS_CHILD | WS_VISIBLE | BS_DEFPUSHBUTTON,
                        14, 98, 196, 28, infoBox, 0, GetModuleHandle(NULL), NULL);
  SetFocus(button);
  // the controls need a nice font
  font = CreateFont(-12, 0, 0, 0, 400, 0, 0, 0, DEFAULT_CHARSET,
                    OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
                    DEFAULT_PITCH | FF_DONTCARE, "MS Sans Serif");
  SendMessage(label,  WM_SETFONT, (UINT) font, 0);
  SendMessage(button, WM_SETFONT, (UINT) font, 0);
  // finally show our window
  ShowWindow(infoBox, SW_SHOWNORMAL);
  while (IsWindow(infoBox))
    // this loop construction ignores WM_QUIT messages
    if ((GetMessage(&msg, 0, 0, 0)) && (!IsDialogMessage(infoBox, &msg))) {
      TranslateMessage(&msg);
      DispatchMessage(&msg);
    }
  // let's Windows clean up the font etc for us
}

// ***************************************************************

BOOL WaitForService(LPTSTR serviceName)
// when the PC boots up and your program is in the autostart
// it may happen that your program runs before the service is ready
// so this function makes sure that the service is up and running
{
  SC_HANDLE      c1, c2;
  SERVICE_STATUS ss;
  INT     	     i1;
  HMODULE        dll;
  BOOL           result;

  typedef SC_HANDLE (WINAPI *OpenSCManagerAFunc    )(LPCSTR lpMachineName, LPCSTR lpDatabaseName, DWORD dwDesiredAccess);
  typedef SC_HANDLE (WINAPI *OpenServiceAFunc      )(SC_HANDLE hSCManager, LPCSTR lpServiceName,  DWORD dwDesiredAccess);
  typedef BOOL      (WINAPI *ControlServiceFunc    )(SC_HANDLE hService, DWORD dwControl, LPSERVICE_STATUS lpServiceStatus);
  typedef BOOL		(WINAPI *StartServiceAFunc     )(SC_HANDLE hService, DWORD dwNumServiceArgs, LPCSTR *lpServiceArgVectors);
  typedef BOOL      (WINAPI *CloseServiceHandleFunc)(SC_HANDLE hSCObject);

  OpenSCManagerAFunc     OpenSCManagerA;
  OpenServiceAFunc       OpenServiceA;
  ControlServiceFunc     ControlService;
  StartServiceAFunc      StartServiceA;
  CloseServiceHandleFunc CloseServiceHandle;

  result = false;
  // dynamic advapi32 API linking
  dll = LoadLibrary("advapi32.dll");
  OpenSCManagerA     = (OpenSCManagerAFunc    ) GetProcAddress(dll, "OpenSCManagerA");
  OpenServiceA       = (OpenServiceAFunc      ) GetProcAddress(dll, "OpenServiceA");
  ControlService     = (ControlServiceFunc    ) GetProcAddress(dll, "ControlService");
  StartServiceA      = (StartServiceAFunc     ) GetProcAddress(dll, "StartServiceA");
  CloseServiceHandle = (CloseServiceHandleFunc) GetProcAddress(dll, "CloseServiceHandle");
  if ( (OpenSCManagerA) && (OpenServiceA) &&
       (ControlService) && (StartServiceA) && (CloseServiceHandle) ) {
    // first we contact the service control manager
    c1 = OpenSCManagerA(NULL, NULL, 0);
    if (c1) {
      // okay, that worked, now we try to open our service
      c2 = OpenServiceA(c1, serviceName, GENERIC_READ | SERVICE_START);
      if (c2) {
        // that worked, too, let's check its state
        if (ControlService(c2, SERVICE_CONTROL_INTERROGATE, &ss)) {
          if (ss.dwCurrentState == SERVICE_STOPPED)
            // the service is stopped (for whatever reason), so let's start it
            StartServiceA(c2, 0, NULL);
          // now we wait until the process is in a clear state (timeout 15 sec)
          for (i1 = 1; (i1 < 300); i1++) {
            if ( (!ControlService(c2, SERVICE_CONTROL_INTERROGATE, &ss)) ||
                 (ss.dwCurrentState != SERVICE_START_PENDING)               )
              break;
            Sleep(50);
          }
          // is it finally running or not?
          result = ss.dwCurrentState == SERVICE_RUNNING;
        }
        CloseServiceHandle(c2);
      }
      CloseServiceHandle(c1);
    }
  }
  FreeLibrary(dll);

  return result;
}

typedef struct
  // this is the information record which we send to our injection service
  TDllInjectRequest {
    BOOL  bInject;
    DWORD dwTimeOut;
    DWORD dwSession;
  } *PDllInjectRequest;

BOOL Inject(BOOL inject)
// (un)inject our dll system wide
{
  TDllInjectRequest dir;
  BOOL              res;
  BOOL              result;

  // first let's try to inject the dlls without the help of the service
  if (inject)
       result =   InjectLibrary(CURRENT_SESSION | SYSTEM_PROCESSES, "HookTerminateAPIs.dll");
  else result = UninjectLibrary(CURRENT_SESSION | SYSTEM_PROCESSES, "HookTerminateAPIs.dll");
  if (!result) {
    // didn't work, so let's try to ask our service for help
    // first of all we wait until the service is ready to go
    WaitForService("madDllInjectServiceDemo");
    // then we prepare a dll injection request record
    dir.bInject   = inject;
    dir.dwTimeOut = 5000;
    dir.dwSession = GetCurrentSessionId();
    // now we try to contact our injection service
    result = SendIpcMessage("madDllInjectServiceDemo", &dir, sizeof(dir), &res, sizeof(res), 15000, true) && res;
  }
  
  return result;
}

// ***************************************************************

void (WINAPI *ExitProcessNext) (UINT uExitCode);

void WINAPI ExitProcessCallback(UINT uExitCode)
{
  // this can't be a proper shutdown
  // our demo can be closed with a simple button click
  // there's no reason to use bad tricks to close us
  SetLastError(ERROR_ACCESS_DENIED);
}

// ***************************************************************

int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR lpCmdLine,
                   int nCmdShow)
{
  // InitializeMadCHook is needed only if you're using the static madCHook.lib
  InitializeMadCHook();

  // create an ipc queue, through which our dll can contact us
  CHAR arrCh [MAX_PATH];
  wsprintf(arrCh, "HookProcessTermination%u", GetCurrentSessionId());
  if (CreateIpcQueue(arrCh, HandleProcessTerminationRequest)) {
    // the 9x task manager doesn't use TerminateProcess, so we hide from it
    HideMeFrom9xTaskList();
    // now inject our dll into all processes system wide
    if (Inject(true)) {
      // hook ExitProcess, so that other processes can't create a remote thread
      // in which they execute ExitProcess to terminate our process
      HookAPI("kernel32.dll", "ExitProcess", ExitProcessCallback, (PVOID*) &ExitProcessNext);
      // as long as the following box is shown, the hook remains installed
      ShowInfoWindow();
      // unhook the ExitProcess hook again, otherwise Windows can't properly
      // end our process
      UnhookAPI((PVOID*) &ExitProcessNext);
      // remove our dll again
      Inject(false);
    } else
      // if you want your stuff to run in under-privileges user accounts, too,
      // you have to do write a little service for the NT family
      // an example for that can be found in the "HookProcessTermination" demo
      MessageBox(0, "the \"InjectService\" must be installed first\n\n" \
                    "otherwise only administrators can run this demo",
                 "information...", MB_ICONINFORMATION);
  } else
    // ooops, we have no ipc queue! probably another instance is already up
    MessageBox(0, "please don't start me twice", "information...", MB_ICONINFORMATION);

  // FinalizeMadCHook is needed only if you're using the static madCHook.lib
  FinalizeMadCHook();

  return true;
}