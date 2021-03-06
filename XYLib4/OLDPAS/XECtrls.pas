{$I XLib.inc }
Unit XECtrls;

Interface

Uses Classes,  Graphics, Controls, DB, DBCtrls, Messages,
     XCtrls, EtvContr, EtvLook, EtvGrid, XMisc, EtvRxCtl;

type

{ TXEDBEdit }

  TXEDBEdit = class(TEtvDBEdit)
  private
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;

{ TXEDBDateEdit }

  TXEDBDateEdit = class(TEtvDBDateEdit)
  private
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;

{ TXEDBCombo }

  TXEDBCombo=class(TEtvDBCombo)
  private
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;

  TXEDBMemo = class(TDBMemo)
  private
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;

{ TXEDBLookupCombo }

  TXEDBLookupCombo = class(TEtvDBLookupCombo)
  private
    FIsContextOpen: Boolean;
    FStoreDataSet: TDataSet;
    FStoreColor: TColor;
    FStoreHeadColor:TColor;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
  protected
    procedure ReadState(Reader: TReader); override;
    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ TXEDBInplaceLookUpCombo }

  TXEDBInplaceLookUpCombo = class(TEtvInplaceLookupCombo)
  private
    FIsContextOpen: Boolean;
    FStoreDataSet: TDataSet;
    FStoreColor: TColor;
    FStoreHeadColor:TColor;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
  protected
    procedure ReadState(Reader: TReader); override;
    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure SetHideFlag(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ TXEDbGrid }

  TXEDbGrid=class(TEtvDbGrid)
  private
    FIsStoredDataSource: Boolean;
    FStoredDataSource: TDataSource;
    FStoredControlSource: TDataSource;
    FStoredColumn: Integer;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMChangePageSource(var Msg: TMessage); message WM_ChangePageSource;
    procedure WMChangeControlSource(var Msg: TMessage); message WM_ChangeControlSource;
    procedure ReadDataSource(Reader: TReader);
    procedure WriteDataSource(Writer: TWriter);
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure ReadIsDataSource(Reader: TReader);
    procedure WriteIsDataSource(Writer: TWriter);
  protected
    function CreateInplaceLookupCombo:TEtvInplaceLookupCombo; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DefineProperties(Filer: TFiler);override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure ColEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure FormatColumns;
  published
    property DataSource read GetDataSource write SetDataSource stored False;
  end;

var XNotifyEvent: TXNotifyEvent;

Implementation

Uses Windows, Dialogs, Forms, DBTables, LnTables, EtvBor, LnkSet, EtvDB, FVisDisp, EtvPopup,
     SysUtils, XTFC, XDBTFC, XForms, XDBMisc, LnkMisc, EtvOther, TlsForm ;

{ TXEDBEdit }

