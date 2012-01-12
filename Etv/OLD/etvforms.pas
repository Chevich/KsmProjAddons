unit EtvForms;    (* Igo *)

interface
uses Windows,Messages,Classes,Forms,Graphics,Controls,DB,dbctrls,
     EtvDB;

{const CM_FormDB = cm_Base + 98;
      FormDBInsertComponent=40;}
type

TFormDBOption = (foDataReadOnly, foPageOneRecord,
                 foFreeOnClose, foApplyOnClose,foPC1ChangeSize,
                 foUserOption1,foUserOption2,foUserOption3);
TFormDBOptions = set of TFormDBOption;

TFormDB = class;

TFormDBDataLink=Class(TDataLink)
  fFormDB:TFormDB;
  procedure ActiveChanged; override;
end;

TFormDB = class(TForm)
protected
  FDataLink: TDataLink;
  FDataSource: TDataSource;
  fOptions: TFormDBOptions;
  fFirstActive:boolean;
  fOldReadOnly:boolean;
  fOldCachedUpdates:boolean;
  fOldActive:boolean;
  fCapture:boolean;
  OldIndexFieldNames:string;
  OldIndexName:string;
  FOnClose: TCloseEvent;
  fFieldReturn:TFieldReturn;
  fFormDataSet:TDataSet;
  function GetDataSource: TDataSource;
  procedure SetDataSource(Value: TDataSource);
  procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  function IsForm: Boolean;
  procedure EtvClose(Sender: TObject; var Action: TCloseAction);
  procedure Loaded; override;
  procedure Activate; override;
  procedure Deactivate; override;
  procedure CaptureDataSet(ADataSet:TDataSet; Need:boolean); dynamic;
  procedure ReleaseDataSet(ADataSet:TDataSet); dynamic;
  {procedure CMFormDB(var Message: TMessage); message CM_FormDB;}
  procedure SetFieldReturn(Value:TFieldReturn);
  procedure CheckDBNavHints(aDBNav:TDBNavigator);
  procedure CheckLabel(aLabel:string);
public
  procedure CheckDataSet(ADataSet:TDataSet);
  property FormDataSet:TDataSet read fFormDataSet write fFormDataSet;
  property FieldReturn:TFieldReturn read fFieldReturn write SetFieldReturn;
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  function AutoWidth(aTextWidth,AddWidth:smallint; aLabelWidth:boolean):boolean;
  procedure AddSetup; dynamic;
procedure ShowForm(TypeShow:TTypeShow);
  procedure SetupParams(ALabel:string; AOptions:TFormDBOptions);
published
  property DataSource: TDataSource read GetDataSource write SetDataSource;
  property Options: TFormDBOptions read fOptions write fOptions default [foFreeOnClose,foApplyOnClose];
  property OnClose: TCloseEvent read FOnClose write FOnClose stored IsForm;
end;

TFormDBClass=class of TFormDB;

procedure ConstructOneRecordEdit(Scroll:TWinControl; aDataSource:TDataSource;
                                 aLabelFont:TFont; aEditColor:TColor; OneColumn,OnlyVisible:boolean);

Procedure RefreshDataOnForm(Form:TForm; All:boolean);

Function FindFormDB(ADataSet:TDataSet):TFormDB;
Function ToForm(FormDBClass:TFormDBClass; ADataSet:TDataSet;
                TypeShow:TTypeShow; AFieldReturn:TFieldReturn):TFormDB;
Function ToFormParam(FormDBClass:TFormDBClass; ADataSet:TDataSet;
                     TypeShow:TTypeShow; AFieldReturn:TFieldReturn; ALabel:string;
                     AOptions:TFormDBOptions):TFormDB;

{EtvApp}
type
TEtvApp=class
protected
  OldDMOnDestroy:TNotifyEvent;
  FRefreshForm:Integer;
  procedure BeforeDestroyData(Sender: TObject);
public
  constructor Create;
  procedure DisableRefreshForm;
  procedure EnableRefreshForm;
  procedure EnableRefreshFormNow;
  Procedure RefreshData(Sender:TObject);
  procedure AllCheckBrowseMode(Sender: TObject);
  procedure ShowMessage(const Msg: string);
end;

function EtvApp:TEtvApp;
procedure CreateEtvApp(AOpen:boolean);
Procedure IsDBControl(A:Tcomponent; var DSet,DSetLookup:TDataSet);

IMPLEMENTATION

uses TypInfo,Dialogs,stdctrls,dbgrids,dbTables,sysutils,
     EtvConst,EtvContr,EtvPas,EtvDBFun;

