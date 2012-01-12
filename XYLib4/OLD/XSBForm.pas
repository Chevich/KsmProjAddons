Unit XSBForm;

Interface

Uses XDBForms, Menus, XTFC, Dialogs, Controls, ComCtrls, ToolWin, XMisc,
     StdCtrls, Mask, ToolEdit, XCtrls, RXCtrls, Buttons, Classes, ExtCtrls,
     EtvContr;

type
  TXSDBForm = class(TXDBForm)
    StartPC: TXDBPageControl;
    TaskSheet: TTabSheet;
    ImageList1: TImageList;
    PrintSetup: TPrinterSetupDialog;
    MainMenu1: TControlMainMenu;
    N22: TMenuItem;
    N24: TMenuItem;
    N32: TMenuItem;
    DetailSheet: TTabSheet;
    HotImageList1: TImageList;
    TaskToolBar: TToolBar;
    ServisSheet: TTabSheet;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    DetailToolBar: TToolBar;
    ServisToolBar: TToolBar;
    PrinterBtn: TToolButton;
    ArchiveBtn: TToolButton;
    SetupBtn: TToolButton;
    StatBtn: TToolButton;
    Panel1: TPanel;
    MainDate: TDateEdit;
    CurrDateBtn: TSpeedButton;
    AboutBtn: TToolButton;
    XLabel1: TXLabel;
    XDBLabel1: TXDBLabel;
    XLabel2: TXLabel;
    SpeedButton1: TSpeedButton;
    procedure CurrDateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure PrinterBtnClick(Sender: TObject);
  end;

var XSDBForm: TXSDBForm;

Implementation

Uses SysUtils, Forms;

{$R *.DFM}

Procedure TXSDBForm.CurrDateBtnClick(Sender: TObject);
begin
  inherited;
  MainDate.Date:=Date;
end;

Procedure TXSDBForm.FormCreate(Sender: TObject);
begin
  inherited;
  MainDate.Date:=Date;
end;

Procedure TXSDBForm.ExitBtnClick(Sender: TObject);
begin
  Application.Terminate;
end;

Procedure TXSDBForm.PrinterBtnClick(Sender: TObject);
begin
  PrintSetup.Execute;
end;

Initialization
  RegisterXForm(TXSDBForm);
Finalization
  UnRegisterXForm(TXSDBForm);
end.
