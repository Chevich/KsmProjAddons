unit EtvDB; (* Val Igo *)

interface
{$I Etv.inc}

Uses Classes,Graphics,DB;

type
(* Variables and types are used for cooperation between DB forms *)
  TTypeShow=(viNone,viShow,viShowModal);
  TFieldReturn=class(TComponent)
    public
    Field:string;
    Value:Variant;
  end;
  TOnEditDataEvent=procedure(Sender: TObject;TypeShow:TTypeShow;FieldReturn:TFieldReturn) of object;
  TItemDataSet=class (* used by Grid and Lookup in DoEditData *)
    DataSet:TDataSet;
    Tag:longint;
  end;
var OkOnEditData:boolean;


type
  TOnFieldFilterEvent=function(Sender: TObject):string of object;
  TOnFieldSetEditEvent=procedure(Sender: TField; Text:string) of object;

{Structures for multilevel lookup}
TEtvLookupLevelItem=Class(TCollectionItem)
protected
  fDataSet:TDataSet;
  fFilterField,
  fKeyField,
  fResultFields:string;
  procedure SetDataSet(aDataSet:TDataSet);
public
  procedure Assign(Source: TPersistent); override;
published
  property DataSet:TDataSet read fDataSet write SetDataSet;
  property FilterField:string read fFilterField write fFilterField;
  property KeyField:string read fKeyField write fKeyField;
  property ResultFields:string read fResultFields write fResultFields;
end;
TEtvLookupLevelCol=Class(TCollection)
protected
  fOwner:TComponent;
  function GetDataSet(aIndex:integer):TDataSet;
  procedure SetDataSet(aIndex:integer; aDataSet:TDataSet);
  function GetFilterField(aIndex:integer):string;
  function GetKeyField(aIndex:integer):string;
  function GetResultFields(aIndex:integer):string;
  function GetOwner: TPersistent; override;
public
  property Owner:TComponent read fOwner write fOwner;
  property DataSet[Index: Integer]:TDataSet read GetDataSet write SetDataSet;
  property FilterField[Index: Integer]:string read GetFilterField;
  property KeyField[Index: Integer]:string read GetKeyField;
  property ResultFields[Index: Integer]:string read GetResultFields;
end;

  TEtvLookFieldOption =
    (foAutoCodeName, foAutoDropDown, foAutoDropDownWidth,
     foEditWindow,foEditOnEnter, foKeyFieldEdit,
     foOnlyEqualinFilter,foUpDownInClose,
     foValueNotInLookup,foUserOption);
  TEtvLookFieldOptions = set of TEtvLookFieldOption;

const
  TEtvLookFieldOptionsDefault=[foEditWindow,foKeyFieldEdit,foUpDownInClose];

