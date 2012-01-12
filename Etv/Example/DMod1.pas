unit DMod1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, EtvTable, EtvDB, Db, EtvFilt, EtvLook, EtvList;

type
  TDM1 = class(TDataModule)
    EtvDMInfo1: TEtvDMInfo;
    TbPeople: TEtvTable;
    TbCont: TEtvTable;
    TbPeopleid: TIntegerField;
    TbPeopleName: TStringField;
    TbPeopleProf: TSmallintField;
    TbPeopleCountry: TSmallintField;
    TbContId: TSmallintField;
    TbContName: TStringField;
    TbProf: TEtvTable;
    TbProfId: TSmallintField;
    TbProfName: TStringField;
    TbCountry: TEtvTable;
    TbCountryId: TSmallintField;
    TbCountryName: TStringField;
    TbPeopleSex: TEtvListField;
    TbPeopleCountryName1: TEtvLookField;
    TbPeopleCountryName2: TEtvLookField;
    QCont: TEtvQuery;
    QContId: TSmallintField;
    QContName: TStringField;
    TbCountryContN: TEtvLookField;
    QProf: TEtvQuery;
    QProfId: TSmallintField;
    QProfName: TStringField;
    QCountry: TEtvQuery;
    QCountryId: TSmallintField;
    QCountryName: TStringField;
    TbLang: TEtvTable;
    QLang: TEtvQuery;
    TbLangId: TSmallintField;
    TbLangName: TStringField;
    TbLangFont: TStringField;
    TbLangFontSize: TSmallintField;
    TbLangLayout: TStringField;
    QLangId: TSmallintField;
    QLangName: TStringField;
    QLangFont: TStringField;
    QLangFontSize: TSmallintField;
    QLangLayout: TStringField;
    TbProfIdUp: TSmallintField;
    TbProfKodUpName: TEtvLookField;
    TbPeopleLang: TSmallintField;
    TbPeopleLangName: TEtvLookField;
    TbPeopleProfName: TEtvLookField;
    TbPeoplePasport: TStringField;
    QProfIdUp: TSmallintField;
    TbPeopleEmptyField: TSmallintField;
    DSQLang: TDataSource;
    TbCountryContinent: TSmallintField;
    QCountryContinent: TSmallintField;
    TbCountryDescription: TStringField;
    TbCountryInfo: TStringField;
    TbCountryPicture: TGraphicField;
    TbPeopleContinent: TSmallintField;
    TbProfAmountDown: TSmallintField;
    QProfAmountDown: TSmallintField;
    TbJob: TEtvTable;
    TbJobId: TAutoIncField;
    TbJobPeople: TIntegerField;
    TbJobDateBe: TDateField;
    TbJobDateEn: TDateField;
    TbJobCompany: TStringField;
    TbJobJobPosition: TStringField;
    TbPeopleInfo: TMemoField;
    TbPeopleImage: TGraphicField;
    TbPeopleRich: TMemoField;
    procedure TbContEditData(Sender: TObject; TypeShow: TTypeShow;
      FieldReturn: TFieldReturn);
    procedure TbProfEditData(Sender: TObject; TypeShow: TTypeShow;
      FieldReturn: TFieldReturn);
    procedure TbCountryEditData(Sender: TObject; TypeShow: TTypeShow;
      FieldReturn: TFieldReturn);
    procedure TbPeopleEditData(Sender: TObject; TypeShow: TTypeShow;
      FieldReturn: TFieldReturn);
    procedure TbProfAfterPost(DataSet: TDataSet);
    procedure TbPeopleAfterPost(DataSet: TDataSet);
    procedure DM1Create(Sender: TObject);
    procedure TbPeopleLangNameEditData(Sender: TObject;
      TypeShow: TTypeShow; FieldReturn: TFieldReturn);
  private
    { Private declarations }
  public
    procedure resetCount;
    { Public declarations }
  end;

var
  DM1: TDM1;

procedure ExampleOnFilterLoad(EtvFilter:TComponent);
procedure ExampleOnFilterSave(EtvFilter:TComponent);

