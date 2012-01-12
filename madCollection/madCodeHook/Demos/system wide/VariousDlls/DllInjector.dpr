// ***************************************************************
//  DllInjector               version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  tool to inject/uninject dlls system wide or user wide
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

program DllInjector;

{$R ..\..\mad.res}
{$R ..\..\needAdminRights.res}

uses Windows, Messages, madCodeHook, CommDlg;

// ***************************************************************

var dllFileA : array [0..MAX_PATH] of char;      // 9x
    dllFileW : array [0..MAX_PATH] of wideChar;  // nt

procedure InitDllFile;
// dllFile is set to "ourExePath\*.dll"
var i1 : integer;
begin
  GetModuleFileNameA(0, dllFileA, MAX_PATH);
  GetModuleFileNameW(0, dllFileW, MAX_PATH);
  for i1 := lstrlenA(dllFileA) - 1 downto 0 do
    if dllFileA[i1] = '\' then begin
      dllFileA[i1 + 1] := #0;
      break;
    end;
  for i1 := lstrlenW(dllFileW) - 1 downto 0 do
    if dllFileW[i1] = '\' then begin
      dllFileW[i1 + 1] := #0;
      break;
    end;
  lstrcatA(dllFileA, '*.dll');
  lstrcatW(dllFileW, '*.dll');
end;

function GetDllFile(parentWindow: dword) : boolean;
// let the user choose a dll file, the result is stored in "dllFile"
var ofnA : TOpenFileNameA;
    ofnW : TOpenFileNameW;
begin
  if GetVersion and $80000000 <> 0 then begin
    // in win9x we use ansi strings
    ZeroMemory(@ofnA, sizeOf(ofnA));
    ofnA.lStructSize     := 19 * 4;
    ofnA.hWndOwner       := parentWindow;
    ofnA.lpstrFilter     := 'system wide hook dll' + #0 + '*.dll';
    ofnA.nFilterIndex    := 1;
    ofnA.lpstrFile       := dllFileA;
    ofnA.nMaxFile        := MAX_PATH;
    ofnA.lpstrTitle      := 'Choose system wide hook dll';
    ofnA.Flags           := OFN_NOREADONLYRETURN or OFN_HIDEREADONLY;
    result := GetOpenFileNameA(ofnA);
  end else begin
    // in winNT we use wide strings
    ZeroMemory(@ofnW, sizeOf(ofnW));
    ofnW.lStructSize     := 19 * 4;
    ofnW.hWndOwner       := parentWindow;
    ofnW.lpstrFilter     := 'system wide hook dll' + #0 + '*.dll';
    ofnW.nFilterIndex    := 1;
    ofnW.lpstrFile       := dllFileW;
    ofnW.nMaxFile        := MAX_PATH;
    ofnW.lpstrTitle      := 'Choose system wide hook dll';
    ofnW.Flags           := OFN_NOREADONLYRETURN or OFN_HIDEREADONLY;
    result := GetOpenFileNameW(ofnW);
  end;
end;

// ***************************************************************

var
  // here the window handles for our 4 controls are stored
  systemWide, userWide, inject, uninject : dword;

function MainBoxWndProc(window, msg: dword; wParam, lParam: integer) : integer; stdcall;
// this is our main box' window proc
var b1 : boolean;
begin
  if msg = WM_COMMAND then begin
    if dword(lParam) = inject then begin
      // the user pressed on the inject button
      if GetDllFile(window) then begin
        if GetVersion and $80000000 <> 0 then begin
          if SendMessage(systemWide, BM_GETCHECK, 0, 0) = BST_CHECKED then
               b1 := InjectLibraryA(ALL_SESSIONS or SYSTEM_PROCESSES, dllFileA)
          else b1 := InjectLibraryA(CURRENT_USER,                     dllFileA);
        end else
          if SendMessage(systemWide, BM_GETCHECK, 0, 0) = BST_CHECKED then
               b1 := InjectLibraryW(ALL_SESSIONS or SYSTEM_PROCESSES, dllFileW)
          else b1 := InjectLibraryW(CURRENT_USER,                     dllFileW);
        if not b1 then
          // if you want your stuff to run in under-privileges user accounts, too,
          // you have to do write a little service for the NT family
          // an example for that can be found in the "HookProcessTermination" demo
          MessageBox(0, 'only users with administrator privileges can inject dlls',
                     'information...', MB_ICONINFORMATION);
      end;
      SetFocus(inject);
    end else
      if dword(lParam) = uninject then begin
        // the user pressed on the uninject button
        if GetDllFile(window) then begin
          if GetVersion and $80000000 <> 0 then begin
            if SendMessage(systemWide, BM_GETCHECK, 0, 0) = BST_CHECKED then
                 b1 := UninjectLibraryA(ALL_SESSIONS or SYSTEM_PROCESSES, dllFileA)
            else b1 := UninjectLibraryA(CURRENT_USER,                     dllFileA);
          end else
            if SendMessage(systemWide, BM_GETCHECK, 0, 0) = BST_CHECKED then
                 b1 := UninjectLibraryW(ALL_SESSIONS or SYSTEM_PROCESSES, dllFileW)
            else b1 := UninjectLibraryW(CURRENT_USER,                     dllFileW);
          if (not b1) and (GetLastError = ERROR_ACCESS_DENIED) then
            MessageBox(0, 'only users with administrator privileges can uninject dlls',
                       'information...', MB_ICONINFORMATION);
        end;
        SetFocus(uninject);
      end else
        if (dword(lParam) <> systemWide) and (dword(lParam) <> userWide) then
          DestroyWindow(window);  // escape was pressed
    result := 0;
  end else
    result := DefWindowProc(window, msg, wParam, lParam);