type

  TEtvLookField = class(TStringField)
  protected
    FLookupFields: TList;
    FListFieldIndex: Integer;
    FFilterFieldName: String;
    FLevelUpName: String;
    FLevelDownName: String;
    FFilterKeyName: String;
    fHeadLine:boolean;
    fHeadColor:TColor;
    fOnFilter:TOnFieldFilterEvent;
    fSetEditValue:TOnFieldSetEditEvent;
    fOptions:TEtvLookFieldOptions;
    fLookupResultFields:string;
    fLookupResultCount:Integer;
    fLookupAddFields:string;
    fLookupGridFields:string;
    fGridFields:TList;
    fLookupResultIndex:smallint;
    fLookupCache:boolean;
    fLookupLevels:TEtvLookupLevelCol;
    fEditData:TOnEditDataEvent;
    function GetLookupResultField: string;
    procedure SetLookupResultField(Const Value: string);
    procedure SetLookupGridFields(Const Value: string);
    procedure SetLookupAddFields(Const Value: string);
  {protected}
    function FieldDataSize(Field:Pointer): word;
    function GetDataSize: Word; override;
    function GetIsNull: boolean; override;
    function GetAsString: string; override;
    function GetAsVariant: Variant; override;
    procedure GetText(var Text: string; DisplayText: Boolean); override;
    procedure SetAsString(const Value: string); override;
    procedure SetAsVariant(const aValue: Variant); override;
    function GetAsVariants(Index: Integer): Variant;
    function GetLookupField(Index: Integer): TField;
    {$IFDEF Delphi4}
    procedure Bind(Binding: Boolean); override;
    procedure ValidateLookupInfo(All: Boolean);
    {$ENDIF}
    procedure RefreshLookupList;
    procedure ValidateLookupFields;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure ReadLookupLevelsData(Reader: TReader);
    procedure WriteLookupLevelsData(Writer: TWriter);
    procedure DefineProperties(Filer: TFiler); override;

  public
    VFieldIndex: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AllLookupFields:string;
    procedure ChangeLookupFields;
    property LookupFields: TList read FLookupFields;
    property LookupField[Index: Integer]: TField read GetLookupField;
    property GridFields: TList read FGridFields;
    property LookupResultCount:Integer read fLookupResultCount;
    function LengthResultFields:smallint;
    function CheckByLookName(Name: String): Boolean;
    function FieldByLookName(Name: String): TField;
    function StringByLookName(Name: String): String;
    function ValueByLookName(Name: String): Variant;
    procedure ValueByLookNameToField(Name: String; aField:TField);
    property Value: Variant read GetAsVariant write SetAsVariant;
    property Values[Index: Integer]: Variant read GetAsVariants;
  published
    property LookupResultField: string read GetLookupResultField write SetLookupResultField;
    property ListFieldIndex: Integer read FListFieldIndex write FListFieldIndex;

    property LookupLevels:TEtvLookupLevelCol read fLookupLevels stored false;
    property LookupFilterField: String read fFilterFieldName write fFilterFieldName;
    property LookupLevelUp: String read fLevelUpName write fLevelUpName;
    property LookupFilterKey: String read fFilterKeyName write fFilterKeyName;
    property LookupLevelDown: String read fLevelDownName write fLevelDownName;
    property LookupAddFields: String read FLookupAddFields write SetLookupAddFields;
    property LookupGridFields: String read FLookupGridFields write SetLookupGridFields;
    property LookupResultIndex:smallint read fLookupResultIndex write fLookupResultIndex default 0;
    property HeadLine:boolean read fHeadLine write fHeadLine;
    property HeadColor:TColor read fHeadColor write fHeadColor;
    property Options: TEtvLookFieldOptions read fOptions write fOptions
               default TEtvLookFieldOptionsDefault;
    property OnEditData:TOnEditDataEvent read fEditData Write fEditData;
    property OnFilter:TOnFieldFilterEvent read fOnFilter write fOnFilter;
    property SetEditValue:TOnFieldSetEditEvent read fSetEditValue write fSetEditValue;
  end;

  {$IFNDEF Delphi4}
  procedure AfterInternalOpen(ADataSet:TDataSet); (* Need for LookField *)
  {$ENDIF}

type
  TEtvListField = class(TSmallIntField)
  protected
    FValues: TStrings;
    function GetEditFormat: String;
    function GetDisplayFormat: String;
    function GetMinValue: Longint;
    function GetMaxValue: LongInt;
    procedure SetValues(Value: TStrings);
    procedure GetText(var Text: string; DisplayText: Boolean); override;
    function GetAsString: string; override;
    procedure SetAsInteger(Value: Longint); override;
    procedure SetAsString(const Value: string); override;
    procedure ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DisplayFormat: String read GetDisplayFormat;
    property EditFormat: String read GetEditFormat;
    property Values: TStrings read FValues write SetValues;
    property MinValue: Longint Read GetMinValue;
    property MaxValue: Longint Read GetMaxvalue;
  end;

IMPLEMENTATION

uses SysUtils,DBConsts,Dialogs,
     EtvPas,EtvBor,EtvConst,EtvDBFun;

