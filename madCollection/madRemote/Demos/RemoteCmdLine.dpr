// ***************************************************************
//  RemoteCmdLine             version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  demo: executing code in the context of another process
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

program RemoteCmdLine;

{$R mad.res}

uses Windows, madRemote;

// ***************************************************************

// this is our remote function
// it can be executed in the context of any desired process
function RemoteGetCmdLine(buffer: pchar) : dword; stdcall;
begin
  result := 0;
  // let's copy the command line of the current process to the specified buffer
  lstrcpyA(buffer, GetCommandLine);
end;

// this function can give us the command line of any specified 32bit process
function GetProcessCmdLine(processHandle: dword) : string;
var arrCh : array [0..MAX_PATH] of char;
    dummy : dword;
begin
  // we simply execute "GetCmdLineThread" in the context of the target process
  if RemoteExecute(processHandle, @RemoteGetCmdLine, dummy, @arrCh, MAX_PATH) then
    // if this succeeds, "arrCh" will contain the command line 
    result := arrCh
  else
    result := '';
end;

procedure ShowExplorerCmdLine;
// this demo shows us the command line of the explorer
// this is not possible when using normal win32 APIs
var wnd, pid, ph : dword;
begin
  // first we ask the taskbar's window handle and the corresponding process ID
  wnd := FindWindow('Shell_TrayWnd', '');
  GetWindowThreadProcessID(wnd, @pid);

  // then we open the process, which is the explorer, of course
  ph := OpenProcess(PROCESS_ALL_ACCESS, false, pid);

  // and finally we show it's command line
  MessageBox(0, pchar(GetProcessCmdLine(ph)), 'explorer''s command line...', 0);

  // I like it the clean style
  CloseHandle(ph);
end;

begin
  ShowExplorerCmdLine;
end.
