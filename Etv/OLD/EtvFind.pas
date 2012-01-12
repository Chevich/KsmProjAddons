unit EtvFind; (* basic on Val unit; Igo *)

interface

{$I Etv.inc}

uses SysUtils,Windows,Messages,Classes,
     Controls,Forms,StdCtrls, DBTables, DB, Buttons;

Type
  TEtvFindDlg = class(TComponent)
  protected
    FMaxLabelWidth: Integer;
    FMaxEditWidth: Integer;
    FDataSource: TDataSource;
    fNoPartial,fSensitive:boolean;
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetDataSource(Value: TDataSource);
    function ToEditKey(DataSet:TDataSet):boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; virtual;
  published
    property MaxLabelWidth: Integer Read FMaxLabelWidth write FMaxLabelWidth;
    property MaxEditWidth: Integer Read FMaxEditWidth write FMaxEditWidth;
    property DataSource:TDataSource Read FDataSource Write SetDataSource;
  end;

implementation

Uses TypInfo,Bde,DBCommon,dbClient,Dialogs,
     EtvDB,DiFind,EtvForms,EtvDBFun,EtvConst,EtvPas,EtvContr;

procedure TEtvFindDlg.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = fDataSource) then
    DataSource := nil;
end;

Procedure TEtvFindDlg.SetDataSource(Value: TDataSource);
begin
  if FDataSource<>Value then begin
    FDataSource := Value;
    if Value <> nil then Value.FreeNotification(Self);
  end;
end;

type TBDEDataSetSelf=class(TBDEDataSet) end;

function TEtvFindDlg.ToEditKey(DataSet:TDataSet):boolean;
begin
  Result:=true;
  if DataSet is TClientDataSet then
    TClientDataSet(DataSet).EditKey
  else
    if DataSet is TBDEDataSet then
      TBDEDataSetSelf(DataSet).SetKeyBuffer(DBTables.kiLookup,false)
    else Result:=false;
end;

constructor TEtvFindDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fNoPartial:=true;
  fSensitive:=true;
end;

destructor TEtvFindDlg.Destroy;
begin
  inherited Destroy;
end;

type
TEtvFindDataSet=class(TBDEDataSet)
  protected
    function CreateHandle: HDBICur; override;
    procedure InternalOpen; override;
    {function GetRecordCount: Integer; override;}
    procedure EncodeFieldDesc(var FieldDesc: FLDDesc;
      const Name: string; DataType: TFieldType; Size,Precision: Word);

end;

procedure TEtvFindDataSet.EncodeFieldDesc(var FieldDesc: FLDDesc;
  const Name: string; DataType: TFieldType; Size,Precision: Word);
begin
  with FieldDesc do
  begin
    DBTables.AnsiToNative(Locale, Name, szName, SizeOf(szName) - 1);
    iFldType := FldTypeMap[DataType];
    iSubType := FldSubTypeMap[DataType];
    case DataType of
      {$IFDEF Delphi4}
      ftString, ftFixedChar, ftBytes, ftVarBytes, ftBlob..ftTypedBinary:
      {$ELSE}
      ftString, ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic,
      ftFmtMemo, ftParadoxOle, ftDBaseOle, ftTypedBinary:
      {$ENDIF}
        iUnits1 := Size;
      ftBCD:
        begin
          if (Precision > 0) and (Precision <= 32) then
            iUnits1 := Precision {Only Delphi4}
          else iUnits1 := 32;
          iUnits2 := Size;
        end;
    end;
  end;
end;

procedure TEtvFindDataSet.InternalOpen;
begin
  inherited;
  {$IFNDEF Delphi4}
  AfterInternalOpen(Self);
  {$ENDIF}
end;

function TEtvFindDataSet.CreateHandle: HDBICur;
type TFieldDescListSelf = dbTables.TFieldDescList;
 PFieldDescList = ^TFieldDescListSelf;
var
  i:integer;
  {$IFDEF Delphi4}
  FieldDescs:TFieldDescListSelf;
  {$ELSE}
  FieldDescs:PFLDDesc;
  {$ENDIF}