Procedure TXEDBEdit.WMSetFocus(var Message: TWMSetFocus);
(*
const FirstFFF:boolean=true;
      I: integer=0;
var FFF: TextFile;
    UUU: String;
*)
begin
  Inherited;
  {******************************************************
  if FirstFFF then begin
    AssignFile(FFF,'c:\temp\tempik.tmp');
    Rewrite(FFF);
    FirstFFF:=false;
  end else begin
    AssignFile(FFF,'c:\temp\tempik.tmp');
    Append(FFF);
  end;
  Inc(I);
  if Assigned(DataSource) then UUU:=DataSource.Name else UUU:='���';
  writeln(FFF,IntToStr(I)+' '+UUU);
  CloseFile(FFF);
  {******************************************************}
  XNotifyEvent.GoSpellChild(GetParentForm(Self), xeChangeParams, DataSource, opInsert);
  CreateCaret(Handle, 0, Font.Size div 2, Height);
  ShowCaret(Handle);
end;

Procedure TXEDBEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if AComponent is TXNotifyEvent then
    case TXNotifyEvent(AComponent).SpellEvent of
      xeGetFirstXControl: TXNotifyEvent(AComponent).GoEqual(Self, Operation);
      xeIsThisLink:
        if Assigned(DataSource) and
        (DataSource = TXNotifyEvent(AComponent).SpellChild) then begin
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
      xeSetParams:
        begin
          if Operation = opInsert then begin
            TXEDBLookupCombo(TXNotifyEvent(AComponent).SpellChild).KeyValue:=Self.Text;
            TDBLookupComboBoxBorland(TXNotifyEvent(AComponent).SpellChild).FDataList.KeyValue:=Self.Text;
          end else begin
            Field.AsString:=
                  TDBLookupComboBoxBorland(TXNotifyEvent(AComponent).SpellChild).FDataList.KeyValue;
          end;
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
    end
  else Inherited Notification(AComponent, Operation);
end;

{ TXEDBDateEdit }

Procedure TXEDBDateEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  Inherited;
  XNotifyEvent.GoSpellChild(GetParentForm(Self), xeChangeParams, DataSource, opInsert);
  CreateCaret(Handle, 0, Font.Size div 2, Height);
  ShowCaret(Handle);
end;

Procedure TXEDBDateEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if AComponent is TXNotifyEvent then
    case TXNotifyEvent(AComponent).SpellEvent of
      xeGetFirstXControl: TXNotifyEvent(AComponent).GoEqual(Self, Operation);
      xeIsThisLink:
        if Assigned(DataSource)and
        (DataSource = TXNotifyEvent(AComponent).SpellChild) then begin
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
    end
  else Inherited Notification(AComponent, Operation);
end;

{ TXEDBCombo }

Procedure TXEDBCombo.WMSetFocus(var Message: TWMSetFocus);
begin
  Inherited;
  XNotifyEvent.GoSpellChild(GetParentForm(Self), xeChangeParams, DataSource, opInsert);
end;

Procedure TXEDBCombo.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if AComponent is TXNotifyEvent then
    case TXNotifyEvent(AComponent).SpellEvent of
      xeGetFirstXControl: TXNotifyEvent(AComponent).GoEqual(Self, Operation);
      xeIsThisLink:
        if Assigned(DataSource)and
        (DataSource = TXNotifyEvent(AComponent).SpellChild) then begin
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
    end
  else Inherited Notification(AComponent, Operation);
end;

Procedure TXEDBMemo.WMSetFocus(var Message: TWMSetFocus);
begin
  Inherited;
  XNotifyEvent.GoSpellChild(GetParentForm(Self), xeChangeParams, DataSource, opInsert);
  CreateCaret(Handle, 0, Font.Size div 2, Height);
  ShowCaret(Handle);
end;

Procedure TXEDBMemo.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if AComponent is TXNotifyEvent then 
    case TXNotifyEvent(AComponent).SpellEvent of
      xeGetFirstXControl: TXNotifyEvent(AComponent).GoEqual(Self, Operation);
      xeIsThisLink:
        if Assigned(DataSource) and
        (DataSource = TXNotifyEvent(AComponent).SpellChild) then begin
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
    end
  else Inherited Notification(AComponent, Operation);
end;

{ common procedures }

Procedure XEDBSetLookupMode(Self: TDBLookupControl; Value: Boolean);
begin
  with TDBLookupControlBorland(Self) do
    if FLookupMode <> Value then
      if Value then begin
        FMasterField:=GetFieldProperty(FDataField.DataSet, Self, FDataField.KeyFields);
        FLookupSource.DataSet:=FDataField.LookupDataSet;
        FKeyFieldName:=FDataField.LookupKeyFields;
        FLookupMode:=True;
        FListLink.DataSource:=FLookupSource;
      end else begin
        FListLink.DataSource:=nil;
        FLookupMode:=False;
        FKeyFieldName:='';
        FLookupSource.DataSet:=nil;
        FMasterField:=FDataField;
      end;
end;

Procedure XEDBDataLinkRecordChanged(Self: TDBLookupComboBox);
begin
  with Self, TDBLookupControlBorland(Self) do
    if FMasterField <> nil then KeyValue:= FMasterField.Value
    else KeyValue:=Null;
end;

Procedure XEDBChangeDataField(Self: TDBLookupComboBox; Field: TField);
begin
  XEDBSetLookupMode(Self, False);
  TDBLookupControlBorland(Self).FDataField:=Field;
  XEDBSetLookupMode(Self, True);
  XEDBDataLinkRecordChanged(Self);
end;

Procedure XEDBPaint(Self: TEtvCustomDBLookupCombo; FIsContextOpen: Boolean;
                    FStoreColor, FStoreHeadColor: TColor);
begin
  if not FIsContextOpen then
    with TDBLookupComboBoxBorland(self).FDataList do begin
      Color:=FStoreColor;
      Self.HeadColor:=FStoreHeadColor;
    end;
end;

{ Lev 17.04.99 The Begin  }
procedure XEDBSetIsContextOpen(Self: TEtvCustomDBLookupCombo; AValue: Boolean;
                               var FIsContextOpen: Boolean; FStoreColor, FStoreHeadColor: TColor;
                               FStoreDataSet: TDataSet);
var LC:TDBLookupControlBorland;
begin
  LC:=TDBLookupControlBorland(Self);
  if (FIsContextOpen<>AValue) and Assigned(FStoreDataSet) then
    {with LC.FDataField do}
    if AValue then begin
      if LC.FLookUpMode then begin
        LC.FDataField.DataSet.DisableControls;
        TFieldBorland(LC.FDataField).FLookupDataSet:=
          TLinkQuery(FStoreDataSet).LinkSource.LikeQuery;
      end else LC.FlistLink.DataSource.DataSet:=
                 TLinkQuery(FStoreDataSet).LinkSource.LikeQuery;
      if LC.FLookUpMode then XEDBChangeDataField(Self, LC.FDataField);
      Self.Color:=clLime or clSilver;
      TDBLookupComboBoxBorland(self).FDataList.Color:=clLime or clSilver;
      if Assigned(Self.Field) and (Self.Field is TEtvLookField) then
        TEtvLookField(Self.Field).HeadColor:=clYellow
      else Self.HeadColor:=clYellow;
      {Self.Field.HeadColor:=clYellow;}
      Self.HeadLineStr:='������� �� "'+
        TLinkQuery(FStoreDataSet).LinkSource.LikePatterns[0]+'" - '+
          IntToStr(TLinkQuery(FStoreDataSet).LinkSource.LikeQuery.RecordCount)+' �������';
      if LC.FlookUpMode then LC.FDataField.DataSet.EnableControls;
      FIsContextOpen:=True;
    end else begin
      if LC.FLookUpMode then begin
        LC.FDataField.DataSet.DisableControls;
        TFieldBorland(LC.FDataField).FLookupDataSet:=FStoreDataSet;
      end else LC.FlistLink.DataSource.DataSet:=FStoreDataSet;
      if LC.FLookUpMode then XEDBChangeDataField(Self,LC.FDataField);

      LC.FListLink.DataSet.Locate(LC.FListField.FieldName,TDBLookupComboBoxBorland(self).
        FDataList.KeyValue, [loCaseInsensitive, loPartialKey]);
      Self.HeadLineStr:='';

      if Assigned(Self.Field) and (Self.Field is TEtvLookField) then
        TEtvLookField(Self.Field).HeadColor:=FStoreHeadColor
      else Self.HeadColor:=FStoreHeadColor;

      Self.Color:=FStoreColor;
      if LC.FlookUpMode then LC.FDataField.DataSet.EnableControls;
      FIsContextOpen:=False;
    end;
end;
{ Lev 17.04.99 The End }

Procedure XEDBContextUse(Self: TEtvCustomDBLookupCombo;
                         var FIsContextOpen: Boolean; FStoreColor, FStoreHeadColor: TColor;
                         FStoreDataSet: TDataSet);
begin
  XEDBSetIsContextOpen(Self, Not FIsContextOpen, FIsContextOpen, FStoreColor,
                       FStoreHeadColor, FStoreDataSet);
end;

{ Lev 17.04.99 The Begin }
Procedure XEDBContextCreate(Self: TEtvCustomDBLookupCombo; Const AStr:String;
                            var FIsContextOpen: Boolean; FStoreColor,
                            FStoreHeadColor: TColor; var FStoreDataSet: TDataSet);
var
  LinkSet: TLinkSource;
  LC:TDBLookupControlBorland;
  LDataSet: TDataSet;   { LookUpDataSet }
  LResultField: String; { LookUpResultField }
begin
  LC:=TDBLookupControlBorland(Self);
  if not((Assigned(LC.FDataField) and LC.FDataField.Lookup) or
  (Assigned(LC.FlistLink.DataSource) and (LC.FListFieldName<>'') and
  (LC.FKeyFieldName<>''))) then Exit;
  { ������������� LookupDataSet'� � LookUpResultField'�� }
  if LC.FLookupMode then begin
    LDataSet:=LC.FDataField.LookUpDataSet;
    {LResultField:=TEtvLookField(LC.FDataField).LookUpResultField;}
    LResultField:=LC.FDataField.LookUpResultField;
  end else begin
    LDataSet:=LC.FListLink.DataSource.DataSet;
    LResultField:=LC.FListFieldName;
  end;
  if FIsContextOpen then LinkSet:=TLinkQuery(FStoreDataSet).LinkSource
  else
    if LDataSet is TLinkQuery then
      LinkSet:=TLinkQuery(LDataSet).LinkSource
    else LinkSet:=nil;
  if Assigned(LinkSet) then {with LC.FDataField do} begin
    LinkSet.CreateLikeQuery;
    if LC.FLookUpMode then LC.FDataField.DataSet.DisableControls;
    if not FIsContextOpen then FStoreDataSet:=LDataSet;
    if LinkSet.ChangeLikeQuery(FStoreDataSet, LResultField, AStr) then FIsContextOpen:=False;
    XEDBContextUse(Self, FIsContextOpen, FStoreColor, FStoreHeadColor, FStoreDataSet);
    if LC.FLookUpMode then LC.FDataField.DataSet.EnableControls;
  end;
end;
{ Lev 17.04.99 The End }

Procedure XEDBContextInit(Self: TEtvCustomDBLookupCombo;
                          var FIsContextOpen: Boolean; FStoreColor,
                          FStoreHeadColor: TColor; FStoreDataSet: TDataSet);
begin
  Self.Color:=FStoreColor;
  Self.HeadColor:=FStoreHeadColor;
  XEDBSetIsContextOpen(Self, False, FIsContextOpen, FStoreColor,
                       FStoreHeadColor, FStoreDataSet);
end;

type
  TXEPopupDataList = class(TEtvPopupDataList)
  end;

Function XEDBNotContextSearchKey(Self: TEtvCustomDBLookupCombo;
           var Key: Char; var FIsContextOpen: Boolean; FStoreColor, FStoreHeadColor: TColor;
           var FStoreDataSet: TDataSet): boolean;
var s:string;
begin
  Result:=True;
  if Self.ListVisible then
    with Self, TDBLookupControlBorland(Self)
      {TDBLookupControlBorland(TDBLookupComboBoxBorland(self).FDataList)}
    do
      if (FListField<>nil) and (FListField.FieldKind=fkData) and
      ((FListField.DataType=ftString) or
      ((FListField.DataType in [ftInteger,ftSmallInt,ftAutoInc]) and
      (Key in [{Char(VK_Back),}#27,'0'..'9']))) then {Lev 30/04/97}
        case Key of
          #27:
            if FIsContextOpen then begin
              XEDBContextInit(Self,FIsContextOpen,FStoreColor,FStoreHeadColor,FStoreDataSet);
              Invalidate;
              Result:=False;
            end;
(*
          #27: FSearchText := '';
          Char(VK_Back):
            begin
              S:=FSearchText;
              Delete(S,Length(S),1);
              TDBLookupControlBorland(self).FSearchText:=S;
              TDBLookupControlBorland(TDBLookupComboBoxBorland(self).FDataList).FSearchText:=S;
              Invalidate;
              Result:=False;
            end;
*)
          #32..#255:
            if FListActive and not ReadOnly and ((FDataLink.DataSource = nil) or
            (FMasterField<>nil) and FMasterField.CanModify) then begin
              if Length(FSearchText)<32 then begin
                S:=TDBLookupControlBorland(
                     TDBLookupComboBoxBorland(Self).FDataList).FSearchText+Key;
                if FListLink.DataSet.Locate(FListField.FieldName,S,
                [loCaseInsensitive, loPartialKey]) then begin
{                 TXEDBLookupCombo(Self).SelectKeyValue(FKeyField.Value);}
                  TXEPopupDataList(TDBLookupComboBoxBorland(Self).FDataList).
                    SelectKeyValue(FKeyField.Value);
{                 FSearchText := S;
                  TDBLookupControlBorland(TDBLookupComboBoxBorland(self).FDataList).FSearchText:=S;}
                end;
                if FListField.DataType in [ftInteger, ftSmallInt, ftAutoInc] then
                  if Length(FSearchText)<8 then begin
{                   FSearchText := S;}
                    TDBLookupControlBorland(TDBLookupComboBoxBorland(Self).
                      FDataList).FSearchText:=S;
                  end else
                else begin
                  FSearchText:=S;
                  TDBLookupControlBorland(TDBLookupComboBoxBorland(Self).
                    FDataList).FSearchText:=S;
                end;
                Invalidate;
                Result:=False;
              end;
            end;
        end; { case }
end;

Procedure XEDBSetContextKey(Self: TEtvCustomDBLookupCombo;
            var FIsContextOpen: Boolean; FStoreColor, FStoreHeadColor: TColor;
            var FStoreDataSet: TDataSet);
begin
  if Self.ListVisible then with Self, TDBLookupControlBorland(self) do
    if (FListField<>nil) and (FListField.FieldKind=fkData) then begin
      if TDBLookupControlBorland(TDBLookupComboBoxBorland(self).FDataList).FSearchText<>'' then
        XEDBContextCreate(Self, TDBLookupControlBorland(TDBLookupComboBoxBorland(Self).
          FDataList).FSearchText, FIsContextOpen, FStoreColor, FStoreHeadColor, FStoreDataSet)
      else begin
        XEDBContextUse(Self, FIsContextOpen, FStoreColor, FStoreHeadColor, FStoreDataSet);
        if FIsContextOpen then begin
          TDBLookupControlBorland(TDBLookupComboBoxBorland(self).FDataList).FSearchText:=
          TLinkQuery(FStoreDataSet).LinkSource.LikePatterns[0];
        end;
      end;
      Invalidate;
    end;
end;

{ TXEDBLookupCombo }

Constructor TXEDBLookupCombo.Create(AOwner: TComponent);
begin
  Inherited;
  FStoreDataSet:=nil;
  FIsContextOpen:=False;
  FStoreColor:=Color;
  {FStoreHeadColor:=HeadColor;}
end;

Procedure TXEDBLookupCombo.ReadState(Reader: TReader);
begin
  Inherited ReadState(Reader);
  FStoreColor:=Color;
  {FStoreHeadColor:=HeadColor;}
end;

Procedure TXEDBLookupCombo.Paint;
begin
  XEDBPaint(Self, FIsContextOpen, FStoreColor, FStoreHeadColor);
  Inherited Paint;
end;

Procedure TXEDBLookupCombo.KeyPress(var Key: Char);
begin
  if XEDBNotContextSearchKey(Self, Key, FIsContextOpen,
                                   FStoreColor, FStoreHeadColor, FStoreDataSet) then
  Inherited KeyPress(Key);
end;

Function XEDBSystemLookup: Boolean;
begin
  if TXEDBLookupCombo(SystemMenuItemObject).ListVisible then
    with TXEDBLookupCombo(SystemMenuItemObject) do begin
      XEDBSetContextKey(TXEDBLookupCombo(SystemMenuItemObject), FIsContextOpen,
        FStoreColor, FStoreHeadColor, FStoreDataSet);
      Result:=True;
    end else Result:=False;
end;

Procedure SetOpenReturnControl(AField: TField; ADataSource: TDataSource; AOwner: TComponent);
var LinkSet, FormLinkSet: TLinkSource;
    DBF1: TDBFormControl;
begin
  if Assigned(AField) and (AField.LookupDataSet is TLinkQuery) then begin
    LinkSet:=TLinkQuery(AField.LookupDataSet).LinkSource;
    if (ADataSource is TLinkSource) then FormLinkSet:=TLinkSource(ADataSource)
    else FormLinkSet:=nil;
    if Assigned(LinkSet) then begin
{     if Assigned(FormLinkSet) then begin
      FormLinkSet.IsCheckPostedMode:=False;
      end;}
{!}
{     XNotifySelect.GoSpellSelect(LinkSet,xeSetParams, AField, AOwner, opInsert);}
      if (AOwner is TXForm) and (TXForm(AOwner).FormControl is TDBFormControl) then begin
        DBF1:= GetLinkedDBFormControl(LinkSet);
        if Assigned(DBF1) then begin
          DBF1.SelectedField:= AField;
          DBF1.ReturnForm:= TForm(AOwner);
          TDBFormControl(TXForm(AOwner).FormControl).OpenReturnControl:= DBF1;
        end;
      end;
{!}
(*
        if (XNotifySelect.SpellEvent=xeNone) and (AOwner is TXForm) then with TXForm(AOwner) do
{           if Assigned(XFormLink) and Assigned(XFormLink.LinkControl) then
              TFormControl(XFormLink.LinkControl).OpenReturnControl:=TFormControl(XNotifySelect.SpellSelect);}
           if Assigned(FormControl) then
              TFormControl(FormControl).OpenReturnControl:=TFormControl(XNotifySelect.SpellSelect);
*)
    end;
  end;
end;

Procedure ClearOpenReturnControl(AOwner: TComponent);
begin
  if AOwner is TXForm then with TXForm(AOwner) do
{     if Assigned(XFormLink) and Assigned(XFormLink.LinkControl) then
        TFormControl(XFormLink.LinkControl).OpenReturnControl:=Nil;}
  if Assigned(FormControl) then TFormControl(FormControl).OpenReturnControl:=nil;
end;

Procedure TXEDBLookupCombo.WMSetFocus(var Message: TWMSetFocus);
var LinkSet, FormLinkSet: TLinkSource;
    ADataSet: TDataSet;
    AField: TField;
    DBF1: TDBFormControl;
begin
  Inherited;
  FStoreColor:=Color;
  FStoreHeadColor:=GetHeadColor;
  SystemMenuItemObject:=Self;
  SystemMenuItemProc:=XEDBSystemLookup;
  XNotifyEvent.GoSpellChild(GetParentForm(Self), xeChangeParams, DataSource, opInsert);
  if Assigned(TDBLookupControlBorland(Self).FDataField) then
    if TDBLookupControlBorland(Self).FDataField.Lookup and
    (TDBLookupControlBorland(Self).FDataField.LookupDataSet is TLinkQuery) then begin
      LinkSet:=TLinkQuery(TDBLookupControlBorland(Self).FDataField.LookupDataSet).LinkSource;
      if Assigned(LinkSet) then begin
{!
        XNotifySelect.GoSpellSelect(LinkSet,xeSetParams,TDBLookupControlBorland(Self).FDataField,
                                       Owner, opRemove);
}
{!}
        DBF1:= GetLinkedDBFormControl(LinkSet);
        if Assigned(DBF1) and (DBF1.ReturnForm=Owner) then begin
          LinkSet.IsSetReturn:= False;
          DBF1.ReturnForm:=nil;
          if LinkSet.IsReturnValue then begin
            LinkSet.IsReturnValue:=False;
            ADataSet:=TDBLookupControlBorland(Self).FDataField.LookupDataSet;
            if ADataSet is TLinkQuery then begin
              AField:=TLinkQuery(ADataSet).LinkSource.Declar.FindField(
                TDBLookupControlBorland(Self).FDataField.LookupKeyFields);
              SelectKeyValue(AField.Value);
            end;
            if (DataSource is TLinkSource) then FormLinkSet:=TLinkSource(DataSource)
            else FormLinkSet:=nil;
            if Assigned(FormLinkSet) then begin
              FormLinkSet.PostChecked:=True;
            end;
          end;
        end;

      end;
    end;
  SetOpenReturnControl(TDBLookupControlBorland(Self).FDataField, DataSource, Owner);
end;

{ Lev. Time Of Correction 18.04.99 The Begin }
Procedure TXEDBLookupCombo.WMKillFocus(var Message: TWMKillFocus);
begin
  if (Assigned(TDBLookupControlBorland(Self).FDataField) or
  (Assigned(TDBLookupControlBorland(Self).FlistLink.DataSource) and
  (TDBLookupControlBorland(Self).FListFieldName<>'') and
  (TDBLookupControlBorland(Self).FKeyFieldName<>''))) and FIsContextOpen then
    XEDBContextInit(Self, FIsContextOpen, FStoreColor, FStoreHeadColor, FStoreDataSet);
  ClearOpenReturnControl(Owner);
  SystemMenuItemObject:=nil;
  SystemMenuItemProc:=nil;
  Inherited;
end;

{ Lev. Time Of Correction 18.04.99 The Begin }
Procedure TXEDBLookupCombo.KeyDown(var Key: Word; Shift: TShiftState);
var Priz1: Boolean;
    LinkSet, FormLinkSet: TLinkSource;
    LC:TDBLookupControlBorland;
    LDataSet: TDataSet;   { LookUpDataSet }
    LResultField: String; { LookUpResultField }
begin
  case Key of
    Word('F'):
      if (ssCtrl in Shift) then begin
        Key:=0;
        XEDBSetContextKey(Self, FIsContextOpen, FStoreColor, FStoreHeadColor, FStoreDataSet);
      end;
{
    Word('S'):
      if (ssCtrl in Shift) and TDBLookupControlBorland(Self).FDataField.Lookup and
      (TDBLookupControlBorland(Self).FDataField.LookupDataSet is TLinkQuery) then begin
        Key:=0;
        if Owner is TXForm then with TXForm(Owner) do
          if Assigned(XFormLink) and Assigned(XFormLink.LinkControl) then
            if Assigned(TFormControl(XFormLink.LinkControl).OpenReturnControl) then
              TFormControl(XFormLink.LinkControl).OpenReturnControl.ReturnExecute;
      end;
}
(*  ���� ���� �����������
    Word('S'):
      if (ssShift in Shift) {True} then begin
        Key:=0;
        with TDBFormControl(TXForm(Screen.ActiveForm).FormControl) do
          with TToolsForm(FormTools.Tools.ToolsForm) do
            if ReturnOpenBtn.Enabled then begin
              ReturnSubOpen;
              SubSetFocus;
            end;
                   {FormTools.Tools.SubClick(TToolsForm(FormTools.Tools.ToolsForm).ReturnOpenBtn);}
                 {OpenReturnControl.ReturnExecute;}
      end;
*)
    Word('Z'):
      if (ssCtrl in Shift) then
        if not (ssShift in Shift) then Key:= 0
        else begin
          LC:=TDBLookupControlBorland(Self);
          { ������������� LookupDataSet'� � LookUpResultField'�� }
          if LC.FLookupMode then begin
            LDataSet:=LC.FDataField.LookUpDataSet;
            LResultField:=TEtvLookField(LC.FDataField).LookUpResultField;
          end else begin
            LDataSet:=LC.FListLink.DataSource.DataSet;
            LResultField:=LC.FListFieldName;
          end;
          if (Assigned(LC.FDataField) and LC.FDataField.Lookup and
          not(foAutoDropDownWidth in TEtvLookField(LC.FDataField).Options)) or
          (Assigned(LC.FlistLink.DataSource) and (LC.FListFieldName<>'') and
          (LC.FKeyFieldName<>'')) and (LDataSet is TLinkQuery) then begin
            Key:=0;
            Cursor:=crHourGlass;
            Priz1:= ListVisible;
            if Priz1 then CloseUp(False);
            TLinkQuery(LDataSet).LinkSource.
            ChangeLookQueryField(LC.FDataField,LC,LDataSet,LResultField);
            if Assigned(LC.FDataField) then XEDBChangeDataField(Self, LC.FDataField);
            DoEnter;
            if Priz1 then DropDown;
            Cursor:=crDefault;
          end;
        end;
  end;
  Inherited KeyDown(Key, Shift);
end;
{ Lev. Time of Correction 18.04.99 The End }

Procedure TXEDBLookupCombo.KeyUp(var Key: Word; Shift: TShiftState);
begin
(*
  Inherited;
  case Key of
    Word('S'):
      if (ssCtrl in Shift) {True} then begin
        Key:=0;
        with TDBFormControl(TXForm(Screen.ActiveForm).FormControl) do
          with TToolsForm(FormTools.Tools.ToolsForm) do
            if ReturnOpenBtn.Enabled then begin
              ReturnSubOpen;
              SubSetFocus;
            end;
      end;
  end;
*)
end;

Procedure TXEDBLookupCombo.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if AComponent is TXNotifyEvent then
    case TXNotifyEvent(AComponent).SpellEvent of
      xeIsLookField:
        begin
          if TDBLookupControlBorland(Self).FDataField is TEtvLookField then
            TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
      xeSetSource:
        begin
          if (not Assigned(ListSource)) and (not Assigned(DataSource)) then
            ListSource:=TDataSource(TXNotifyEvent(AComponent).SpellChild);
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
      xeSetParams:
        begin
          if Operation=opInsert then begin
            ListField:=TLnTable(TXNotifyEvent(AComponent).SpellChild).IndexFieldNames;
            KeyField:=TLnTable(TXNotifyEvent(AComponent).SpellChild).IndexFieldNames;
            DropDown;
          end;
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
      xeGetFirstXControl: TXNotifyEvent(AComponent).GoEqual(Self, Operation);
      xeIsThisLink:
        if Assigned(DataSource) and
        (DataSource = TXNotifyEvent(AComponent).SpellChild) then
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
    end
  else Inherited Notification(AComponent, Operation);
end;

{TXEDBInplaceLookupCombo}

Constructor TXEDBInplaceLookupCombo.Create(AOwner: TComponent);
begin
  Inherited;
  FStoreDataSet:=nil;
  FIsContextOpen:=False;
  FStoreColor:=Color;
  {FStoreHeadColor:=HeadColor;}
end;

Procedure TXEDBInplaceLookupCombo.ReadState(Reader: TReader);
begin
  Inherited ReadState(Reader);
  FStoreColor:=Color;
  {FStoreHeadColor:=HeadColor;}
end;

Procedure TXEDBInplaceLookupCombo.Paint;
begin
  XEDBPaint(Self, FIsContextOpen, FStoreColor, FStoreHeadColor);
  Inherited Paint;
end;

Procedure TXEDBInplaceLookupCombo.KeyPress(var Key: Char);
begin
  if XEDBNotContextSearchKey(Self, Key, FIsContextOpen,
                                   FStoreColor, FStoreHeadColor, FStoreDataSet) then
    Inherited KeyPress(Key);
end;

Function XEDBSystemLookupInplace: Boolean;
begin
  if TXEDBInplaceLookupCombo(SystemMenuItemObject).ListVisible then
    with TXEDBInplaceLookupCombo(SystemMenuItemObject) do begin
      SetHideFlag(False);
      XEDBSetContextKey(TXEDBInplaceLookupCombo(SystemMenuItemObject), FIsContextOpen,
        FStoreColor, FStoreHeadColor, FStoreDataSet);
      SetHideFlag(True);
      Result:=True;
    end else Result:=False;
end;

Procedure TXEDBInplaceLookupCombo.WMSetFocus(var Message: TWMSetFocus);
var LinkSet, FormLinkSet: TLinkSource;
    ADataSet: TDataSet;
    AField: TField;
    DBF1: TDBFOrmControl;
begin
  Inherited;
  SystemMenuItemObject:=Self;
  SystemMenuItemProc:=XEDBSystemLookupInplace;
  if Assigned(TDBLookupControlBorland(Self).FDataField) then begin
    if TDBLookupControlBorland(Self).FDataField.Lookup and
    (TDBLookupControlBorland(Self).FDataField.LookupDataSet is TLinkQuery) then begin
      LinkSet:=TLinkQuery(TDBLookupControlBorland(Self).FDataField.LookupDataSet).LinkSource;
      if Assigned(LinkSet) then begin
{          XNotifySelect.GoSpellSelect(LinkSet,xeSetParams,TDBLookupControlBorland(Self).FDataField,
                                       Owner, opRemove);}
        DBF1:= GetLinkedDBFormControl(LinkSet);
        if Assigned(DBF1) and (DBF1.ReturnForm=Owner) then begin
          LinkSet.IsSetReturn:= False;
          DBF1.ReturnForm:=nil;
          if LinkSet.IsReturnValue then begin
            LinkSet.IsReturnValue:=False;
            ADataSet:=TDBLookupControlBorland(Self).FDataField.LookupDataSet;
            if ADataSet is TLinkQuery then begin
              AField:=TLinkQuery(ADataSet).LinkSource.Declar.FindField(
                TDBLookupControlBorland(Self).FDataField.LookupKeyFields);
              SelectKeyValue(AField.Value);
            end;
            if (DataSource is TLinkSource) then FormLinkSet:=TLinkSource(DataSource)
            else FormLinkSet:=nil;
            if Assigned(FormLinkSet) then begin
              FormLinkSet.PostChecked:=True;
            end;
          end;
        end;
      end;
    end;
  end;
end;

Procedure TXEDBInplaceLookupCombo.WMKillFocus(var Message: TWMKillFocus);
begin
  if Assigned(TDBLookupControlBorland(Self).FDataField) then
    XEDBContextInit(Self, FIsContextOpen, FStoreColor, FStoreHeadColor, FStoreDataSet);
  SystemMenuItemObject:=nil;
  SystemMenuItemProc:=nil;
  Inherited;
end;

Procedure TXEDBInplaceLookupCombo.SetHideFlag(Value: Boolean);
begin
  TXEDBGrid(Lookup).EtvAutoHide:=Value;
end;

Procedure TXEDBInplaceLookupCombo.KeyDown(var Key: Word; Shift: TShiftState);
var Priz1: Boolean;
    LinkSet, FormLinkSet: TLinkSource;
    LC:TDBLookupControlBorland;
begin
  case Key of
    Word('F'):
      if (ssCtrl in Shift) then begin
        Key:=0;
        SetHideFlag(False);
        XEDBSetContextKey(Self, FIsContextOpen, FStoreColor, FStoreHeadColor, FStoreDataSet);
        SetHideFlag(True);
      end;
{
    Word('S'): if (ssCtrl in Shift) and
        TDBLookupControlBorland(Self).FDataField.Lookup and
        (TDBLookupControlBorland(Self).FDataField.LookupDataSet is TLinkQuery)
        then begin
        Key:=0;
        if Owner is TXForm then with TXForm(Owner) do
           if Assigned(XFormLink) and Assigned(XFormLink.LinkControl) then
              if Assigned(TFormControl(XFormLink.LinkControl).OpenReturnControl) then
                 TFormControl(XFormLink.LinkControl).OpenReturnControl.ReturnExecute;
        end;
        }
    Word('Z'):
      if (ssCtrl in Shift) then
        if not (ssShift in Shift) then Key:= 0
        else begin
          LC:=TDBLookupControlBorland(Self);
          if LC.FDataField.Lookup and (LC.FDataField.LookupDataSet is TLinkQuery) and
          (not (foAutoDropDownWidth in TEtvLookField(LC.FDataField).Options)) then begin
            Key:=0;
            SetHideFlag(False);
            Cursor:=crHourGlass;
            Priz1:= ListVisible;
            if Priz1 then CloseUp(False);
            TLinkQuery(LC.FDataField.LookupDataSet).LinkSource.
            ChangeLookQueryField(LC.FDataField,nil,
              LC.FDataField.LookUpDataSet,LC.FDataField.LookUpResultField);
            XEDBChangeDataField(Self, LC.FDataField);
            DoEnter;
            if Priz1 then DropDown;
            Cursor:=crDefault;
            SetHideFlag(True);
          end;
        end;
  end;
  Inherited KeyDown(Key, Shift);
end;

{ TXEDbGrid }

Constructor TXEDBGrid.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FStoredDataSource:=nil;
  FStoredControlSource:=nil;
  FStoredColumn:= 0;
  FIsStoredDataSource:= False;
end;

Procedure TXEDBGrid.FormatColumns;
var i,j:integer;
begin
  if Assigned(DataSource) then begin
    SetMinLengthFieldsByDataSet(TDBDataSet(DataSource.DataSet));
    { ������������� ������ �������� � ������ �������� ������ }
    if Assigned(fListTotal) then
      for i:=0 to ListTotal.Count-1 do
        for j:=0 to Columns.Count-1 do
          if (AnsiUpperCase(Columns[j].FieldName)=AnsiUpperCase(
          TItemTotal(ListTotal[i]).FieldName)) and (TItemTotal(ListTotal[i]).Value<>'')
          and (Length(TItemTotal(ListTotal[i]).Value)>Columns[j].Field.DisplayWidth) then
            Columns[j].Field.DisplayWidth:=Length(TItemTotal(ListTotal[i]).Value);
  end;
end;

Procedure TXEDBGrid.WMSetFocus(var Message: TWMSetFocus);
var LinkSet, FormLinkSet: TLinkSource;
    ADataSet: TDataSet;
    AField: TField;
    DBF1: TDBFormControl;
begin
  Inherited;
  HideEditor;
  XNotifyEvent.GoSpellChild(GetParentForm(Self), xeChangeParams, DataSource, opInsert);
  if Assigned(Columns[SelectedIndex].Field) then begin
    if (IsEtvField=efLookup) and
    (Columns[SelectedIndex].Field.LookupDataSet is TLinkQuery) then begin
      LinkSet:=TLinkQuery(Columns[SelectedIndex].Field.LookupDataSet).LinkSource;
      if Assigned(LinkSet) then begin
{       XNotifySelect.GoSpellSelect(LinkSet,xeSetParams,Columns[SelectedIndex].Field,
                                       Owner, opRemove);}
        DBF1:= GetLinkedDBFormControl(LinkSet);
        if Assigned(DBF1) and (DBF1.ReturnForm=Owner) then begin
          LinkSet.IsSetReturn:= False;
          DBF1.ReturnForm:=nil;
          if LinkSet.IsReturnValue then begin
            LinkSet.IsReturnValue:=False;
            ADataSet:=Columns[SelectedIndex].Field.LookupDataSet;
            if ADataSet is TLinkQuery then begin
              AField:=TLinkQuery(ADataSet).LinkSource.Declar.FindField(
                Columns[SelectedIndex].Field.LookupKeyFields);
              if DataLink.Edit then
                DataSource.DataSet.FindField(
                  Columns[SelectedIndex].Field.KeyFields).Value:=AField.Value;

            end;
            if (DataSource is TLinkSource) then FormLinkSet:=TLinkSource(DataSource)
            else FormLinkSet:=nil;
            if Assigned(FormLinkSet) then FormLinkSet.PostChecked:=True;
          end;
        end;
      end;
    end;
  end;
  if IsEtvField=efLookup then
    SetOpenReturnControl(Columns[SelectedIndex].Field, DataSource, Owner);
end;

Procedure TXEDBGrid.WMKillFocus(var Message: TWMKillFocus);
begin
  Inherited;
end;

Procedure TXEDBGrid.ColEnter;
var Priz: Boolean;
begin
  Priz:=IsEtvField=efLookup;
  Inherited;
  if (IsEtvField=efLookup) or Priz then begin
    XNotifyEvent.GoSpellChild(GetParentForm(Self), xeChangeParams, DataSource, opInsert);
    if IsEtvField=efLookup then
      SetOpenReturnControl(Columns[SelectedIndex].Field, DataSource, Owner)
    else ClearOpenReturnControl(Owner);
  end;
end;

procedure TXEDBGrid.Notification(AComponent: TComponent; Operation: TOperation);
var aTotals: TStringList;
    i: Integer;
begin
  if AComponent is TXNotifyEvent then
    case TXNotifyEvent(AComponent).SpellEvent of
      xeSumExecute:
        {if TLinkSource(DataSource).IsDeclar then }
        begin
          if Operation=opInsert then begin
            ListTotal.ClearFull;
{!          TLinkSource(DataSource).LinkMaster.Calc.Dataset:= DataSource.Dataset;}
            TAggregateLink(TXNotifyEvent(AComponent).SpellChild).Calc.Dataset:= DataSource.Dataset;
            aTotals:=CalcFieldTotals(DataSource.DataSet, TLinkSource(DataSource).TableName,
                       TLinkSource(DataSource).DatabaseName{'AO_GKSM_InProgram'},
                       TAggregateLink(TXNotifyEvent(AComponent).SpellChild).Calc.SumCalc
{                          TLinkSource(DataSource).DeclarLink.Calc.SumCalc}
                          {TLinkSource(DataSource).LinkMaster.Calc.SumCalc});
            for i:=0 to aTotals.Count-1 do
              SetItemTotal(TField(aTotals.Objects[i]).FieldName, aTotals[i]);
            Total:= True;
            aTotals.Free;
          end else Total:= False;
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
      xeIsLookField:
        begin
          if IsEtvField=efLookup then TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
      xeSetSource:
        begin
          if not Assigned(DataSource) then begin
            DataSource:=TDataSource(TXNotifyEvent(AComponent).SpellChild);
            if Assigned(DataSource.DataSet) then
              DataSource.DataSet.Active:=Operation=opInsert;
            end;
            TXNotifyEvent(AComponent).SpellEvent:=xeNone;
          end;
      xeGetFirstXControl: TXNotifyEvent(AComponent).GoEqual(Self, Operation);
      xeIsThisLink:
        if Assigned(DataSource)and
        (DataSource = TXNotifyEvent(AComponent).SpellChild) then begin
          TXNotifyEvent(AComponent).SpellEvent:=xeNone;
        end;
    end
  else Inherited;
end;

Function TXEDBGrid.GetDataSource: TDataSource;
begin
  if FIsStoredDataSource then Result:=FStoredDataSource
  else Result:=Inherited DataSource;
end;

Procedure TXEDBGrid.SetDataSource(Value: TDataSource);
begin
  if FIsStoredDataSource then FStoredDataSource:=Value
  else Inherited DataSource:=Value;
end;

Procedure TXEDBGrid.ReadIsDataSource(Reader: TReader);
begin
  FIsStoredDataSource:=Reader.ReadBoolean;
end;

Procedure TXEDBGrid.WriteIsDataSource(Writer: TWriter);
begin
  Writer.WriteBoolean(FIsStoredDataSource);
end;

Function TXEDBGrid.CreateInplaceLookupCombo:TEtvInplaceLookupCombo;
begin
  Result:=TXEDBInplaceLookupCombo.Create(nil);
end;

Procedure TXEDBGrid.ReadDataSource(Reader: TReader);
begin
  Reader.ReadIdent;
end;

Procedure TXEDBGrid.WriteDataSource(Writer: TWriter);
var S: String;
begin
  if DataSource.Owner<>Owner then S:=DataSource.Owner.Name+'.' else S:='';
  Writer.WriteIdent(S+DataSource.Name);
end;

Procedure TXEDBGrid.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('IsStoredDataSource', ReadIsDataSource, WriteIsDataSource, True{FIsStoredDataSource});
  Filer.DefineProperty('DataSource', ReadDataSource, WriteDataSource, Assigned(DataSource));
  Inherited;
end;

Procedure TXEDBGrid.WMChangePageSource(var Msg: TMessage);
begin
  if Msg.WParam=0 then begin
    if not Assigned(FStoredDataSource) then begin
      FStoredDataSource:=DataSource;
      FStoredColumn:=SelectedIndex;
      Inherited DataSource:=nil;
    end;
    FIsStoredDataSource:=True;
  end else begin
    FIsStoredDataSource:=False;
    if Assigned(FStoredDataSource) then begin
      DataSource:=FStoredDataSource;
      SelectedIndex:=FStoredColumn;
      FStoredDataSource:=nil;
    end;
  end;
end;

Procedure TXEDBGrid.WMChangeControlSource(var Msg: TMessage);
var wSource, lSource: TDataSource;
begin
  lSource:= TDataSource(Msg.lParam);
  wSource:= TDataSource(Msg.wParam);
  if Assigned(lSource) then begin
    if wSource=DataSource then begin
      FStoredControlSource:= DataSource;
      DataSource:= lSource;
    end;
  end else
    if wSource=FStoredControlSource then begin
      DataSource:= FStoredControlSource;
      FStoredControlSource:=nil;
    end;
end;

Procedure TXEDBGrid.KeyDown(var Key: Word; Shift: TShiftState);
var LinkSet, FormLinkSet: TLinkSource;
    EtvField:TEtvLookField;
begin
  case Key of
{
    Word('S'): if (ssCtrl in Shift) and
        (IsEtvField=efLookup) and
        (Columns[SelectedIndex].Field.LookupDataSet is TLinkQuery)
        then begin
        Key:=0;
        if Owner is TXForm then with TXForm(Owner) do
           if Assigned(XFormLink) and Assigned(XFormLink.LinkControl) then
              if Assigned(TFormControl(XFormLink.LinkControl).OpenReturnControl) then
                 TFormControl(XFormLink.LinkControl).OpenReturnControl.ReturnExecute;
        end;
        }
    Word('Z'):
      if (ssCtrl in Shift) then
        if not (ssShift in Shift) then Key:= 0
        else
          if IsEtvField=efLookup then begin
            EtvField:=TEtvLookField(Columns[SelectedIndex].Field);
            if (EtvField.LookupDataSet is TLinkQuery) and
            not(foAutoDropDownWidth in EtvField.Options) then begin
              Key:=0;
              Cursor:=crHourGlass;
              TLinkQuery(EtvField.LookupDataSet).LinkSource.ChangeLookQueryField(EtvField,
                nil, EtvField.LookUpDataSet, EtvField.LookUpResultField);
              Cursor:=crDefault;
            end;
          end;
  end;
  Inherited KeyDown(Key, Shift);
end;

{ Mixer }

Function GetXELookup(AOwner: TComponent): TWinControl;
begin
  Result:=TXEDBLookupCombo.Create(AOwner);
{  Result:=TDBLookupComboBox.Create(AOwner);}
end;

Procedure SetXELookupField(AControl: TWinControl; AField: TField; aDataSource: TDataSource);
var aLookField: TField;
begin
  with TDBLookupComboBox(AControl) do begin
    if ChangeToLookField(aField, aLookField) then aField:=aLookField;
    DataField:=AField.FieldName;
    DataSource:=ADataSource;
  end;
end;

Procedure SetXELookupKeyValue(AControl: TWinControl; AValue: String);
begin
  TDBLookupComboBox(AControl).KeyValue:=AValue;
end;

Function  GetXEEdit(AOwner: TComponent): TWinControl;
begin
  Result:=TXEDBEdit.Create(AOwner);
end;

Procedure SetXEEditField(AControl: TWinControl; AField: TField; ADataSource: TDataSource);
begin
  TDBEdit(AControl).DataField:=AField.FieldName;
  TDBEdit(AControl).DataSource:=ADataSource;
end;

Procedure SetXEEditKeyValue(AControl: TWinControl; AValue: String);
begin
  TDBEdit(AControl).Text:=AValue;
end;

type TControlSelf=class(TControl) end;

Function GetXEOtherDBEdit(aOwner:TComponent):TControl;
begin
  Result:= TXEDBEdit.Create(aOwner);
  TControlSelf(Result).PopupMenu:=PopupMenuEtvDBFieldControls;
end;

Function GetXEOtherDBDateEdit(aOwner:TComponent):TControl;
begin
  Result:= TXEDBDateEdit.Create(aOwner);
  TControlSelf(Result).PopupMenu:=PopupMenuEtvDBFieldControls;
end;

Function GetXEOtherDBComboBox(aOwner:TComponent):TControl;
begin
  Result:= TXEDBCombo.Create(aOwner);
  TControlSelf(Result).PopupMenu:=PopupMenuEtvDBFieldControls;
end;

Function GetXEOtherDBMemo(aOwner:TComponent):TControl;
begin
  Result:= TXEDBMemo.Create(aOwner);
  TControlSelf(Result).PopupMenu:=PopupMenuEtvDBFieldControls;
end;

Function GetXEOtherDBLookupComboBox(aOwner:TComponent):TControl;
begin
  Result:= TXEDBLookupCombo.Create(aOwner);
  TControlSelf(Result).PopupMenu:=PopupMenuEtvDBFieldControls;
end;

Initialization
  DFGetLookCombo:=GetXELookup;
  DFSetLookField:=SetXELookupField;
  DFSetLookKeyValue:=SetXELookupKeyValue;
  DFGetDBEdit:=GetXEEdit;
  DFSetDBEditField:=SetXEEditField;
  DFSetDBEditKeyValue:=SetXEEditKeyValue;

  XNotifyEvent:=TXNotifyEvent.Create(nil);

  CreateOtherDBEdit:= GetXEOtherDBEdit;
  CreateOtherDBDateEdit:= GetXEOtherDBDateEdit;
  CreateOtherDBComboBox:= GetXEOtherDBComboBox;
  CreateOtherDBMemo:= GetXEOtherDBMemo;
  CreateOtherDBLookupComboBox:= GetXEOtherDBLookupComboBox;

finalization
  DFGetLookCombo:=nil;
  DFSetLookField:=nil;
  DFSetLookKeyValue:=nil;
  DFGetDBEdit:=nil;
  DFSetDBEditField:=nil;
  DFSetDBEditKeyValue:=nil;

  XNotifyEvent.Free;
  XNotifyEvent:=nil;

  CreateOtherDBEdit:=nil;
  CreateOtherDBDateEdit:=nil;
  CreateOtherDBComboBox:=nil;
  CreateOtherDBMemo:=nil;
  CreateOtherDBLookupComboBox:=nil;
end.
