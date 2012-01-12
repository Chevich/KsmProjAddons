unit EtvDsgn;

interface
uses DsgnIntf,classes,db;

type
  TEtvDataSetEditor = class(TComponentEditor)
    function GetVerbCount:integer; override;
    function GetVerb(Index:integer):string; override;
    procedure ExecuteVerb(Index:Integer); override;
  end;

  TEtvDMEditor = class(TComponentEditor)
    function GetVerbCount:integer; override;
    function GetVerb(Index:integer):string; override;
    procedure ExecuteVerb(Index:Integer); override;
  end;

  TEtvDBCustomControlEditor = class(TComponentEditor)
    procedure ToDataSet(DataS:TComponent);
    procedure ToField(DataSource:TDataSource; DataField:string);
  end;

  TEtvDBControlEditor = class(TEtvDBCustomControlEditor)
    function GetVerbCount:integer; override;
    function GetVerb(Index:integer):string; override;
    procedure ExecuteVerb(Index:Integer); override;
  end;

  TEtvDBFieldControlEditor = class(TEtvDBCustomControlEditor)
    function GetVerbCount:integer; override;
    function GetVerb(Index:integer):string; override;
    procedure ExecuteVerb(Index:Integer); override;
  end;

  TEtvDBLookupComboEditor = class(TEtvDBCustomControlEditor)
    function GetVerbCount:integer; override;
    function GetVerb(Index:integer):string; override;
    procedure ExecuteVerb(Index:Integer); override;
  end;

  TEtvDataSourceEditor = class(TEtvDBCustomControlEditor)
    function GetVerbCount:integer; override;
    function GetVerb(Index:integer):string; override;
    procedure ExecuteVerb(Index:Integer); override;
  end;

  TEtvPageControlEditor = class(TComponentEditor)
    function GetVerbCount:integer; override;
    function GetVerb(Index:integer):string; override;
    procedure ExecuteVerb(Index:Integer); override;
  end;

procedure SetDesignerToComponent(Comp:TComponent);

IMPLEMENTATION

Uses TypInfo,exptIntf,EditIntf,LibIntf,DsDesign,DBXplor,
     sysutils,dbTables,Clipbrd,Dialogs,graphics,Windows,
     EtvDB,EtvTable,EtvDBFun,EtvLook,EtvBor,
     EtvForms,fBase,EtvPas,EtvContr;

{TEtvDataSetEditor}
const QuantityLines=9;

Function TEtvDataSetEditor.GetVerbCount:integer;
begin
  Result:=QuantityLines+(TDataSet(Component).fieldCount);
end;

Function TEtvDataSetEditor.GetVerb(Index:integer):string;
begin
  Case Index of
    0: Result:='Fields Editor..';
    1: Result:=DataSetInfo(TDataSet(Component));
    2: Result:='Auto correct';
    3: Result:='Pump Display Labels. Auto correct';
    4: Result:='Explore';
    5: Result:='Connect/reconnect database';
    6: Result:='Copy list of data fields to clipboard';
    7: Result:='Copy info of fields to clipboard';
    8: Result:='Run edit form';
    else Result:=FieldInfo(TDataSet(Component).Fields[Index-QuantityLines],false);
  end;
end;

procedure TEtvDataSetEditor.ExecuteVerb(Index:integer);
var db:TDataBase;
    List:TList;
    I: Integer;
    f:TFormDB;
