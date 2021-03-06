library ec;

{$IMAGEBASE $5c000000}

// just the uses clause and one exported function

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  ecDll in 'ecDll.pas',
  ecCrashParam in 'ecCrashParam.pas',
  SysUtils;

procedure DllExportedFunction;
// if the application calls us, just raise an exception
begin
  raise Exception.Create('Demo "dll exported function".');
end;

exports DllExportedFunction;

end.