end;

procedure ShowMainWindow;
// show our little info box, nothing special here
var wndClass : TWndClass;
    mainBox  : dword;
    font     : dword;
    msg      : TMsg;
    r1       : TRect;
begin
  // first let's register our window class
  ZeroMemory(@wndClass, sizeOf(TWndClass));
  with wndClass do begin
    lpfnWndProc   := @MainBoxWndProc;
    hInstance     := SysInit.HInstance;
    hbrBackground := COLOR_BTNFACE + 1;
    lpszClassname := 'DllInjectorWindow';
    hCursor       := LoadCursor(0, IDC_ARROW);
  end;
  RegisterClass(wndClass);
  // next we create our window
  r1.Left   := 0;
  r1.Top    := 0;
  r1.Right  := 199;
  r1.Bottom := 92;
  AdjustWindowRectEx(r1, WS_CAPTION or WS_SYSMENU, false, WS_EX_WINDOWEDGE or WS_EX_DLGMODALFRAME);
  r1.Right  := r1.Right  - r1.Left;
  r1.Bottom := r1.Bottom - r1.Top;
  r1.Left   := (GetSystemMetrics(SM_CXSCREEN) - r1.Right ) div 2;
  r1.Top    := (GetSystemMetrics(SM_CYSCREEN) - r1.Bottom) div 2;
  mainBox := CreateWindowEx(WS_EX_WINDOWEDGE or WS_EX_DLGMODALFRAME,
                            wndClass.lpszClassname, 'Dll Injector...',
                            WS_CAPTION or WS_SYSMENU,
                            r1.Left, r1.Top, r1.Right, r1.Bottom, 0, 0, HInstance, nil);
  // now we create the controls...
  systemWide := CreateWindow('Button', 'system wide',
                             WS_CHILD or WS_VISIBLE or BS_AUTORADIOBUTTON or WS_TABSTOP,
                             16, 12, 80, 28, mainBox, 0, HInstance, nil);
  userWide   := CreateWindow('Button', 'user wide',
                             WS_CHILD or WS_VISIBLE or BS_AUTORADIOBUTTON,
                             110, 12, 80, 28, mainBox, 0, HInstance, nil);
  inject     := CreateWindow('Button', 'inject dll',
                             WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON or WS_TABSTOP,
                             14, 48, 80, 28, mainBox, 0, HInstance, nil);
  uninject   := CreateWindow('Button', 'uninject dll',
                             WS_CHILD or WS_VISIBLE or WS_TABSTOP,
                             104, 48, 80, 28, mainBox, 0, HInstance, nil);
  // ... and initialize them
  SendMessage(systemWide, BM_SETCHECK, BST_CHECKED, 0);
  if GetVersion and $80000000 <> 0 then begin
    EnableWindow(systemWide, false);
    EnableWindow(  userWide, false);
  end;
  SetFocus(inject);
  // the controls need a nice font
  font := CreateFont(-12, 0, 0, 0, 400, 0, 0, 0, DEFAULT_CHARSET,
                     OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
                     DEFAULT_PITCH or FF_DONTCARE, 'MS Sans Serif');
  SendMessage(systemWide, WM_SETFONT, integer(font), 0);
  SendMessage(userWide,   WM_SETFONT, integer(font), 0);
  SendMessage(inject,     WM_SETFONT, integer(font), 0);
  SendMessage(uninject,   WM_SETFONT, integer(font), 0);
  // finally show our window
  ShowWindow(mainBox, SW_SHOWNORMAL);
  while IsWindow(mainBox) and GetMessage(msg, 0, 0, 0) do
    if not IsDialogMessage(mainBox, msg) then begin
      TranslateMessage(msg);
      DispatchMessage(msg);
    end;
  // let's Windows clean up the font etc for us
end;

// ***************************************************************

begin
  InitDllFile;
  ShowMainWindow;
end.
