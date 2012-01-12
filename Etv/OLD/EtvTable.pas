unit EtvTable; (* Igo Val Lev *)

interface

uses Classes,Db,DBTables,DBClient,
     EtvDB;

{$I Etv.inc}

type
  TEtvDataSetAction=(daInsert,daDelete,daClone,daPrint,daPrintRecord,
                     daUserAction1,daUserAction2,daUserAction3);
  TEtvDataSetActions=set of TEtvDataSetAction;
  TOnDataSetActionEvent=procedure (Sender: TObject; aDataSet:TDataSet;
    aAction:TEtvDataSetAction; var ActionNeed:boolean) of object;
const DefaultEtvDataSetAction=[daInsert,daDelete,daClone,daPrint,daPrintRecord];

type
  TEtvTable=class(TTable)
  protected
    fActions:TEtvDataSetActions;
    fCaption:String;
    fSortingList:TStrings;
    fUniqueFields:string;
    fEditData:TOnEditDataEvent;
    fOnAction:TOnDataSetActionEvent;
    procedure SetCaption(ACaption:string);
    procedure SetSortingList(Value: TStrings);
    procedure InternalOpen; override;
    procedure DoBeforePost; override;
    procedure DoBeforeInsert; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeIndex(aNameIndex: string);
    procedure GotoBookmarkWOExcept(Bookmark: TBookmark);
    function LocateWOExcept(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean;   (* need when filter changed *)
  published
    property Actions:TEtvDataSetActions read fActions write fActions default DefaultEtvDataSetAction;
    property Caption:String read fCaption Write SetCaption;
    property SortingList:TStrings read fSortingList Write SetSortingList;
    property UniqueFields:String read fUniqueFields Write fUniqueFields;
    property OnEditData:TOnEditDataEvent read fEditData Write fEditData;
    property OnAction:TOnDataSetActionEvent read fOnAction write fOnAction;
  end;

type
TEtvQuery=class(TQuery)
  protected
    fActions:TEtvDataSetActions;
    fCaption:String;
    fSortingList:TStrings;
    fTableName:String;
    fUniqueFields:string;
    fEditData:TOnEditDataEvent;
    fOnAction:TOnDataSetActionEvent;
    procedure SetCaption(ACaption:string);
    procedure SetSortingList(Value: TStrings);
    procedure SetTableName(ATableName:String);
    procedure InternalOpen; override;
    procedure DoBeforePost; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Actions:TEtvDataSetActions read fActions write fActions default DefaultEtvDataSetAction;
    property Caption:String read fCaption Write SetCaption;
    property SortingList:TStrings read fSortingList Write SetSortingList;
    property TableName: String read FTableName write SetTableName;
    property UniqueFields:String read fUniqueFields Write fUniqueFields;
    property OnEditData:TOnEditDataEvent read fEditData Write fEditData;
    property OnAction:TOnDataSetActionEvent read fOnAction write fOnAction;
  end;

TEtvClientDataSet=class(TClientDataSet)
  protected
    fActions:TEtvDataSetActions;
    fCaption:String;
    fSortingList:TStrings;
    fUniqueFields:string;
    fEditData:TOnEditDataEvent;
    fOnAction:TOnDataSetActionEvent;
    procedure SetCaption(ACaption:string);
    procedure SetSortingList(Value: TStrings);
    procedure InternalOpen; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Actions:TEtvDataSetActions read fActions write fActions default DefaultEtvDataSetAction;
    property Caption:String read fCaption Write SetCaption;
    property SortingList:TStrings read fSortingList Write SetSortingList;
    property UniqueFields:String read fUniqueFields Write fUniqueFields;
    property OnEditData:TOnEditDataEvent read fEditData Write fEditData;
    property OnAction:TOnDataSetActionEvent read fOnAction write fOnAction;
  end;

{$IFDEF EtvAutoInc}
Procedure AutoIncBeforePost(DataSet: TDataSet; Const ATableName, ADataBaseName: String);
{$ENDIF}

type
  TEtvDMInfo = class(TComponent) (* info about DataModule*)
  protected
    fCaption:string;
  published
    property Caption:String read fCaption write fCaption;
  end;

implementation
uses Dialogs,SysUtils,
     EtvDBFun;

procedure TEtvTable.SetCaption(ACaption:String);
begin
  fCaption:=ACaption;
end;

procedure TEtvTable.SetSortingList(Value: TStrings);
begin
  fSortingList.Assign(Value);
  DataEvent(deDataSetChange,0);
end;

procedure TEtvQuery.SetCaption(ACaption:String);
begin
  fCaption:=ACaption;
end;

procedure TEtvQuery.SetSortingList(Value: TStrings);
begin
  fSortingList.Assign(Value);
  DataEvent(deDataSetChange,0);
end;

procedure TEtvQuery.SetTableName(ATableName:String);
begin
  fTableName:=ATableName;
end;

Constructor TEtvClientDataSet.Create(AOwner: TComponent);
begin
  inherited;
  fSortingList:=TStringList.Create;
  fActions:=DefaultEtvDataSetAction;
end;

Destructor TEtvClientDataSet.Destroy;
begin
 fSortingList.free;
 inherited;
end;

procedure TEtvClientDataSet.SetCaption(ACaption:String);
begin
  fCaption:=ACaption;
end;

procedure TEtvClientDataSet.SetSortingList(Value: TStrings);
begin
  fSortingList.Assign(Value);
  DataEvent(deDataSetChange,0);
end;

{$IFDEF EtvAutoInc} (* Val for Autoinc begin *)
var
  AutoIncQuery: TQuery=Nil;
  MaxNumAutoIncQuery: TIntegerField;

procedure AutoIncBeforePost(DataSet: TDataSet; Const ATableName, ADataBaseName: String);
var Field:TField;
    i: Integer;
begin
  if DataSet.State=dsInsert then
    for i:=0 to DataSet.FieldCount-1 do
      if DataSet.Fields[i].DataType = ftAutoInc then
        with AutoIncQuery do begin
          DatabaseName:=ADatabaseName;
          SQL.Add('select max('+DataSet.Fields[i].FieldName+') as MaxNumAutoIncQuery from '+ATableName);
          Try
            Open;
            Field:=DataSet.Fields[i];
            if Field.ReadOnly then begin
              Field.ReadOnly:=False;
              Field.Value:=MaxNumAutoIncQuery.Value+1;
              Field.ReadOnly:=True;
            end else Field.Value:=MaxNumAutoIncQuery.Value+1;
          Finally
            Close;
            SQL.Clear;
          end;
        end;
end;
{$ENDIF} (* Val for Autoinc end *)

procedure TEtvTable.InternalOpen;
begin
  inherited InternalOpen;
  {$IFNDEF Delphi4}
  AfterInternalOpen(self);
  {$ENDIF}
end;

procedure TEtvQuery.InternalOpen;
var Table:TTable;
    i:integer;
begin
  inherited InternalOpen;
  {$IFNDEF Delphi4}
  AfterInternalOpen(self);
  {$ENDIF}
  (* fill SortingList *)
  if (TableName<>'') and (SortingList.Count=0) and
     (not (csDesigning in ComponentState)) then begin
    Table:=TTable.Create(nil);
    Table.DataBaseName:=DataBaseName;
    Table.TableName:=TableName;
    Table.IndexDefs.Update;
    for i:=0 to Table.IndexDefs.Count-1 do
      SortingList.Add(Table.IndexDefs.Items[i].Fields);
    Table.Free;
  end;
end;

procedure TEtvClientDataSet.InternalOpen;
begin
  inherited InternalOpen;
  {$IFNDEF Delphi4}
  AfterInternalOpen(self);
  {$ENDIF}
end;

procedure TEtvTable.DoBeforePost;
begin
  {$IFDEF EtvAutoInc} (* Val for Autoinc begin *)
  if Database.IsSqlBased then
    AutoIncBeforePost(Self, TableName, DatabaseName);
  {$ENDIF}
  inherited DoBeforePost;
end;

procedure TEtvQuery.DoBeforePost;
begin
  {$IFDEF EtvAutoInc} (* Val for Autoinc begin *)
  if Database.IsSqlBased then
    AutoIncBeforePost(Self, TableName, DatabaseName);
  {$ENDIF}
  inherited DoBeforePost;
end;

procedure TEtvTable.DoBeforeInsert;
begin
  (* Auto Post MasterSource.DataSet *)
  if Assigned(MasterSource) and Assigned(MasterSource.DataSet) then begin
    if MasterSource.DataSet.State=dsInsert then begin
      MasterSource.DataSet.Post;
      if MasterSource.DataSet.State=dsInsert then SysUtils.Abort;
    end;
    if MasterSource.DataSet.BOF and MasterSource.DataSet.EOF then
      SysUtils.Abort;
  end;
  inherited DoBeforeInsert;
end;


Constructor TEtvTable.Create(AOwner: TComponent);
begin
  inherited;
  fSortingList:=TStringList.Create;
  fActions:=DefaultEtvDataSetAction;
end;

Destructor TEtvTable.Destroy;
begin
 fSortingList.free;
 inherited;
end;

Constructor TEtvQuery.Create(AOwner: TComponent);
begin
  inherited;
  fSortingList:=TStringList.Create;
  fActions:=DefaultEtvDataSetAction;
end;

Destructor TEtvquery.Destroy;
begin
  fSortingList.free;
  inherited;
end;

Procedure TEtvTable.ChangeIndex(aNameIndex: string);
begin
  SortingToDataSet(Self,aNameIndex,true);
end;

procedure TEtvTable.GotoBookmarkWOExcept(Bookmark: TBookmark);
begin
  if Bookmark <> nil then
  begin
    CheckBrowseMode;
    DoBeforeScroll;
    InternalGotoBookmark(Bookmark);
    Resync([{rmExact, }rmCenter]);
    DoAfterScroll;
  end;
end;

function TEtvTable.LocateWOExcept(const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
begin
  DoBeforeScroll;
  Result := LocateRecord(KeyFields, KeyValues, Options, True);
  if Result then
  begin
    Resync([{rmExact, }rmCenter]);
    DoAfterScroll;
  end;
end;


Initialization
  OkOnEditData:=false;

{$IFDEF EtvAutoInc} (* Val for Autoinc begin *)
  try
  AutoIncQuery:=TQuery.Create(Nil);
  MaxNumAutoIncQuery:=TIntegerField.Create(AutoIncQuery);
  MaxNumAutoIncQuery.FieldName:='MaxNumAutoIncQuery';
  MaxNumAutoIncQuery.DataSet:=AutoIncQuery;
  except
    AutoIncQuery.Free;
    AutoIncQuery:=Nil;
    ShowMessage('Error: AutoIncQuery not created');
  end;

finalization
  AutoIncQuery.Free;
  AutoIncQuery:=Nil;
{$ENDIF}(* Val for Autoinc end *)

end.