Procedure RefreshDataOnForm(Form:TForm; All:boolean);
var i:smallint;
    List:TList;
    T,TLookup:TDataSet;
    Need:boolean;
    lForm:TForm;
    PropInfo: PPropInfo;
    DS:TDataSource;
  procedure CheckForList(T:TDataset; First:boolean);
  var j:smallint;
  begin
    if (T<>nil) and (List.IndexOf(T)<0) then begin
      if First then List.Insert(0,T)
      else List.Add(T);
      for j:=0 to T.FieldCount-1 do
        if assigned(T.Fields[j].LookupDataSet) then
          CheckForList(T.Fields[j].LookupDataSet,True);
    end;
  end;
begin
  if Form<>nil then lForm:=Form
  else if Screen<>nil then lForm:=Screen.ActiveForm
    else lForm:=nil;
  if lForm<>nil  then with lForm do begin
    List:=TList.Create;
    for i:=0 to ComponentCount-1 do begin
      IsDBControl(components[i],T,TLookup);
      CheckForList(TLookup,True);
      CheckForList(T,False);
    end;
    for i:=0 to List.Count-1 do try
      if TDataSet(List[i]).Active then begin
        if All or
           ((TDataSet(List[i]).tag mod 100 div 10=9) and
            (not (TDataSet(List[i]).State in [dsInsert,dsEdit]))) then begin
          Need:=true;
          PropInfo := GetPropInfo(TDataSet(List[i]).ClassInfo, 'MasterSource');
          if PropInfo <> nil then begin
            DS:=TDataSource(GetOrdProp(TDataSet(List[i]),PropInfo));
            if Assigned(DS) and (DS.DataSet is TQuery) and
               (All or (DS.DataSet.Tag mod 100 div 10=9)) and
               (List.IndexOf(DS.DataSet)>=0) then
              Need:=false;
          end;
          if Need and (TDataSet(List[i]) is TQuery) and
             Assigned(TQuery(List[i]).DataSource) and
             Assigned(TQuery(List[i]).DataSource.DataSet) and
             (All or (TQuery(List[i]).DataSource.DataSet.Tag mod 100 div 10=9)) and
             (List.IndexOf(TQuery(List[i]).DataSource.DataSet)>=0) then
            Need:=false;
          if Need then DataSetRefresh(TDataSet(List[i]));
        end;
      end else if All or (TDataSet(List[i]).Tag mod 100 div 10<>8) then
        TDataSet(List[i]).Open;
    except
    end;
    List.free;
  end;
end;

procedure TFormDBDataLink.ActiveChanged;
begin
  if fFormDB <> nil then fFormDB.CheckDataSet(DataSet);
end;

{TFormDB}
procedure TFormDB.CheckLabel(aLabel:string);
var aCaption:string;
begin
  if ALabel<>'' then
    Caption:=ALabel
  else if Assigned(DataSource) and Assigned(DataSource.DataSet) then begin
    aCaption:=ObjectStrProp(DataSource.DataSet,'Caption');
    if aCaption<>'' then Caption:=aCaption;
  end;
end;

procedure TFormDB.SetupParams(ALabel:string; AOptions:TFormDBOptions);
begin
  CheckLabel(aLabel);
  Options:=AOptions;
end;

constructor TFormDB.Create(aOwner: TComponent);
begin
  FDataLink := TFormDBDataLink.Create;
  TFormDBDataLink(FDataLink).fFormDB:=self;
  fOptions:=[foFreeOnClose];
  inherited Create(aOwner);
  fDataSource:=nil;
  CheckLabel('');
  fCapture:=false;
end;

destructor TFormDB.Destroy;
begin
  if Assigned(DataSource) and Assigned(DataSource.DataSet) then
    CheckDataSet(nil);
  if Assigned(fDataSource) then fDataSource.free;
  fDataSource:=nil;
  inherited Destroy;
  FDataLink.free;
  FDataLink := nil;
end;

function TFormDB.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TFormDB.SetDataSource(Value: TDataSource);
var PropInfo: PPropInfo;
    DS:TDataSource;
    i:integer;