{TEtvLookupLevelItem}
procedure TEtvLookupLevelItem.SetDataSet(aDataSet:TDataSet);
begin
  if fDataSet<>aDataSet then begin
    fDataSet:=aDataSet;
    if Assigned(aDataSet) then
      aDataSet.FreeNotification(TEtvLookupLevelCol(Collection).Owner);
  end;
end;

procedure TEtvLookupLevelItem.Assign(Source: TPersistent);
begin
  if Source is TEtvLookupLevelItem then with TEtvLookupLevelItem(Source) do begin
    Self.DataSet:=DataSet;
    Self.FilterField:=FilterField;
    Self.KeyField:=KeyField;
    Self.ResultFields:=ResultFields;
  end else inherited;
end;

{TEtvLookupLevelCol}
function TEtvLookupLevelCol.GetDataSet(aIndex:integer):TDataSet;
begin
  if aIndex<Count then Result:=TEtvLookupLevelItem(Items[aIndex]).DataSet
  else Result:=nil;
end;

procedure TEtvLookupLevelCol.SetDataSet(aIndex:integer; aDataSet:TDataSet);
begin
  if aIndex<Count then
    TEtvLookupLevelItem(Items[aIndex]).DataSet:=aDataSet;
end;

function TEtvLookupLevelCol.GetFilterField(aIndex:integer):string;
begin
  if aIndex<Count then Result:=TEtvLookupLevelItem(Items[aIndex]).FilterField
  else Result:='';
end;

function TEtvLookupLevelCol.GetKeyField(aIndex:integer):string;
begin
  if aIndex<Count then Result:=TEtvLookupLevelItem(Items[aIndex]).KeyField
  else Result:='';
end;

function TEtvLookupLevelCol.GetResultFields(aIndex:integer):string;
begin
  if aIndex<Count then Result:=TEtvLookupLevelItem(Items[aIndex]).ResultFields
  else Result:='';
end;

function TEtvLookupLevelCol.GetOwner: TPersistent;
begin
  Result:=fOwner;
end;

{ TEtvLookField }
constructor TEtvLookField.Create(AOwner: TComponent);
begin
  Inherited;
  FLookupFields:=TList.Create;
  FGridFields:=TList.Create;
  FLookupResultCount:=0;
  FLookupResultFields:='';
  fLookupResultIndex:=0;
  VFieldIndex:=-1;
  fOptions:=TEtvLookFieldOptionsDefault;
  fHeadLine:=true;
  fHeadColor:=DefaultHeadColor;
  fLookupLevels:=TEtvLookupLevelCol.Create(TEtvLookupLevelItem);
  fLookupLevels.Owner:=Self;
end;

destructor TEtvLookField.Destroy;
begin
  FlookupFields.Free;
  FGridFields.Free;
  fLookupLevels.Free;
  Inherited;
end;

function TEtvLookField.StringByLookName(Name: String): String;
var OldIndex,i,Pos: Integer;
    s:string;
begin
  OldIndex:=VFieldIndex;
  Pos := 1;
  Result:='';
  while Pos <= Length(Name) do begin
    s:=ExtractFieldName(Name, Pos);
    for i:=0 to fLookupFields.Count-1 do
      if AnsiCompareText(LookupField[i].FieldName, s)=0 then begin
        VFieldIndex:=i;
        if Result<>'' then Result:=Result+' ';
        Result:=Result+GetAsString;
        Break;
      end;
    if OldIndex<>VFieldIndex then VFieldIndex:=OldIndex;
  end;
end;

function TEtvLookField.ValueByLookName(Name: String): variant;
var i: Integer;
begin
  Result:=Null;
  for i:=0 to FLookupFields.Count-1 do
    if AnsiCompareText(LookupField[i].FieldName, Name)=0 then begin
      Result:=Values[i];
      Break;
    end;
end;

procedure TEtvLookField.ValueByLookNameToField(Name: String; aField:TField);
var v:variant;
begin
  v:=ValueByLookName(Name);
  if v<>null then aField.Value:=v else aField.Clear;
