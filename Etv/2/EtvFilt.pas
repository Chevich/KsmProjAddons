unit EtvFilt;

interface
uses Classes,controls,db,
     EtvDBFun,EtvMem;

{$I Etv.inc}

type

TDataSetItem=Class
public
  TableName:String;
  Total:String;
  All:boolean;
  OtherInfo:string;
  constructor Create;
end;

{TEtvFilter}
TFilterItem=Class
public
  Name:String;
  AutoTotal:boolean;
  OtherInfo:string;
  Conditions:TListObj;
  DataSets:TListObj;
  function DataSetItemByName(aTableName:string):TDataSetItem;
  constructor Create;
  destructor Destroy; override;
end;

TConditionItem=Class
public
  TableName:String;
  FieldName:string;
  LookFieldName:string;
  Operation:string;
  BothFields:boolean;
  Value:Variant;
  OtherInfo:string;
  constructor Create;
end;

TEtvFilter=class;

TFilterDataLink=Class(TDataLink)
  fFilter:TEtvFilter;
  procedure ActiveChanged; override;
end;

TFilterUsed=(fuNone,fuSet,fuExternalSet);
TFilterSetAs=(fsFilter,fsFilterQuery,fsQuery,fsQueryFilter);
TFilterEditValueEvent=procedure(aField:TField; aValue:TControl) of object;
TConstructConditionEvent=procedure(Var Condition:string; aField:TField;
                     aOperation:string; aValue:Variant) of object;
TDataSetFilterEvent=procedure(var Text:String; aDataSet:TDataSet) of object;
TTableNameKind=(tnNoQuotes,tnQuotes,tnQuotesCreator);
TLikeKind=(lkNormal,lkToUpper,lkAsAaBbCc);

TEtvFilter=class(TComponent)
protected
  fDataLink:TDataLink;
  fDataSet:TDataSet;
  fOldFilter:string;
  fOldFiltered:boolean;
  fOldOnFilterRecord: TFilterRecordEvent;
  fOneFilter:boolean;
  fUsed:TFilterUsed;
  fCurFilter:smallint;
  fSubDataSets:TDataSetCol;
  fSetProcess:boolean;
  fDestroyQExtracts:boolean;
  fOrigDataSet:TDataSet;
  fFilterSetAs:TFilterSetAs;
  fLikeExist:boolean;
  fWidthDataSetName,
  fWidthFieldName:integer;
  fTableNameKind:TTableNameKind;
  fQExtracts:TDataSet;
  fLikeKind:TLikeKind;
  fOnSet:TNotifyEvent;
  fOnUnset:TNotifyEvent;
  fOnCreateValue:TFilterEditValueEvent;
  fOnConstructCondition:TConstructConditionEvent;
  fOnDataSetLink:TDataSetFilterEvent;
  fOnCreateQExtracts:TNotifyEvent;
  fOnConstructFilter:TDataSetFilterEvent;
  fOnVisualizeFilters:TNotifyEvent;
  fOnSetToEditWindow:TNotifyEvent;
  fOnGetFromEditWindow:TNotifyEvent;
  function GetDataSource: TDataSource;
  procedure SetDataSource(Value: TDataSource);
  procedure SetQExtracts(Value: TDataSet);
  procedure SetOneFilter(aOneFilter:boolean);
  function GetDataSet:TDataSet;
  function GetFilterExist:boolean;
  procedure CheckDataSet; dynamic;
  procedure SetUsed(aUsed:TFilterUsed);
  procedure SetFilterSetAs(aFilterSetAs:TFilterSetAs);
  procedure SetCurFilter(aCurFilter:Smallint);
  procedure Notification(AComponent: TComponent;
                         Operation: TOperation); override;
  procedure SetFilter(aUsed:TFilterUsed);
  procedure StandardSetFilter(aUsed:TFilterUsed);
  procedure UnSetFilter;

  procedure CaptureDataSet;
  procedure RestoreFilter(KeepPosition:boolean);
  procedure RestoreDataSet(KeepPosition:boolean);

  procedure ReadSubDataSetData(Reader: TReader);
  procedure WriteSubDataSetData(Writer: TWriter);
  procedure DefineProperties(Filer: TFiler); override;

  procedure SetWidthDataSetName(aWidthDataSetName:integer);
  procedure SetWidthFieldName(aWidthFieldName:integer);
public
  Filters:TListObj;
  ExternalInfo:Tstrings;
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;

  function LoadFromStream(Stream: TStream):string;
  procedure SaveToStream(Stream: TStream);
  procedure LoadFromBase; dynamic;
  procedure SaveToBase; dynamic;

  procedure AddCondition;
  procedure DeleteCondition(aIndex:smallint);

  function AddFilter:boolean;
  procedure DeleteFilter;
  procedure ClearAllFilters;
  procedure PredFilter;
  procedure NextFilter;
  procedure ChangeCurrentFilter(Index:smallint);
  function FindFilter(aName:string):smallint;
  procedure FilterParams(aName:String; aAutoTotal:boolean; aTotals:TStrings; aAllOrAny:string);
  procedure ConditionsParams(Index:smallint;aTableName,aFieldName,aOperation:string;
                             aValue:Variant);
  procedure Reset;

  function Enhanced:boolean; (* with subtables*)
  procedure AddSubDataSet(aDataSet:TDataSet);
  function CheckSubDataSet(aDataSet:TDataSet):boolean;
  function IndexDataSet(aDataSet:TDataSet):smallint;
  function ChooseCondDataSet(IndexCond:smallint):TDataSet;
  function IndexCondDataSet(IndexCond:smallint):smallint;

  function TotalForDataSet(aDataSet:TDataSet):string;
  function AllForDataSet(aDataSet:TDataSet):boolean;
  function NeedQuery(aUsed:TFilterUsed):boolean;

  function GetExternalInfoByIndex(index:Integer):string;
  function GetExternalInfo(aDataSet:TDataSet):string;
  procedure SetExternalInfo(aDataSet:TDataSet; aValue:string);
  function ExternalInfoExist:boolean;

  function ConstructCondition(aDataSet:TDataSet; Index:Smallint; ForQuery:boolean):string;
  function ConstructFilter(aDataSet:TDataSet; ForQuery:boolean; aUsed:TFilterUsed):string;
  function ConstructSQLFilter(aUsed:TFilterUsed):string;
  function ConstructFullFilter(aUsed:TFilterUsed):string;
  function ConstructFilterInfo(aDataSet:TDataSet):string;
  function ConstructConditionInfo(aDataSet:TDataSet; Index:Smallint):string;

  procedure Execute;
  function Show:integer;

  property DataSet:TDataSet read GetDataSet;
  property CurFilter:smallint read fCurFilter write SetCurFilter;
  property FilterExist:boolean read GetFilterExist;
  property Used:TFilterUsed read fUsed write SetUsed;
