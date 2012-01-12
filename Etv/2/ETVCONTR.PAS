unit EtvContr;     (* Val Igo *)

interface

uses Messages, ComCtrls, StdCtrls, DBCtrls, classes, controls,
     forms,DB,dbGrids;

type
TEtvDBEdit=class(TDBEdit)
protected
  procedure Loaded; override;
  procedure KeyDown(var Key: Word; Shift: TShiftState); override;
end;

{TEtvDBLookText}
TEtvDBText = class(TDBText)
protected
  fLookField:string;
  function  GetLabelText: string; override;
  procedure SetLookField(aLookField:string);
published
  property LookField:string read fLookField write SetLookField;
end;

{ TEtvDBCombo }
TEtvCustomDBCombo=class(TDBComboBox) (* For EtvList*)
protected {private}
  function GetComboBoxStyle:TComboBoxStyle;
  procedure SetComboBoxStyle(aValue:TComboBoxStyle);
  function GetItems: Integer;
  function GetDataField: string;
  procedure SetDataField(const Value: string);
  function GetDataSource: TDataSource;
  procedure SetDataSource(Value: TDataSource);
  procedure SetParent(AParent: TWinControl); override;
protected
  procedure PumpValues(Sender: TObject);
  procedure Loaded; override;
  procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
public
  constructor Create(AOwner: TComponent); override;
published
  property DataField: string read GetDataField write SetDataField;
  property DataSource: TDataSource read GetDataSource write SetDataSource;
  property Style: TComboBoxStyle Read GetComboBoxStyle write SetComboBoxStyle;
  property Items: Integer read GetItems;
end;

TEtvDBCombo=class(TEtvCustomDBCombo) (* For EtvList*)
protected
  procedure Loaded; override;
  procedure KeyDown(var Key: Word; Shift: TShiftState); override;
end;

TSortingDataLink=Class(TDataLink)
  fCombo:TCustomComboBox;
  procedure ActiveChanged; override;
  procedure DataSetChanged;override;
  procedure DataSetScrolled(Distance: Integer);override;
end;

TEtvDBSortingCombo=class(TCustomComboBox)
protected
  fDataLink:TDataLink;
  fItems:TStrings;
  fSelfList:boolean;
  fSetProcess:smallint;
  procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  procedure Change; override;
  procedure Notification(AComponent: TComponent;
                         Operation: TOperation); override;
  procedure SetParent(AParent: TWinControl); override;
  function GetDataSource: TDataSource;
  procedure SetDataSource(Value: TDataSource);
  procedure SetItems(Value: TStrings);
  procedure SetSelfList(Value: boolean);
  procedure CheckSortingList;
  procedure SetCurrentSorting;
  function StandartList:boolean;
  function ActiveItems:TStrings;
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
published
  property DataSource:TDataSource read GetDataSource write SetDataSource;
  property SelfList:boolean read fSelfList write SetSelfList;
  property Items:TStrings read fItems write SetItems;

  property Color;
  property Ctl3D;
  property DragMode;
  property DragCursor;
  property DropDownCount;
  property Enabled;
  property Font;
  property ImeMode;
  property ImeName;
  property ItemHeight;

  property ParentColor;
  property ParentCtl3D;
  property ParentFont;
  property ParentShowHint;
  property PopupMenu;
  property ShowHint;
  property TabOrder;
  property TabStop;
  property Visible;
  property OnChange;
  property OnClick;
  property OnDblClick;
  property OnDragDrop;
  property OnDragOver;
  property OnDrawItem;
  property OnDropDown;
  property OnEndDrag;
  property OnEnter;
  property OnExit;
  property OnKeyDown;
  property OnKeyPress;
  property OnKeyUp;
  property OnMeasureItem;
  property OnStartDrag;
end;

TEtvDBRichEdit=class(TDBRichEdit)
protected
  procedure Loaded; override;
Public
  procedure BeginEditing;
end;

TEtvTabSheet=class(TTabSheet)
protected
  fTurnSource:boolean;
  fTurnMasterSource:boolean;
  fControlDataSource:TDataSource;
  fMasterSource:TDataSource;
  fControl:TControl;
  function GetControlDataSource:TDataSource;
  procedure SetControlDataSource(aValue:TDataSource);
  procedure SetControl(aValue:TControl);
  procedure Loaded; override;
  procedure EnableControl;
  procedure DisableControl;
  procedure Notification(AComponent: TComponent;
                         Operation: TOperation); override;
public
published
  property TurnControl:TControl read fControl write SetControl;
  property TurnMasterSource:boolean read fTurnMasterSource
             write fTurnMasterSource default false;
  property TurnSource:boolean read fTurnSource write fTurnSource default false;