end;

Function TEtvLookField.LengthResultFields:smallint;
var i:smallint;
begin
  Result:=0;
  ChangeLookupFields;
  if Assigned(LookupDataSet) then begin
    for i:=0 to FLookupResultCount-1 do
      Result:=Result+LookupField[i].DisplayWidth;
  end;
end;

Function TEtvLookField.CheckByLookName(Name: String): boolean;
var i: Integer;
begin
  Result:=false;
  for i:=0 to FLookupFields.Count-1 do
    if AnsiCompareText(LookupField[i].FieldName, Name)=0 then begin
      Result:=true;
      Break;
    end;
end;

function TEtvLookField.FieldByLookName(Name: String): TField;
var i: Integer;
begin
  Result:=nil;
  for i:=0 to FLookupFields.Count-1 do
    if AnsiCompareText(LookupField[i].FieldName, Name)=0 then begin
      Result:=LookupField[i];
      Break;
    end;
end;

function TEtvLookField.FieldDataSize(Field:Pointer): word;
begin
  Result:=TField(Field).DataSize;
  if TField(Field) is TDateField then Result:=Sizeof(TDateTime);
end;

function TEtvLookField.GetAsString: string;
var v:variant;
    i:integer;
begin
  if Lookup then begin
    Result:='';
    if VFieldIndex>=0 then begin
      v:=GetAsVariant;
      if TVarData(v).VType<>varNull then Result:=VarToStr(v)
      else
        if lookup and (KeyFields<>'') and
           (LowerCase(LookupField[VFieldIndex].FieldName)=
            LowerCase(LookupKeyFields)) then
          Result:=DataSet.FieldByname(KeyFields).AsString;
    end
    else begin
      for i:=0 to FLookupResultCount-1 do begin
        VFieldIndex:=i;
        with LookupField[VFieldIndex] do begin
          if VFieldIndex>0 then  Result:=Result+' ';
          Result:=Result+GetAsString;
        end;
      end;
      VFieldIndex:=-1;
    end;
  end else Result:=inherited GetAsString;
end;

function TEtvLookField.GetAsVariant: variant;
var OldIndex,ofs,i:integer;
    s:string;
    Buffer: array[0..dsMaxStringSize] of Char;
    VarType:Word;
begin
  if Lookup and (DataSet.State<>dsSetKey) then begin
    Result:=null;
    OldIndex:=VFieldIndex;
    if VFieldIndex<0 then VFieldIndex:=fLookupResultIndex;
    if VFieldIndex<0 then Result:=GetAsString
    else if GetData(@Buffer) then begin
      ofs:=0;
      for i:=0 to VFieldIndex-1 do inc(ofs,FieldDataSize(LookupField[i])+SizeOf(Word));
      move(Buffer[ofs],VarType,SizeOf(Word));
      if VarType<>varNull then begin
        if (LookupField[VFieldIndex] is TStringField) or
           (LookupField[VFieldIndex] is TblobField) then begin
          move(Buffer[ofs+Sizeof(Word)],Buffer,
               FieldDataSize(LookupField[VFieldIndex]));
          s:=Buffer;
          Result:=s;
        end
        else begin
          TVarData(Result).VType:=VarType;
          Move(Buffer[ofs+Sizeof(Word)],TVarData(Result).vPointer,
               FieldDataSize(LookupField[VFieldIndex]));
        end;
      end;
    end;
    VFieldIndex:=OldIndex;
  end else Result:=Inherited GetAsVariant;
end;

function TEtvLookField.GetAsVariants(Index: Integer): Variant;
var OldIndex:Integer;
begin
  Result:=Null;
  OldIndex:=VFieldIndex;
  VFieldIndex:=index;
  Result:=GetAsVariant;
  VFieldIndex:=OldIndex;
end;

function TEtvLookField.GetLookupField(Index: Integer): TField;
begin
  Result:=TField(FLookupFields[Index]);
