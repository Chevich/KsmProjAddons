unit EtvProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DsgnIntf, StdCtrls, DBReg;

{ TLookupDestProperty }

type

TEtvLookupFieldProperty = class(TDBStringProperty)
public
  procedure GetValueList(List: TStrings); override;
end;
TEtvFieldProperty = class(TDBStringProperty)
public
  procedure GetValueList(List: TStrings); override;
end;

TEtvLookupProperty = class(TDBStringProperty)
public
  procedure GetValueList(List: TStrings); override;
end;
TEtvLookProperty = class(TDBStringProperty)
public
  procedure GetValueList(List: TStrings); override;
end;


TEtvLookupResultProperty = class(TDBStringProperty)
public
  procedure GetValueList(List: TStrings); override;
end;

TEtvLookupLevelFieldProperty = class(TDBStringProperty)
public
  procedure GetValueList(List: TStrings); override;
end;

TDataSetListProperty=class(TClassProperty)
  fSource,fTarget:TStrings;
public
  procedure AddToStrings(const S: string);
  procedure Edit; override;
  function GetAttributes: TPropertyAttributes; override;
end;

IMPLEMENTATION

uses TypInfo,DB,
     EtvDB,EtvDBFun,EtvLook,{EtvFilt,}EtvContr,DiDual;

procedure TEtvLookupFieldProperty.GetValueList(List: TStrings);
var i: Integer;
begin
  with GetComponent(0) as TField do if LookupDataSet <> nil then
    For i:=0 to LookupDataSet.FieldCount-1 do
      List.Add(LookupDataSet.Fields[i].FieldName);
end;

procedure TEtvFieldProperty.GetValueList(List: TStrings);
var i: Integer;
begin
  with GetComponent(0) as TField do if DataSet <> nil then
    For i:=0 to DataSet.FieldCount-1 do
      if DataSet.Fields[i].FieldName<>FieldName then
        List.Add(DataSet.Fields[i].FieldName);
end;

procedure TEtvLookupProperty.GetValueList(List: TStrings);
var i: Integer;
begin
  with GetComponent(0) as TEtvCustomDBLookupCombo do
    if (ListSource<>nil) and (ListSource.DataSet<>nil) then
      For i:=0 to ListSource.DataSet.FieldCount-1 do
        List.Add(ListSource.DataSet.Fields[i].FieldName);
end;

procedure TEtvLookProperty.GetValueList(List: TStrings);
var i: Integer;
begin
  with GetComponent(0) as TEtvCustomDBLookupCombo do
    if (DataSource<>nil) and (DataSource.DataSet<>nil) then
      For i:=0 to DataSource.DataSet.FieldCount-1 do
        List.Add(DataSource.DataSet.Fields[i].FieldName);
end;

procedure TEtvLookupResultProperty.GetValueList(List: TStrings);
var Pos:integer;
    s:string;
    lField:TField;
begin
  with GetComponent(0) as TEtvDBText do
    if Assigned(DataSource) and Assigned(DataSource.DataSet) then begin
      lField:=DataSource.DataSet.FindField(DataField);
      if Assigned(lField) and (lField is TEtvLookField) then begin
        s:=TEtvLookField(lField).AllLookupFields;
        Pos:=1;
        while Pos <= Length(s) do
          List.Add(ExtractFieldName(s, Pos));
      end;
    end;
end;

procedure TEtvLookupLevelFieldProperty.GetValueList(List: TStrings);
var i: Integer;
begin
  with GetComponent(0) as TEtvLookupLevelItem do if DataSet <> nil then
    For i:=0 to DataSet.FieldCount-1 do
      List.Add(DataSet.Fields[i].FieldName);
end;


function TDataSetListProperty.GetAttributes:TPropertyAttributes;
begin
  Result:=[paDialog{,paRevertable}];
end;

procedure TDataSetListProperty.AddToStrings(const S: string);
begin
  if fSource.IndexOf(S)=-1 then fTarget.Add(S);
end;

procedure TDataSetListProperty.Edit;
var Dial:TEtvDualListDlg;
    i:integer;
    lCollection:TDataSetCol;
begin
    Dial:=TEtvDualListDlg.Create(nil);
    lCollection:=TDataSetCol(GetOrdValue);
    with Dial do try
      Caption:='List of Datasets';
      SrcLabel.Caption:='Used';
      DstLabel.Caption:='Not Used';
      SrcList.Items.Clear;
      for i:=0 to lCollection.Count-1 do
        SrcList.Items.add(Self.Designer.GetComponentName(lCollection[i]));
      DstList.Items.Clear;
      fSource:=SrcList.Items;
      fTarget:=DstList.Items;
      Self.Designer.GetComponentNames(GetTypeData(TDataSet.ClassInfo),AddToStrings);
      if ShowModal=idOk then begin
        lCollection.Clear;
        for i:=0 to SrcList.Items.Count-1 do
          {if GetComponent(0) is TEtvFilter then
            TEtvFilter(GetComponent(0)).
              AddSubDataSet(TDataSet(Self.Designer.GetComponent(SrcList.Items[i])))
          else} begin
            if lCollection.AddItem(TDataSet(Self.Designer.GetComponent(SrcList.Items[i])),true) then
              lCollection[i].FreeNotification(TComponent(GetComponent(0)));
          end;
        Self.Designer.Modified;
      end;
    finally
      Dial.Free;
    end;
end;

end.
