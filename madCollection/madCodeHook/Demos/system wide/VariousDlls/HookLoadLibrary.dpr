// ***************************************************************
//  HookLoadLibrary.dll       version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  write all LoadLibrary(Ex)A/W calls into a log file
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

library HookLoadLibrary;

{$IMAGEBASE $58800000}

uses Windows, madCodeHook, madStrings;

// ***************************************************************

procedure Log(api: string; libA: pchar; libW: pwideChar; file_, flags, res, callingModule: dword);
// log the API call to our shared log file

  function GetModuleFileNameAW(module: dword; path: boolean; fill: integer = 0) : string;
  // in the 9x family we're using GetModuleFileNameA
  // in nt we're using GetModuleFileNameW
  // nt doesn't like us to call ansi APIs in wide API hook callback functions
  var arrChA : array [0..MAX_PATH] of char;
      arrChW : array [0..MAX_PATH] of wideChar;
      i1     : integer;
  begin
    if GetVersion and $80000000 = 0 then begin
      GetModuleFileNameW(module, arrChW, MAX_PATH);
      // nevertheless we want to get an ansi string back
      // so we convert the wide string...
      WideToAnsi(arrChW, arrChA);
    end else
      GetModuleFileNameA(module, arrChA, MAX_PATH);
    result := arrChA;
    // we either want the path or the name, let's kill the unwanted part
    for i1 := Length(result) downto 1 do
      if result[i1] = '\' then begin
        if path then
             Delete(result, i1 + 1, maxInt)
        else Delete(result, 1,      i1    );
        break;
      end;
    // fill up the string with blank characters
    i1 := Length(result);
    if fill > i1 then begin
      SetLength(result, fill);
      for i1 := i1 + 1 to fill do
        result[i1] := ' ';
    end;
  end;

  function ComposeLogString : string;
  // this one is simple: we just compose a log line out of the available infos
  var arrChA : array [0..MAX_PATH] of char;
  begin
    result := GetModuleFileNameAW(0,             false, 21) +
              GetModuleFileNameAW(callingModule, false, 21) +
              'LoadLibrary' + api;
    if res <> 0 then
         result := result + IntToHexEx(res, 8) + ' '
    else result := result + 'failed    ';
    if flags <> 0 then
         result := result + 'flags: ' + IntToHexEx(flags) + ' '
    else result := result + 'flags: -  ';
    result := result + 'lib: ';
    try
      if libW <> nil then begin
        WideToAnsi(libW, arrChA);
        result := result + '"' + arrChA + '" ';
      end else
        result := result + '"' + libA + '" ';
    except result := result + '??? ' end;
    if file_ <> 0 then
      result := result + 'file: ' + IntToHexEx(file_);
    result := result + #$D#$A;
  end;

  procedure AppendStrToFileAW(str, fileName: string);
  // this function adds our log line to our shared log file
  // again, we're using either the ansi or the wide API, depending on the OS
  var fh, c1 : dword;
      arrChW : array [0..MAX_PATH] of wideChar;
  begin
    if GetVersion and $80000000 = 0 then begin
      AnsiToWide(pchar(fileName), arrChW);
      fh := CreateFileW(arrChW, GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_ALWAYS, 0, 0);
    end else
      fh := CreateFileA(pchar(fileName), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_ALWAYS, 0, 0);
    if fh <> 0 then begin
      SetFilePointer(fh, 0, nil, FILE_END);
      WriteFile(fh, pchar(str)^, Length(str), c1, nil);
      CloseHandle(fh);
    end;
  end;

var s1    : string;
    mutex : dword;
begin
  // the log file is used by all processes system wide
  // we have to synchronize access to it, of course
  mutex := CreateGlobalMutex('HookLoadLibraryLogMutex');
  if mutex <> 0 then begin
    s1 := ComposeLogString;
    // if we don't get access in 100ms, we give up, so we don't freeze anyone
    if WaitForSingleObject(mutex, 100) = WAIT_OBJECT_0 then begin
      AppendStrToFileAW(s1, GetModuleFileNameAW(HInstance, true) + 'HookLoadLibraryLog.txt');
      ReleaseMutex(mutex);
    end;
    CloseHandle(mutex);
  end;
end;

// ***************************************************************

var LoadLibraryANext   : function (lib: pchar    ) : dword; stdcall;
    LoadLibraryWNext   : function (lib: pwidechar) : dword; stdcall;
    LoadLibraryExANext : function (lib: pchar;     file_, flags: dword) : dword; stdcall;
    LoadLibraryExWNext : function (lib: pwidechar; file_, flags: dword) : dword; stdcall;

function LoadLibraryACallback(lib: pchar) : dword; stdcall;
// the hook callback functions are easy
// we just call the original API, then we log the call
begin
  result := LoadLibraryANext(lib);
  Log('A:   ', lib, nil, 0, 0, result, GetCallingModule);
end;

function LoadLibraryWCallback(lib: pwidechar) : dword; stdcall;
begin
  result := LoadLibraryWNext(lib);
  Log('W:   ', nil, lib, 0, 0, result, GetCallingModule);
end;

function LoadLibraryExACallback(lib: pchar; file_, flags: dword) : dword; stdcall;
begin
  result := LoadLibraryExANext(lib, file_, flags);
  Log('ExA: ', lib, nil, file_, flags, result, GetCallingModule);
end;

function LoadLibraryExWCallback(lib: pwidechar; file_, flags: dword) : dword; stdcall;
begin
  result := LoadLibraryExWNext(lib, file_, flags);
  Log('ExW: ', nil, lib, file_, flags, result, GetCallingModule);
end;

// ***************************************************************

begin
  HookAPI('kernel32.dll', 'LoadLibraryA',   @LoadLibraryACallback,   @LoadLibraryANext  );
  HookAPI('kernel32.dll', 'LoadLibraryW',   @LoadLibraryWCallback,   @LoadLibraryWNext  );
  HookAPI('kernel32.dll', 'LoadLibraryExA', @LoadLibraryExACallback, @LoadLibraryExANext);
  HookAPI('kernel32.dll', 'LoadLibraryExW', @LoadLibraryExWCallback, @LoadLibraryExWNext);
end.