end;

procedure TEtvLookField.GetText(var Text: string; DisplayText: Boolean);
var OldVFieldIndex:integer;
begin
  if Lookup then begin
    OldVFieldIndex:=VFieldIndex;
    if DisplayText and (VFieldIndex<0) then begin
      OldVFieldIndex:=VFieldIndex;
      VFieldIndex:=fLookupResultIndex;
    end;
    Text:=GetAsString;
    if (VFieldIndex>=0) and DisplayText then begin
      Text:=SForm(Text,LookupField[VFieldIndex].DisplayWidth,
        LookupField[VFieldIndex].Alignment);
    end;
    VFieldIndex:=OldVFieldIndex;
  end else Inherited;
end;

procedure TEtvLookField.SetAsString(const Value: string);
begin
  if lookup then
   {Nothing}
  else Inherited;
end;

procedure TEtvLookField.SetAsVariant(const aValue: Variant);
var i,ofs: Integer;
    Buffer: array[0..dsMaxStringSize] of Char;
  procedure SetToData(Field:TField; localValue:variant);
  var P:pChar;
  begin
    Move(TVarData(localValue).VType,Buffer[Ofs],SizeOf(Word));
    if TVarData(localValue).VType<>VarNull then begin
      if (Field is TStringField) or (Field is TblobField) then begin
        P:=@Buffer[ofs+SizeOf(Word)];
        StrPCopy(P,VarToStr(LocalValue));
      end
      else Move(TVarData(localValue).vInteger,Buffer[Ofs+SizeOf(Word)],FieldDataSize(Field));
    end;
    inc(ofs,FieldDataSize(Field)+SizeOf(Word));
  end;
begin
  if Lookup then begin
    if TVarData(aValue).VType <> varNull then begin
      ofs:=0;
      if VarIsArray(aValue) then
        for i:=0 to FLookupFields.Count-1 do
          SetToData(LookupField[i],avalue[i])
      else SetToData(LookupField[0],avalue);
      SetData(@Buffer);
    end
    else Clear;
  end else inherited;
end;

function TEtvLookField.GetLookupResultField: string;
begin
  if (fLookupResultFields='') and (inherited LookupResultField<>'') then
    fLookupResultFields:=inherited LookupResultField;
  Result:=fLookupResultFields;
end;

procedure TEtvLookField.SetLookupResultField(Const Value: string);
begin
  inherited LookupResultField:=Value;
  fLookupResultFields:=value;
end;

procedure TEtvLookField.SetLookupAddFields(Const Value: string);
begin
  CheckInactive;
  fLookupAddFields:=Value;
end;

procedure TEtvLookField.SetLookupGridFields(Const Value: string);
begin
  CheckInactive;
  fLookupGridFields:=Value;
end;

function TEtvLookField.AllLookupFields:string;
var i,j,Len:integer;
    GridField:string;
    Exist:boolean;
begin
  Result:=LookupResultField;
  if LookupAddFields<>'' then Result:=Result+';'+LookupAddFields;
  i:=1;
  Len:=Length(Result);
  while i<=Length(LookupGridFields) do begin
    GridField:=ExtractFieldName(LookupGridFields,i);
    Exist:=false;
    j := 1;
    while j <= Len do begin
      if AnsiCompareText(GridField,ExtractFieldName(Result,j))=0 then begin
        Exist:=true;
        break;
      end;
    end;
    if Not Exist then Result:=Result+';'+GridField;
  end;
end;

procedure TEtvLookField.ChangeLookupFields;
var Pos: Integer;
begin
  FLookupFields.Clear;
  FGridFields.Clear;
  FLookupResultCount:=0;
  if Assigned(LookupDataSet)and(LookupResultField<>'') then begin
    Pos := 1;
    while Pos <= Length(LookupResultField) do begin
      ExtractFieldName(LookupResultField,Pos);
      Inc(FLookupResultCount);
    end;
    LookupDataSet.GetFieldList(FLookupFields,AllLookupFields);
    LookupDataSet.GetFieldList(FGridFields,LookupGridFields);
  end;
