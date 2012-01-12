unit SaErrors;
interface

uses SysUtils;

type
  TSaErr = class
  public
    procedure HandleDBExcept(Sender: TObject; E: Exception);
  end;

var  SaErr: TSaErr;

implementation
uses Forms,db,classes,TypInfo,Dialogs, EtvDB, DBTables;

procedure ShowError(ErrID : Integer); External 'ODBCERRH.DLL' index 1;
function NativErrorSt(ErrID : Integer): PChar; External 'ODBCERRH.DLL' index 2;

procedure TSaErr.HandleDBExcept(Sender: TObject; E: Exception);
var S,s1:string;
    I:Integer;
begin
  S:='';
  if E is EDBEngineError then with EDBEngineError(E) do begin
    for I := 0 to ErrorCount-1 do begin
      s1:=NativErrorSt(Errors[I].NativeError);
      if s1<>'' then begin
        if s<>'' then s:=s+#13#10;
        S:=S+S1;
      end;
    end;
    if S<>'' then begin
      s:=s+#13#10;
      for I := 0 to ErrorCount-1 do if Errors[I].NativeError<>0 then begin
        s1:=Errors[I].Message;
        if s1<>'' then S:=s+#13#10+S1;
      end;
    end;
  end;
  EtvApp.DisableRefreshForm;
  if S='' then Application.ShowException(E)
  else MessageDlg(S,mtError,[mbOK],0);
  EtvApp.EnableRefreshForm;
end;

initialization
  SaErr:=TSaErr.Create;
finalization
  SaErr.Free;
end.
