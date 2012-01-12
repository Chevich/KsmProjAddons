Unit EtvTemp;

Interface
Uses DBTables,
     DB,BDE,DBCommon;


Function WhereFromSQL(SQLText:string; ToOrderBy:boolean):string;
Procedure OpenDutyQuery(aDataBaseName,aText:string; HideError:boolean);
{ Подправляет глюки Borland'овской функции для случая когда ГОД - 2 ЦИФРЫ! }
{ от 00 до 50 будет 2050 год иначе 19хх }
Function StrToDate_(const S: string):TDateTime;
Function DateToStr_(Date: TDateTime): string;

var DQuery: TQuery;

Implementation
Uses SysUtils,Controls,Forms;

{ Подправляет глюки Borland'овской функции }
Function StrToDate_(const S: string):TDateTime;
var S1:string;
    aYear: string[2];
begin
  S1:=S;
  if Length(S1)=8 then begin
    aYear:=Copy(S1,7,2);
    if StrToInt(aYear)<50 then
      S1:=Copy(S1,1,6)+'20'+aYear
    else S1:=Copy(S1,1,6)+'19'+aYear
  end;
  Result:=StrToDate(S1);
end;

Function DateToStr_(Date:TDateTime):string;
var S1:string;
    aYear: string[2];
begin
  S1:=DateToStr(Date);
  if Length(S1)=8 then begin
    aYear:=Copy(S1,7,2);
    if StrToInt(aYear)<50 then
      S1:=Copy(S1,1,6)+'20'+aYear
    else S1:=Copy(S1,1,6)+'19'+aYear
  end;
  Result:=S1;
end;

Function WhereFromSQL(SQLText:string; ToOrderBy:boolean):string;
var i,j:integer;
begin
  j:=0;
  Result:='';
  i:=Pos('where', AnsiLowerCase(SQLText));
  if i=0 then Exit; { нет условия "where" в данном SQLText'е }
  if not ToOrderBy then j:=Pos('group by',AnsiLowerCase(SQLText));
  if j=0 then j:=Pos('order by',AnsiLowerCase(SQLText));
  if j=0 then j:=Length(SQLText)+1;
  Result:=Copy(SQLText,i+Length('where '),j-i-Length('where '));
end;

Procedure OpenDutyQuery(aDataBaseName,aText:string; HideError:boolean);
var OldCursor: TCursor;
begin
  if Not Assigned(DQuery) then DQuery:=TQuery.Create(nil);
  DQuery.DataBaseName:=aDataBaseName;
  DQuery.Sql.Clear; { Предыдущий запрос очищается }
  DQuery.Sql.Add(aText);
  if Assigned(Screen) then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crSQLWait;
  end;
  try
    try
      DQuery.Open;
    except
      if Not HideError then Raise;
    end;
  finally
    Screen.Cursor:=OldCursor;
  end
end;

Initialization

Finalization
  if Assigned(DQuery) then DQuery.Free;
end.