published
  property DataSource:TDataSource read GetDataSource write SetDataSource;
  property OneFilter:boolean read fOneFilter write SetOneFilter;
  property FilterSetAs:TFilterSetAs read fFilterSetAs write SetFilterSetAs default fsFilterQuery;
  property LikeKind:TLikeKind read fLikeKind write fLikeKind default lkNormal;
  property SubDataSets:TDataSetCol read fSubDataSets stored false;
  Property TableNameKind:TTableNameKind read fTableNameKind write fTableNameKind default tnNoQuotes;
  property QExtracts:TDataSet read fQExtracts write SetQExtracts;
  property WidthDataSetName:integer read fWidthDataSetName write SetWidthDataSetName;
  property WidthFieldName:integer read fWidthFieldName write SetWidthFieldName;
  property OnSet:TNotifyEvent read fOnSet write fOnSet;
  property OnUnset:TNotifyEvent read fOnUnset write fOnUnset;
  property OnCreateValue:TFilterEditValueEvent read fOnCreateValue write fOnCreateValue;
  property OnConstructCondition:TConstructConditionEvent read fOnConstructCondition
             write fOnConstructCondition;
  property OnDataSetLink:TDataSetFilterEvent read fOnDataSetLink write fOnDataSetLink;
  property OnCreateQExtracts:TNotifyEvent read fOnCreateQExtracts write fOnCreateQExtracts;
  property OnConstructFilter:TDataSetFilterEvent read fOnConstructFilter write fOnConstructFilter;
  property OnVisualizeFilters:TNotifyEvent read fOnVisualizeFilters write fOnVisualizeFilters;
  property OnGetFromEditWindow:TNotifyEvent read fOnGetFromEditWindow write fOnGetFromEditWindow;
  property OnSetToEditWindow:TNotifyEvent read fOnSetToEditWindow write fOnSetToEditWindow;
end;

function CreateSQLText(aDataSet:TDataSet;
           aAliasForTable,aWhere,aOrderBy:string;
           UseFilter:boolean; aTableNameKind:TTableNameKind):string;
procedure CreateSQLforQuery(aDataSet:TDataSet; aQuery:TDataSet;
            aAliasForTable,aWhere,aOrderBy:string;
            FilterToSQL:boolean; aTableNameKind:TTableNameKind);
function CopyDataSetToQuery(aDataSet:TDataSet; aAliasForTable,aWhere,aOrderBy:string;
            FilterToSQL:boolean; aTableNameKind:TTableNameKind):TDataSet;
procedure SyncDataSets(aSourceDataSet,aTargetDataSet:TDataSet);
procedure CopyPropDataSetToQuery(aDataSet:TDataSet; aQuery:TDataSet);

IMPLEMENTATION

uses TypInfo,SysUtils,Windows,Forms,{dbTables,}
     {$IFDEF BDE_IS_USED}
     EtvTable,
     {$ENDIF}
     EtvPas,EtvConst,Filter,EtvForms,EtvOther;

function InDoubleQuotes(s:string; aTableNameKind:TTableNameKind):string;
var i:integer;
begin
  Result:='';
  if s<>'' then case aTableNameKind of
    tnNoQuotes: Result:=s;
    tnQuotes: Result:='"'+s+'"';
    tnQuotesCreator: begin
      i:=Pos('.',s);
      if i>0 then Result:='"'+Copy(s,1,i-1)+'"."'+Copy(s,i+1,MaxInt)+'"'
      else Result:='"'+s+'"';
    end;
  end;
end;

Constructor TDataSetItem.Create;
begin
  inherited;
  All:=false;
end;

{TConditionItem}
Constructor TConditionItem.Create;
begin
  inherited;
  TableName:='';
  FieldName:='';
  Operation:='=';
  Value:=null;
end;

Constructor TFilterItem.Create;
begin
  inherited Create;
  Conditions:=TListObj.Create;
  DataSets:=TListObj.Create;
  AutoTotal:=true;
end;

Destructor TFilterItem.Destroy;
begin
  if Assigned(Conditions) then Conditions.Free;
  if Assigned(DataSets) then DataSets.Free;
  inherited;
end;

function TFilterItem.DataSetItemByName(aTableName:string):TDataSetItem;
var i:integer;
begin
  for i:=0 to DataSets.Count-1 do
    if AnsiUpperCase(TDataSetItem(DataSets[i]).TableName)=
       AnsiUpperCase(aTableName) then begin
      Result:=TDataSetItem(DataSets[i]);
      Exit;
    end;
  Result:=TDataSetItem.Create;
  Result.TableName:=aTableName;
  DataSets.Add(Result);
end;

procedure TFilterDataLink.ActiveChanged;
begin
  if fFilter <> nil then fFilter.CheckDataSet;
end;

procedure TEtvFilter.CheckDataSet;
begin
  if (fDataSet<>DataSet) or
     (Assigned(DataSet) and (csDestroying in DataSet.ComponentState)) then begin
    RestoreDataSet(true);
    if not fSetProcess then begin
      fOrigDataSet:=nil;
      LoadFromBase;
    end;
  end;
end;

procedure TEtvFilter.RestoreFilter(KeepPosition:boolean);
var B:TBookMark;
begin
  if Assigned(fDataSet) and
     (not (csDestroying in fDataSet.ComponentState)) then begin
    if KeepPosition and (fDataSet<>QExtracts) then
      B:=fDataSet.GetBookMark else b:=nil;
    fDataSet.DisableControls;
    try
      fDataSet.OnFilterRecord:=fOldOnFilterRecord;
      if fOldFiltered<>fDataSet.Filtered then
        fDataSet.Filtered:=fOldFiltered;
      if fOldFilter<>fDataSet.Filter then
        fDataSet.Filter:=fOldFilter;
      if b<>nil then GotoBookMarkWOExcept(fDataSet,B);
    finally
      if b<>nil then fDataSet.FreeBookMark(B);
      fDataSet.EnableControls;
    end;
  end;
end;

procedure TEtvFilter.RestoreDataSet(KeepPosition:boolean);
begin
  RestoreFilter(KeepPosition and (not fSetProcess));
  fDataSet:=nil;
  if not fSetProcess then fUsed:=fuNone;
end;

procedure TEtvFilter.CaptureDataSet;
begin
  if Assigned(DataSet) and (Not (csDestroying in DataSet.ComponentState)) and
     (fDataSet=nil) then begin
    fOldFilter:=DataSet.Filter;
    fOldFiltered:=DataSet.Filtered;
    fOldOnFilterRecord:=DataSet.OnFilterRecord;
    fDataSet:=DataSet;
    fDataSet.FreeNotification(Self);
  end;
end;

procedure TEtvFilter.DefineProperties(Filer: TFiler);
  function WriteData: Boolean;
  begin
    {if Filer.Ancestor <> nil then
      Result := not FParams.IsEqual(TQuery(Filer.Ancestor).FParams) else}
      Result := FSubDataSets.Count > 0;
  end;
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('SubDataSetData',ReadSubDataSetData,WriteSubDataSetData,WriteData);
end;