begin
  if Value <> nil then begin
    Value.FreeNotification(Self);
    if Not(csLoading in ComponentState) then
      for i:=0 to ComponentCount-1 do begin
        if GetPropInfo(Components[i].ClassInfo, 'DataField')=nil then begin
          PropInfo := GetPropInfo(Components[i].ClassInfo, 'DataSource');
          if PropInfo <> nil then begin
            DS:=TDataSource(GetOrdProp(Components[i],PropInfo));
            if (DS=FDataLink.DataSource) and
               ((Not(Components[i] is TControl)) or
                TControl(Components[i]).Enabled) then
              SetOrdProp(Components[i], PropInfo, Integer(Value));
          end;
        end;
      end;
  end;
  FDataLink.DataSource := Value;
  CheckLabel('');
end;

procedure TFormDB.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then begin
    if (FDataLink <> nil) and (AComponent = DataSource) then
      DataSource := nil;
    if AComponent=fFieldReturn then fFieldReturn:=nil;
  end;
  {if (Operation = opInsert) and HandleAllocated and
     (csDesigning in ComponentState) and
     (Not(csLoading in ComponentState)) then
    PostMessage(Handle,CM_FormDB,Integer(FormDBInsertComponent),Integer(aComponent));}
end;

function TFormDB.IsForm: Boolean;
begin
  Result := not IsControl;
end;

procedure TFormDB.EtvClose(Sender: TObject; var Action: TCloseAction);
begin
  if (foFreeOnClose in fOptions) or (formStyle=fsMDIChild) then Action:=caFree
  else Action:=caHide;
  if Assigned(DataSource) and assigned(DataSource.DataSet) and (DataSource.DataSet.Active) then begin
    if Not (foDataReadOnly in fOptions) then DataSource.DataSet.CheckBrowseMode;
    if (foApplyOnClose in Options) and (DataSource.DataSet is TDBDataSet) and
      TDBDataSet(DataSource.DataSet).CachedUpdates and
      TDBDataSet(DataSource.DataSet).UpdatesPending then
      TDBDataSet(DataSource.DataSet).DataBase.ApplyUpdates([TDBDataSet(DataSource.DataSet)]);
    if Assigned(FieldReturn) then
      FieldReturn.Value:=DataSource.DataSet.FieldByName(FieldReturn.Field).value;
  end;
  if Assigned(fOnClose) then fOnClose(Sender, Action);
end;

procedure TFormDB.Loaded;
begin
  inherited Loaded;
  if not(csDesigning in ComponentState) then begin
    inherited OnClose:=EtvClose;
  end;
end;

procedure TFormDB.Activate;
begin
  if assigned(DataSource) and assigned(DataSource.Dataset) and
     Assigned(FieldReturn) then
    try
      LocateWOExcept(DataSource.DataSet,FieldReturn.Field,FieldReturn.Value,[])
    finally
    end;
  inherited Activate;
end;

Procedure TFormDB.Deactivate;
begin
  if assigned(DataSource) and assigned(DataSource.DataSet) and
     (DataSource.DataSet.Active) and (Not (foDataReadOnly in fOptions)) then
    DataSource.DataSet.CheckBrowseMode;
  inherited Deactivate;
end;

Function TFormDB.AutoWidth(aTextWidth,AddWidth:smallint; aLabelWidth:boolean):boolean;
var i,j,AWidth:integer;
begin
  Result:=true;
  if aTextWidth<=0 then aTextWidth:=Canvas.TextWidth('0');
  if Assigned(Datasource) and Assigned(DataSource.DataSet) and
     (DataSource.DataSet.FieldCount>0) then begin
    (* Width of form *)
    AWidth:=0;
    for i := 0 to DataSource.DataSet.FieldCount - 1 do
      if DataSource.DataSet.Fields[i].visible then begin
        j:=DataSource.DataSet.Fields[i].DisplayWidth;
        if aLabelWidth and
           (length(DataSource.DataSet.Fields[i].DisplayLabel)>j) then
          j:=length(DataSource.DataSet.Fields[i].DisplayLabel);
        AWidth:=AWidth+j+1;
      end;
    AWidth:=AWidth*ATextWidth+AddWidth;

    if AWidth>Screen.Width then begin
      AWidth:=Screen.Width;
      Result:=false;
    end;
    if AWidth>Width then Width:=AWidth;
    if Width+Left>Screen.Width then
      Left:=Screen.Width-width;
  end;
end;

procedure TFormDB.AddSetup;
begin
  AutoWidth(0,45,true);
end;