end;

function TEtvLookField.GetDataSize: Word;
var i:integer;
begin
  if Lookup then begin
    Result:=0;
    if (DataSet.State=dsInactive) then begin
      if (inherited LookupResultField<>'') then begin
        i:=Length(inherited LookupResultField);
        if Length(fLookupResultFields)<i then i:=Length(fLookupResultFields);
        if (i=0) or (copy(inherited LookupResultField,1,i)<>
                     copy(fLookupResultFields,1,i)) then begin
          fLookupResultFields:=inherited LookupResultField;
        end;
      end;
      {$IFDEF Delphi4}
      TFieldBorland(Self).fLookupResultField:=AllLookupFields;
      {$ELSE}
      if(Pos(';',fLookupResultFields)>0) then
        TFieldBorland(Self).fLookupResultField:=
          copy(fLookupResultFields,1,(Pos(';',fLookupResultFields)-1))
      else TFieldBorland(Self).fLookupResultField:=fLookupResultFields;
      fLookupCache:=LookupCache;
      if fLookupCache then LookupCache:=false;
      {$ENDIF}
      ChangeLookupFields;
    end;
    for i:=0 to FLookupFields.Count-1 do
      Result:=Result+FieldDataSize(LookupField[i])+SizeOf(Word);
  end else Result:=inherited GetDataSize;
  if Result>dsMaxStringSize then showmessage('Out Limit');
end;

function TEtvLookField.GetIsNull: boolean;
begin
  Result:=inherited GetIsNull;
  if Result and lookup and (foValueNotInLookup in Options) and
     (KeyFields<>'') then Result:=DataSet.FieldByName(KeyFields).IsNull;
end;

{$IFDEF Delphi4}
procedure TEtvLookField.Bind(Binding: Boolean);
begin
  if FieldKind = fkLookup then
    if Binding then begin
      if FLookupCache then RefreshLookupList
      else ValidateLookupInfo(True);
    end;
end;

procedure TEtvLookField.ValidateLookupInfo(All: Boolean);
begin
  if (All and ((LookupDataSet = nil) or (LookupKeyFields = '') or
     (LookupResultField = ''))) or (KeyFields = '') then
    DatabaseErrorFmt(SLookupInfoError, [DisplayName]);
  CheckFieldNames(DataSet,KeyFields);
  if All then begin
    LookupDataSet.Open;
    CheckFieldNames(LookupDataSet,LookupKeyFields);
    ValidateLookupFields;
  end;
end;

{$ELSE} {for Delphi 3}

procedure AfterInternalOpen(ADataSet:TDataSet);
var i:integer;
begin
  with ADataSet do
    for i:=0 to FieldCount-1 do
      if (TField(Fields[i]) is TEtvLookField) and
         TField(Fields[i]).Lookup then begin
        TFieldBorland(Fields[i]).fLookupResultField:=
          TEtvLookField(Fields[i]).AllLookupFields;
        if TEtvLookField(Fields[i]).fLookupCache then begin
          TField(Fields[i]).LookupCache:=true;
          TEtvLookField(Fields[i]).fLookupCache:=false;
          TEtvLookField(Fields[i]).RefreshLookupList;
        end else TEtvLookField(Fields[i]).ValidateLookupFields;
      end;
end;
{$ENDIF}

procedure TEtvLookField.RefreshLookupList;
var WasActive: Boolean;
begin
  if Assigned(LookupDataSet) then begin
    WasActive := LookupDataSet.Active;
    {$IFDEF Delphi4}
    ValidateLookupInfo(True);
    {$ELSE}
    ValidateLookupFields;
    {$ENDIF}
    with LookupDataSet do try
      LookupList.Clear;
      DisableControls;
      try
        First;
        while not EOF do begin
          LookupList.Add(FieldValues[LookupKeyFields],
            FieldValues[AllLookupFields]);
          Next;
        end;
      finally
        EnableControls;
      end;
    finally
      Active := WasActive;
    end;
  end
  {$IFDEF Delphi4}
  else ValidateLookupInfo(False);
  {$ENDIF}
