// ***************************************************************
//  HookPrintAPIs.dll         version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  hook several print APIs and notify application about calls
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

library HookPrintAPIs;

{$IMAGEBASE $5a000000}

uses Windows, madCodeHook, madStrings;

// ***************************************************************

type
  TPrintNotification = record
    process : array [0..MAX_PATH] of char;
    api     : array [0..MAX_PATH] of char;
    params  : array [0..MAX_PATH] of char;
    result  : array [0..MAX_PATH] of char;
  end;

procedure NotifyApplication(api: string; deviceA: pchar; deviceW: pwidechar;
                            dc: dword; dia: PDocInfoA; diw: PDocInfoW;
                            job: integer; result: boolean);
// this function composes all the strings and sends them to our log window
var pn      : TPrintNotification;
    arrChA  : array [0..MAX_PATH] of char;
    arrChW  : array [0..MAX_PATH] of wideChar;
    session : dword;
begin
  // fill the "process" and "api" strings, the format is independent of the API
  if GetVersion and $80000000 = 0 then begin
    GetModuleFileNameW(0, arrChW, MAX_PATH);
    WideToAnsi(arrChW, pn.process);
  end else
    GetModuleFileNameA(0, pn.process, MAX_PATH);
  lstrcpyA(pn.api, pchar(api));
  if (deviceA <> nil) or (deviceW <> nil) then begin
    // this is the CreateDCA/W API
    if deviceA <> nil then begin
      lstrcpyA(arrChA, deviceA);
      arrChA[11] := #0;
      if lstrcmpA('\\.\DISPLAY', arrChA) = 0 then
        // no, we don't want to display dcs!
        exit;
      lstrcpyA(arrChA, deviceA);
    end else begin
      lstrcpyW(arrChW, deviceW);
      arrChW[11] := #0;
      if lstrcmpW('\\.\DISPLAY', arrChW) = 0 then
        exit;
      WideToAnsi(deviceW, arrChA);
    end;
    // we output one parameter, namely the printer name
    lstrcpyA(pn.params, 'printer: "');
    lstrcatA(pn.params, arrChA);
    lstrcatA(pn.params, '"');
    // the result is either a valid dc handle or a failure indicator
    if dc <> 0 then begin
      lstrcpyA(pn.result, 'dc: ');
      lstrcatA(pn.result, pchar(IntToHexEx(dc)));
    end else
      lstrcpyA(pn.result, 'error');
  end else begin
    // all other APIs have a "dc" paramter, so we output it first
    lstrcpyA(pn.params, 'dc: ');
    lstrcatA(pn.params, pchar(IntToHexEx(dc)));
    if (dia <> nil) or (diw <> nil) then begin
      // this is the StartDocA/W API, it has an additional "doc" parameter
      if dia <> nil then begin
        // ansi version
        if dia^.lpszDocName <> nil then begin
          lstrcatA(pn.params, '; doc: "');
          lstrcatA(pn.params, dia^.lpszDocName);
          lstrcatA(pn.params, '"');
        end;
        if dia^.lpszOutput <> nil then begin
          lstrcatA(pn.params, '; output: "');
          lstrcatA(pn.params, dia^.lpszOutput);
          lstrcatA(pn.params, '"');
        end;
      end else begin
        // wide version
        if diw^.lpszDocName <> nil then begin
          WideToAnsi(diw^.lpszDocName, arrChA);
          lstrcatA(pn.params, '; doc: "');
          lstrcatA(pn.params, arrChA);
          lstrcatA(pn.params, '"');
        end;
        if diw^.lpszOutput <> nil then begin
          WideToAnsi(diw^.lpszOutput, arrChA);
          lstrcatA(pn.params, '; output: "');
          lstrcatA(pn.params, arrChA);
          lstrcatA(pn.params, '"');
        end;
      end;
      // the result is either a valid job identifier or a failure indicator
      if job > 0 then begin
        lstrcpyA(pn.result, 'job: ');
        lstrcatA(pn.result, pchar(IntToHexEx(job)));
      end else
        lstrcpyA(pn.result, 'error');
    end else
      // all the other ideas have only a boolean result
      if result then
           lstrcpyA(pn.result, 'success')
      else lstrcpyA(pn.result, 'error'  );
  end;
  // which terminal server (XP fast user switching) session shall we contact?
  if AmSystemProcess and (GetCurrentSessionId = 0) then
    // some system process are independent of sessions
    // so let's contact the PrintMonitor application instance
    // which is running in the current input session
    session := GetInputSessionId
  else
    // we're an application running in a specific session
    // let's contact the PrintMonitor application instance
    // which runs in the same session as we do
    session := GetCurrentSessionId;
  // now send the composed strings to our log window
  // hopefully there's an instance running in the specified session
  SendIpcMessage(pchar('PrintMonitor' + IntToStrEx(session)), @pn, sizeOf(pn));
