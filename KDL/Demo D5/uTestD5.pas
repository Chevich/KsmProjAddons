unit uTestD5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, Grids, DBGrids, uFrameD5, uFreeLocalizer;

const
  EnglishFile = 'testappd5.english.lng';
  BelarusianFile = 'testappd5.belarusian.lng';
  RussianFile = 'testappd5.russian.lng';

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Memo1: TMemo;
    btnStrings: TButton;
    btnNewForm: TButton;
    cbAutoTranslation: TCheckBox;
    pnlLanguage: TPanel;
    rgLanguage: TRadioGroup;
    btnLoad: TButton;
    btnTranslate: TButton;
    btnTranslateAll: TButton;
    DBGrid1: TDBGrid;
    Frame11: TFrame1;
    StaticText1: TStaticText;
    btnClose: TButton;
    procedure btnStringsClick(Sender: TObject);
    procedure btnNewFormClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnTranslateClick(Sender: TObject);
    procedure btnTranslateAllClick(Sender: TObject);
    procedure cbAutoTranslationClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    OldAfterLanguageLoad: TAfterLanguageLoadEvent;

    procedure UpdateFormState;
    procedure MyAfterLanguageLoad(Sender: TObject; const LanguageFile: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

resourcestring
  Str1 = #13#10'Hallo';     // Try to edit these resource strings,
  Str2 = ''''#13#10'Hallo'; // then makelng and updatelng.
  Str3 = '''Hallo';         // You'll see how String Versioning System
  Str4 = 'Hallo''';         // will catch these modifications
  Str5 = 'Hallo'#13#10'';
  Str6 = 'Ha'#13#10'llo';
  Str7 = 'Ha'''#13#10'llo';

procedure TForm1.btnStringsClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Add(Str1);
  Memo1.Lines.Add(Str2);
  Memo1.Lines.Add(Str3);
  Memo1.Lines.Add(Str4);
  Memo1.Lines.Add(Str5);
  Memo1.Lines.Add(Str6);
  Memo1.Lines.Add(Str7);
end;

procedure TForm1.btnNewFormClick(Sender: TObject);
var
  f: TForm1;
begin
  f := TForm1.Create(Self);
  f.ShowModal;
  f.Free;
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  case rgLanguage.ItemIndex of
    0: FreeLocalizer.LanguageFile := EnglishFile;
    1: FreeLocalizer.LanguageFile := BelarusianFile;
    2: FreeLocalizer.LanguageFile := RussianFile;
  end;
end;

procedure TForm1.btnTranslateClick(Sender: TObject);
begin
  FreeLocalizer.Translate(Self);
  dbgrid1.Repaint;
end;

procedure TForm1.btnTranslateAllClick(Sender: TObject);
begin
  FreeLocalizer.TranslateScreen;
end;

procedure TForm1.cbAutoTranslationClick(Sender: TObject);
begin
  FreeLocalizer.AutoTranslate := cbAutoTranslation.Checked;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  OldAfterLanguageLoad := FreeLocalizer.AfterLanguageLoad;
  FreeLocalizer.AfterLanguageLoad := MyAfterLanguageLoad;
  UpdateFormState;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(OldAfterLanguageLoad) then
    FreeLocalizer.AfterLanguageLoad := OldAfterLanguageLoad;
end;

procedure TForm1.MyAfterLanguageLoad(Sender: TObject;
  const LanguageFile: string);
begin
  if Assigned(OldAfterLanguageLoad) then
    OldAfterLanguageLoad(Sender, LanguageFile);

  UpdateFormState;
end;

procedure TForm1.UpdateFormState;
begin
  with FreeLocalizer do begin
    if LanguageFile = EnglishFile then rgLanguage.ItemIndex := 0 else
    if LanguageFile = BelarusianFile then rgLanguage.ItemIndex := 1 else
    rgLanguage.ItemIndex := 2;
    cbAutoTranslation.Checked := AutoTranslate;
  end;
  dbgrid1.Repaint;
end;

end.