procedure TFormDB.ShowForm(TypeShow:TTypeShow);
var Exist:boolean;
begin
  if (TypeShow=viShowModal) and (formStyle<>fsMDIChild) then begin
    if visible then visible:=false;
    if windowState=wsMinimized then windowState:=wsNormal;
    if ShowModal=mrOk then OkOnEditData:=true
    else OkOnEditData:=false;
  end else
  if TypeShow<>viNone then begin
    Exist:=false;
    if not visible then begin
      visible:=true;
      Exist:=true;
    end;
    if windowState=wsMinimized then begin
      windowState:=wsNormal;
      Exist:=true;
    end;
    if not Exist then begin
      if (formStyle=fsMDIChild) then bringToFront;
      SetFocus;
    end;
  end;
end;

procedure TFormDB.CheckDataSet(ADataSet:TDataSet);
begin
  if Not Assigned(DataSource) then begin
    if Not Assigned(fDataSource) then fDataSource:=TDataSource.Create(nil);
    DataSource:=fDataSource;
  end;
  if DataSource.DataSet<>aDataSet then begin
    if Assigned(DataSource.DataSet) then ReleaseDataSet(DataSource.DataSet);
    DataSource.DataSet:=aDataSet;
    if Assigned(aDataSet) then CaptureDataSet(aDataSet,true);
  end else CaptureDataSet(aDataSet,false);
  CheckLabel('');
end;

procedure TFormDB.CaptureDataSet(ADataSet:TDataSet; Need:boolean);
begin
  if Need or (Not fCapture) then begin
    fCapture:=true;
    if Assigned(ADataset) then begin
      fOldActive:=ADataSet.Active;
      if ADataSet is TTable then with TTable(ADataSet) do begin
        fOldCachedUpdates:=CachedUpdates;
        if not(foDataReadOnly in fOptions) and fOldCachedUpdates then begin
          if fOldActive then Close;
          CachedUpdates:=false;
        end;
        fOldReadOnly:=ReadOnly;
        if fOldReadOnly<>(foDataReadOnly in fOptions) then begin
          if Active then Close;
          ReadOnly:=foDataReadOnly in fOptions;
        end;
        OldIndexFieldNames:=IndexFieldNames;
        OldIndexName:=IndexName;
      end;
      if Not ADataSet.Active then ADataSet.Open;
    end;
  end;
end;

procedure TFormDB.ReleaseDataSet(ADataSet:TDataSet);
begin
  if (ADataSet is TTable) then with TTable(ADataSet) do begin
    if (fOldCachedUpdates<>CachedUpdates) then begin
      if Active then Close;
      CachedUpdates:=fOldCachedUpdates;
    end;
    if (fOldReadOnly<>ReadOnly) then begin
      if Active then Close;
      ReadOnly:=fOldReadOnly;
    end;
    if OldIndexFieldNames<>IndexFieldNames then
      IndexFieldNames:=OldIndexFieldNames;
    if OldIndexName<>IndexName then IndexName:=OldIndexName;
  end;
  if ADataSet.Active<>fOldActive then ADataSet.Active:=fOldActive;
end;

{procedure TFormDB.CMFormDB(var Message: TMessage);
var PropInfo: PPropInfo;
begin
  if (Message.wParam=FormDBInsertComponent) then begin
    PropInfo := GetPropInfo(TComponent(Message.lParam).ClassInfo, 'DataSource');
    if PropInfo <> nil then
      SetOrdProp(TComponent(Message.lParam), PropInfo, Integer(DataSource));
    if TComponent(Message.lParam) is TDBNavigator then
      CheckDBNavHints(TDBNavigator(TComponent(Message.lParam)));
  end;
end;}

procedure TFormDB.SetFieldReturn(Value:TFieldReturn);
begin
  fFieldReturn:=Value;
  if Assigned(Value) then
    Value.FreeNotification(Self);
end;

procedure TFormDB.CheckDBNavHints(aDBNav:TDBNavigator);
begin
  if aDBNav.Hints.count=0 then begin
    aDBNav.Hints.Add(SNavFirst);
    aDBNav.Hints.Add(SNavPrior);
    aDBNav.Hints.Add(SNavNext);
    aDBNav.Hints.Add(SNavLast);
    aDBNav.Hints.Add(SNavInsert);
    aDBNav.Hints.Add(SNavDelete);
    aDBNav.Hints.Add(SNavEdit);
    aDBNav.Hints.Add(SNavPost);
    aDBNav.Hints.Add(SNavCancel);
    aDBNav.Hints.Add(SNavRefresh);
  end;
end;

type TWinControlSelf=class(TWinControl) end;
     TControlSelf=class(TControl) end;

procedure ConstructOneRecordEdit(Scroll:TWinControl; aDataSource:TDataSource;
            aLabelFont:TFont; aEditColor:TColor; OneColumn,OnlyVisible:boolean);