end;

procedure TEtvLookField.ValidateLookupFields;
var i:integer;
begin
  CheckFieldNames(LookupDataSet,AllLookupFields);
  if LookupLevelUp<>'' then LookupDataSet.FieldByName(LookupLevelUp);
  if LookupLevelDown<>'' then LookupDataSet.FieldByName(LookupLevelDown);
  if LookupLevels.Count>0 then
    for i:=0 to LookupLevels.Count-1 do begin
      if (not Assigned(LookupLevels.DataSet[i])) or
         (LookupLevels.KeyField[i]='') or
         (LookupLevels.ResultFields[i]='') then
        DatabaseErrorFmt(SLookupInfoError, [DisplayName]);
      if Not LookupLevels.DataSet[i].Active then LookupLevels.DataSet[i].Open;
      LookupLevels.DataSet[i].FieldByName(LookupLevels.KeyField[i]);
      CheckFieldNames(LookupLevels.DataSet[i],LookupLevels.ResultFields[i]);
    end;
end;

procedure TEtvLookField.Notification(AComponent: TComponent; Operation: TOperation);
var i:integer;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
    for i:=0 to fLookupLevels.Count-1 do
      if fLookupLevels.DataSet[i]=AComponent then
        fLookupLevels.DataSet[i]:=nil;
end;

procedure TEtvLookField.ReadLookupLevelsData(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(FLookupLevels);
end;

procedure TEtvLookField.WriteLookupLevelsData(Writer: TWriter);
begin
  Writer.WriteCollection(FLookupLevels);
end;

procedure TEtvLookField.DefineProperties(Filer: TFiler);
  function WriteData: Boolean;
  begin
    Result:=FLookupLevels.Count>0;
  end;
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('LookupLevelsData',ReadLookupLevelsData,WriteLookupLevelsData,WriteData);
end;

{ TEtvListField }
constructor TEtvListField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValues := TStringList.Create;
  Alignment:=taLeftJustify;
  Inherited MinValue:=0;
end;

destructor TEtvListField.Destroy;
begin
  FValues.Free;
  inherited Destroy;
end;

procedure TEtvListField.ReadState(Reader: TReader);
begin
  Inherited;
  Inherited MaxValue:=FValues.Count-1;
end;

procedure TEtvListField.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
  Inherited MaxValue:=FValues.Count-1;
  if Assigned(DataSet) then DataChanged;
end;

procedure TEtvListField.GetText(var Text: string; DisplayText: Boolean);
begin
  Text:=GetAsString;
end;

function TEtvListField.GetAsString: string;
var L: Longint;
begin
  if GetValue(L) then begin
    if (L>=Inherited MinValue)and(L<=Inherited MaxValue) then Result:=FValues[L]
    else Result:='';
  end else Result:='';
end;

procedure TEtvListField.SetAsInteger(Value: Longint);
begin
  if (Value>=0) and (Value<=MaxValue) and (FValues[Value]='') then
    Clear
  else Inherited;
end;

procedure TEtvListField.SetAsString(const Value: string);
var L: Integer;
begin
  if Value='' then Clear
  else begin
    L:=FValues.IndexOf(Value);
    if L=-1 then
      DataBaseErrorFmt(SFieldValueError, [DisplayName])
    else SetAsInteger(L);
  end;
end;

function TEtvListField.GetEditFormat: String;
begin
  Result:=Inherited EditFormat;
end;

function TEtvListField.GetDisplayFormat: String;
begin
  Result:=Inherited DisplayFormat;
end;

function TEtvListField.GetMinValue: Longint;
begin
  Result:=Inherited MinValue;
end;

function TEtvListField.GetMaxValue: LongInt;
begin
  Result:= Inherited MaxValue;
end;

end.



