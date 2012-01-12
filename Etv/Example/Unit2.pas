unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, EtvGrid, ComCtrls, EtvContr, StdCtrls,
  DBCtrls, ExtCtrls, EtvLook, fBase, EtvFilt,
  Menus, EtvFind, Mask, Buttons, EtvRich, EtvClone, EtvList,
  EtvPages, EtvSort,EtvDB;

type
  TFormPeople = class(TFormBase)
    TabSheet1: TTabSheet;
    EtvDBLookupCombo2: TEtvDBLookupCombo;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Memo1: TMemo;
    EtvTabSPopup: TEtvTabSheet;
    EtvTabSForms: TEtvTabSheet;
    EtvTabSList: TEtvTabSheet;
    EtvTabSExtracts: TEtvTabSheet;
    EtvTabSDesign: TEtvTabSheet;
    DataSource1: TDataSource;
    EtvDBEdit1: TEtvDBEdit;
    Label3: TLabel;
    Label5: TLabel;
    Label21: TLabel;
    EtvDBLookupCombo5: TEtvDBLookupCombo;
    Label22: TLabel;
    EtvDBLookupCombo6: TEtvDBLookupCombo;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    EtvDBText1: TEtvDBText;
    Label27: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label20: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    EtvDBEdit2: TEtvDBEdit;
    EtvDBLookupCombo3: TEtvDBLookupCombo;
    Label15: TLabel;
    Label6: TLabel;
    EtvDBLookupCombo4: TEtvDBLookupCombo;
    Label10: TLabel;
    Label9: TLabel;
    EtvDBLookupCombo1: TEtvDBLookupCombo;
    Label2: TLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Label28: TLabel;
    EtvDbGrid1: TEtvDbGrid;
    EtvDbGrid2: TEtvDbGrid;
    DataSource2: TDataSource;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    EtvDBLookupCombo7: TEtvDBLookupCombo;
    EtvDBLookupCombo8: TEtvDBLookupCombo;
    EtvDbGrid3: TEtvDbGrid;
    Label1: TLabel;
    Label42: TLabel;
    DBMemo1: TDBMemo;
    EtvDBRichEdit1: TEtvDBRichEdit;
    Label43: TLabel;
    DBImage1: TDBImage;
    Label18: TLabel;
    Bevel6: TBevel;
    EtvTabSheet1: TEtvTabSheet;
    Label19: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    EtvDBCombo1: TEtvDBCombo;
    Label46: TLabel;
    Label47: TLabel;
    EtvDbGrid4: TEtvDbGrid;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Image1: TImage;
    Label57: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label58: TLabel;
    Image10: TImage;
    Label59: TLabel;
    Label60: TLabel;
    EtvDbGrid5: TEtvDbGrid;
    EtvDbGrid6: TEtvDbGrid;
    Label61: TLabel;
    Label62: TLabel;
    Button1: TButton;
    EtvRecordCloner1: TEtvRecordCloner;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    EtvDBLookupCombo9: TEtvDBLookupCombo;
    Label66: TLabel;
    Label67: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    procedure EtvDbGridSetFont(Sender: TObject; Field: TField;
      Font: TFont);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EtvDbGridSetColor(Sender: TObject; Field: TField;
      var aColor: TColor);
    procedure EtvDBLookupCombo6DropDown(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EtvRecordCloner1CloneDataSet(DataSet: TDataSet);
    procedure EtvRecordCloner1CloneSubDataSet(DataSet: TDataSet);
    procedure SBFilterEditClick(Sender: TObject);
    procedure SBFilterSetClick(Sender: TObject);
    procedure SBFilterNoneClick(Sender: TObject);
    procedure ComboBoxFilterListChange(Sender: TObject);
    procedure EtvDBLookupCombo5EditData(Sender: TObject;
      TypeShow: TTypeShow; FieldReturn: TFieldReturn);
    procedure PageControl1Change(Sender: TObject);
  private
    ListCount:integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPeople: TFormPeople;

implementation
uses EtvForms,EtvPas,EtvPopup,EtvDBFun,DMod1;

{$R *.DFM}

procedure TFormPeople.FormActivate(Sender: TObject);
begin
  inherited;
  dm1.TbPeopleAfterPost(nil);
end;

procedure TFormPeople.FormCreate(Sender: TObject);
begin
  inherited;
  FormPeople:=self;
  EtvDBLookupCombo9.KeyValue:=99;
  DBMemo1.PopupMenu:=PopupMenuEtvDBMemo;
  // Disable Load from file and Save to file because some
  // versions of Delphi do it bad.
  TPopupMenuEtvDBImage(PopupMenuEtvDBImage).CanLoadSave:=false;
  DBImage1.PopupMenu:=PopupMenuEtvDBImage;
end;

procedure TFormPeople.EtvDbGridSetColor(Sender: TObject; Field: TField;
  var aColor: TColor);
begin
  inherited;
  if (Field=Field.Dataset.FieldByName('Pasport')) and
    dm1.QLang.Locate('id',Field.Dataset.FieldByName('Lang').value,[]) then begin
    if Field.Dataset.FieldByName('Lang').value=6 then
      aColor:=$00C0FFFF;
  end;
end;

procedure TFormPeople.EtvDbGridSetFont(Sender: TObject; Field: TField;
  Font: TFont);
begin
  if (Field=DataSource1.Dataset.FieldByName('Pasport')) and
    dm1.QLang.Locate('id',Field.Dataset.FieldByName('Lang').value,[]) then begin
    Font.Name:=dm1.QLangFont.Value;
    if Field.Dataset.FieldByName('Lang').value=2 then Font.Color:=clRed;
  end;
end;

procedure TFormPeople.EtvDBLookupCombo6DropDown(Sender: TObject);
begin
  Inc(ListCount);
  EtvDBLookupCombo6.HeadLineStr:='You open this list '+IntToStr(ListCount)+' time'
end;

procedure TFormPeople.Button1Click(Sender: TObject);
begin
  EtvRecordCloner1.Clone;
end;

procedure TFormPeople.EtvRecordCloner1CloneDataSet(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('id').Value:=
    GetFromSQLText('EtvExample','Select Max(id)+1 from people.db',false);
end;

procedure TFormPeople.EtvRecordCloner1CloneSubDataSet(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('People').Value:=DataSource1.Dataset.FieldByName('id').value;
end;

procedure TFormPeople.SBFilterEditClick(Sender: TObject);
begin
  inherited;
  dm1.ResetCount;
end;

procedure TFormPeople.SBFilterSetClick(Sender: TObject);
begin
  inherited;
  dm1.ResetCount;
end;

procedure TFormPeople.SBFilterNoneClick(Sender: TObject);
begin
  inherited;
  dm1.ResetCount;
end;

procedure TFormPeople.ComboBoxFilterListChange(Sender: TObject);
begin
  inherited;
  dm1.ResetCount;
end;

procedure TFormPeople.EtvDBLookupCombo5EditData(Sender: TObject;
  TypeShow: TTypeShow; FieldReturn: TFieldReturn);
begin
  inherited;
  ToForm(TFormBase,dm1.TbLang,TypeShow,FieldReturn);
end;

procedure TFormPeople.PageControl1Change(Sender: TObject);
begin
  inherited;
  if (PageControl1.ActivePage=EtvTabSheet1) and (EFilter.Used<>fuNone) then begin
    EFilter.Used:=fuNone;
    CheckAroundFilter;
  end;
end;

end.