begin
  Case Index of
    0: ShowDatasetDesigner(Designer, TDataSet(Component));
    1: begin
      if TDataSet(Component).Active then TDataSet(Component).close
      else TDataSet(Component).Open;
      Designer.Modified;
    end;
    2: begin
      DataSetAutoCorrect(TDBDataSet(Component));
      Designer.Modified;
    end;
    3: begin
      DataSetLabel(TDBDataSet(Component));
      DataSetAutoCorrect(TDBDataSet(Component));
      Designer.Modified;
    end;
    4: ExploreDataSet(TDBDataSet(Component));
    5: begin
      with TDBDataSet(Component) do begin
        if Assigned(Session.FindDataBase(DataBaseName)) then begin
          DB:=Session.FindDataBase(DataBaseName);
          List:=TList.Create;
          for I := 0 to DB.DataSetCount - 1 do
            List.Add(DB.DataSets[I]);
          if DB.Connected then DB.Connected:=false;
          DB.Connected:=true;
          if DB.Connected then
            for I := 0 to List.Count - 1 do
              TDataSet(List.items[I]).Active:=true;
          List.Free;
        end;
      end;
      Designer.Modified;
    end;
    6: FieldDataListToClipBoard(TDataSet(Component));
    7: DataSetInfoToClipBoard(TDataSet(Component));
    8: begin
      F:=nil;
      try
        F:=TFormBase.Create(nil);
        F.CheckDataSet(TDataSet(Component));
        if TDataSet(Component).Active then begin
          F.AddSetup;
          F.ShowForm(viShowModal);
        end else F.Free;
        F:=nil;
      except
        on E: Exception do begin
          if Assigned(F) then F.Free;
          EtvApp.ShowMessage(E.Message);
        end;
      end;
    end;
    else begin
      Designer.SelectComponent(TDataSet(Component).Fields[Index-QuantityLines]);
      DelphiIDE.ModalEdit(#0,Nil);
    end;
  end;
end;

{TEtvDMEditor}
Function TEtvDMEditor.GetVerbCount:integer;
var dm:TComponent;
    i:smallInt;
begin
  Result:=3;  (* Active and Close all DataSets *)
  dm:=Component.owner;
  for i:=0 to dm.ComponentCount-1 do
    if dm.Components[i] is TDBDataSet then Result:=Result+1;
end;

Function TEtvDMEditor.GetVerb(Index:integer):string;
var dm:TComponent;
    i,ind:smallint;
begin
  case Index of
    0: Result:=TEtvDMInfo(Component).Caption;
    1: Result:='Open all DataSets';
    2: Result:='Close all DataSets';
    else begin
      dm:=Component.owner;
      ind:=2;
      for i:=0 to DM.ComponentCount-1 do begin
        if dm.Components[i] is TDBDataSet then Inc(Ind);
        if ind=index then begin
          Result:=DataSetInfo(TDataSet(dm.Components[i]));
          break;
        end;
      end;
    end;
  end;
end;

procedure TEtvDMEditor.ExecuteVerb(Index:integer);
var dm:TComponent;
    i,ind:smallint;
begin
  dm:=Component.owner;
  case Index of
    0: ;
    1: begin (* Open all DataSets *)
      OpenAllDataSets(DM,true);
      Designer.Modified;
    end;
    2: begin (* Close all DataSets *)
      CloseAllDataSets(DM,true);
      Designer.Modified;
    end;
    else begin
      ind:=2;
      for i:=0 to DM.ComponentCount-1 do begin
        if dm.Components[i] is TDBDataSet then Inc(Ind);
        if ind=index then begin
          Designer.SelectComponent(dm.components[i]);
          break;
        end;
      end;
    end;
  end;
end;

procedure SetDesignerToComponent(Comp:TComponent);
var i: Integer;
    MI: TIModuleInterface;
    FI: TIFormInterface;
    CI: TIComponentInterface;
begin
  for i:=0 to ToolServices.GetUnitCount-1 do begin
    MI:=ToolServices.GetModuleInterface(ToolServices.GetUnitName(i));
    if Assigned(MI) then
      try
        FI:=MI.GetFormInterface;
        if Assigned(FI) then
          try
            CI:=FI.GetComponentFromHandle(Comp);
            if Assigned(CI) then begin
              CI.Focus;
              CI.Free;
            end;
          finally
            FI.Free;
          end;
      finally
        MI.Free;
      end;
  end;
end;

{TEtvDBCustomControlEditor}
Procedure TEtvDBCustomControlEditor.ToField(DataSource:TDataSource; DataField:string);
var aField:TField;
begin
  if (DataField<>'') and Assigned(DataSource) and Assigned(DataSource.DataSet) then begin
    aField:=DataSource.DataSet.FindField(DataField);
    if Assigned(aField) then begin
      SetDesignerToComponent(aField);
      DelphiIDE.ModalEdit(#0,nil);
    end;
  end;
end;

procedure TEtvDBCustomControlEditor.ToDataSet(DataS:TComponent);
begin
  if Assigned(DataS) then begin
    if (DataS is TDataSource) and Assigned(TDataSource(DataS).DataSet) then begin
      SetDesignerToComponent(TDataSource(DataS).DataSet);
      DelphiIDE.ModalEdit(#0,Nil);
    end;
    if (DataS is TDataSet) then begin
      SetDesignerToComponent(TDataSet(DataS));
      DelphiIDE.ModalEdit(#0,Nil);
    end;
  end;
end;

{TEtvDBControlEditor}
Function TEtvDBControlEditor.GetVerbCount:integer;
begin
  Result:=1;
end;

Function TEtvDBControlEditor.GetVerb(Index:integer):string;
begin
  Case Index of
    0: Result:='Go to DataSet';
  end;
end;

procedure TEtvDBControlEditor.ExecuteVerb(Index:integer);
var PropInfo: PPropInfo;
begin
  PropInfo := GetPropInfo(Component.ClassInfo, 'DataSource');
  if PropInfo <> nil then
    ToDataSet(TDataSource(GetOrdProp(Component, PropInfo)));
end;

{TEtvDBFieldControlEditor}
Function TEtvDBFieldControlEditor.GetVerbCount:integer;
begin
  Result:=2;
end;

Function TEtvDBFieldControlEditor.GetVerb(Index:integer):string;
begin
  Case Index of
    0: Result:='Go to DataSet';
    1: Result:='Go to DataField';
  end;
end;

procedure TEtvDBFieldControlEditor.ExecuteVerb(Index:integer);
var PropInfo: PPropInfo;
    DS:TDataSource;
begin
  PropInfo := GetPropInfo(Component.ClassInfo, 'DataSource');
  if PropInfo <> nil then begin
    DS:=TDataSource(GetOrdProp(Component, PropInfo));
    if Assigned(DS) then
      case Index of
        0: ToDataSet(DS);
        1: ToField(DS,ObjectStrProp(Component,'DataField'));
      end;
  end;
end;
{TEtvDBLookupComboEditor}
Function TEtvDBLookupComboEditor.GetVerbCount:integer;
begin
  Result:=4;
end;

Function TEtvDBLookupComboEditor.GetVerb(Index:integer):string;
begin
  Case Index of
    0: Result:='Auto size';
    1: Result:='Go to DataField';
    2: Result:='Go to DataSet';
    3: Result:='Go to LookupDataSet';
  end;
end;

procedure TEtvDBLookupComboEditor.ExecuteVerb(Index:integer);
var L:smallint;
    aField:TField;
    Exist:boolean;
begin
  case Index of
    0: begin
      L:=TEtvDBLookupCombo(Component).AutoWidth;
      if L>0 then Designer.Modified;
    end;
    1: With TEtvDBLookupCombo(Component) do
      ToField(DataSource,DataField);
    2: With TEtvDBLookupCombo(Component) do
      ToDataSet(DataSource);
    3: With TEtvDBLookupCombo(Component) do begin
      Exist:=false;
      if (DataField<>'') and Assigned(DataSource) and
         Assigned(DataSource.DataSet) then begin
        aField:=DataSource.DataSet.FindField(DataField);
        if Assigned(aField) and (aField.FieldKind=fkLookup) then begin
          Exist:=true;
          ToDataSet(aField.LookupDataSet);
        end;
      end;
      if (Not Exist) then ToDataSet(ListSource);
    end;
  end;
end;

{TEtvDataSourceEditor}
Function TEtvDataSourceEditor.GetVerbCount:integer;
begin
  Result:=1;
end;

Function TEtvDataSourceEditor.GetVerb(Index:integer):string;
begin
  Case Index of
    0: Result:='Go to DataSet';
  end;
end;

procedure TEtvDataSourceEditor.ExecuteVerb(Index:integer);
begin
  case Index of
    0: ToDataSet(TDataSource(Component))
  end;
end;

{TEtvPageControlEditor}
function TEtvPageControlEditor.GetVerbCount:integer;
begin
  Result:=4;
end;

function TEtvPageControlEditor.GetVerb(Index:integer):string;
begin
  Case Index of
    0: Result:='New page';
    1: Result:='Next page';
    2: Result:='Previous page';
    3: Result:='Current page';
  end;
end;

procedure TEtvPageControlEditor.ExecuteVerb(Index:Integer);
var Tabs:TEtvTabSheet;
    lPageControl:TEtvPageControl;
begin
  if Component is TEtvPageControl then lPageControl:=TEtvPageControl(Component)
  else lPageControl:=TEtvPageControl(TEtvTabSheet(Component).PageControl);
  With lPageControl do begin
    case Index of
      0: begin
        Tabs:=TEtvTabSheet(Designer.CreateComponent(TEtvTabSheet,nil,0,0,0,0));
        Tabs.PageControl:=lPageControl;
        ActivePage:=Tabs;
      end;
      1: SelectNextPage(true);
      2: SelectNextPage(false);
    end;
    if Assigned(ActivePage) then Designer.SelectComponent(ActivePage);
  end;
end;

end.