var i,l,ind,aTop,aLeft,ofs:integer;
    Ed: TControl;
    Field:TField;
    Lab:TLabel;
    labelFont:TFont;
    labelWidth,labelHeight,lWidth,lHeight:integer;
    PropInfo:PPropInfo;
function GoodField(aField:TField):boolean;
begin
  if (aField.Tag mod 10<>8) and
     ((aField.Visible) or (Not OnlyVisible)) then Result:=true
  else Result:=false;
end;
begin
  if Not assigned(aDataSource.DataSet) then Exit;
  GetFontSizes(TWinControlSelf(Scroll).Font,lWidth,lHeight,'');
  if Assigned(aLabelFont) then LabelFont:=aLabelFont
  else LabelFont:=TWinControlSelf(Scroll).Font;

  if OneColumn then begin
    l:=0; ind:=0;
    For i:=0 to aDataSource.DataSet.FieldCount - 1 do
      if GoodField(aDataSource.DataSet.Fields[i]) and
         (length(aDataSource.DataSet.Fields[i].DisplayLabel)>l) then begin
        l:=length(aDataSource.DataSet.Fields[i].DisplayLabel);
        ind:=i;
      end;
    GetFontSizes(LabelFont,LabelWidth,LabelHeight,aDataSource.DataSet.Fields[ind].DisplayLabel);
  end;

  aTop:=3;
  aLeft:=5;
  ofs:=0;
  For i:=0 to aDataSource.DataSet.FieldCount - 1 do
    if GoodField(aDataSource.DataSet.Fields[i]) then begin
      Field:=aDataSource.DataSet.Fields[i];
      Ed:=DBEditForField(Scroll,Field,aDataSource,lWidth);
      if Assigned(Ed) then begin
        if aEditColor<>0 then TControlSelf(Ed).Color:=aEditColor;

        Lab:=TLabel.Create(Scroll);
        Lab.ParentFont:=false;
        Lab.Font:=LabelFont;
        Lab.Caption:=Field.DisplayLabel;

        if OneColumn or
           (aLeft+Lab.Width+4+Ed.Width>=Scroll.ClientWidth) then begin
          aTop:=aTop+ofs;
          aLeft:=5;
          ofs:=0;
        end;

        Lab.Top:=aTop+3;
        Lab.Left:=aLeft;
        if Ed is TCustomLabel then Ed.Top:=aTop+3
        else Ed.Top:=aTop;
        if OneColumn then
          Ed.Left:=Lab.Left+LabelWidth+8
        else Ed.Left:=Lab.Left+Lab.Width+4;

        Scroll.InsertControl(Ed);
        if ControlRequiredParent(Ed) then begin
          PropInfo := GetPropInfo(Ed.ClassInfo, 'DataField');
          if PropInfo <> nil then
          SetStrProp(Ed, PropInfo, Field.FieldName);
        end;
        if Ed is TWinControl then Lab.FocusControl:=TWinControl(Ed);
        Scroll.InsertControl(Lab);
        if ofs<Ed.Height+5 then ofs:=Ed.Height+5;
        aLeft:=Ed.Left+Ed.Width+5;
      end;
    end;
End;

Function FindFormDB(ADataSet:TDataSet):TFormDB;
var i:integer;
begin
  Result:=nil;
  if Assigned(Screen) then
    for i:=0 to Screen.FormCount-1 do
      if (Screen.Forms[i] is TFormDB) and
         (TFormDB(Screen.Forms[i]).FormDataSet=ADataSet)
          then begin
        Result:=TFormDB(Screen.Forms[i]);
        Exit;
      end;
end;

Function ToForm(FormDBClass:TFormDBClass; ADataSet:TDataSet;
                TypeShow:TTypeShow; AFieldReturn:TFieldReturn):TFormDB;
begin
  Result:=FindFormDB(ADataSet);
  if Not Assigned(Result) then begin
    Result:=FormDBClass.Create(Application);
    Result.FormDataSet:=ADataSet;
    Result.CheckDataSet(aDataSet);
    Result.AddSetup;
  end else if Assigned(Screen) and (Result=Screen.ActiveForm) then Exit;
  Result.FieldReturn:=AFieldReturn;
  Result.ShowForm(TypeShow);
end;

Function ToFormParam(FormDBClass:TFormDBClass; ADataSet:TDataSet;
                     TypeShow:TTypeShow; AFieldReturn:TFieldReturn; ALabel:string;
                     AOptions:TFormDBOptions):TFormDB;
