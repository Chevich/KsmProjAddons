unit EtvDBFun;

interface
uses Classes,db,dbTables,Controls,ExtCtrls;
{$I Etv.inc}

Function AllFieldNames(aDataSet:TDataSet; ForQuery,Blobs:boolean):string;

Function UniqueFieldsForDataSet(aDataSet:TDataSet):string;

Function SortingFromDataSet(aDataSet:TDataSet):string;

Procedure SortingToDataSet(aDataSet:TDataSet; NewSorting:string;
                           KeepPosition:boolean);

Procedure DataSetRefresh(aDataSet:TDataSet);

Function FieldsDisplayName(aDataSet:TDataSet; aFields:string):string;

Procedure GotoBookmarkWOExcept(aDataSet:TDataSet; aBookmark: TBookmark);
function LocateWOExcept(aDataSet:TDataSet; const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;

procedure CheckFieldNames(ADataSet:TDataSet; FieldNames:string);

Function LengthFields(aDataSet:TDataSet; s:string):smallint;
Function LengthResultFields(Field:TField):smallint;

procedure ModifyLookDataSetActive(ADataSet: TDataSet; AActive: Boolean);

Function AddFilterCondition(OldFilter,Add:string):string;

(* Calc Length of Fields by scan all data on client*)
procedure SetLengthFieldsByDataScan(aDataSet:TComponent; aMaxRowScan:integer);

procedure OpenAllDataSets(aOwner:TComponent; aShowError:boolean);
procedure CloseAllDataSets(aOwner:TComponent; aShowError:boolean);

   (* information about Field *)
Function FieldInfo(AField:TField; LookupInfo:boolean):string;
Function FieldsInfo(ADataSet:TDataSet):string;

   (* information line of DataSet *)
Function DataSetInfo(ADataSet:TDataSet):string;

Procedure DataSetInfoToClipBoard(ADataSet:TDataSet);
Procedure FieldDataListToClipBoard(ADataSet:TDataSet);

Procedure DataSetAutoCorrect(ADataSet:TDBDataSet);

procedure DataSrcKeyDown(Const DataSource: TDataSource; var Key: Word; Shift: TShiftState);

(* Get Labels from server BD (Need two View on the server) *)
Procedure DataSetLabel(ADataSet:TDBDataSet);
(* Get Labels from server BD for View (Need two View on the server) *)
Procedure DataSetViewLabel(ADataSet:TDBDataSet);

Function GetFromSQLText(aDataBaseName,aText:string; HideError:boolean):variant;
Procedure ExecSQLText(aDataBaseName,aText:string; HideError:boolean);

function FieldDataByComma(aDataSet:TDataSet; aField:string):string;

{--------}
const VisibleFields='VisibleFields';
      InvisibleFields='InvisibleFields';
      AllFields='AllFields';
      UserFields='UserFields'; (* Tag<>8 *)
      VisibleUserFields='VisibleUserFields';
      InvisibleUserFields='InvisibleUserFields';

function GetVisibleFields(aDataSet:TDataSet; aBlobs:boolean; aLinkFields:boolean):TList;
function GetInvisibleFields(aDataSet:TDataSet; aBlobs:boolean):TList;
function GetUserFields(aDataSet:TDataSet; aBlobs:boolean):TList;
function GetVisibleUserFields(aDataSet:TDataSet; aBlobs:boolean):TList;
function GetInvisibleUserFields(aDataSet:TDataSet; aBlobs:boolean):TList;
function GetFieldListExt(aDataSet:TDataSet; aFields:string; aBlobs:boolean):TList;

(* dialog for choose fields *)
function ChooseFieldList(ADataSet:TDataSet; Var SrcFields, DstFields:string;
           aCaption,aSrcLabel,aDstLabel:string; aBlobs:boolean; Separate:char):boolean;

Procedure ChangeVisibleFields(ADataSet: TDataSet;
            AVisibleFields,AInvisibleFields: String);

type
  TRecordCloner = class
  protected
    FBuffer: TStrings;
    FOldNew: TDataSetNotifyEvent;
    procedure DoNewRecord(DataSet: TDataSet);
  public
    procedure GetData(DataSet:TDataSet; aBuffer:TStrings);
    procedure SetData(DataSet:TDataSet; aBuffer:TStrings);
    procedure Clone(DataSet: TDataSet);
end;

procedure CloneRecord(DataSet: TDataSet);

type
TDataSetColItem=Class(TCollectionItem)
protected
  fDataSet:TDataSet;
published
  property DataSet:TDataSet read fDataSet write fDataSet;
end;

TDataSetCol=Class(TCollection)
protected
  function GetDataSet(aIndex:integer):TDataSet;
public
  function AddItem(aDataSet:TDataSet; aUnique:boolean):boolean;
  property DataSets[Index: Integer]:TDataSet read GetDataSet; Default;
end;

Implementation
Uses TypInfo,Windows,Forms,Clipbrd,Dialogs,SysUtils,dbClient,dbGrids,
     DbConsts,EtvConst,EtvPas,EtvDB,DiDual,EtvForms;

procedure DataSrcKeyDown(Const DataSource: TDataSource; var Key: Word; Shift: TShiftState);
{$IFDEF InsertDeleteFromControls}
var s:string;
{$ENDIF}
begin
  if Assigned(DataSource) and Assigned(DataSource.DataSet)and
                 DataSource.DataSet.Active then
    if (ssCtrl in Shift)
    {$IFDEF ForLev} or (Key in [VK_PRIOR,VK_NEXT]) {$ENDIF}
    then
      Case Key of
        VK_HOME: DataSource.DataSet.First;
        VK_END: DataSource.DataSet.Last;
        VK_PRIOR: DataSource.DataSet.Prior;
        VK_NEXT: DataSource.DataSet.Next;
        {$IFDEF InsertDeleteFromControls}
        VK_ADD: DataSource.DataSet.Insert;
        VK_SUBTRACT: begin
          EtvApp.DisableRefreshForm;
          try
            s:=ObjectStrProp(DataSource.DataSet,'Caption');
            if s<>'' then s:=s+#10+SDeleteRecordQuestion
            else s:=SDeleteRecordQuestion;
            if MessageDlg (S, mtConfirmation, mbOKCancel, 0) <> idCancel then
            DataSource.DataSet.Delete;
          finally
            EtvApp.EnableRefreshForm;
          end;
        end;
        {$ENDIF}
      end;
end;

function FindOrderBy(s:string; first:boolean):integer;
var i,j,L,k:integer;
    inString,inText:boolean;
begin
  Result:=0;
  j:=1;
  L:=length(S);
  while J<=L do begin
    i:=Pos('order',AnsiLowerCase(copy(s,j,l)))+(j-1);
    if i>j-1 then begin
      j:=i+5;
      inString:=false;
      inText:=false;
      for k:=1 to i-1 do begin
        if s[k]='''' then inString:=not inString;
        if (s[k]='"') and (not InString) then inText:=not inText;
      end;
      if not (inString or inText) then begin
        while (j<=L) and (s[j]<=' ') do inc(J);
        if AnsiLowerCase(copy(s,j,2))='by' then begin
          if First then result:=i else result:=j+2;
          Exit;
        end;
      end;
    end else Exit;
  end;
end;

Function SortingFromSQL(SQLText:string):string;
var i,l:integer;
    s:string;
    SeparateExists:boolean;
begin
  Result:='';
  i:=FindOrderBy(SQLText,false);
  if i>0 then begin
    s:=trim(copy(SQLText,i,maxint));
    L:=length(s);
    i:=1;
    SeparateExists:=true;
    while i<=L do begin
      while (i<=L) and (s[i]>' ') and (s[i]<>',') and (s[i]<>';') do begin
        if SeparateExists then result:=result+s[i];
        inc(i);
      end;
      SeparateExists:=false;
      while (i<=L) and ((s[i]<=' ') or (s[i]=',') or (s[i]=',')) do begin
        if s[i]=',' then begin
          SeparateExists:=true;
          Result:=Result+';';
        end;
        inc(i);
      end;
    end;
  end;
end;

function AllFieldNames(aDataSet:TDataSet; ForQuery,Blobs:boolean):string;
var i:integer;
begin
  Result:='';
  for i:=0 to aDataSet.FieldCount-1 do
    if (TField(aDataSet.Fields[i]).FieldKind=fkData) and
       (Blobs or (not(TField(aDataSet.Fields[i]) is TBlobField))) then begin
      if Result<>'' then
        if ForQuery then Result:=Result+','
        else Result:=Result+';';
      Result:=Result+TField(aDataSet.Fields[i]).FieldName;
    end;
  if (Result='') and ForQuery then Result:='*';
end;

function UniqueFieldsForTable(Table:TTable):string;
var i:integer;
begin
  Result:='';
  if Assigned(Table) then begin
    Table.IndexDefs.Update;
    for i:=0 to Table.IndexDefs.Count-1 do
      if (ixPrimary in Table.IndexDefs.Items[i].options) or
         (ixUnique in Table.IndexDefs.Items[i].options) then begin
        Result:=Table.IndexDefs.Items[i].Fields;
        Exit;
      end;
    Result:=AllFieldNames(Table,false,false);
  end;
end;

function UniqueFieldsForClientDataSet(ClientDataSet:TClientDataSet):string;
var i:integer;
begin
  Result:='';
  if Assigned(ClientDataSet) then begin
    ClientDataSet.IndexDefs.Update;
    for i:=0 to ClientDataSet.IndexDefs.Count-1 do
      if (ixPrimary in ClientDataSet.IndexDefs.Items[i].options) or
         (ixUnique in ClientDataSet.IndexDefs.Items[i].options) then begin
        Result:=ClientDataSet.IndexDefs.Items[i].Fields;
        Exit;
      end;
    Result:=AllFieldNames(ClientDataSet,false,false);
  end;
end;

function UniqueFieldsForDBDataSet(aDBDataSet:TDBDataSet):string;
var lTableName:string;
    lTable:TTable;
begin
  Result:='';
  lTableName:=ObjectStrProp(aDBDataSet,'TableName');
  if lTableName<>'' then begin
    lTable:=TTable.Create(nil);
    try
      lTable.DatabaseName:=aDBDataSet.DataBaseName;
      lTable.TableName:=LTableName;
      try
        Result:=UniqueFieldsForTable(lTable);
      except
        Result:=AllFieldNames(aDBDataSet,False,False);
      end;
    finally
      lTable.Free;
    end;
  end else Result:=AllFieldNames(aDBDataSet,False,False);
end;

Function UniqueFieldsForDataSet(aDataSet:TDataSet):string;
begin
  Result:=ObjectStrProp(aDataSet,'UniqueFields');
  if Result='' then begin
    if aDataSet is TTable then Result:=UniqueFieldsForTable(TTable(aDataSet))
    else if aDataSet is TClientDataSet then
      Result:=UniqueFieldsForClientDataSet(TClientDataSet(aDataSet))
    else if aDataSet is TDBDataSet then
      Result:=UniqueFieldsForDBDataSet(TDBDataSet(aDataSet))
    else Result:=AllFieldNames(aDataSet,False,false);
  end;
end;

Function SortingToSQL(SQLText:string; NewSorting:string):string;
var i:integer;
begin
  for i:=1 to length(NewSorting) do
    if  NewSorting[i]=';' then NewSorting[i]:=',';
  i:=FindOrderBy(SQLText,true);
  if i>0 then Result:=copy(SQLText,1,i-1)
  else begin
    Result:=Trim(SQLText);
    if Result[length(Result)]=';' then Result:=copy(Result,1,length(Result)-1);
  end;
  if NewSorting<>'' then Result:=Result+#13#10+'order by '+NewSorting;
end;

Procedure SortingToDataSet(aDataSet:TDataSet; NewSorting:string;
                           KeepPosition:boolean);
var PropInfo: PPropInfo;
    lSQL:TStrings;
    lFields:string;
    V:variant;
    lNewSorting:string;
    i:integer;
begin
  lNewSorting:=NewSorting;
  PropInfo:=GetPropInfo(aDataSet.ClassInfo, 'SQL');
  if PropInfo<>nil then begin
    lSQL:=TStrings(GetOrdProp(aDataSet, PropInfo));
    if aDataSet.Active then begin
      if KeepPosition then begin
        lFields:=UniqueFieldsForDataSet(aDataSet);
        if lFields<>'' then V:=aDataSet.FieldValues[lFields];
      end;
      aDataSet.DisableControls;
      try
        aDataSet.Close;
        lSQL.Text:=SortingToSQL(lSQL.Text,lNewSorting);
        aDataSet.Open;
        if KeepPosition and (lFields<>'') then aDataSet.Locate(lFields,V,[]);
      finally
        aDataSet.EnableControls;
      end;
    end else lSQL.Text:=SortingToSQL(lSQL.Text, lNewSorting);
  end else begin
    PropInfo:=GetPropInfo(aDataSet.ClassInfo, 'IndexFieldNames');
    if PropInfo<>nil then begin
      for i:=1 to length(lNewSorting) do
        if lNewSorting[i]=',' then lNewSorting[i]:=';';
      if aDataSet.Active and KeepPosition then begin
        lFields:=UniqueFieldsForDataSet(aDataSet);
        if lFields<>'' then begin
          V:=aDataSet.FieldValues[lFields];
          aDataSet.DisableControls;
          try
            SetStrProp(aDataSet,PropInfo,lNewSorting);
            aDataSet.Locate(lFields,V,[]);
          finally
            aDataSet.EnableControls;
          end;
        end else SetStrProp(aDataSet,PropInfo,lNewSorting);
      end else SetStrProp(aDataSet,PropInfo,lNewSorting);
    end;
  end;
end;

function SortingFromDataSet(aDataSet:TDataSet):string;
var j:integer;
    PropInfo: PPropInfo;
begin
  Result:='';
  if aDataSet is TTable then with TTable(aDataSet) do
    for j:=0 to IndexFieldCount-1 do begin
      if j>0 then Result:=Result+';';
      Result:=Result+IndexFields[j].FieldName;
    end
  else
  if aDataSet is TClientDataSet then with TClientDataSet(aDataSet) do
    for j:=0 to IndexFieldCount-1 do begin
      if j>0 then Result:=Result+';';
      Result:=Result+IndexFields[j].FieldName;
    end;
  if Result='' then Result:=ObjectStrProp(aDataSet,'IndexFieldNames');
  if Result='' then begin
    PropInfo:=GetPropInfo(aDataSet.ClassInfo, 'SQL');
    if PropInfo<>nil then
      Result:=SortingFromSQL(TStrings(GetOrdProp(aDataSet, PropInfo)).Text);
  end;
end;

Procedure DataSetRefresh(aDataSet:TDataSet);
var B:TBookMark;
begin
  if Assigned(aDataSet) and aDataSet.Active then begin
    if aDataSet is TQuery then with aDataSet do begin
      B:=GetBookmark; (* may be need to remake by locate *)
      DisableControls;
      try
        Close;
        Open;
        GotoBookmarkWOExcept(aDataSet,B);
      finally
        EnableControls;
        FreeBookmark(B);
      end;
    end else aDataSet.Refresh;
  end;
end;

function FieldsDisplayName(aDataSet:TDataSet; aFields:string):string;
var Pos:integer;
    lFieldName:string;
    lField:TField;
begin
  Result:='';
  Pos:=1;
  while Pos <= Length(aFields) do begin
    lFieldName:=ExtractFieldName(aFields, Pos);
    lField:=aDataSet.FindField(lFieldName);
    if Result<>'' then Result:=Result+',';
    if Assigned(lField) then Result:=Result+lField.DisplayName
    else Result:=Result+lFieldName;
  end;
end;

type TDataSetSelf=Class(TDataSet) end;
     TBDEDataSetSelf=Class(TBDEDataSet) end;
     TClientDataSetSelf=Class(TClientDataSet) end;

Procedure GotoBookmarkWOExcept(aDataSet:TDataSet; aBookmark: TBookmark);
begin
  if aBookmark<>nil then With TDataSetSelf(aDataSet) do begin
    CheckBrowseMode;
    DoBeforeScroll;
    InternalGotoBookmark(aBookmark);
    Resync([{rmExact, }rmCenter]);
    DoAfterScroll;
  end;
end;

function LocateWOExcept(aDataSet:TDataSet; const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
begin
  Result:=false;
  if aDataSet.Active then
    if (aDataSet is TBDEDataSet) or (aDataSet is TClientDataSet) then
      with TDataSetSelf(aDataSet) do begin
        DoBeforeScroll;
        if aDataSet is TBDEDataSet then
          Result := TBDEDataSetSelf(aDataSet).LocateRecord(KeyFields, KeyValues, Options, True)
        else Result := TClientDataSetSelf(aDataSet).LocateRecord(KeyFields, KeyValues, Options, True);
        if Result then begin
          Resync([{rmExact, }rmCenter]);
          DoAfterScroll;
        end;
      end
  else try
    Result:=aDataSet.Locate(KeyFields, KeyValues, Options);
  except
  end;
end;

procedure CheckFieldNames(ADataSet:TDataSet; FieldNames:string);
var Pos: Integer;
begin
  Pos := 1;
  with ADataSet do
    while Pos <= Length(FieldNames) do
      FieldByName(ExtractFieldName(FieldNames, Pos));
end;

Function LengthFields(aDataSet:TDataSet; s:string):smallint;
var i:integer;
begin
  Result:=0;
  if Assigned(aDataSet) then begin
    i:=1;
    while i<=Length(s) do begin
      Result:=Result+aDataSet.FieldByName(ExtractFieldName(s, i)).DisplayWidth;
    end;
  end;
end;

Function LengthResultFields(Field:TField):smallint;
begin
  if Field is TEtvLookField then Result:=TEtvLookField(Field).LengthResultFields
  else Result:=LengthFields(Field.LookupDataSet,Field.LookupResultField);
end;

{ LookUp fields to Calculated and back}
procedure ModifyLookDataSetActive(ADataSet: TDataSet; AActive: Boolean);
var i:Integer;
    AField: TField;
begin
  if Assigned(ADataSet) then
    with ADataSet do begin
      for i:=0 to FieldCount-1 do begin
        AField:=Fields[i];
        if Assigned(AField.LookupDataSet) and
           (AField.LookUpDataSet.Active=not AActive) then
          AField.LookUpDataSet.Active:=AActive;
      end;
    end;
end;

Function AddFilterCondition(OldFilter,Add:string):string;
begin
  if OldFilter='' then Result:=Add
  else
    if Add<>'' then Result:='('+OldFilter+') and ('+Add+')'
    else Result:=OldFilter;
end;

procedure SetLengthFieldsByDataScan(aDataSet:TComponent; aMaxRowScan:integer);
var B:TBookmark;
    List:array[0..1024] of byte;
    i,j,l:integer;
    lDataSet:TDataSet;
    TM: TTextMetric;
    lRowScan:integer;
    OldActive:boolean;
begin
  lDataSet:=nil;
  if aDataSet is TDataSet then lDataSet:=TDataSet(aDataSet)
  else
  if (aDataSet is TDBGrid) and
     Assigned(TDBGrid(aDataSet).DataSource)then
    lDataSet:=TDBGrid(aDataSet).DataSource.DataSet;

  if Assigned(lDataSet) then Try
    OldActive:=lDataSet.Active;
    if Not OldActive then lDataSet.Open
    else lDataSet.CheckBrowseMode;
    if Not (lDataSet.BOF and lDataSet.EOF) then begin
      lDataSet.DisableControls;
      B:=nil;
     if OldActive then B:=lDataSet.GetBookmark;

      FillChar(List,lDataSet.FieldCount,#0);
      lDataSet.First;
      lRowScan:=0;
      while (not lDataSet.EOF) and (lRowScan<aMaxRowScan) do begin
        for i:=0 to lDataSet.FieldCount-1 do
          if (not(lDataSet.fields[i] is TBlobField)) and
             (not(lDataSet.fields[i] is TEtvLookField)) then begin
            l:=length(lDataSet.fields[i].DisplayText);
            if list[i]<l then
              if l>255 then List[i]:=255
              else List[i]:=l;
          end;
        lDataSet.Next;
        Inc(lRowScan);
      end;
      for i:=0 to lDataSet.FieldCount-1 do
        if List[i]>0 then begin
          if (aDataSet is TDBGrid) and
             (dgColumnResize in TDBGrid(aDataSet).Options) then with TDBGrid(aDataSet) do
            for j:=0 to Columns.Count-1 do
              if Columns[j].Field=lDataSet.fields[i] then begin
                Canvas.Font:=Columns[j].Font;
                GetTextMetrics(Canvas.Handle, TM);
                Columns[j].Width:=
                  (List[i]+1+list[i] div 20)*(Canvas.TextWidth('0')-TM.tmOverhang)+TM.tmOverhang+4;
                break;
              end;
          lDataSet.fields[i].DisplayWidth:=List[i]+1+list[i] div 20;
        end;
      if B<>nil then begin
        GotoBookMarkWOExcept(lDataSet,B);
        lDataSet.FreeBookmark(B);
      end;
    end;
    if not OldActive then lDataSet.Close;
  finally
    lDataSet.EnableControls;
  end;
end;

procedure OpenAllDataSets(aOwner:TComponent; aShowError:boolean);
var s:string;
    i:integer;
begin
  s:='';
  for i:=0 to aOwner.ComponentCount-1 do begin
    if (aOwner.Components[i] is TDBDataSet)
       and (Not TDBDataSet(aOwner.Components[i]).Active) then
      try
        TDBDataSet(aOwner.Components[i]).Open
      Except
        if aShowError then
          s:=s+aOwner.Components[i].Name+#13+#10;
      end;
  end;
  if s<>'' then EtvApp.ShowMessage(s+#13+#10+'Not opened');
end;

procedure CloseAllDataSets(aOwner:TComponent; aShowError:boolean);
var s:string;
    i:integer;
begin
  s:='';
  for i:=0 to aOwner.ComponentCount-1 do begin
    if (aOwner.Components[i] is TDBDataSet)
       and (TDBDataSet(aOwner.Components[i]).Active) then
      try
        TDBDataSet(aOwner.Components[i]).Close
      Except
        if aShowError then
          s:=s+aOwner.Components[i].Name+#13+#10;
      end;
  end;
  if s<>'' then EtvApp.ShowMessage(s+#13+#10+'Not closed!!!');
end;

Function FieldInfo(AField:TField; LookupInfo:boolean):string;
var s:string;
begin
  with AField do begin
    Result:=ClassName;
    if AField is TStringField then
      Result:=Result+'['+IntToStr(TStringField(AField).size)+']';
    Result:=sform(FieldName,18,taLeftJustify)+' '+
      sform(Name,32,taLeftJustify)+' '+sform(Result,17,taLeftJustify);
    Result:=Result+' '+DisplayLabel+'  '+IntToStr(DisplayWidth);
    case FieldKind of
      fkCalculated: Result:=Result+'  CALC';
      fkInternalCalc: Result:=Result+'  InternalCALC';
      fkLookup: begin
        Result:=Result+'  LOOKUP';
        if LookupInfo then begin
          Result:=Result+'(';
          if KeyFields<>'' then Result:=Result+KeyFields+','
          else Result:=Result+'###,';
          if LookupDataSet<>nil then begin
            Result:=Result+LookupDataSet.Name;
            s:=ObjectStrProp(LookupDataset,'TableName');
            if s<>'' then Result:=Result+
              '{'+s+'}';
          end else Result:=Result+'###';
          Result:=Result+',';
          if LookupKeyFields<>'' then Result:=Result+LookupKeyFields+','
          else Result:=Result+'###,';
          if LookupResultField<>'' then
            if AField is TEtvLookField then
              Result:=Result+TEtvLookField(AField).LookupResultField
            else Result:=Result+LookupResultField
          else Result:=Result+'###';
          Result:=Result+')';
        end;
      end;
    end;
  end;
end;

Function FieldsInfo(ADataSet:TDataSet):string;
var i:smallint;
begin
  Result:='';
  if Not Assigned(ADataSet) then Exit;
  for i:=0 to ADataSet.FieldCount-1 do
    Result:=Result+FieldInfo(ADataSet.Fields[i],True)+#13+#10;
end;

Function DataSetInfo(ADataSet:TDataSet):string;
var s:string;
begin
  Result:=ADataset.name;
  s:=ObjectStrProp(ADataSet,'Caption');
  if s<>'' then Result:=Result+'  '+s;
  s:=ObjectStrProp(ADataSet,'DataBaseName');
  if s<>'' then Result:=Result+'  '+s;
  s:=ObjectStrProp(ADataSet,'TableName');
  if s<>'' then Result:=Result+'  '+s;
  if ADataSet.tag mod 10 =9 then Result:=Result+' | Auto open';
  if ADataSet.tag mod 100 div 10=9 then Result:=Result+' | Refresh';
  if ADataSet.Active=true then Result:=Result+' // Active';
end;

procedure DataSetInfoToClipBoard(ADataSet:TDataSet);
var s:string;
begin
  if Not Assigned(ADataSet) then Exit;
  s:='--- '+DataSetInfo(ADataSet)+' ---'+#13+#10+#13+#10;
    s:=s+FieldsInfo(ADataSet);
  Clipboard.SetTextBuf(PChar(s));
end;

procedure FieldDataListToClipBoard(ADataSet:TDataSet);
var s:string;
    i:integer;
begin
  if Not Assigned(ADataSet) then Exit;
  s:='';
  for i:=0 to ADataSet.fieldCount-1 do
    if ADataSet.Fields[i].FieldKind=fkData then begin
      if s<>'' then s:=s+',';
      s:=s+ADataSet.Fields[i].FieldName;
    end;
  if s<>'' then Clipboard.SetTextBuf(PChar(s));
end;

procedure DataSetAutoCorrect(ADataSet:TDBDataSet);
var OldActive:boolean;
    sInfo:string;
    L,I,j:smallint;
    fAutoCalcFields:boolean;
begin
  try
    sInfo:=SAutoCorrectInit;
    fAutoCalcFields:=false;

    OldActive:=ADataSet.Active;

    with ADataSet do begin
      for i:=0 to FieldCount-1 do begin
        sInfo:=SAutoCorrectFieldProcess+Fields[i].FieldName;
        if (Fields[i].fieldKind=fkLookup) then begin
          fAutoCalcFields:=true;
          if Fields[i].KeyFields<>'' then begin
            FieldByName(Fields[i].KeyFields).Visible:=false;
            FieldByName(Fields[i].KeyFields).Tag:=8;
          end;
          sInfo:=SAutoCorrectFieldLengthProcess+Fields[i].FieldName;
            (* calc of length *)
          if Assigned(Fields[i].LookupDataSet) then with Fields[i] do begin
            if Fields[i] is TEtvLookField then begin
              L:=TEtvLookField(Fields[i]).LengthResultFields;
              {$IFNDEF ForLev}
              if TEtvLookField(Fields[i]).LookupResultCount>1 then
                TEtvLookField(Fields[i]).ListFieldIndex:=1;
              {$ENDIF}
            end else L:=LengthResultFields(Fields[i]);
            if L>0 then begin
              if Fields[i] is TStringField then begin
                if Active then Close;
                TStringField(Fields[i]).Size:=L;
              end;
              DisplayWidth:=L+5;
            end;
          end;
        end else begin
          sInfo:=SAutoCorrectFieldOtherProcess+Fields[i].FieldName;
          if Fields[i] is TEtvListField then begin
            L:=0;
            for j:=0 to TEtvListField(Fields[i]).values.Count-1 do
              if L<Length(TEtvListField(Fields[i]).values[j]) then
                L:=Length(TEtvListField(Fields[i]).values[j]);
            if L>0 then Fields[i].DisplayWidth:=L+3;
          end else begin
            if ((Fields[i] is TSmallintField) or
                (Fields[i] is TWordField)) and
               (Fields[i].DisplayWidth>6) then Fields[i].DisplayWidth:=5;
            if Fields[i] is TBlobField then begin
              Fields[i].Visible:=false;
              if (Fields[i] is TMemoField) and (Fields[i].DisplayWidth=10) then
                Fields[i].DisplayWidth:=40;
            end;
            {if (Fields[i] is TDateField) and (Fields[i].EditMask='') then begin
              Fields[i].EditMask:='!99/99/00;1;_';
            end;}
          end;
        end;
      end;
      sInfo:=SAutoCorrectSetTableParams;
      if fAutoCalcFields and (Not ADataSet.AutoCalcFields) then
        ADataSet.AutoCalcFields:=true;
      if OldActive and (Not Active) then Open;
    end;
  except
    ShowMessage(SError+SInfo);
  end;
end;

function GetLabel(var SCap:string):string;
var j,j1:smallint;
begin
  j:=Pos('\',sCap);
  j1:=Pos('/',sCap);
  if (j1>0) and ((j1<j) or (j<=0)) then j:=j1;
  if j>0 then begin
    Result:=Copy(sCap,1,j-1);
    sCap:=Copy(sCap,j+1,Length(sCap));
  end else begin
    Result:=sCap;
    sCap:='';
  end;
  if Length(Result)>80 then Result:=Copy(Result,1,80);
  Result:=Trim(Result);
end;

procedure DataSetLabel(ADataSet:TDBDataSet);
var TbTables,TbColumns:TQuery;
    OldActive:boolean;
    sInfo,s,sCap:string;
    i:smallint;
    PropInfo: PPropInfo;
begin
  TbTables:=nil;
  TbColumns:=nil;
  try
    sInfo:=SAutoCorrectInit+' ('+SLabelPump+')';
    s:=ObjectStrProp(ADataSet,'TableName');
    if s='' then begin
      SInfo:=SLabelPumpTableMissing+' ('+SLabelPump+')';
      SysUtils.Abort;
    end;
    i:=Pos('.',s);
    if i>0 then s:=Copy(s,i+1,length(s)-i);

    OldActive:=ADataSet.Active;
    ADataSet.DisableControls;

    sInfo:=SLabelPumpAidTables+' ('+SLabelPump+')';
    TbTables:=TQuery.create(nil);
    TbTables.DataBaseName:=aDataSet.DataBaseName;
    TbTables.SQL.Add('Select * from Tables where TName='''+s+'''');
    TbTables.Open;

    TbColumns:=TQuery.create(nil);
    TbColumns.DataBaseName:=aDataSet.DataBaseName;
    TbColumns.SQL.Add('Select * from Columns where TName='''+s+'''');
    TbColumns.Open;

    sInfo:=SLabelPumpTableProcess+' ('+SLabelPump+')';

    if Not (TbTables.BOF and TbTables.EOF) then begin
      SCap:=TbTables.FieldByName('Remarks').AsString;
      SCap:=GetLabel(sCap);
      PropInfo := GetPropInfo(ADataSet.ClassInfo, 'Caption');
      if PropInfo <> nil then SetStrProp(ADataSet,PropInfo,SCap);


      with ADataSet do begin
        for i:=0 to FieldCount-1 do begin
          SCap:='';
          sInfo:=SLabelPumpFieldProcess+' '+Fields[i].FieldName+' ('+SLabelPump+')';
          if (Fields[i].fieldKind=fkLookup) then begin
            if Fields[i].KeyFields<>'' then begin
              if (TbColumns.Locate('CName',Fields[i].KeyFields,[])) and
                 (TbColumns.FieldByName('Remarks').Value<>null) then
                SCap:=TbColumns.FieldByName('Remarks').Value;
            end;
          end else begin
            if TbColumns.Locate('cname',Fields[i].FieldName,[]) then begin
              if TbColumns.FieldByName('Remarks').Value<>null then
                SCap:=TbColumns.FieldByName('Remarks').Value;
              sInfo:=SLabelPumpFieldCheckLength+' '+Fields[i].FieldName+' ('+SLabelPump+')';
              if (TbColumns.FindField('Required')<>nil) and
                 (TbColumns.FindField('Required').value<>null) then
                Fields[i].Required:=true;
              if (Fields[i] is TStringField) and
                 (TStringField(Fields[i]).size<>TbColumns.FieldByName('SLength').Value) then begin
                if Active then Close;
                TStringField(Fields[i]).Size:=TbColumns.FieldByName('SLength').Value;
              end;
            end;
          end;
          sInfo:=SLabelPumpFieldLabel+' '+Fields[i].FieldName+' ('+SLabelPump+')';
          if sCap<>'' then
            Fields[i].DisplayLabel:=GetLabel(sCap);
        end;
      end;
    end else ShowMessage(Format(SLabelPumpTableNotFound,[s]));
    if OldActive<> ADataSet.Active then
      ADataSet.Active:=not AdataSet.Active;
    ADataSet.EnableControls;
    TbColumns.free;
    TbTables.free;
  except
    ShowMessage(SError+SInfo);
    if assigned(TbColumns) then TbColumns.free;
    if assigned(TbTables) then TbTables.free;
  end;
end;

procedure DataSetViewLabel(ADataSet:TDBDataSet);
var TbTables:TQuery;
    sInfo,s,sCap:string;
    i:smallint;
    PropInfo: PPropInfo;
begin
  TbTables:=nil;
  try
    sInfo:=SAutoCorrectInit+' ('+SLabelPumpView+')';
    s:=ObjectStrProp(ADataSet,'TableName');
    if s='' then begin
      SInfo:=SLabelPumpTableMissing+' ('+SLabelPumpView+')';
      SysUtils.Abort;
    end;
    i:=Pos('.',s);
    if i>0 then s:=Copy(s,i+1,length(s)-i);

    TbTables:=TQuery.create(nil);
    TbTables.DataBaseName:=ADataSet.DataBaseName;
    TbTables.SQL.Add('select * from TablesV where TName='''+s+'''');
    TbTables.Open;

    sInfo:=SLabelPumpTableProcess+' ('+SLabelPumpView+')';
    if not (TbTables.BOF and TbTables.EOF) then begin
      SCap:=TbTables.FieldByName('Remarks').AsString;
      S:=GetLabel(SCap);
      PropInfo := GetPropInfo(ADataSet.ClassInfo, 'Caption');
      if PropInfo <> nil then SetStrProp(ADataSet,PropInfo,S);

      sInfo:=SLabelPumpViewFieldsProcess+' ('+SLabelPumpView+')';
      with ADataSet do begin
        if (FieldCount=0) and (Not Active) then Open;
        while sCap<>'' do begin
          s:=GetLabel(sCap);
          i:=Pos('=',s);
          if i>0 then begin
            if Assigned(FindField(trim(Copy(s,1,i-1)))) then
              FindField(Trim(Copy(s,1,i-1))).DisplayLabel:=Trim(Copy(s,i+1,length(s)));
          end;
        end;

        for i:=0 to FieldCount-1 do begin
          if (Fields[i].fieldKind=fkLookup) and (Fields[i].KeyFields<>'') and
             Assigned(FindField(Fields[i].KeyFields)) then
            Fields[i].DisplayLabel:=FieldByName(Fields[i].KeyFields).DisplayLabel;
        end;
      end;
    end else ShowMessage(Format(SLabelPumpTableNotFound,[s]));
    TbTables.free;
  except
    ShowMessage(SError+SInfo);
    if assigned(TbTables) then TbTables.free;
  end;
end;

{-------}

function GetVisibleFields(aDataSet:TDataSet; aBlobs:boolean; aLinkFields:boolean):TList;
var i:integer;
    lField:TField;
begin
  Result:=nil;
  if Assigned(aDataSet) then With aDataSet do begin
    Result:=TList.Create;
    for i:=0 to FieldCount-1 do
      if Fields[i].Visible and
         (aBlobs or (not (Fields[i] is TBlobField))) then begin
        if aLinkFields then begin
          if (Fields[i].FieldKind=fkLookup) then begin
            lField:=ADataSet.FindField(Fields[i].KeyFields);
            if Assigned(lField) and (lField.Visible=false) and
              (Result.IndexOf(lField)<0) then Result.Add(lField);
          end;
        end;
        Result.Add(ADataSet.Fields[i])
      end;
  end;
end;

function GetInvisibleFields(aDataSet:TDataSet; aBlobs:boolean):TList;
var i:integer;
begin
  Result:=nil;
  if Assigned(aDataSet) then With aDataSet do begin
    Result:=TList.Create;
    for i:=0 to FieldCount-1 do
      if (not Fields[i].Visible) and
         (aBlobs or (not (Fields[i] is TBlobField))) then Result.Add(ADataSet.Fields[i])
  end;
end;

function GetUserFields(aDataSet:TDataSet; aBlobs:boolean):TList;
var i:integer;
begin
  Result:=nil;
  if Assigned(aDataSet) then With aDataSet do begin
    Result:=TList.Create;
    for i:=0 to FieldCount-1 do
      if (Fields[i].Tag<>8) and
         (aBlobs or (not (Fields[i] is TBlobField))) then Result.Add(ADataSet.Fields[i])
  end;
end;

function GetVisibleUserFields(aDataSet:TDataSet; aBlobs:boolean):TList;
var i:integer;
begin
  Result:=nil;
  if Assigned(aDataSet) then With aDataSet do begin
    Result:=TList.Create;
    for i:=0 to FieldCount-1 do
      if (Fields[i].Tag<>8) and Fields[i].visible and
         (aBlobs or (not (Fields[i] is TBlobField)))then Result.Add(ADataSet.Fields[i])
  end;
end;

function GetInvisibleUserFields(aDataSet:TDataSet; aBlobs:boolean):TList;
var i:integer;
begin
  Result:=nil;
  if Assigned(aDataSet) then With aDataSet do begin
    Result:=TList.Create;
    for i:=0 to FieldCount-1 do
      if (Fields[i].Tag<>8) and (Not Fields[i].visible) and
         (aBlobs or (not (Fields[i] is TBlobField))) then Result.Add(ADataSet.Fields[i])
  end;
end;

function GetFieldListExt(aDataSet:TDataSet; aFields:string; aBlobs:boolean):TList;
var i:integer;
begin
  if aFields=VisibleFields then Result:=GetVisibleFields(aDataSet,aBlobs,false)
  else if aFields=InvisibleFields then Result:=GetInvisibleFields(aDataSet,aBlobs)
  else if aFields=AllFields then begin
    Result:=TList.Create;
    for i:=0 to aDataSet.FieldCount-1 do
      if aBlobs or (Not (aDataSet.Fields[i] is TBlobField)) then
        Result.Add(aDataSet.Fields[i]);
  end
  else if aFields=UserFields then Result:=GetUserFields(aDataSet,aBlobs)
  else if aFields=VisibleUserFields then Result:=GetVisibleUserFields(aDataSet,aBlobs)
  else if aFields=InvisibleUserFields then Result:=GetInvisibleUserFields(aDataSet,aBlobs)
  else begin
    Result:=TList.Create;
    aDataSet.GetFieldList(Result,aFields);
    if (Not aBlobs) and assigned(Result) then
      For i:=Result.Count-1 downto 0 do
        if TField(Result[i]) is TBlobField then Result.Delete(i);
  end;
end;

function ChooseFieldList(ADataSet:TDataSet; Var SrcFields, DstFields:string;
           aCaption,aSrcLabel,aDstLabel:string; aBlobs:boolean; Separate:char):boolean;
var Dial:TEtvDualListDlg;
    i,j:integer;
    SrcFieldList,DstFieldList:TList;
    Exist:boolean;
begin
  Result:=false;
  if Assigned(ADataSet) then begin
    Dial:=TEtvDualListDlg.Create(nil);
    with Dial do Try
      if aCaption<>'' then Caption:=aCaption;
      if aSrcLabel<>'' then SrcLabel.Caption:=aSrcLabel;
      if aDstLabel<>'' then DstLabel.Caption:=aDstLabel;
      SrcList.Items.Clear;
      DstList.Items.Clear;
      SrcFieldList:=GetFieldListExt(aDataSet,ChangeSymbol(SrcFields,Separate,';'),aBlobs);
      try
        DstFieldList:=GetFieldListExt(aDataSet,ChangeSymbol(DstFields,Separate,';'),aBlobs);
        with aDataset do try
          if Assigned(SrcFieldList) then for i:=0 to SrcFieldList.Count-1 do begin
            Exist:=false;
            if Assigned(DstFieldList) then for j:=0 to DstFieldList.Count-1 do
              if SrcFieldList[i]=DstFieldList[j] then begin
                Exist:=true;
                break;
              end;
            if Not Exist then SrcList.Items.add(TField(SrcFieldList[i]).DisplayLabel)
          end;
          if Assigned(DstFieldList) then for i:=0 to DstFieldList.Count-1 do
            DstList.Items.add(TField(DstFieldList[i]).DisplayLabel);
          if (SrcList.Items.Count+DstList.Items.Count>0) and (ShowModal=idOk) then begin
            if Not Assigned(SrcFieldList) then SrcFieldList:=Tlist.Create;
            if Assigned(DstFieldList) then
              for i:=0 to DstFieldList.count-1 do
                SrcFieldList.Add(DstFieldList[i]);
            Result:=true;
            SrcFields:='';
            DstFields:='';
            for j:=0 to SrcList.Items.Count-1 do
              for i:=0 to SrcFieldList.count-1 do
                if TField(SrcFieldList[i]).DisplayLabel=SrcList.Items[j] then begin
                  if (Separate<>'') and (SrcFields<>'') then
                    SrcFields:=SrcFields+Separate;
                  SrcFields:=SrcFields+TField(SrcFieldList[i]).FieldName;
                  Break;
                end;
            for j:=0 to DstList.Items.Count-1 do
              for i:=0 to SrcFieldList.Count-1 do
                if TField(SrcFieldList[i]).DisplayLabel=DstList.Items[j] then begin
                  if (Separate<>'') and (DstFields<>'') then
                    DstFields:=DstFields+Separate;
                  DstFields:=DstFields+TField(SrcFieldList[i]).FieldName;
                  Break;
                end;
          end;
        finally
          DstFieldList.Free;
        end;
      finally
        SrcFieldList.Free;
      end;
    finally
      if Assigned(Dial) then Dial.Free;
    end;
  end;
end;

procedure ChangeVisibleFields(ADataSet: TDataSet;
            AVisibleFields,AInvisibleFields: String);
var AList:TList;
    aCount,i,j:Integer;
begin
  AList:= TList.Create;
  try
    ADataSet.GetFieldList(AList, AVisibleFields);
    for j:=0 to AList.Count-1 do
      for i:=0 to ADataSet.FieldCount-1 do
        if ADataSet.Fields[i]=AList[j] then begin
          ADataSet.Fields[i].Visible:=True;
          ADataSet.Fields[i].Index:=j;
          Break;
        end;
    aCount:=AList.Count;
    AList.Clear;
    ADataSet.GetFieldList(AList, AInvisibleFields);
    for j:=0 to AList.Count-1 do
      for i:=0 to ADataSet.FieldCount-1 do
        if ADataSet.Fields[i]=AList[j] then begin
          ADataSet.Fields[i].Visible:=false;
          ADataSet.Fields[i].Index:=j+aCount;
          Break;
        end;
  finally
    AList.Free;
  end;
end;

{ TRecordCloner }
{type
TRecordCloner = class
private
  FBuffer: TStrings;
  FStream: TStringStream;
  FOldNew: TDataSetNotifyEvent;
protected
  procedure DoNewRecord(DataSet: TDataSet);
public
  constructor Create(DataSet: TDataSet);
end;

constructor TRecordCloner.Create(DataSet: TDataSet);
var
  I: Integer;
  FieldVal: String;
begin
  FBuffer := TStringList.Create;
  try
    with DataSet do
      begin
        CheckBrowseMode;
        for I := 0 to FieldCount - 1 do
          with Fields[I] do
            if CanModify and (not (Fields[i] is TAutoincField)) then
              if IsBlob then
                begin
                  FStream := TStringStream.Create('');
                  try
                    TBlobField(Fields[I]).SaveToStream(FStream);
                    FBuffer.Add(FStream.DataString);
                  finally
                    FStream.Free;
                  end;
                end
              else
                begin
                  SetLength(FieldVal, DataSize);
                  GetData(Pointer(FieldVal));
                  FBuffer.Add(FieldVal);
                end;
        FOldNew := OnNewRecord;
        OnNewRecord := DoNewRecord;
        try
          Append;
        finally
          OnNewRecord := FOldNew;
        end;
      end;
  finally
    FBuffer.Free;
  end;
end;

procedure TRecordCloner.DoNewRecord(DataSet: TDataSet);
var
  I, J: Integer;
begin
  J := 0;
  with DataSet do
    for I := 0 to FieldCount - 1 do
      with Fields[I] do
        if (CanModify) and (not (Fields[i] is TAutoincField)) then
          try
            try
              if IsBlob then
                begin
                  FStream := TStringStream.Create(FBuffer[J]);
                  try
                    TBlobField(Fields[I]).LoadFromStream(FStream);
                  finally
                    FStream.Free;
                  end;
                end
              else
                SetData(Pointer(FBuffer[J]));
            finally
              Inc(J);
            end;
          except
          end;
  if @FOldNew <> nil then
    FOldNew(DataSet);
end;
}

procedure TRecordCloner.GetData(DataSet:TDataSet; aBuffer:TStrings);
var I: Integer;
    FieldVal: String;
    FStream: TStringStream;
begin
  with DataSet do begin
    CheckBrowseMode;
    for I:=0 to FieldCount - 1 do with Fields[I] do
      if CanModify and (not (Fields[i] is TAutoincField)) then
        if IsBlob then begin
          FStream := TStringStream.Create('');
          try
            TBlobField(Fields[I]).SaveToStream(FStream);
            aBuffer.Add(FStream.DataString);
          finally
            FStream.Free;
          end;
        end
        else begin
          if not isNull then begin
            SetLength(FieldVal, DataSize);
            GetData(Pointer(FieldVal));
            aBuffer.Add(FieldVal);
          end else aBuffer.Add('');
        end;
  end;
end;

procedure TRecordCloner.Clone(DataSet: TDataSet);
var lBuffer:TStrings;
begin
  lBuffer := TStringList.Create;
  try
    GetData(DataSet,lBuffer);
    SetData(DataSet,lBuffer);
  finally
    lBuffer.Free;
  end;
end;

procedure TRecordCloner.SetData(DataSet: TDataSet; aBuffer:TStrings);
begin
  FBuffer:=aBuffer;
  FOldNew := DataSet.OnNewRecord;
  DataSet.OnNewRecord := DoNewRecord;
  try
    DataSet.Insert;
  finally
    DataSet.OnNewRecord := FOldNew;
  end;
end;

procedure TRecordCloner.DoNewRecord(DataSet: TDataSet);
var
  I, J: Integer;
  FStream: TStringStream;
begin
  J := 0;
  with DataSet do
    for I := 0 to FieldCount - 1 do
      with Fields[I] do
        if (CanModify) and (not (Fields[i] is TAutoincField)) then
          try
            try
              if IsBlob then
                begin
                  FStream := TStringStream.Create(FBuffer[J]);
                  try
                    TBlobField(Fields[I]).LoadFromStream(FStream);
                  finally
                    FStream.Free;
                  end;
                end
              else
                SetData(Pointer(FBuffer[J]));
            finally
              Inc(J);
            end;
          except
          end;
  if @FOldNew <> nil then
    FOldNew(DataSet);
end;

procedure CloneRecord(DataSet: TDataSet);
var RC:TRecordCloner;
begin
  RC:=TRecordCloner.Create;
  try
    RC.Clone(DataSet);
  finally
    RC.Free;
  end;
end;

{TDataSetCol}
function TDataSetCol.GetDataSet(aIndex:integer):TDataSet;
begin
  if aIndex<Count then Result:=TDataSetColItem(Items[aIndex]).DataSet
  else Result:=nil;
end;

function TDataSetCol.AddItem(aDataSet:TDataSet; aUnique:boolean):Boolean;
var i:smallint;
begin
  Result:=false;
  if aUnique then
    for i:=0 to Count-1 do
      if Self[i]=aDataSet then begin
        EtvApp.ShowMessage(aDataSet.Name+' is not added to collection,'+
            #10+'it is in collection already');
        Exit;
      end;
  (Add as TDataSetColItem).DataSet:=aDataSet;
  Result:=true;
end;

var Q:TQuery;

Function GetFromSQLText(aDataBaseName,aText:string; HideError:boolean):variant;
begin
  Result:=null;
  if Not Assigned(Q) then Q:=TQuery.Create(nil);
  Q.DataBaseName:=aDataBaseName;
  Q.Sql.Clear;
  Q.Sql.Add(aText);
  try
    Q.Open;
    try
      if Q.FieldCount>0 then Result:=Q.Fields[0].Value;
    finally
      Q.Close;
    end;
  except
    if Not HideError then Raise;
  end;
end;

procedure ExecSQLText(aDataBaseName, aText:string; HideError:boolean);
var OldCursor: TCursor;
begin
  if Not Assigned(Q) then Q:=TQuery.Create(nil);
  Q.DataBaseName:=aDataBaseName;
  Q.Sql.Clear;
  Q.Sql.Add(aText);
  if Assigned(Screen) then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crSQLWait;
  end;
  try
    try
      Q.ExecSQL;
    except
      if Not HideError then Raise;
    end;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

function FieldDataByComma(aDataSet:TDataSet; aField:string):string;
begin
  Result:='';
  aDataSet.Open;
  aDataSet.First;
  while not aDataSet.EOF do begin
    if Result<>'' then Result:=Result+', ';
    Result:=Result+aDataSet.FieldByName(aField).AsString;
    aDataSet.Next;
  end;
  aDataSet.Close;
end;

initialization

finalization
  if Assigned(Q) then Q.Free;
end.
