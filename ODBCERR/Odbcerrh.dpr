library OdbcErrH;


uses
  //SysUtils,
  //Classes,
  Windows,Messages;

procedure ShowError(ErrorID : Integer); forward;
function  NativErrorSt(ErrorID : Integer): PChar; forward;

exports
  ShowError index 1 name 'SHOWERROR';
exports
  NativErrorSt index 2 name 'NATIVERRORST';
{==============================================================================}
{$R SAError.res}

{------------------------------------------------------------------------------}
procedure ShowError(ErrorID : Integer); export;
var
 S: array[0..255] of Char;
begin
  LoadString(HInstance, ErrorID, S, 255);
  MessageBox(0,S,nil,MB_OK);
end;

{------------------------------------------------------------------------------}
function NativErrorSt(ErrorID : Integer): PChar; export;
var
 S: array[0..255] of Char;
 I : byte;
begin
  LoadString(HInstance, ErrorID, S, 255);
  Result := S;
end;

end.