end;

TEtvPageControl=Class(TPageControl)
protected
  function CanChange: Boolean; override;
  procedure Change; override;
public
  procedure EnableControl;
  procedure DisableControl;
end;

TEtvScrollBoxForGrid=Class(TScrollBox)
protected
  fGrid:TCustomDBGrid;
  fSimpleControls:boolean;
  procedure PutFocus;
  procedure CreateRecordControls;
  procedure SetGrid(aValue:TCustomDBGrid);
  procedure Notification(AComponent: TComponent;
                         Operation: TOperation); override;
public
  procedure RefreshRecord;
  procedure ChangeControls;
  property Grid:TCustomDBGrid read fGrid write SetGrid;
end;

Function DBEditForField(Owner:TComponent; Field:TField; DS:TDataSource;
                      aWidth:Integer):TControl;
Function EditForField(Owner:TComponent; Field:TField; aWidth:Integer;
                      aLookSource:TDataSource):TControl;

function ControlRequiredParent(aControl:TControl):Boolean;

function CreateEtvText(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
function CreateEtvEdit(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
function CreateEtvDateEdit(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
function CreateEtvComboBox(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
function CreateEtvMemo(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
function CreateEtvLookupComboBox(aOwner:TComponent; Field:TField; aWidth:Integer; LS:TDataSource):TControl;

function CreateEtvDBText(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
function CreateEtvDBEdit(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
function CreateEtvDBDateEdit(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
function CreateEtvDBComboBox(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
function CreateEtvDBMemo(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
function CreateEtvDBImage(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
function CreateEtvDBLookupComboBox(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;

IMPLEMENTATION

uses SysUtils,Windows,DBTables,TypInfo,Graphics,{Dialogs,}
     EtvDBFun,EtvConst,EtvForms,EtvPas,EtvDB,EtvLook,EtvBor,
     EtvOther,EtvPopup;

procedure TEtvDBEdit.Loaded;
begin
  inherited;
  if (not(csDesigning in ComponentState)) and (PopupMenu=nil) then
    PopupMenu:=PopupMenuEtvDBFieldControls;
end;

procedure TEtvDBEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  {DataSrcKeyDown(DataSource,Key,Shift);}
  KeyReturn(Self,Key,Shift);
end;

{TEtvDBText}
function TEtvDBText.GetLabelText: string;
begin
  if Assigned(Field) and (Field is TEtvLookField) then
    Result := TEtvLookField(Field).StringByLookName(fLookField)
  else Result:=Inherited GetLabelText;
end;

procedure TEtvDBText.SetLookField(aLookField:string);
begin
  fLookField:=aLookField;
  Invalidate;
end;

{TEtvCustomDBCombo}
constructor TEtvCustomDBCombo.Create(AOwner: TComponent);
begin
  Inherited;
  Inherited Style:=csDropDownList;
end;

function TEtvCustomDBCombo.GetComboBoxStyle:TComboBoxStyle;
begin
  Result:=Inherited Style;
end;

procedure TEtvCustomDBCombo.SetComboBoxStyle(aValue:TComboBoxStyle);
begin
  if aValue in [csDropDownList,csOwnerDrawFixed,csOwnerDrawVariable] then
    inherited Style:=aValue;
end;

function TEtvCustomDBCombo.GetItems: Integer;
begin
  Result:= Inherited Items.Count;
end;

function TEtvCustomDBCombo.GetDataField: string;
begin
  Result:=Inherited DataField;
end;

procedure TEtvCustomDBCombo.SetDataField(const Value: string);
begin
  Inherited DataField:=Value;
  PumpValues(Self);
end;

function TEtvCustomDBCombo.GetDataSource: TDataSource;
begin
  Result:=Inherited DataSource;
end;

procedure TEtvCustomDBCombo.SetDataSource(Value: TDataSource);
begin
  Inherited DataSource:=Value;
  PumpValues(Self);
end;

procedure TEtvCustomDBCombo.SetParent(AParent: TWinControl);
begin
  inherited;
  if Assigned(Parent) then PumpValues(Self);
end;

procedure TEtvCustomDBCombo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    ord('0')..ord('9'):
      if not DroppedDown then
        if Assigned(Field) and (Field is TEtvListField) and Field.CanModify and
           (Key-ord('0')<=TEtvListField(Field).MaxValue) then begin
          DataSource.Edit;
          Field.Value:=Key-ord('0');
          Key:=0;
        end else SysUtils.Beep;
    VK_Delete,VK_Back:
      if Assigned(Field) and (Field is TEtvListField) and Field.CanModify then begin
        DataSource.Edit;
        Field.Clear;
        Key:=0;
      end;
    VK_RETURN: if (ssCtrl in Shift) then begin
      PostMessage(Handle, CB_SHOWDROPDOWN, LongInt(True), 0);
      Key:=0;
    end;
  end;
  inherited;
end;

procedure TEtvCustomDBCombo.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if (not Focused) and
  (Message.XPos<(Width-GetSystemMetrics(SM_CXHSCROLL))) then begin
    SetFocus;
    BeginDrag(False);
    Exit;
  end;
  inherited;
end;

procedure TEtvCustomDBCombo.PumpValues(Sender: TObject);
begin
  if Assigned(Parent) then
    if Assigned(Field) and (Field is TEtvListField) then
      Inherited Items:=TEtvListField(Field).Values
    else Inherited Items.Clear;
end;

procedure TEtvCustomDBCombo.Loaded;
begin
  inherited;
  TDBComboBoxBorland(Self).fDataLink.OnActiveChange:=PumpValues;
  PumpValues(Self);
end;

{TEtvDBCombo}
procedure TEtvDBCombo.Loaded;
begin
  inherited;
  if (not(csDesigning in ComponentState)) and (PopupMenu=nil) then
    PopupMenu:=PopupMenuEtvDBFieldControls;
end;

procedure TEtvDBCombo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  Inherited;
  {if Not DroppedDown then DataSrcKeyDown(DataSource,Key,Shift);}
  KeyReturn(Self,Key,Shift);
end;

{TEtvDBSortingCombo}
procedure TSortingDataLink.ActiveChanged;
begin
  if Assigned(fCombo) then
    TEtvDBSortingCombo(fCombo).CheckSortingList;
end;

procedure TSortingDataLink.DataSetChanged;
begin
  if Assigned(fCombo) then with TEtvDBSortingCombo(fCombo) do
    if StandartList then SetCurrentSorting
    else CheckSortingList;
end;

procedure TSortingDataLink.DataSetScrolled(Distance: Integer);
begin
end;

procedure TEtvDBSortingCombo.Change;
var NewSorting:string;
begin
  if (fSetProcess=0) and Enabled and fDataLink.Active then
    if ItemIndex>=0 then begin
      if StandartList then begin
        with TTable(DataSource.DataSet) do
          if IndexDefs[ItemIndex].Fields<>'' then
            NewSorting:=IndexDefs[ItemIndex].Fields
          else NewSorting:=IndexDefs[ItemIndex].Name;
      end else NewSorting:=ActiveItems[ItemIndex];
      SortingToDataSet(DataSource.DataSet,NewSorting,true);
    end;
  inherited Change;
end;

procedure TEtvDBSortingCombo.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
     (AComponent = DataSource) then
    DataSource := nil;
end;

procedure TEtvDBSortingCombo.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    CheckSortingList;
end;


procedure TEtvDBSortingCombo.SetParent(AParent: TWinControl);
begin
  inherited;
  if Assigned(Parent) then CheckSortingList;
end;

function TEtvDBSortingCombo.GetDataSource: TDataSource;
begin
  if FDataLink <> nil then Result := FDataLink.DataSource
  else Result := nil;
end;

procedure TEtvDBSortingCombo.SetDataSource(Value: TDataSource);
begin
  if FDataLink.DataSource<>Value then begin
    FDataLink.DataSource := Value;
    if Value <> nil then Value.FreeNotification(Self);
  end;
end;

procedure TEtvDBSortingCombo.SetItems(Value: TStrings);
begin
  fItems.Assign(Value);
  CheckSortingList;
end;

procedure TEtvDBSortingCombo.SetSelfList(Value: boolean);
begin
  if Value<>fSelfList then begin
    fSelfList:=Value;
    CheckSortingList;
  end;
end;

procedure TEtvDBSortingCombo.CheckSortingList;
var j:integer;
    lItems:TStrings;
begin
  if Assigned(Parent) then try
    inherited Items.BeginUpdate;
    Inc(fSetProcess);
    inherited Items.Clear;
    if fDataLink.Active and Enabled then begin
      if StandartList then with TTable(DataSource.DataSet) do begin
        IndexDefs.Update;
        for j:=0 to IndexDefs.Count-1 do begin
          if IndexDefs[j].Fields='' then TCustomComboBox(Self).Items.Add(IndexDefs[j].Name)
          else
            TCustomComboBox(Self).Items.
              Add(FieldsDisplayName(Self.DataSource.DataSet,IndexDefs[j].Fields));
        end;
      end else begin
        lItems:=ActiveItems;
        for j:=0 to lItems.Count-1 do
          inherited Items.Add(FieldsDisplayName(DataSource.DataSet,lItems[j]));
      end;
      SetCurrentSorting;
    end;
  finally
    Dec(fSetProcess);
    inherited Items.EndUpdate;
  end;
end;

procedure TEtvDBSortingCombo.SetCurrentSorting;
var i,j:integer;
    CurFields:string;
    lItems:TStrings;
begin
  i:=-1;
  if StandartList then with TTable(DataSource.DataSet) do begin
    if IndexName<>'' then i:=IndexDefs.IndexOf(IndexName);
    if i<0 then begin
      CurFields:=SortingFromDataSet(Self.DataSource.DataSet);
      for j:=0 to IndexDefs.Count-1 do
        if AnsiCompareText(IndexDefs[j].Fields,CurFields)=0 then begin
          i:=j;
          Break;
        end;
    end;
  end else begin
    CurFields:=SortingFromDataSet(DataSource.DataSet);
    lItems:=ActiveItems;
    for j:=0 to lItems.Count-1 do
      if AnsiCompareText(lItems[j],CurFields)=0 then begin
        i:=j;
        break;
      end;
  end;
    {if (i<0) and (CurFields<>'') then begin
        i:=TCustomComboBox(Self).Items.Count;
        TCustomComboBox(Self).Items.Add(CurFields);
      end;}
  if ItemIndex<>i then try
    Inc(fSetProcess);
    ItemIndex:=i;
  finally
    dec(fSetProcess);
  end;
end;

function TEtvDBSortingCombo.StandartList:boolean;
begin
  Result:=true;
  if (not (DataSource.DataSet is TTable)) or
     ((ActiveItems.Count>0) and (fSelfList or (fItems.Count=0))) then
    Result:=false;
end;

function TEtvDBSortingCombo.ActiveItems:TStrings;
var PropInfo:PPropInfo;
    lItems:TStrings;
begin
  Result:=fItems;
  if (not fSelfList) or (Result.Count=0) then begin
    PropInfo := GetPropInfo(DataSource.DataSet.ClassInfo, 'SortingList');
    if PropInfo <> nil then begin
      lItems:=TStrings(GetOrdProp(DataSource.DataSet, PropInfo));
      if lItems.Count>0 then Result:=lItems;
    end;
  end;
end;

constructor TEtvDBSortingCombo.Create(AOwner: TComponent);
begin
  inherited;
  fDataLink :=TSortingDataLink.Create;
  TSortingDataLink(FDataLink).fCombo:=self;
  fSelfList:=false;
  fSetProcess:=0;
  Style:=csDropDownList;
  Width:=180;
  fItems:=TStringList.Create;
end;

Destructor TEtvDBSortingCombo.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  fItems.Free;
  inherited;
end;

{TEtvDBRichEdit}
procedure TEtvDBRichEdit.Loaded;
begin
  inherited;
  if (not(csDesigning in ComponentState)) and (PopupMenu=nil) then
    PopupMenu:=PopupMenuEtvDBRichEdit;
end;

procedure TEtvDBRichEdit.BeginEditing;
begin
  with TDBRichEditBorland(Self) do
    if not FDataLink.Editing then try
      if FDataLink.Field.IsBlob then
        FDataSave := FDataLink.Field.AsString;
      FDataLink.Edit;
    finally
      FDataSave := '';
    end;
end;

{TEtvTabSheet}
procedure TEtvTabSheet.Loaded;
var i:smallint;
begin
  inherited;
  if Not(csDesigning in ComponentState) then begin
    if Not Assigned(fControl) then
      for i:=0 to ControlCount-1 do
        if (Controls[i] is TCustomDBGrid) then begin
          fControl:=Controls[i];
          Break;
        end;
    if Assigned(fControl) then
      if PageControl.ActivePage<>self then DisableControl;
  end;
end;

procedure TEtvTabSheet.SetControl(aValue:TControl);
begin
  {if csDesigning in ComponentState then begin}
  if fControl<>aValue then begin
    fControl:=aValue;
    if assigned(aValue) then aValue.FreeNotification(Self);
  end;
end;

function TEtvTabSheet.GetControlDataSource:TDataSource;
var PropInfo: PPropInfo;
begin
  Result:=nil;
  if Assigned(fControl) then begin
    PropInfo := GetPropInfo(fControl.ClassInfo,'DataSource');
    if PropInfo <> nil then
      Result:=TDataSource(GetOrdProp(fControl, PropInfo));
  end;
end;

Procedure TEtvTabSheet.SetControlDataSource(aValue:TDataSource);
var PropInfo,PropInfoOther: PPropInfo;
    PropSource,PropOtherSource:TDataSource;
    {i:integer;}

  { Рекюрсивная процедюра для всех винконтрёлей, в натуре... }
  Procedure SetWinControlDataSource(W: TWinControl);
  var i: Integer;
  begin
    for i:=0 to W.ControlCount-1 do
      { У каждого Combo есть PopupDataList, а он-редиска, тоже WinControl!!! }
      if (W.Controls[i]<>fControl) and not(W.Controls[i] is TPopUpDataList) then begin
        if (W.Controls[i] is TWinControl) then
          { Для всех подконтрольных подконтролей }
          SetWinControlDataSource(TWinControl(W.Controls[i]));
        PropInfoOther:=GetPropInfo(W.Controls[i].ClassInfo,'DataSource');
        if PropInfoOther<>nil then begin
          PropOtherSource:=TDataSource(GetOrdProp(W.Controls[i],PropInfoOther));
          if PropOtherSource=PropSource then
            SetOrdProp(W.Controls[i],PropInfoOther,Integer(aValue));
        end;
      end;
  end;

begin
  if Assigned(fControl) then begin
    PropInfo:=GetPropInfo(fControl.ClassInfo,'DataSource');
    if PropInfo <> nil then begin
      PropSource:=TDataSource(GetOrdProp(fControl,PropInfo));
(*
      for i:=0 to ControlCount-1 do
        if (Controls[i]<>fControl) {and (Controls[i] is TXDBLabel)} then begin
          {PropInfoOther:=GetPropInfo(Controls[i].ClassInfo,'DataSource');}
          PropInfoOther:=GetPropInfo(Controls[i].ClassInfo,'DataSource');
          if PropInfoOther<>nil then begin
            PropOtherSource:=TDataSource(GetOrdProp(Controls[i],PropInfoOther));
            if {PropInfoOther=PropInfo}PropOtherSource=PropSource then
              SetOrdProp(Controls[i],PropInfoOther,Integer(aValue));
          end;
        end;
*)
      SetWinControlDataSource(Self);
      SetOrdProp(fControl,PropInfo,Integer(aValue));
    end;
  end;
end;

procedure TEtvTabSheet.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation=opRemove then
    if AComponent=fControl then fControl:=nil
    else if AComponent=fControlDataSource then fControlDataSource:=nil
    else if AComponent=fMasterSource then fMasterSource:=nil;
end;

procedure TEtvTabSheet.DisableControl;
var LSource:TDataSource;
function CheckMaster(aProp:string):boolean;
var MSource:TDataSource;
    PropInfo: PPropInfo;
begin
  PropInfo:=GetPropInfo(LSource.DataSet.ClassInfo, aProp);
  if PropInfo <> nil then begin
    Result:=true;
    MSource:=TDataSource(GetOrdProp(LSource.DataSet, PropInfo));
    if Assigned(MSource) then begin
      fMasterSource:=MSource;
      MSource.FreeNotification(Self);
      SetOrdProp(LSource.DataSet, PropInfo, Integer(nil));
    end
  end else Result:=false;
end;
begin
  if Assigned(fControl) then begin
    LSource:=GetControlDataSource;
    if Assigned(LSource) then begin
      if fTurnSource then begin
        fControlDataSource:=LSource;
        LSource.FreeNotification(Self);
        SetControlDataSource(nil);
        fControl.Enabled:=false;
      end;
      if fTurnMasterSource and Assigned(LSource.DataSet) then
        if not CheckMaster('MasterSource') then CheckMaster('DataSource');
    end;
  end;
end;

procedure TEtvTabSheet.EnableControl;
var lSource:TDataSource;
function SetMaster(aProp:string):boolean;
var PropInfo: PPropInfo;
begin
  PropInfo:=GetPropInfo(lSource.DataSet.ClassInfo,aProp);
  if PropInfo <> nil then begin
    Result:=true;
    SetOrdProp(lSource.DataSet,PropInfo,integer(fMasterSource));
  end else Result:=false;
end;
begin
  if Assigned(fControlDataSource) and
     (GetControlDataSource=nil) then begin
    SetControlDataSource(fControlDataSource);
    fControlDataSource:=nil;
    fControl.Enabled:=true;
  end;
  if Assigned(fMasterSource) then begin
    lSource:=GetControlDataSource;
    if Not SetMaster('MasterSource') then SetMaster('DataSource');
    fMasterSource:=nil;
  end;
end;

{TEtvPageControl}
Function TEtvPageControl.CanChange:boolean;
begin
  Result:=inherited CanChange;
  if Result then DisableControl;
end;

Procedure TEtvPageControl.Change;
begin
  Inherited Change;
  EnableControl;
end;

procedure TEtvPageControl.EnableControl;
var i:integer;
begin
  if (Not(csDesigning in ComponentState)) and
     Assigned(ActivePage) and (ActivePage is TEtvTabSheet) then
    TEtvTabSheet(ActivePage).EnableControl;
  for i:=1 to ControlCount-1 do
    if Controls[i] is TEtvPageControl then
      TEtvPageControl(Controls[i]).EnableControl;
end;

procedure TEtvPageControl.DisableControl;
var i:integer;
begin
  if (Not(csDesigning in ComponentState)) and
     Assigned(ActivePage) and (ActivePage is TEtvTabSheet) then
    TEtvTabSheet(ActivePage).DisableControl;
  for i:=1 to ControlCount-1 do
    if Controls[i] is TEtvPageControl then
      TEtvPageControl(Controls[i]).DisableControl;
end;

{TEtvScrollBoxForGrid}
procedure TEtvScrollBoxForGrid.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation=opRemove) and (AComponent=fGrid) then Grid:=nil;
end;

procedure TEtvScrollBoxForGrid.PutFocus;
var i:integer;
begin
  for i:=0 to ControlCount-1 do
    if (Controls[i] is TWinControl) and
       TWinControl(Controls[i]).TabStop then begin
      TWinControl(Controls[i]).SetFocus;
      break;
    end;
end;

type TCustomDBGridSelf=class(TCustomDBGrid);

procedure TEtvScrollBoxForGrid.CreateRecordControls;
var LabelFont:TFont;
begin
  if not TCustomDBGridSelf(fGrid).DataSource.DataSet.CanModify then begin
    LabelFont:=TFont.Create;
    Font.Style:=[fsBold];
  end else LabelFont:=nil;
  ConstructOneRecordEdit(Self,TCustomDBGridSelf(fGrid).DataSource,
                         LabelFont,TCustomDBGridSelf(fGrid).Color,false,true);
  if Assigned(LabelFont) then LabelFont.Free;
end;

procedure TEtvScrollBoxForGrid.RefreshRecord;
var lFocus:boolean;
    i:integer;
begin
  if fSimpleControls then begin
    lFocus:=false;
    for i:=0 to ControlCount-1 do
      if (Controls[i] is TWinControl) and
         TWinControl(Controls[i]).Focused then begin
        lFocus:=true;
        break;
      end;
    DestroyComponents;
    CreateRecordControls;
    if lFocus then PutFocus;
  end;
end;

procedure TEtvScrollBoxForGrid.SetGrid(aValue:TCustomDBGrid);
begin
  if aValue<>fGrid then begin
    fGrid:=aValue;
    if assigned(aValue) then begin
      aValue.FreeNotification(Self);
      BoundsRect:=fGrid.BoundsRect;
      Align:=fGrid.Align;
      {ParentFont:=false;}
      Font.Assign(TCustomDBGridSelf(fGrid).Font);
    end;
  end;
end;

procedure TEtvScrollBoxForGrid.ChangeControls;
var lFocus:boolean;
    i:integer;
begin
  if fSimpleControls then begin
    lFocus:=false;
    for i:=0 to ControlCount-1 do
      if (Controls[i] is TWinControl) and
          TWinControl(Controls[i]).Focused then begin
        lFocus:=true;
        break;
      end;
    Hide;
    if Assigned(fGrid) then begin
      fGrid.Visible:=true;
      if lFocus then fGrid.SetFocus;
    end;
    fSimpleControls:=false;
  end else begin
    if Assigned(fGrid) and Assigned(TCustomDBGridSelf(fGrid).DataSource) and
       Assigned(TCustomDBGridSelf(fGrid).DataSource.DataSet) then begin
      lFocus:=fGrid.focused;
      fGrid.Visible:=false;
      fGrid.Parent.InsertControl(Self);
      CreateRecordControls;
      if lFocus then PutFocus;
      fSimpleControls:=true;
    end;
  end;
end;

Function DBEditForField(Owner:TComponent; Field:TField; DS:TDataSource;
                        aWidth:Integer):TControl;
const fWidth=6;
begin
  if aWidth<=0 then aWidth:=fWidth;
  Result:=nil;
  case Field.FieldKind of
    fkData: begin
      if Field is TMemoField then
        Result:=CreateEtvDBMemo(Owner,Field,DS,aWidth)
      else if Field is TGraphicField then
        Result:=CreateEtvDBImage(Owner,Field,DS,aWidth)
      else if Not Field.CanModify then
        Result:=CreateEtvDBText(Owner,Field,DS,aWidth)
      else if Field is TEtvListField then
        Result:=CreateEtvDBComboBox(Owner,Field,DS,aWidth)
      else if (Field is TDateField) and (not(csDesigning in Field.ComponentState)) then
        Result:=CreateEtvDBDateEdit(Owner,Field,DS,aWidth)
      else
        Result:=CreateEtvDBEdit(Owner,Field,DS,aWidth)
    end;
    fkCalculated: Result:=CreateEtvDBText(Owner,Field,DS,aWidth);
    fkLookup:begin
      if (Not Field.DataSet.CanModify) or Field.ReadOnly then
        Result:=CreateEtvDBText(Owner,Field,DS,aWidth)
      else Result:=CreateEtvDBLookupComboBox(Owner,Field,DS,aWidth);
    end;
  end;
end;

Function EditForField(Owner:TComponent; Field:TField; aWidth:Integer;aLookSource:TDataSource):TControl;
const fWidth=6;
begin
  if aWidth<=0 then aWidth:=fWidth;
  Result:=nil;
  case Field.FieldKind of
    fkData: begin
      if Field is TEtvListField then
        Result:=CreateEtvComboBox(Owner,Field,aWidth)
      else if Field is TDateField then
        Result:=CreateEtvDateEdit(Owner,Field,aWidth)
      else if Field is TMemoField then
        Result:=CreateEtvMemo(Owner,Field,aWidth)
      else Result:=CreateEtvEdit(Owner,Field,aWidth);
    end;
    fkCalculated: Result:=CreateEtvText(Owner,Field,aWidth);
    fkLookup: Result:=CreateEtvLookupComboBox(Owner,Field,aWidth,aLookSource);
  end;
end;

function ControlRequiredParent(aControl:TControl):Boolean;
begin
  Result:=false;
  if (aControl is TCustomComboBox) or (aControl is TCustomMemo) then
    Result:=True;
end;

Procedure SetControl(aControl:TControl; Field:TField; aWidth:Integer);
begin
  if aWidth>0 then begin
    aControl.Width:=(Field.DisplayWidth+2)*aWidth;
    if (Field is TDateField) or (aControl is TCustomComboBox) or
       (aControl is TDBLookupComboBox) then
      aControl.Width:=aControl.Width+GetSystemMetrics(SM_CXVSCROLL);
  end;
end;

Procedure SetDBControl(aControl:TControl; Field:TField; DS:TDataSource; aWidth:Integer);
var PropInfo: PPropInfo;
begin
  PropInfo := GetPropInfo(aControl.ClassInfo, 'DataSource');
  if PropInfo <> nil then
    SetOrdProp(aControl, PropInfo, Integer(DS));
  if Assigned(Field) and (Not ControlRequiredParent(aControl)) then begin
    PropInfo := GetPropInfo(aControl.ClassInfo, 'DataField');
    if PropInfo <> nil then
      SetStrProp(aControl, PropInfo, Field.FieldName);
  end;
  if aWidth>0 then begin
    aControl.Width:=(Field.DisplayWidth+2)*aWidth;
    if (Field is TDateField) or (aControl is TCustomComboBox) or
       (aControl is TDBLookupComboBox) then
      aControl.Width:=aControl.Width+GetSystemMetrics(SM_CXVSCROLL);
  end;
end;

function CreateEtvText(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
begin
  if assigned(CreateOtherText) then
    Result:=CreateOtherText(aOwner)
  else Result:=TLabel.Create(aOwner);
  SetControl(Result,Field,aWidth);
end;

function CreateEtvEdit(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherEdit) then
    Result:=CreateOtherEdit(aOwner)
  else Result:=TEdit.Create(aOwner);
  SetControl(Result,Field,aWidth);
end;

function CreateEtvDateEdit(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherDateEdit) then
    Result:=CreateOtherDateEdit(aOwner)
  else Result:=TEdit.Create(aOwner);
  SetControl(Result,Field,aWidth);
end;

function CreateEtvComboBox(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherComboBox) then
    Result:=CreateOtherComboBox(aOwner)
  else Result:=TComboBox.Create(aOwner);
  SetControl(Result,Field,aWidth);
end;

function CreateEtvMemo(aOwner:TComponent; Field:TField; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherMemo) then
    Result:=CreateOtherMemo(aOwner)
  else Result:=TEdit{TMemo}.Create(aOwner);
  SetControl(Result,Field,aWidth);
end;

function CreateEtvLookupComboBox(aOwner:TComponent; Field:TField; aWidth:Integer; LS:TDataSource):TControl;
begin
  if Assigned(CreateOtherLookupComboBox) then
    Result:=CreateOtherLookupComboBox(aOwner)
  else Result:=TEtvDBLookupCombo.Create(aOwner);
  SetControl(Result,Field,aWidth);
  if (Result is TDBLookupComboBox) and (Field.FieldKind=fkLookup) then begin
    TDBLookupComboBox(Result).ListSource:=LS;
    if Field is TEtvLookField then begin
      TDBLookupComboBox(Result).ListField:=TEtvLookField(Field).LookupResultField;
      TDBLookupComboBox(Result).ListFieldIndex:=TEtvLookField(Field).ListFieldIndex;
      if Result is TEtvDBLookupCombo then begin
        TEtvDBLookupCombo(Result).HeadColor:=TEtvLookField(Field).HeadColor;
        TEtvDBLookupCombo(Result).HeadLine:=TEtvLookField(Field).HeadLine;
      end;
    end else
      TDBLookupComboBox(Result).ListField:=Field.LookupResultField;
    TDBLookupComboBox(Result).KeyField:=Field.LookupKeyFields;
  end;
end;

function CreateEtvDBText(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
begin
  if assigned(CreateOtherDBText) then
    Result:=CreateOtherDBText(aOwner)
  else Result:=TEtvDBText.Create(aOwner);
  SetDBControl(Result,Field,DS,aWidth);
  if (Field.FieldKind=fkLookup) and (Field is TEtvLookField)
     and (Result is TEtvDBText) then
    TEtvDBText(Result).LookField:=TEtvLookField(Field).LookupResultField;
end;

type TControlSelf=class(TControl) end;

function CreateEtvDBEdit(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherDBEdit) then
    Result:=CreateOtherDBEdit(aOwner)
  else begin
    Result:=TEtvDBEdit.Create(aOwner);
    TControlSelf(Result).PopupMenu:=PopupMenuEtvDBFieldControls;
  end;
  SetDBControl(Result,Field,DS,aWidth);
end;

function CreateEtvDBDateEdit(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherDBDateEdit) then
    Result:=CreateOtherDBDateEdit(aOwner)
  else begin
    Result:=TEtvDBEdit.Create(aOwner);
    TControlSelf(Result).PopupMenu:=PopupMenuEtvDBFieldControls;
  end;
  SetDBControl(Result,Field,DS,aWidth);
end;

function CreateEtvDBComboBox(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherDBComboBox) then
    Result:=CreateOtherDBComboBox(aOwner)
  else begin
    Result:=TEtvDBCombo.Create(aOwner);
    TControlSelf(Result).PopupMenu:=PopupMenuEtvDBFieldControls;
  end;
  SetDBControl(Result,Field,DS,aWidth);
end;

type TCustomMemoSelf=class(TCustomMemo) end;

function CreateEtvDBMemo(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherDBMemo) then
    Result:=CreateOtherDBMemo(aOwner)
  else begin
    Result:=TDBMemo.Create(aOwner);
    TDBMemo(Result).ScrollBars:=ssVertical;
    TControlSelf(Result).PopupMenu:=PopupMenuEtvDBMemo;
  end;
  SetDBControl(Result,Field,DS,aWidth);
  if Not Field.CanModify and (Result is TCustomMemo) then begin
    TCustomMemoSelf(Result).ReadOnly:=true;
    TCustomMemoSelf(Result).color:=clBtnFace;
  end;
end;

function CreateEtvDBImage(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherDBImage) then
    Result:=CreateOtherDBImage(aOwner)
  else Result:=TDBImage.Create(aOwner);
  SetDBControl(Result,Field,DS,aWidth);
  if Not Field.CanModify and (Result is TDBImage) then
    TDBImage(Result).ReadOnly:=true;
end;

function CreateEtvDBLookupComboBox(aOwner:TComponent; Field:TField; DS:TDataSource; aWidth:Integer):TControl;
begin
  if Assigned(CreateOtherDBLookupComboBox) then
    Result:=CreateOtherDBLookupComboBox(aOwner)
  else begin
    Result:=TEtvDBLookupCombo.Create(aOwner);
    TControlSelf(Result).PopupMenu:=PopupMenuEtvDBFieldControls;
  end;
  if (Result is TEtvDBLookupCombo) and
     (Field is TEtvLookField) then begin
    TEtvDBLookupCombo(Result).HeadColor:=TEtvLookField(Field).HeadColor;
    TEtvDBLookupCombo(Result).HeadLine:=TEtvLookField(Field).HeadLine;
  end;
  SetDBControl(Result,Field,DS,aWidth);
end;

end.