implementation
uses EtvPas,EtvForms,fBase,etvDBFun,EtvOther,unit2;

{$R *.DFM}

procedure TDM1.TbContEditData(Sender: TObject; TypeShow: TTypeShow;
  FieldReturn: TFieldReturn);
begin
  ToForm(TFormBase,TbCont,TypeShow,FieldReturn);
end;

procedure TDM1.TbProfEditData(Sender: TObject; TypeShow: TTypeShow;
  FieldReturn: TFieldReturn);
begin
  ToForm(TFormBase,TbProf,TypeShow,FieldReturn);
end;

procedure TDM1.TbCountryEditData(Sender: TObject; TypeShow: TTypeShow;
  FieldReturn: TFieldReturn);
begin
  ToForm(TFormBase,TbCountry,TypeShow,FieldReturn);
end;

procedure TDM1.TbPeopleLangNameEditData(Sender: TObject;
  TypeShow: TTypeShow; FieldReturn: TFieldReturn);
begin
  ToForm(TFormBase,TbLang,TypeShow,FieldReturn);
end;

procedure TDM1.TbPeopleEditData(Sender: TObject; TypeShow: TTypeShow;
  FieldReturn: TFieldReturn);
begin
  ToForm(TFormPeople,TbPeople,TypeShow,FieldReturn);
end;

procedure TDM1.TbProfAfterPost(DataSet: TDataSet);
begin
  if QProf.Active then QProf.Close;
  QProf.Open;
  TbProf.Refresh;
end;

procedure TDM1.TbPeopleAfterPost(DataSet: TDataSet);
begin
  ResetCount;
end;

procedure TDM1.ResetCount;
var v:variant;
    lText:string;
begin
  if assigned(FormPeople) then begin
    lText:='Select Count(*) from People.db EFilter';
    // EFilter - standard alias of table in EtvFilter 
    if FormPeople.EFilter.Used<>fuNone then
      lText:=lText+' where '+FormPeople.EFilter.ConstructSQLFilter(FormPeople.EFilter.Used);
    v:=GetFromSQLText('EtvExample',lText,true);
    if v<>null then
      FormPeople.EtvDBGrid.SetItemTotal('Name','Count: '+IntToStr(v))
    else FormPeople.EtvDBGrid.SetItemTotal('Name','');
  end;
end;

function CreateFileName(aDataSet:TDataSet):string;
begin
  Result:=ObjectStrProp(aDataSet,'TableName');
  if Result='' then Result:=aDataSet.Name
  else While Pos('.',Result)>0 do Result[Pos('.',Result)]:='_';
  Result:=Result+'.flt';
end;


procedure ExampleOnFilterLoad(EtvFilter:TComponent);
var Stream:TFileStream;
    s:string;
begin
  if Assigned(TEtvFilter(EtvFilter).DataSet) then begin
    s:=ExtractFilePath(ParamStr(0))+CreateFileName(TEtvFilter(EtvFilter).DataSet);
    if FileExists(s) then
      try
        Stream:=TFileStream.Create(s,fmOpenRead);
        TEtvFilter(EtvFilter).LoadFromStream(Stream);
        Stream.free;
      except
      end;
  end;
end;

procedure ExampleOnFilterSave(EtvFilter:TComponent);
var Stream:TFileStream;
begin
  Stream:=nil;
  try
    Stream:=TFileStream.Create(ExtractFilePath(ParamStr(0))+
      CreateFileName(TEtvFilter(EtvFilter).DataSet),fmCreate);
    TEtvFilter(EtvFilter).SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TDM1.DM1Create(Sender: TObject);
begin
  with Session do if not IsAlias('EtvExample') then begin
    ConfigMode := cmSession;
    try
      AddStandardAlias('EtvExample', ExtractFilePath(ParamStr(0)), 'PARADOX');
    finally
      ConfigMode := cmAll;
    end;
  end;
end;

initialization
  CreateOtherOnFilterLoad:=ExampleOnFilterLoad;
  CreateOtherOnFilterSave:=ExampleOnFilterSave;
finalization

end.