begin
  Result:=FindFormDB(ADataSet);
  if Not Assigned(Result) then begin
    Result:=FormDBClass.Create(Application);
    Result.FormDataSet:=ADataSet;
    Result.SetupParams(ALabel,AOptions);
    Result.CheckDataSet(aDataSet);
    Result.AddSetup;
  end else if Assigned(Screen) and (Result=Screen.ActiveForm) then Exit;
  Result.FieldReturn:=AFieldReturn;
  Result.ShowForm(TypeShow);
end;

{EtvApp}
var fEtvApp:TEtvApp;

function EtvApp:TEtvApp;
begin
  if Not Assigned(fEtvApp) then fEtvApp:=TEtvApp.Create;
  Result:=fEtvApp;
end;

Procedure IsDBControl(A:Tcomponent; var DSet,DSetLookup:TDataSet);
var DS:TDataSource;
  function FIsDBControl(A:Tcomponent;NameProp:string):TDataSource;
  var PropInfo: PPropInfo;
  begin
    Result:=nil;
    PropInfo := GetPropInfo(A.ClassInfo, NameProp);
    if PropInfo <> nil then
      Result:=TDataSource(GetOrdProp(A, PropInfo));
  end;
begin
  DS:=FIsDBControl(A,'DataSource');
  if Assigned(DS) then DSet:=DS.DataSet else DSet:=nil;
  DS:=FIsDBControl(A,'ListSource');
  if Assigned(DS) then DSetLookup:=DS.DataSet else DSetLookup:=nil;
end;

constructor TEtvApp.Create;
begin
 Inherited;
 FRefreshForm:=0;
end;

procedure TEtvApp.DisableRefreshForm;
begin
  inc(FRefreshForm);
end;

procedure TEtvApp.EnableRefreshForm;
begin
  if FRefreshForm>0 then Dec(FRefreshForm);
end;

procedure TEtvApp.EnableRefreshFormNow;
begin
  if FRefreshForm>0 then begin
    Dec(FRefreshForm);
    if FRefreshForm=0 then RefreshData(Self);
  end;
end;

Procedure TEtvApp.RefreshData(Sender:TObject);
begin
  if (Screen.ActiveForm<>nil) and (Screen.ActiveForm.Tag=9) and
     (FRefreshForm=0) then
    RefreshDataOnForm(Screen.ActiveForm,false);
end;

procedure TEtvApp.AllCheckBrowseMode(Sender: TObject);
var i,j:Integer;
begin
  (*All CheckBrowseMode*)
  for i:=0 to Session.DataBaseCount-1 do
    for j:=0 to Session.DataBases[i].DataSetCount-1 do
      Try
        with Session.DataBases[i].DataSets[j] do
          if Active then CheckBrowseMode;
      except
      end;
end;

procedure TEtvApp.BeforeDestroyData(Sender: TObject);
begin
  AllCheckBrowseMode(Sender);
  if Assigned(OldDMOnDestroy) then OldDMOnDestroy(Sender);
end;

procedure TEtvApp.ShowMessage(const Msg: string);
begin
  EtvApp.DisableRefreshForm;
  Dialogs.ShowMessage(Msg);
  EtvApp.EnableRefreshForm;
end;

procedure CreateEtvApp(AOpen:boolean);
var i,j:integer;
begin
  if Assigned(Screen) then begin
    Screen.OnActiveFormChange:=EtvApp.RefreshData;
    (* auto Open *)
    if AOpen then
      for i:=0 to Screen.DatamoduleCount-1 do
        for j:=0 to Screen.DataModules[i].ComponentCount-1 do
          if (Screen.DataModules[i].Components[j] is TDBDataSet) then begin
            if (Screen.DataModules[i].Components[j].tag mod 10=9) then
              try
                TDBDataSet(Screen.DataModules[i].Components[j]).Open;
              except
              end;
          end;
  end else EtvApp.ShowMessage('Screen dont initialize');
  if Assigned(Application) then begin
    if Assigned(Application.MainForm) then
      RefreshDataOnForm(Application.MainForm,false);
    if Screen.DatamoduleCount>0 then begin
      EtvApp.OldDMOnDestroy:=Screen.DataModules[Screen.DatamoduleCount-1].OnDestroy;
      Screen.DataModules[Screen.DatamoduleCount-1].OnDestroy:=EtvApp.BeforeDestroyData;
    end;
  end;
end;

initialization

finalization
  if assigned(fEtvApp) then fEtvApp.Free;
end.