begin
  CheckInactive;
  FieldDefs.Clear;
  if FieldDefs.Count = 0 then
    for I:=0 to FieldCount-1 do
      with Fields[I] do
        if FieldKind = fkData then
          FieldDefs.Add(FieldName, DataType, Size, Required);
  {$IFDEF Delphi4}
  SetLength(FieldDescs, FieldDefs.Count);
  {$ELSE}
  FieldDescs := AllocMem(FieldDefs.Count*SizeOf(FLDDesc));
  {$ENDIF}
  try
    for I := 0 to FieldDefs.Count - 1 do with FieldDefs[I] do
      {$IFDEF Delphi4}
      Self.EncodeFieldDesc(FieldDescs[I],Name,DataType, Size,Precision);
      {$ELSE}
      Self.EncodeFieldDesc(PFieldDescList(FieldDescs)^[I],Name,DataType,Size,0);
      {$ENDIF}
    Check(DbiTranslateRecordStructure(nil, FieldDefs.Count, BDE.PFLDDesc(FieldDescs), nil,
      nil, BDE.PFLDDesc(FieldDescs), False));
    Check(DbiCreateInMemTable(nil,pChar('EtvFind'),
      Cardinal(FieldDefs.Count), BDE.PFLDDesc(FieldDescs),Result));
  finally
    {$IFNDEF Delphi4}
    FreeMem(FieldDescs, FieldDefs.Count*SizeOf(FLDDesc));
    {$ENDIF}
  end;
end;

function TEtvFindDlg.Execute: Boolean;
var i, j, Lw, Ew,ATop,ALeft: Integer;
    Lab: TLabel;
    Ed: TWinControl;
    Field: TField;
    List: TList;
    {$IFDEF SAW}
    (* This flag for SAW, who dont undestand the next date - "1.1.0" *)
    SawIndexClear:boolean;
    OldIndex: String;
    OldIndexByFields:boolean;
    {$ENDIF}
    Va:variant;
    s:string;
    SetKeyExist,NeedLocate,MayGotoNearest:boolean;
    lWidth,lHeight:integer;
    iList:TList;
    CurSortingFields:string;
    SortingFieldCount:integer;
    lDataSet:TEtvFindDataSet;
    StringFieldExist:boolean;
    lOptions: TLocateOptions;
    PropInfo:PPropInfo;
