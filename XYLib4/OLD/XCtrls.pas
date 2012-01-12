Unit XCtrls;

Interface

Uses Classes, DB, DBCtrls, RxCtrls;

Type

{ TXLabel }

  TXLabel = class(TRxLabel)
  end;

{ TXDBLabel }

  TXDBLabel = class(TXLabel)
  private
    FDataLink: TFieldDataLink;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure DataChange(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption stored False;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;
{ TXDBLabel }

Implementation

{ TXDBLabel }
Constructor TXDBLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.OnDataChange := DataChange;
end;

Destructor TXDBLabel.Destroy;
begin
  FDataLink.OnDataChange:=nil;
  FDataLink.Free;
  inherited Destroy;
end;

Function TXDBLabel.GetDataField: string;
begin
  Result:=FDataLink.FieldName;
end;

Function TXDBLabel.GetDataSource: TDataSource;
begin
  Result:=FDataLink.DataSource as TDataSource;
end;

Procedure TXDBLabel.SetDataField(const Value: string);
begin
  FDataLink.FieldName:=Value;
end;

Procedure TXDBLabel.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource:=Value;
end;

Procedure TXDBLabel.DataChange(Sender: TObject);
begin
  if FDataLink.Field=nil then Caption:=''
  else Caption:=FDataLink.Field.AsString;
end;

end.