end;

// ***************************************************************

var CreateDCANext : function (driver, device, output: pchar; dm: PDeviceModeA) : dword; stdcall;
    CreateDCWNext : function (driver, device, output: pwidechar; dm: PDeviceModeW) : dword; stdcall;
    StartDocANext : function (dc: dword; const di: TDocInfoA) : integer; stdcall;
    StartDocWNext : function (dc: dword; const di: TDocInfoW) : integer; stdcall;
    EndDocNext    : function (dc: dword) : integer; stdcall;
    StartPageNext : function (dc: dword) : integer; stdcall;
    EndPageNext   : function (dc: dword) : integer; stdcall;
    AbortDocNext  : function (dc: dword) : integer; stdcall;

function CreateDCACallback(driver, device, output: pchar; dm: PDeviceModeA) : dword; stdcall;
begin
  result := CreateDCANext(driver, device, output, dm);
  // we log this call only if it is a printer DC creation
  if (device <> nil) and (not IsBadReadPtr(device, 1)) and (device^ <> #0) then
    NotifyApplication('CreateDCA', device, nil, result, nil, nil, 0, false);
end;

function CreateDCWCallback(driver, device, output: pwidechar; dm: PDeviceModeW) : dword; stdcall;
begin
  result := CreateDCWNext(driver, device, output, dm);
  if (device <> nil) and (not IsBadReadPtr(device, 2)) and (device^ <> #0) then
    NotifyApplication('CreateDCW', nil, device, result, nil, nil, 0, false);
end;

function StartDocACallback(dc: dword; const di: TDocInfoA) : integer; stdcall;
begin
  result := StartDocANext(dc, di);
  NotifyApplication('StartDocA', nil, nil, dc, @di, nil, result, false);
end;

function StartDocWCallback(dc: dword; const di: TDocInfoW) : integer; stdcall;
begin
  result := StartDocWNext(dc, di);
  NotifyApplication('StartDocW', nil, nil, dc, nil, @di, result, false);
end;

function EndDocCallback(dc: dword) : integer; stdcall;
begin
  result := EndDocNext(dc);
  NotifyApplication('EndDoc', nil, nil, dc, nil, nil, 0, result > 0);
end;

function StartPageCallback(dc: dword) : integer; stdcall;
begin
  result := StartPageNext(dc);
  NotifyApplication('StartPage', nil, nil, dc, nil, nil, 0, result > 0);
end;

function EndPageCallback(dc: dword) : integer; stdcall;
begin
  result := EndPageNext(dc);
  NotifyApplication('EndPage', nil, nil, dc, nil, nil, 0, result > 0);
end;

function AbortDocCallback(dc: dword) : integer; stdcall;
begin
  result := AbortDocNext(dc);
  NotifyApplication('AbortDoc', nil, nil, dc, nil, nil, 0, result > 0);
end;

// ***************************************************************

begin
  // collecting hooks can improve the hook installation performance in win9x
  CollectHooks;
  HookAPI('gdi32.dll', 'CreateDCA', @CreateDCACallback, @CreateDCANext);
  HookAPI('gdi32.dll', 'CreateDCW', @CreateDCWCallback, @CreateDCWNext);
  HookAPI('gdi32.dll', 'StartDocA', @StartDocACallback, @StartDocANext);
  HookAPI('gdi32.dll', 'StartDocW', @StartDocWCallback, @StartDocWNext);
  HookAPI('gdi32.dll', 'EndDoc',    @EndDocCallback,    @EndDocNext   );
  HookAPI('gdi32.dll', 'StartPage', @StartPageCallback, @StartPageNext);
  HookAPI('gdi32.dll', 'EndPage',   @EndPageCallback,   @EndPageNext  );
  HookAPI('gdi32.dll', 'AbortDoc',  @AbortDocCallback,  @AbortDocNext );
  FlushHooks;
end.