begin
  Result:=false;
  if (FDataSource<>Nil)and(FDataSource.DataSet<>Nil) then begin
    CurSortingFields:=SortingFromDataSet(fDataSource.DataSet);
    if CurSortingFields='' then begin
      EtvApp.ShowMessage(SKeyDlgSortingMissing);
      Exit;
    end;
    fDataSource.DataSet.CheckBrowseMode;
    DialFind:=TDialFind.Create(Application);
    List:=TList.Create;
    iList:=TList.Create;
    lDataSet:=TEtvFindDataSet.Create(nil);
    with fDataSource.DataSet do try
      DisableControls;
      try
        (* list of fields for find *)
        GetFieldList(iList,CurSortingFields);
        for i:=0 to FieldCount-1 do
          if not (Fields[i] is TBlobField) then begin
            TField(CloneComponent(Fields[i])).DataSet:=lDataSet;
            lDataSet.Fields[lDataSet.fieldCount-1].ReadOnly:=false;
          end;
        StringFieldExist:=false;
        Lw:=0; Ew:=0;
        for i:=0 to iList.Count-1 do begin
          Field:=TField(iList[i]);
          if Field is TStringField then StringFieldExist:=true;
          for j:=0 to FieldCount-1 do
            if (fields[j].FieldKind=fkLookup) and
               (fieldByName(fields[j].keyfields)=IList[i]) then begin
              Field:=fields[j];
              Break;
            end;
          List.Add(lDataSet.FieldByName(Field.FieldName));
          if Length(Field.DisplayLabel)>Lw Then Lw:=Length(Field.DisplayLabel);
          if Field.DisplayWidth>Ew then Ew:=Field.DisplayWidth;
        end;

        DialFind.DataSource.DataSet:=lDataSet;
        lDataSet.Open;
        lDataSet.Insert;
        SetKeyExist:=ToEditKey(fDataSource.DataSet);
        if SetKeyExist then begin
          for i:=0 to lDataSet.FieldCount-1 do
            if lDataSet.Fields[i].FieldKind=fkData then
              lDataSet.Fields[i].Value:=
                FieldByName(lDataSet.Fields[i].FieldName).Value;
          CheckBrowseMode;
        end;
        With DialFind do begin
          Caption:=Caption+' '+FieldsDisplayName(lDataSet,CurSortingFields);
          Bevel1.Height:=iList.Count*28+8;
          Height:=Bevel1.Height+40+Panel.Height;
          ATop:=Bevel1.Top+8;
          ALeft:=Bevel1.Left+4;
          if (FMaxLabelWidth>0)and(Lw>FMaxLabelWidth) then Lw:=FMaxLabelWidth;
          if (FMaxEditWidth>0)and(Ew>FMaxEditWidth) then Ew:=FMaxLabelWidth;
          Lw:=Lw*10;
          Ew:=Ew*10;
          if Bevel1.Width<Lw+Ew+8 then Bevel1.Width:=Lw+Ew+8;
          Width:=Bevel1.Width+20;
          GetFontSizes(DialFind.Font,lWidth,lHeight,'');
          For i:=0 to List.Count-1 do begin
            Lab:=TLabel.Create(DialFind);
            Lab.Top:=ATop;
            Lab.Left:=ALeft;
            Lab.Caption:=TField(List[i]).DisplayLabel;

            Ed:=TWinControl(DBEditForField(DialFind,TField(List[i]),DataSource,lWidth));
            Ed.Top:=ATop;
            Ed.Left:=ALeft+Lw;

            Lab.FocusControl:=Ed;
            InsertControl(Lab);
            InsertControl(Ed);
            if ControlRequiredParent(Ed) then begin
              PropInfo := GetPropInfo(Ed.ClassInfo, 'DataField');
              if PropInfo <> nil then
              SetStrProp(Ed, PropInfo, TField(List[i]).FieldName);
            end;
            if i=0 then ActiveControl:=Ed;
            Inc(ATop,28);
          end;
          CheckBoxCase.Checked:=fSensitive;
          CheckBoxNoPartial.Checked:=fNoPartial;
          if StringFieldExist then begin
            CheckBoxCase.Enabled:=true;
            CheckBoxNoPartial.Enabled:=true;
          end else begin
            CheckBoxCase.Enabled:=false;
            CheckBoxNoPartial.Enabled:=false;
          end;
          EtvApp.DisableRefreshForm;
          Result:=ShowModal=idOk;
          EtvApp.EnableRefreshForm;
          if Result and StringFieldExist then begin
            fSensitive:=CheckBoxCase.Checked;
            fNoPartial:=CheckBoxNoPartial.Checked;
          end;
        end;

        if Result then begin
          if SetKeyExist then begin
            ToEditKey(fDataSource.DataSet);
            for i:=0 to iList.Count-1 do
              TField(iList[i]).Value:=
                lDataSet.FieldByName(TField(iList[i]).FieldName).Value;
          end;

          SortingFieldCount:=iList.Count;
          while (SortingFieldCount>0) and
                (lDataSet.FieldByName(TField(iList[SortingFieldCount-1]).FieldName).value=Null) do
            Dec(SortingFieldCount);

          if SortingFieldCount>0 then begin

            i:=0;
            while lDataSet.FieldByName(TField(iList[i]).FieldName).value=Null do
              Inc(i);
            if (i=0) and ((fDataSource.DataSet is TTable) or
                          (fDataSource.DataSet is TClientDataSet)) then
              NeedLocate:=false
            else NeedLocate:=true;
            MayGotoNearest:=false;

            {$IFDEF SAW}
            SawIndexClear:=false;
            if (fDataSource.DataSet is TTable) or
               (fDataSource.DataSet is TClientDataSet) then
              for j:=SortingFieldCount to iList.Count-1 do
                if TField(iList[j]) is TDateField then begin
                  NeedLocate:=true;
                  SAWIndexClear:=true;
                  break;
                end;
            {$ENDIF}

            StringFieldExist:=false;
            for j:=i to SortingFieldCount-1 do
              if TField(iList[j]) is TStringField then begin
                StringFieldExist:=true;
                Break;
              end;

            if (Not NeedLocate) and StringFieldExist and
               ((Not DialFind.CheckBoxCase.Checked) or
                (Not DialFind.CheckBoxNoPartial.Checked)) then begin
              NeedLocate:=true;
              MayGotoNearest:=true;
            end;

            if NeedLocate then begin
              s:='';
              if i<SortingFieldCount-1 then begin
                Va:=VarArrayCreate([0,SortingFieldCount-i-1], varVariant);
                for j:=i to SortingFieldCount-1 do begin
                  if s<>'' then s:=s+';';
                  s:=s+TField(iList[j]).FieldName;
                  Va[j-i]:=lDataSet.FieldByName(TField(iList[j]).FieldName).value;
                end;
              end else begin
                s:=TField(iList[i]).FieldName;
                Va:=lDataSet.FieldByName(TField(iList[i]).FieldName).value;
              end;

              {$IFDEF SAW}
              if SAWIndexClear then
               if fDataSource.DataSet is TTable then with TTable(fDataSource.DataSet) do begin
                if indexFieldNames<>'' then begin
                  OldIndexByFields:=true;
                  OldIndex:=indexFieldNames;
                end else begin
                  OldIndexByFields:=false;
                  OldIndex:=IndexName;
                end;
                IndexFieldNames:='';
              end else with TClientDataSet(fDataSource.DataSet) do begin
                if indexFieldNames<>'' then begin
                  OldIndexByFields:=true;
                  OldIndex:=indexFieldNames;
                end else begin
                  OldIndexByFields:=false;
                  OldIndex:=IndexName;
                end;
                IndexFieldNames:='';
              end;
              {$ENDIF}

              lOptions:=[];
              if StringFieldExist then begin
                if Not fSensitive then
                  lOptions:=[loCaseinSensitive];
                if Not fNoPartial then
                lOptions:=lOptions+[loPartialKey];
              end;
              if Not locate(s,va,lOptions) then
                if MayGotoNearest then begin
                  if fDataSource.DataSet is TTable then with TTable(fDataSource.DataSet) do begin
                    EtvApp.DisableRefreshForm;
                    if MessageDlg(SKeyDlgRecordNotFound+#10+SKeyDlgGotoNearest,
                       mtInformation, [mbYes, mbNo], 0) = mrYes then begin
                      ToEditKey(fDataSource.DataSet);
                      KeyFieldCount:=SortingFieldCount;
                      GotoNearest;
                    end;
                    EtvApp.EnableRefreshForm;
                  end
                  else with TClientDataSet(fDataSource.DataSet) do begin
                    EtvApp.DisableRefreshForm;
                    if MessageDlg(SKeyDlgRecordNotFound+#10+SKeyDlgGotoNearest,
                       mtInformation, [mbYes, mbNo], 0) = mrYes then begin
                      ToEditKey(fDataSource.DataSet);
                      KeyFieldCount:=SortingFieldCount;
                      GotoNearest;
                    end;
                    EtvApp.EnableRefreshForm;
                  end;
                end
                else EtvApp.ShowMessage(SKeyDlgRecordNotFound);

              {$IFDEF SAW}
              if SAWIndexClear then
                if fDataSource.DataSet is TTable then with TTable(fDataSource.DataSet) do
                  if OldIndexByFields then IndexFieldNames:=OldIndex
                  else IndexName:=OldIndex
                else with TClientDataSet(fDataSource.DataSet) do
                  if OldIndexByFields then IndexFieldNames:=OldIndex
                  else IndexName:=OldIndex;
              {$ENDIF}

            end else begin
              if fDataSource.DataSet is TTable then with TTable(fDataSource.DataSet) do begin
                KeyFieldCount:=SortingFieldCount;
                if Not gotokey then begin
                  EtvApp.DisableRefreshForm;
                  if MessageDlg(SKeyDlgRecordNotFound+#10+SKeyDlgGotoNearest,
                     mtInformation, [mbYes, mbNo], 0) = mrYes then GotoNearest;
                  EtvApp.EnableRefreshForm;
                end
              end else with TClientDataSet(fDataSource.DataSet) do begin
                KeyFieldCount:=SortingFieldCount;
                if Not gotokey then begin
                  EtvApp.DisableRefreshForm;
                  if MessageDlg(SKeyDlgRecordNotFound+#10+SKeyDlgGotoNearest,
                     mtInformation, [mbYes, mbNo], 0) = mrYes then GotoNearest;
                  EtvApp.EnableRefreshForm;
                end;
              end;
            end;
          end else begin
           CheckBrowseMode;
           EtvApp.ShowMessage(SKeyDlgFieldsEmpty);
          end;
        end else CheckBrowseMode;
      finally
        if lDataSet.state=dsInsert then lDataSet.Cancel;
        EnableControls;
      end;
    finally
      if Assigned(lDataSet) then lDataSet.free;
      if Assigned(iList) then iList.free;
      if Assigned(List) then List.Free;
      if Assigned(DialFind) then DialFind.Free;
    end;
  end;
end;

end.
