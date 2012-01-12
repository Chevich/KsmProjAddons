unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    Label1: TLabel;
    LabelMail: TLabel;
    Label5: TLabel;
    LabelHomePage: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label69: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure LabelMailClick(Sender: TObject);
    procedure LabelHomePageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses ShellApi,EtvDB,DMod1;
{$R *.DFM}

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  DM1.TbPeople.OnEditData(Self,viShow,nil);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  DM1.TbCountry.OnEditData(Self,viShow,nil);
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  DM1.TbLang.OnEditData(Self,viShow,nil);
end;

procedure TForm1.LabelMailClick(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow(), 'open', PChar('mailto:'+LabelMail.Caption),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.LabelHomePageClick(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow(), 'open', PChar(LabelHomePage.Caption),
    nil, nil, SW_SHOWNORMAL);
end;

end.
