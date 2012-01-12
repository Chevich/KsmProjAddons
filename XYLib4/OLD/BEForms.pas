Unit BEForms;

Interface

Uses
  XDBForms, XMisc, StdCtrls, Nav, ExtCtrls, Controls, Grids, DBGrids, EtvGrid,
  XECtrls, ComCtrls, Classes, Forms, EtvContr, SrcIndex, Menus, Graphics;

Type

{ TBForm }

  TBEForm = class(TXDBForm)
    PageControl1: TXDBPageControl;
    Grid: TXEDbGrid;
    GridSheet: TEtvTabSheet;
    PageControl1Panel: TLinkPanel;
    PageControl1PanelNavigator: TLinkNavigator;
    PageControl1PanelIndexCombo: TLinkIndexCombo;{override;!!!}
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
{    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);}
  private
  public
    Scroll:TScrollBox;
    GridColor:TColor;
  end;
  var BitsPerPixel:smallint;

Implementation

Uses EtvForms, EtvPas;

{$R *.DFM}

{ TBEForm }

Procedure TBEForm.FormCreate(Sender: TObject);
begin
  Inherited;
  if BitsPerPixel>=16 then GridColor:=$00CDE1EB else GridColor:=clInfoBk;
  Grid.Color:=GridColor;
End;

Procedure TBEForm.FormActivate(Sender: TObject);
var Tabs:TTabSheet;
    OnlyVisibleFields:boolean;

Function CreateLabelFont:TFont;
begin
  Result:=TFont.Create;
  with Result do begin
    Name:='Arial';
    Size:=9;
    Style:=[fsItalic];
  end;
end;

Begin
  Inherited;
  {Exit;}
  if Self.ClassName<>'TBEForm' then Exit;
{  if ((Not AutoWidth(EtvDBGrid.Canvas.TextWidth('0'),45)) and}
  if (PageControl1.PageCount=1) then begin
    { (foPageOneRecord in Options) then begin}
    GridSheet.TabVisible:=true;
    Tabs:=TTabSheet.Create(Self);
    Tabs.Caption:='Форма';
    Tabs.PageControl:=PageControl1;
    Scroll:=TScrollBox.Create(Self);
    Scroll.Align:=alClient;
    Scroll.Width:=PageControl1.Width-8;
    Scroll.ParentFont:=false;
    with Scroll.Font do begin
      {Name:='';}
      Size:=10;
      Style:=[fsBold];
    end;
    Tabs.InsertControl(Scroll);
    ConstructOneRecordEdit(Scroll, Grid.DataSource, CreateLabelFont, GridColor, false, false);
  end;
  if Self.Tag>0 then begin
    { Перестраиваем страничку "Форма" }
    Scroll.DestroyComponents;
    if Self.Tag=8 then OnlyVisibleFields:=true
    else OnlyVisibleFields:=false;
    ConstructOneRecordEdit(Scroll, Grid.DataSource, CreateLabelFont, GridColor, false, OnlyVisibleFields);
    Self.Tag:=0;
  end;
{}
end;

procedure TBEForm.FormDeactivate(Sender: TObject);
begin
  inherited;
{}
end;

procedure TBEForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
{}
end;

{
procedure TBEForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(Scroll) and Scroll.Focused then begin
    DataSrcKeyDown(Grid.DataSource,Key,Shift);
  end;
end;
}

Initialization
  RegisterAliasXForm(fcDBDefaultClass, TBEForm);
  BitsPerPixel:=GetBitsPerPixel;
Finalization
  UnRegisterXForm(TBEForm);
end.