procedure TEtvFilter.ReadSubDataSetData(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(FSubDataSets);
end;

procedure TEtvFilter.WriteSubDataSetData(Writer: TWriter);
begin
  Writer.WriteCollection(FSubDataSets);
end;

procedure TEtvFilter.SetWidthDataSetName(aWidthDataSetName:integer);
begin
  if (aWidthDataSetName>=50) and (aWidthDataSetName<=300) then fWidthDataSetName:=aWidthDataSetName
  else fWidthDataSetName:=175;
end;

procedure TEtvFilter.SetWidthFieldName(aWidthFieldName:integer);
begin
  if (aWidthFieldName>=50) and (aWidthFieldName<=300) then fWidthFieldName:=aWidthFieldName
  else fWidthFieldName:=150;
end;

Procedure TEtvFilter.SetOneFilter(aOneFilter:boolean);
begin
  if fOneFilter<>aOneFilter then begin
    fOneFilter:=aOneFilter;
    if fOneFilter then begin
      if Filters.Count=0 then AddFilter;
      ChangeCurrentFilter(Filters.Count-1);
      while Filters.Count>1 do DeleteFilter;
    end;
  end;
end;

function TEtvFilter.GetDataSet:TDataSet;
begin
  Result:=nil;
  if assigned(DataSource) then Result:=DataSource.DataSet;
end;

function TEtvFilter.GetFilterExist:boolean;
begin
  Result:=Filters.Count>0;
end;

procedure TEtvFilter.SetUsed(aUsed:TFilterUsed);
begin
  if Assigned(DataSet) then
    if aUsed=fuNone then UnSetFilter else SetFilter(aUsed);
end;

procedure TEtvFilter.SetFilterSetAs(aFilterSetAs:TFilterSetAs);
begin
  if aFilterSetAs<>fFilterSetAs then
    if fUsed=fuNone then fFilterSetAs:=aFilterSetAs
    else EtvApp.ShowMessage(SChangeFilterSetAsError);
end;

procedure TEtvFilter.SetCurFilter(aCurFilter:Smallint);
begin
  if (aCurFilter>=0) and (aCurFilter<=Filters.Count-1) then begin
    fCurFilter:=aCurFilter;
    Reset;
  end;
end;

procedure TEtvFilter.Notification(AComponent: TComponent; Operation: TOperation);
var i:integer;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then begin
    if (FDataLink <> nil) and (AComponent = DataSource) then DataSource := nil
    else begin
      if AComponent=fQExtracts then begin
        fQExtracts:=nil;
        fDestroyQExtracts:=false;
      end;
      if AComponent=fDataSet then RestoreDataSet(false);
      if AComponent=fOrigDataSet then DataSource.DataSet:=nil;
      for i:=0 to fSubdatasets.Count-1 do
        if FSubDataSets[i]=AComponent then begin
          FSubDataSets.Items[i].Free;
          Break;
        end;
    end;
  end;
end;

Constructor TEtvFilter.Create(AOwner: TComponent);
begin
  inherited;
  fDataSet:=nil;
  FDataLink :=TFilterDataLink.Create;
  TFilterDataLink(FDataLink).fFilter:=self;
  Filters:=TListObj.Create;
  fSubDataSets:=TDataSetCol.Create(TDataSetColItem);
  ExternalInfo:=TStringList.Create;
  fOldFilter:='';
  fOldFiltered:=false;
  fOneFilter:=false;
  fCurFilter:=-1;
  fUsed:=fuNone;
  fSetProcess:=false;
  fQExtracts:=nil;
  fDestroyQExtracts:=false;
  fOrigDataSet:=nil;
  fFilterSetAs:=fsFilterQuery;
  fLikeKind:=lkNormal;
  fTableNameKind:=tnNoQuotes;
  fWidthDataSetName:=175;
  fWidthFieldName:=150;
end;

Destructor TEtvFilter.Destroy;
begin
  RestoreDataSet(true);
  FDataLink.Free;
  FDataLink := nil;
  ClearAllFilters;
  Filters.Free;
  ExternalInfo.Free;
  fSubDataSets.Free;
  if fDestroyQExtracts and Assigned(fQExtracts) then fQExtracts.free;
  inherited;
end;

Function TEtvFilter.GetDataSource: TDataSource;
begin
  if FDataLink <> nil then Result := FDataLink.DataSource
  else Result := nil;
end;

Procedure TEtvFilter.SetDataSource(Value: TDataSource);
begin
  if FDataLink.DataSource<>Value then begin
    RestoreDataSet(true);
    FDataLink.DataSource := Value;
    if Value <> nil then Value.FreeNotification(Self);
  end;
end;

Procedure TEtvFilter.SetQExtracts(Value: TDataSet);
begin
  if fQExtracts<>Value then begin
    fQExtracts:=Value;
    if Assigned(fQExtracts) then fQExtracts.FreeNotification(Self);
  end;
end;

Procedure TEtvFilter.Execute;
var FormFilter:TFormFilter;
begin
  if Assigned(DataSet) then begin
    FormFilter:=TFormFilter.Create(Application);
    FormFilter.WidthDataSetName:=WidthDataSetName;
    FormFilter.WidthFieldName:=WidthFieldName;
    FormFilter.EFilters:=Self;
    EtvApp.DisableRefreshForm;
    case FormFilter.ShowModal of
      IdOk: begin
        SaveToBase;
        Used:=fuSet;{SetFilter;}
      end;
      IdNo: begin
        SaveToBase;
        Used:=fuNone;{UnSetFilter;}
      end;
      else LoadFromBase;
    end;
    EtvApp.EnableRefreshForm;
    FormFilter.Free;
  end else ClearAllFilters;
end;

Function TEtvFilter.Show:integer;
var FormFilter:TFormFilter;
begin
  Result:=IdCancel;
  if Assigned(DataSet) then begin
    FormFilter:=TFormFilter.Create(Application);
    FormFilter.WidthDataSetName:=WidthDataSetName;
    FormFilter.WidthFieldName:=WidthFieldName;
    FormFilter.BitBtnNone.visible:=false;
    FormFilter.BitBtnCancel.Left:=160;
    FormFilter.EFilters:=Self;
    EtvApp.DisableRefreshForm;
    Result:=FormFilter.ShowModal;
    if Result=IdOk then SaveToBase
    else LoadFromBase;
    EtvApp.EnableRefreshForm;
    FormFilter.Free;
  end else ClearAllFilters;
end;

procedure TEtvFilter.StandardSetFilter(aUsed:TFilterUsed);
var NewFilter:string;
    B:TBookMark;
begin
  if aUsed in [fuSet,fuExternalSet] then begin
    if Assigned(DataSet) then begin
      CaptureDataSet;
      NewFilter:=ConstructFilter(nil,false,aUsed);
      if NewFilter<>'' then begin
        if (Not fOldFiltered) then DataSet.OnFilterRecord:=nil
        else begin
          NewFilter:=AddFilterCondition(fOldFilter,NewFilter);
          DataSet.OnFilterRecord:=fOldOnFilterRecord;
        end;
        if (DataSet.Filter<>NewFilter) or (not DataSet.Filtered) then begin
          B:=DataSet.GetBookmark;
          DataSet.DisableControls;
          try
            if DataSet.Filter<>NewFilter then DataSet.Filter:=NewFilter;
            if not DataSet.Filtered then DataSet.Filtered:=true;
            GotoBookMarkWOExcept(DataSet,B);
          finally
            DataSet.FreeBookMark(B);
            DataSet.EnableControls;
          end;
        end;
        fUsed:=aUsed;
      end else Used:=fuNone;
    end;
  end;
end;

procedure TEtvFilter.SetFilter(aUsed:TFilterUsed);
var lFields,lWhere:string;
    v:variant;
    lOrigDataSet:TDataSet;
begin
  fSetProcess:=true;
  try
    if Assigned(fOnSet) then begin
      fOnSet(self);
      fUsed:=aUsed;
    end else begin
      if NeedQuery(aUsed) then begin
        lWhere:=ConstructSQLFilter(aUsed);
        if lWhere<>'' then begin
          try
            if DataSet<>fQExtracts then
              lOrigDataSet:=DataSet
            else begin
              lOrigDataSet:=fOrigDataSet;
              lFields:=UniqueFieldsForDataSet(fQExtracts);
              if lFields<>'' then v:=fQExtracts.FieldValues[lFields];
            end;
            if Assigned(fQExtracts) then
              CreateSQLforQuery(lOrigDataSet,fQExtracts,'EFilter',lWhere,
                SortingFromDataSet(lOrigDataSet),true,fTableNameKind)
            else begin
              fDestroyQExtracts:=true;
              if Assigned(fOnCreateQExtracts) then fOnCreateQExtracts(Self);
              if Not Assigned(fQExtracts) then 
                fQExtracts:=CopyDataSetToQuery(lOrigDataSet,'EFilter',lWhere,
                  SortingFromDataset(lOrigDataSet),true,fTableNameKind);
            end;
            QExtracts.DisableControls;
            try
              QExtracts.Open;
              if DataSet<>fQExtracts then SyncDataSets(DataSet,fQExtracts)
              else if lFields<>'' then
                LocateWOExcept(fQExtracts,lFields,v,[loCaseInsensitive]);
              if DataSet<>fQExtracts then begin
                fOrigDataSet:=DataSet;
                fOrigDataSet.FreeNotification(Self);
                DataSource.DataSet:=fQExtracts;
                CaptureDataSet;
              end;
            finally
              QExtracts.EnableControls;
            end;
            fUsed:=aUsed;
          except
            EtvApp.ShowMessage(SFilterInvalid);
            Used:=fuNone;
          end;
        end else Used:=fuNone;
      end else begin
        try
          if DataSource.DataSet=fQExtracts then begin
            fOrigDataSet.DisableControls;
            SortingToDataSet(fOrigDataSet,SortingFromDataSet(fQExtracts),false);
            SyncDataSets(fQExtracts,fOrigDataSet);
            DataSource.DataSet:=fOrigDataSet;
          end else DataSource.DataSet.DisableControls;
          fOrigDataSet:=nil;
          StandardSetFilter(aUsed);
        finally
          DataSource.DataSet.EnableControls;
        end;
      end;
    end;
  finally
    fSetProcess:=false;
  end;
end;

procedure TEtvFilter.UnSetFilter;
begin
  if fUsed<>fuNone then begin
    fSetProcess:=true;
    try
      if Assigned(fOnUnset) then fOnUnset(self)
      else begin
        if DataSet=fQExtracts then begin
          SortingToDataSet(fOrigDataSet,SortingFromDataSet(fQExtracts),false);
          SyncDataSets(fQExtracts,fOrigDataSet);
          DataSource.DataSet:=fOrigDataSet;
          fOrigDataSet:=nil;
        end else RestoreFilter(true);
      end;
    finally
      fSetProcess:=false;
    end;
    fUsed:=fuNone;
  end;
end;

function TEtvFilter.GetExternalInfo(aDataSet:TDataSet):string;
var i:integer;
begin
  i:=IndexDataSet(aDataSet);
  Result:=GetExternalInfoByIndex(i);
end;

function TEtvFilter.GetExternalInfoByIndex(index:Integer):string;
begin
  Result:='';
  if (index>=0) and (index<=ExternalInfo.Count-1) then Result:=ExternalInfo[index];
end;

procedure TEtvFilter.SetExternalInfo(aDataSet:TDataSet; aValue:string);
var i:integer;
begin
  i:=IndexDataSet(aDataSet);
  if i>=0 then begin
    while ExternalInfo.Count-1<i do ExternalInfo.Add('');
    ExternalInfo[i]:=aValue;
  end;
end;

function TEtvFilter.ExternalInfoExist:boolean;
var i:integer;
begin
  Result:=false;
  for i:=0 to ExternalInfo.Count-1 do
    if ExternalInfo[i]<>'' then begin
      Result:=true;
      Exit;
    end;
end;

function CreateFileName(aDataSet:TDataSet):string;
begin
  Result:=ObjectStrProp(aDataSet,'TableName');
  if Result='' then Result:=aDataSet.Name
  else While Pos('.',Result)>0 do Result[Pos('.',Result)]:='_';
  Result:='c:\'+Result+'.flt';
end;

procedure TEtvFilter.LoadFromBase;
var Stream:TFileStream;
    s:string;
begin
  if Assigned(CreateOtherOnFilterLoad) then CreateOtherOnFilterLoad(self)
  else begin
    if Assigned(DataSet) then begin
      s:=CreateFileName(DataSet);
      if FileExists(s) then begin
        Stream:=TFileStream.Create(s,fmOpenRead);
        try
          LoadFromStream(Stream);
        finally
          Stream.free;
        end;
      end;
    end;
  end;
end;

procedure TEtvFilter.SaveToBase;
var Stream:TFileStream;
begin
  if Assigned(CreateOtherOnFilterSave) then CreateOtherOnFilterSave(self)
  else begin
    Stream:=nil;
    try
      Stream:=TFileStream.Create(CreateFileName(DataSet),fmCreate);
      SaveToStream(Stream);
    finally
      Stream.Free;
    end;
  end;
end;

function TEtvFilter.ConstructCondition(aDataSet:TDataSet; Index:Smallint;
                                       ForQuery:boolean):string;
var Field:TField;
    lDataSet:TDataSet;
    lValue:string;
    i:integer;
begin
  Result:='';
  lDataSet:=aDataSet;
  if Not Assigned(lDataSet) then lDataSet:=DataSet;
  if (CurFilter>=0) and Assigned(lDataSet) and (lDataSet=ChooseCondDataSet(Index)) then
    with TConditionItem(TFilterItem(Filters[CurFilter]).Conditions[index]) do begin
      Result:={Result+'('+}FieldName;
      Field:=lDataSet.FindField(FieldName);
      if Assigned(Field) then begin
        if Value=null then begin
          if Operation='=' then
            if ForQuery then Result:=Result+' is '
            else Result:=Result+'='
          else
            if ForQuery then Result:=Result+' is not '
            else Result:=Result+'<>';
          Result:=Result+'Null'
        end
        else begin
          if Field is TDateField then
            lValue:=''''+DateToStr(Value)+''''
          else if Field is TFloatField then
            lValue:=FloatToStr(Value)
          else if Field is TIntegerField then
            lValue:=IntToStr(Value)
          else lValue:=''''+Value+'''';
          if Operation<>S_Like then Result:=Result+Operation+lValue
          else begin
            fLikeExist:=true;
            if lValue='' then
              Result:=Result+' Like ''%'''
            else begin
              if (pos('%',lValue)<=0) and (pos('_',lValue)<=0) then
                if lValue[1]<>'''' then lValue:='%'+lValue+'%'
                else lValue:='''%'+copy(lValue,2,length(lValue)-2)+'%''';
              case fLikeKind of
                lkNormal: Result:=Result+' Like '+lValue;
                lkToUpper: Result:='Upper('+Result+') Like Upper('+lValue+')';
                lkAsAaBbCc: begin
                  Result:=Result+' Like ';
                  for i:=1 to length(lValue) do
                    if AnsiUpperCase(lValue[i])<>AnsiLowerCase(lValue[i]) then
                      Result:=Result+'['+AnsiUpperCase(lValue[i])+
                        AnsiLowerCase(lValue[i])+']'
                    else Result:=Result+lValue[i];
                end;
              end;
            end;
          end;
        end;
        Result:='('+Result+')';
        if Assigned(fOnConstructCondition) then begin
          fOnConstructCondition(Result,Field,Operation,Value);
          if (Result<>'') and
             ((Result[1]<>'(') or (Result[Length(Result)]<>')')) then Result:='('+Result+')';
        end;
      end else Result:='';
    end;
end;

function ChangeWord(s,SourceWord,TargetWord:string; ExcludeStr:boolean):string;
var i,j,k,l:smallint;
    Exist:boolean;
  procedure SpaceWord;
  begin
    i:=j+length(SourceWord);
    j:=0;
  end;
begin
  i:=1;
  Result:=s;
  repeat
    j:=Pos(AnsiUpperCase(SourceWord),AnsiUpperCase(Copy(Result,i,length(Result))));
    if j>0 then begin
      Exist:=true;
      j:=j+i-1;
      if (j=1) or (j=length(Result)-Length(SourceWord)+1) or
         (Not (Result[j+Length(SourceWord)] in [S_Number[1],'#',' ','(',')'])) then SpaceWord;
      if (j>0) and (Not (Result[j-1] in [' ','(',')'])) then begin
        l:=j-1;
        while (l>0) and (Result[l] in ['0'..'9']) do Dec(l);
        if (l=0) or (l=j-1) or (Not (Result[l] in ['#',S_Number[1]])) then SpaceWord;
      end;
      if ExcludeStr then begin
        k:=0;
        for l:=1 to (j-1) do if Result[l]='''' then inc(k);
        if k mod 2<>0 then SpaceWord;
      end;
      if j>0 then begin
        Result:=copy(Result,1,j-1)+
          TargetWord+copy(Result,j+Length(SourceWord),Length(Result));
        i:=j+length(TargetWord);
      end;
    end else Exist:=false;
  until (Not Exist);
end;

function TEtvFilter.ConstructFilter(aDataSet:TDataSet; ForQuery:boolean; aUsed:TFilterUsed):string;
var i,NCond:smallint;
    Elem,Cond,lTotal:string;
    c:char;
    lDataSet:TDataSet;
begin
  Result:='';
  lDataSet:=aDataSet;
  if not Assigned(lDataSet) then lDataSet:=DataSet;
  if (CurFilter>=0) and Assigned(lDataSet) and (aUsed=fuSet) then
   with TFilterItem(Filters[CurFilter]) do begin
    NCond:=0;

    lTotal:=TotalForDataSet(lDataSet);

    if AutoTotal or (lTotal='') then begin
      for i:=0 to Conditions.Count-1 do begin
        Cond:=ConstructCondition(lDataSet,i,ForQuery);
        if Cond<>'' then begin
          if NCond>0 then Result:=Result+' and ';
          Result:=Result+Cond;
          inc(NCond);
        end;
      end;
    end else begin (* not autototal *)
      lTotal:=ChangeWord(lTotal,S_Or,'or',true);
      lTotal:=ChangeWord(lTotal,S_And,'and',true);
      lTotal:=ChangeWord(lTotal,S_Not,'not',true);
      i:=1;
      while i<=length(lTotal) do begin
        c:=lTotal[i];
        if (c='#') or (c=S_Number) then begin
          Elem:='';
          inc(i);
          while (i<=length(lTotal)) and (lTotal[i] in ['0'..'9']) do begin
            Elem:=Elem+lTotal[i];
            inc(i);
          end;
          NCond:=StrToInt(Elem);
          if (NCond>0) and (NCond<=Conditions.Count) then
            Result:=Result+ConstructCondition(lDataSet,NCond-1,ForQuery);
        end else begin
          Result:=Result+c;
          Inc(i);
        end;
      end;
    end;
  end;
  Elem:=GetExternalInfo(lDataSet);
  if Elem<>'' then
    if Result='' then Result:=Elem else Result:='('+Elem+') and ('+Result+')';
  if Assigned(fOnConstructFilter) then fOnConstructFilter(Result,lDataSet);
end;

function TEtvFilter.ConstructSQLFilter(aUsed:TFilterUsed):string;
var i,j,k,Pos,Pos2:integer;
    inText:boolean;
    s,sAllGroup,lLink,lMasterFields,lIndexFieldNames:string;
begin
  Result:='';
  s:=ConstructFilter(nil,true,aUsed);
  if s<>'' then Result:='('+s+')';
  for i:=0 to SubDataSets.Count-1 do begin
    sAllGroup:=ConstructFilter(SubDataSets[i],true,aUsed);
    While sAllGroup<>'' do begin
      j:=0;
      inText:=false;
      for k:=1 to length(sAllGroup) do
        if sAllGroup[k]='''' then inText:=not inText
        else if (not inText) and (sAllGroup[k]='|') then begin
          j:=k;
          break;
        end;
      if j>0 then begin
        s:=copy(sAllGroup,1,j-1);
        sAllGroup:=Trim(copy(sAllGroup,j+1,maxInt));
      end else begin
        s:=sAllGroup;
        sAllGroup:='';
      end;
      if s<>'' then begin
        lLink:='';
        lMasterFields:=ObjectStrProp(SubDataSets[i],'MasterFields');
        lIndexFieldNames:=ObjectStrProp(SubDataSets[i],'IndexFieldNames');
        if (lMasterFields<>'') and  (lIndexFieldNames<>'') then begin
          Pos:=1;
          Pos2:=1;
          while (Pos<=Length(lMasterFields)) do begin
            if lLink<>'' then lLink:=lLink+' and ';
            if (Pos2<=Length(lIndexFieldNames)) then
              lLink:=lLink+'(EFilter.'+ExtractFieldName(lMasterFields, Pos)+
                '='+ExtractFieldName(lIndexFieldNames,Pos2)+')'
            else begin
              lLink:='';
              Break;
            end;
          end;
        end;
        if Assigned(fOnDataSetLink) then fOnDataSetLink(lLink,SubDataSets[i]);
        if lLink<>'' then begin
          if not AllForDataSet(SubDataSets[i]) then
            s:='Exists(select * from '+
              InDoubleQuotes(ObjectStrProp(SubDataSets[i],'TableName'),fTableNameKind)+
              ' where '+lLink+' and ('+s+'))'
          else s:='Exists(select * from '+       {Check for exists any records}
              InDoubleQuotes(ObjectStrProp(SubDataSets[i],'TableName'),fTableNameKind)+
              ' where '+lLink+') and'+
              '(Not Exists(select * from '+
              InDoubleQuotes(ObjectStrProp(SubDataSets[i],'TableName'),fTableNameKind)+
              ' where '+lLink+' and (not ('+s+'))))';
          if Result<>'' then Result:=Result+' and ';
          Result:=Result+s;
        end;
      end;
    end;
  end;
end;

function TEtvFilter.ConstructFullFilter(aUsed:TFilterUsed):string;
begin
  if NeedQuery(aUsed) then Result:=ConstructSQLFilter(aUsed)
  else Result:=ConstructFilter(nil,false,aUsed);
end;

function TEtvFilter.ConstructConditionInfo(aDataSet:TDataSet; Index:Smallint):string;
var Field:TField;
    lDataSet:TDataSet;
begin
  Result:='';
  lDataSet:=aDataSet;
  if not Assigned(lDataSet) then lDataSet:=DataSet;
  if (CurFilter>=0) and Assigned(lDataSet) and (lDataSet=ChooseCondDataSet(Index)) then
    with TConditionItem(TFilterItem(Filters[CurFilter]).Conditions[index]) do begin
      Field:=lDataSet.FindField(FieldName);
      if Assigned(Field) then begin
        Result:=Result+'('+Field.DisplayName;
        Result:=Result+Operation;
        if Value=null then Result:=Result+S_Null
        else if Field is TDateField then
          Result:=Result+''''+DateToStr(Value)+''''
        else if Field is TFloatField then
          Result:=Result+FloatToStr(Value)
        else if Field is TIntegerField then
          Result:=Result+IntToStr(Value)
        else Result:=Result+''''+Value+'''';
        Result:=Result+')';
      end else Result:='';
    end;
end;

function TEtvFilter.ConstructFilterInfo(aDataSet:TDataSet):string;
var i,NCond:smallint;
    Elem,Cond,lTotal:string;
    c:char;
    lDataSet:TDataSet;
begin
  Result:='';
  lDataSet:=aDataSet;
  if not Assigned(lDataSet) then lDataSet:=DataSet;
  Result:='';
  if (CurFilter>=0) and Assigned(lDataSet) then
   with TFilterItem(Filters[CurFilter]) do begin
    NCond:=0;
    lTotal:=TotalForDataSet(lDataSet);
    if AutoTotal or (lTotal='') then begin
      for i:=0 to Conditions.Count-1 do begin
        Cond:=ConstructConditionInfo(lDataSet,i);
        if Cond<>'' then begin
          if NCond>0 then Result:=Result+' '+S_And+' ';
          Result:=Result+Cond;
          inc(NCond);
        end;
      end;
    end else begin (* not autototal *)
      lTotal:=ChangeWord(lTotal,'OR',S_Or,true);
      lTotal:=ChangeWord(lTotal,'AND',S_And,true);
      lTotal:=ChangeWord(lTotal,'NOT',S_Not,true);
      i:=1;
      while i<=length(lTotal) do begin
        c:=lTotal[i];
        if (c='#') or (c=S_Number) then begin
          Elem:='';
          inc(i);
          while (i<=length(lTotal)) and (lTotal[i] in ['0'..'9']) do begin
            Elem:=Elem+lTotal[i];
            inc(i);
          end;
          NCond:=StrToInt(Elem);
          if (NCond>0) and (NCond<=Conditions.Count) then
            Result:=Result+ConstructConditionInfo(lDataSet,NCond-1);
        end else begin
          Result:=Result+c;
          Inc(i);
        end;
      end;
    end;
  end;
end;

procedure TEtvFilter.AddCondition;
var CondItem:TConditionItem;
begin
  if CurFilter>=0 then begin
    CondItem:=TConditionItem.Create;
    TFilterItem(Filters[CurFilter]).Conditions.Add(CondItem);
  end;
end;

procedure TEtvFilter.DeleteCondition(aIndex:smallint);
begin
  if CurFilter>=0 then
    TFilterItem(Filters[CurFilter]).Conditions.DeleteFull(aIndex);
end;

function TEtvFilter.AddFilter:boolean;
var FilterItem:TFilterItem;
    i:smallint;
begin
  Result:=false;
  if fOneFilter and (Filters.Count=1) then Exit;
  FilterItem:=TFilterItem.Create;
  i:=Filters.Count;
  repeat
    FilterItem.Name:=SFilterNumber+IntToStr(i);
    Inc(i);
  until FindFilter(FilterItem.Name)<0;
  Filters.Add(FilterItem);
  fCurFilter:=Filters.Count-1;
  Result:=true;
end;

procedure TEtvFilter.DeleteFilter;
begin
  if Filters.Count>0 then Filters.DeleteFull(fCurFilter);
  if fCurFilter>Filters.Count-1 then fCurFilter:=Filters.Count-1;
end;

procedure TEtvFilter.ClearAllFilters;
begin
  while fCurFilter>=0 do DeleteFilter;
end;

procedure TEtvFilter.PredFilter;
begin
  if fCurFilter>0 then Dec(fCurFilter) else fCurFilter:=Filters.Count-1;
end;

procedure TEtvFilter.NextFilter;
begin
  if Filters.Count>0 then
    if fCurFilter<Filters.Count-1 then Inc(fCurFilter)
    else fCurFilter:=0;
end;

procedure TEtvFilter.ChangeCurrentFilter(Index:Smallint);
begin
  if Index<=Filters.Count-1 then fCurFilter:=Index
  else fCurFilter:=Filters.Count-1;
  if (Filters.Count>0) and (fCurFilter<0) then fCurFilter:=0;
end;

Function TEtvFilter.FindFilter(aName:string):smallint;
var i:smallint;
begin
  Result:=-1;
  for i:=0 to Filters.Count-1 do
    if UpperCase(aName)=UpperCase(TFilterItem(Filters[i]).Name) then begin
      Result:=i;
      Exit;
    end;
end;

procedure TEtvFilter.FilterParams(aName:String; aAutoTotal:boolean; aTotals:TStrings; aAllOrAny:string);
var i:integer;
begin
  if fCurFilter>=0 then With TFilterItem(Filters[fCurFilter]) do begin
    Name:=aName;
    AutoTotal:=aAutoTotal;
    DataSetItemByName('').Total:=aTotals[0];
    for i:=0 to SubDataSets.Count-1 do
      with DataSetItemByName(ObjectStrProp(SubDataSets[i],'TableName')) do begin
        Total:=aTotals[i+1];
        if (aAllOrAny[i+1]='0') then All:=true else All:=false;
      end;
  end;
end;

procedure TEtvFilter.ConditionsParams(Index:smallint;aTableName,aFieldName,aOperation:string; aValue:Variant);
begin
  if fCurFilter>=0 then
    With TConditionItem(TFilterItem(Filters[fCurFilter]).Conditions[Index]) do begin
      TableName:=aTableName;
      FieldName:=aFieldName;
      Operation:=aOperation;
      Value:=aValue;
    end;
end;

procedure TEtvFilter.Reset;
begin
  Used:=Used;
end;

function TEtvFilter.Enhanced:boolean; (* with subtables*)
begin
  Result:=SubDataSets.count>0;
end;

procedure TEtvFilter.AddSubDataSet(aDataSet:TDataSet);
begin
  if CheckSubDataSet(aDataSet) and
     fSubDataSets.AddItem(aDataSet, true) then
    aDataSet.FreeNotification(Self);
end;

function TEtvFilter.CheckSubDataSet(aDataSet:TDataSet):boolean;
var PropInfo: PPropInfo;
begin
  Result:=false;
  PropInfo := GetPropInfo(aDataSet.ClassInfo, 'TableName');
  if PropInfo <> nil then
    if GetStrProp(aDataSet,PropInfo)<>'' then Result:=true
    else EtvApp.ShowMessage('Component '+Self.Name+
                          #10+aDataSet.Name+' is not added to SubDataSets'+
                          #10+'property "TableName" is empty')
  else EtvApp.ShowMessage('Component '+Self.Name+
                          #10+aDataSet.Name+' is not added to SubDataSets'+
                          #10+'it have not the property "TableName"');
end;

function TEtvFilter.IndexDataSet(aDataSet:TDataSet):smallint;
var i:integer;
begin
  if (aDataSet=nil) or (aDataSet=DataSet) or (aDataSet=fOrigDataSet) then begin
    Result:=0;
    Exit;
  end;
  Result:=-1;
  if Not Enhanced then Exit;
    for i:=0 to SubDataSets.Count-1 do begin
      if aDataSet=SubDataSets[i] then begin
        Result:=i+1;
        break;
      end;
    end;
end;

function TEtvFilter.ChooseCondDataSet(IndexCond:smallint):TDataSet;
var i:smallint;
begin
  Result:=nil;
  if Not Enhanced then Result:=DataSet
  else if fCurFilter>=0 then
    With TConditionItem(TFilterItem(Filters[fCurFilter]).Conditions[IndexCond]) do begin
      if TableName='' then Result:=DataSet
      else for i:=0 to SubDataSets.Count-1 do begin
        if AnsiUpperCase(TableName)=
           AnsiUpperCase(ObjectStrProp(SubDataSets[i],'TableName')) then begin
          Result:=SubDataSets[i];
          break;
        end;
      end;
    end;
end;

function TEtvFilter.IndexCondDataSet(IndexCond:smallint):smallint;
var i:smallint;
begin
  Result:=0;
  if Not Enhanced then Exit;
  if fCurFilter>=0 then
    With TConditionItem(TFilterItem(Filters[fCurFilter]).Conditions[IndexCond]) do begin
      if TableName='' then Exit;
      for i:=0 to SubDataSets.Count-1 do begin
        if AnsiUpperCase(TableName)=
           AnsiUpperCase(ObjectStrProp(SubDataSets[i],'TableName')) then begin
          Result:=i+1;
          break;
        end;
      end;
    end;
end;

function TEtvFilter.TotalForDataSet(aDataSet:TDataSet):string;
var i:integer;
begin
  Result:='';
  if CurFilter>=0 then with TFilterItem(Filters[CurFilter]) do begin
    i:=IndexDataSet(aDataSet);
    if i>=0 then Result:=TDataSetItem(DataSets[i]).Total;
  end;
end;

function TEtvFilter.AllForDataSet(aDataSet:TDataSet):boolean;
var i:integer;
begin
  Result:=false;
  if CurFilter>=0 then with TFilterItem(Filters[CurFilter]) do begin
    i:=IndexDataSet(aDataSet);
    if i>=0 then Result:=TDataSetItem(DataSets[i]).All;
  end;
end;

function TEtvFilter.NeedQuery(aUsed:TFilterUsed):boolean;
var i:integer;
begin
  Result:=false;
  if (ObjectStrProp(Dataset,'DataBaseName')='') or
     (ObjectStrProp(Dataset,'TableName')='') then Exit;
  case fFilterSetAs of
    fsFilterQuery,fsQueryFilter: if CurFilter>=0 then begin
      if Enhanced then
        for i:=0 to SubDataSets.Count-1 do
          if ConstructFilter(SubDataSets[i],true,aUsed)<>'' then begin
            Result:=true;
            Exit;
          end;
      if (GetExternalInfoByIndex(0)<>'') and (fFilterSetAs=fsQueryFilter) then begin
        Result:=true;
        Exit;
      end;
      if aUsed=fuSet then with TFilterItem(Filters[CurFilter]) do begin
        if (Not AutoTotal) and (TotalForDataSet(nil)<>'') and
           (fFilterSetAs=fsQueryFilter) then begin
          Result:=true;
          Exit;
        end;
        fLikeExist:=false;
        ConstructFilter(nil,true,fuSet);
        if fLikeExist then begin
          Result:=true;
          Exit;
        end;
      end;
    end;
    fsQuery: Result:=true;
  end;
end;

{ ������ }
function TEtvFilter.LoadFromStream(Stream: TStream):string;
var lFiltersCount,lConditionsCount,lDataSetsCount,i,j:integer;
    lFilterItem:TFilterItem;
    lConditionItem:TConditionItem;

function LoadStr:string;
var Size:integer;
begin
  Stream.Read(Size,sizeof(Integer));
  SetString(Result, nil, Size);
  Stream.Read(Pointer(Result)^, Size);
end;

function LoadVariant:variant;
var Size:integer;
    IsPointer:boolean;
begin
  Stream.Read(IsPointer,Sizeof(IsPointer));
  if IsPointer then Result:=LoadStr
  else begin
    Stream.Read(Size,sizeof(Integer));
    Stream.Read(TVarData(Result), Size);
  end;
end;
begin
  Result:='';
  ClearAllFilters;
  with Stream do begin
    Result:=LoadStr;
    read(fCurFilter,sizeof(fCurFilter));
    read(lFiltersCount,sizeof(Integer));
    for i:=0 to lFiltersCount-1 do begin
      lFilterItem:=TFilterItem.Create;
      with lFilterItem do begin
        Name:=LoadStr;
        read(AutoTotal,Sizeof(boolean));
        OtherInfo:=LoadStr;
        (* read DataSets *)
        DataSets.Clear;
        read(lDataSetsCount,sizeof(Integer));
        for j:=0 to lDataSetsCount-1 do begin
          DataSets.Add(TDataSetItem.Create);
          with TDataSetItem(DataSets[j]) do begin
           TableName:=LoadStr;
           Total:=LoadStr;
           Read(All,Sizeof(boolean));
           OtherInfo:=LoadStr;
          end;
        end;
       (* read conditions *)
        read(lConditionsCount,sizeof(Integer));
        for j:=0 to lConditionsCount-1 do begin
          lConditionItem:=TConditionItem.Create;
          with lConditionItem do begin
            TableName:=LoadStr;
            FieldName:=LoadStr;
            LookFieldName:=LoadStr;
            Operation:=LoadStr;
            Read(BothFields,Sizeof(boolean));
            Value:=LoadVariant;
            OtherInfo:=LoadStr;
          end;
          Conditions.Add(lConditionItem);
        end;

      end;
      Filters.Add(lFilterItem);
    end;
  end;
end;

{ ������ }
procedure TEtvFilter.SaveToStream(Stream: TStream);
var i,j:smallint;
procedure WriteStr(s:string);
var L:integer;
begin
  L:=Length(s);
  Stream.write(L,sizeof(Integer));
  Stream.write(Pointer(S)^,L);
end;

procedure WriteVariant(v:Variant);
var L:integer;
    IsPointer:boolean;
begin
  if TVarData(v).vType=varString then isPointer:=true
  else IsPointer:=false;
  Stream.write(IsPointer,sizeof(boolean));
  if IsPointer then WriteStr(VarToStr(V))
  else begin
    L:=SizeOf(TVarData(v));
    Stream.write(L,sizeof(Integer));
    Stream.write(TVarData(V),L);
  end;
end;

begin
  with Stream do begin
    writeStr(CreateFileName(DataSet));
    write(fCurFilter,sizeof(fCurFilter));
    write(Filters.Count,sizeof(Integer));
    for i:=0 to Filters.Count-1 do with TFilterItem(Filters[i]) do begin
      WriteStr(Name);
      write(AutoTotal,Sizeof(boolean));
      WriteStr(OtherInfo);
      (* write DataSets *)
      write(DataSets.Count,sizeof(Integer));
      for j:=0 to DataSets.Count-1 do with TDataSetItem(DataSets[j]) do begin
        writeStr(TableName);
        writeStr(Total);
        write(All,Sizeof(boolean));
        WriteStr(OtherInfo);
      end;
      (* write conditions *)
      write(Conditions.Count,sizeof(Integer));
      for j:=0 to Conditions.Count-1 do with TConditionItem(Conditions[j]) do begin
        WriteStr(TableName);
        WriteStr(FieldName);
        WriteStr(LookFieldName);
        WriteStr(Operation);
        Write(BothFields,Sizeof(boolean));
        WriteVariant(Value);
        WriteStr(OtherInfo);
      end;
    end;
  end;
end;

{ ����� }
{
function TEtvFilter.LoadFromStream(Stream: TStream):string;
const MaxDataSets=255;
      MaxFilters=65535;
      MaxConditions=255;
var lFiltersCount,lConditionsCount,lDataSetsCount,i,j:integer;
    lFilterItem:TFilterItem;
    lConditionItem:TConditionItem;

function LoadStr:string;
var Size:Word;
begin
  Stream.Read(Size,sizeof(Word));
  SetString(Result, nil, Size);
  Stream.Read(Pointer(Result)^, Size);
end;

function LoadVariant:variant;
var Size:Word;
    IsPointer:boolean;
begin
  Stream.Read(IsPointer,Sizeof(IsPointer));
  if IsPointer then Result:=LoadStr
  else begin
    Stream.Read(Size,sizeof(word));
    Stream.Read(TVarData(Result), Size);
  end;
end;
begin
  Result:='';
  ClearAllFilters;
  with Stream do begin
    Result:=LoadStr;
    read(fCurFilter,sizeof(fCurFilter));
    read(lFiltersCount,sizeof(Integer));
    if (lFiltersCount<0) or (lFiltersCount>MaxFilters) then
      raise EInOutError.Create(SFilterLoadError);
    for i:=0 to lFiltersCount-1 do begin
      lFilterItem:=TFilterItem.Create;
      with lFilterItem do begin
        Name:=LoadStr;
        read(AutoTotal,Sizeof(boolean));
        OtherInfo:=LoadStr;
        (* read DataSets *)
        DataSets.Clear;
        read(lDataSetsCount,sizeof(Integer));
        if (lDataSetsCount<0) or (lDataSetsCount>MaxDataSets) then
          raise EInOutError.Create(SFilterLoadError);
        for j:=0 to lDataSetsCount-1 do begin
          DataSets.Add(TDataSetItem.Create);
          with TDataSetItem(DataSets[j]) do begin
           TableName:=LoadStr;
           Total:=LoadStr;
           Read(All,Sizeof(boolean));
           OtherInfo:=LoadStr;
          end;
        end;
       (* read conditions *)
        read(lConditionsCount,sizeof(Integer));
        if (lConditionsCount<0) or (lConditionsCount>MaxConditions) then
          raise EInOutError.Create(SFilterLoadError);
        for j:=0 to lConditionsCount-1 do begin
          lConditionItem:=TConditionItem.Create;
          with lConditionItem do begin
            TableName:=LoadStr;
            FieldName:=LoadStr;
            LookFieldName:=LoadStr;
            Operation:=LoadStr;
            Read(BothFields,Sizeof(boolean));
            Value:=LoadVariant;
            OtherInfo:=LoadStr;
          end;
          Conditions.Add(lConditionItem);
        end;
      end;
      Filters.Add(lFilterItem);
    end;
  end;
end;
}
{ ����� }
{
procedure TEtvFilter.SaveToStream(Stream: TStream);
var i,j:smallint;
procedure WriteStr(s:string);
var L:word;
begin
  L:=Length(s);
  Stream.write(L,sizeof(word));
  Stream.write(Pointer(S)^,L);
end;

procedure WriteVariant(v:Variant);
var L:word;
    IsPointer:boolean;
begin
  if TVarData(v).vType=varString then isPointer:=true
  else IsPointer:=false;
  Stream.write(IsPointer,sizeof(boolean));
  if IsPointer then WriteStr(VarToStr(V))
  else begin
    L:=SizeOf(TVarData(v));
    Stream.write(L,sizeof(Word));
    Stream.write(TVarData(V),L);
  end;
end;

begin
  with Stream do begin
    writeStr(CreateFileName(DataSet));
    write(fCurFilter,sizeof(fCurFilter));
    write(Filters.Count,sizeof(Integer));
    for i:=0 to Filters.Count-1 do with TFilterItem(Filters[i]) do begin
      WriteStr(Name);
      write(AutoTotal,Sizeof(boolean));
      WriteStr(OtherInfo);
      (* write DataSets *)
      write(DataSets.Count,sizeof(Integer));
      for j:=0 to DataSets.Count-1 do with TDataSetItem(DataSets[j]) do begin
        writeStr(TableName);
        writeStr(Total);
        write(All,Sizeof(boolean));
        WriteStr(OtherInfo);
      end;
      (* write conditions *)
      write(Conditions.Count,sizeof(Integer));
      for j:=0 to Conditions.Count-1 do with TConditionItem(Conditions[j]) do begin
        WriteStr(TableName);
        WriteStr(FieldName);
        WriteStr(LookFieldName);
        WriteStr(Operation);
        Write(BothFields,Sizeof(boolean));
        WriteVariant(Value);
        WriteStr(OtherInfo);
      end;
    end;
  end;
end;
}
procedure CopyPropDataSetToQuery(aDataSet:TDataSet; aQuery:TDataSet);
var i:integer;
    PropInfo,PropInfo2:PPropInfo;
    s:string;
begin
  s:=ObjectStrProp(aDataSet,'DatabaseName');
  if s<>'' then SetObjectStrProp(aQuery,'DatabaseName',s);

  SetObjectStrProp(aQuery,'TableName',ObjectStrProp(aDataSet,'TableName'));
  SetObjectStrProp(aQuery,'UniqueFields',ObjectStrProp(aDataSet,'UniqueFields'));
  SetObjectStrProp(aQuery,'Caption',ObjectStrProp(aDataSet,'Caption'));
  aQuery.Tag:=aDataSet.Tag;
  PropInfo:=GetPropInfo(aDataSet.ClassInfo, 'SortingList');
  if PropInfo<>nil then begin
    PropInfo2:=GetPropInfo(aQuery.ClassInfo, 'SortingList');
    if PropInfo2<>nil then
      TStrings(GetOrdProp(aQuery, PropInfo2)).Assign(
        TStrings(GetOrdProp(aDataSet, PropInfo)));
  end;
  CopyObjectMethodProps(aDataSet,aQuery);

  for i:=0 to aDataSet.FieldCount-1 do
    TField(CloneComponent(TField(aDataSet.Fields[i]))).DataSet:=aQuery;
end;

procedure SyncDataSets(aSourceDataSet,aTargetDataSet:TDataSet);
var lFields:string;
begin
  lFields:=UniqueFieldsForDataSet(aSourceDataSet);
  if lFields<>'' then
    LocateWOExcept(aTargetDataSet,lFields,
      aSourceDataSet.fieldValues[lFields],[loCaseInsensitive])
end;

function CreateSQLText(aDataSet:TDataSet;
           aAliasForTable,aWhere,aOrderBy:string;
           UseFilter:boolean; aTableNameKind:TTableNameKind):string;
var s:string;
begin
  Result:='Select '+AllFieldNames(aDataSet,true,true)+' from '+
    InDoubleQuotes(ObjectStrProp(aDataSet,'TableName'),aTableNameKind)+' '+aAliasForTable;
  s:=aWhere;
  if (aDataSet.Filter<>'') and UseFilter then
    s:=AddFilterCondition(s,aDataSet.Filter);
  if s<>'' then Result:=Result+' Where '+s;
  if aOrderBy<>'' then begin
    s:=aOrderBy;
    while Pos(';',s)>0 do s[Pos(';',s)]:=',';
    Result:=Result+' Order by '+s;
  end;
end;

procedure CreateSQLforQuery(aDataSet:TDataSet; aQuery:TDataSet;
            aAliasForTable,aWhere,aOrderBy:string;
            FilterToSQL:boolean; aTableNameKind:TTableNameKind);
var lSQL:TStrings;
    PropInfo:PPropInfo;
begin
  PropInfo:=GetPropInfo(aQuery.ClassInfo, 'SQL');
  if PropInfo<>nil then begin
    lSQL:=TStrings(GetOrdProp(aQuery, PropInfo));
    lSQL.Clear;
    lSQL.Add(CreateSQLText(aDataSet,aAliasForTable,aWhere,aOrderBy,
          FilterToSQL, aTableNameKind));
    if (aDataSet.Filter<>'') and (not FilterToSQL) then begin
      aQuery.Filter:=aDataSet.Filter;
      aQuery.Filtered:=aDataSet.Filtered;
    end;
  end else EtvApp.ShowMessage('Property "SQL" is absent in dataset '+aQuery.Name);
end;

function CopyDataSetToQuery(aDataSet:TDataSet; aAliasForTable,aWhere,aOrderBy:string;
            FilterToSQL:boolean; aTableNameKind:TTableNameKind):TDataSet;
begin
  if Assigned(OtherQueryClass) then
    Result:=OtherQueryClass.Create(aDataSet.Owner)
  else begin
    {$IFDEF BDE_IS_USED}
    Result:=TEtvQuery.Create(aDataSet.Owner)
    {$ENDIF}
  end;

  CopyPropDataSetToQuery(aDataSet,Result);
  CreateSQLforQuery(aDataSet,Result,aAliasForTable,aWhere,aOrderBy,
    FilterToSQL,aTableNameKind);
end;

end.

