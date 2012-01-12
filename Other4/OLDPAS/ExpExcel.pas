{                                                              }
{ First Autor:  Sergei Sotnik EMail:sergei@alice.dp.ua         }
{ Home page                   http://www.alice.dp.ua/~sergei   }
{ Improvement: Lev Zusman     EMail: lev@gksm.belpak.grodno.by }
{ 09.11.99                                                     }
{                                                              }
Unit ExpExcel;
Interface
Uses DbTables;

Procedure ExportToExcel(aQuery:TQuery);

Implementation
Uses SysUtils, Dialogs, DB, Graphics,
     { For Export to Excel }
     Excel_TLB, ComObj;
//   Excel_TLB - Import through "Project/Import type library"
//   library EXCEL8.OLB

var ExApp: _Application;
    WS:    WorkSheet;
Procedure ExportToExcel(aQuery:TQuery);
Const MaxRecordExportStr='65536';{ vrode MAX kol-vo strok na list Excel }
var i, j: integer;
    v: Variant;
    aRecordCount: integer;
    NameCell: string;
begin
  if not aQuery.Active then aQuery.Open;
  aRecordCount:=aQuery.RecordCount;
  if aRecordCount>StrToInt(MaxRecordExportStr) then begin
    ShowMessage('ѕревышен предел количества строк '+MaxRecordExportStr+#13+
                '—ообщите о проблеме автору');
    Exit;
  end;

  ExApp :=CoApplication_.Create;
  ExApp.Visible[0] := true;
  ExApp.Workbooks.Add(xlWBATWorksheet, 0);
  v:= VarArrayCreate([0, aQuery.RecordCount+1, 0, aQuery.FieldCount-1], varVariant);
  WS := ExApp.ActiveSheet as WorkSheet;

  for i:=0 to aQuery.FieldCount-1 do begin
    v[0,i]:=aQuery.Fields[i].DisplayLabel;
    { 65 - A, 66 - B, 67 - C, ... }
    NameCell:=Chr(i+65);
(*
    { ”станавливаем соответствующую ширину €чеек }
    WS.Columns.Range[NameCell+'1',NameCell+'1'].ColumnWidth:=aQuery.Fields[i].DisplayWidth;
*)
    { ”станавливаем соответствующий формат €чеек }
    case aQuery.Fields[i].DataType of
      ftString,
      ftMemo,
      ftFmtMemo   : WS.Range[NameCell+'1',NameCell+MaxRecordExportStr].NumberFormat:='@';
      ftSmallint,
      ftInteger,
      ftWord,
      ftAutoInc   : WS.Range[NameCell+'1',NameCell+MaxRecordExportStr].NumberFormat:='0';
      ftFloat     : WS.Range[NameCell+'1',NameCell+MaxRecordExportStr].NumberFormat:='ќсновной';
    end;
  end;

  aQuery.First;
  j:=1;
  try
    aQuery.DisableControls;
    while not aQuery.Eof do begin
      for i:=0 to aQuery.FieldCount-1 do begin
        v[j,i]:=aQuery.Fields[i].Value;
      end;
      aQuery.Next;
      Inc(j);
    end;
  finally
    aQuery.EnableControls;
  end;
  WS.Cells.Range['a1',chr(ord('a')+varArrayHighBound(v, 2))+
    IntToStr(varArrayHighBound(v, 1)+1)].value:=v;
(*
  WS.Cells.Range['a1',chr(ord('a')+varArrayHighBound(v, 2))+
    IntToStr(varArrayHighBound(v, 1)+1)].Borders[xlEdgeBottom].Color:=clBlack;
*)
  WS.Cells.Range['a1',chr(ord('a')+varArrayHighBound(v, 2))+
    IntToStr(varArrayHighBound(v, 1)+1)].Borders.LineStyle:=xlContinuous;
(*
  WS.Cells.Range['a1',chr(ord('a')+varArrayHighBound(v, 2))+
    IntToStr(varArrayHighBound(v, 1)+1)].BorderAround(
      xlDouble,xlMedium,xlColorIndexAutomatic,xlColor3)
*)
  WS.Cells.Range['a1',chr(ord('a')+varArrayHighBound(v, 2))+
    IntToStr(varArrayHighBound(v, 1)+1)].AutoFormat(
       xlRangeAutoFormatSimple,
       false,
       false,
       false,
       false,
       false,
       true);
end;
end.