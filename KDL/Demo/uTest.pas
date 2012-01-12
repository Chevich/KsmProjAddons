(*
  Test Project for the Kryvich's Delphi Localizer.
  Copyright (C) 2006, 2007, 2008 Kryvich, Belarusian Linguistic Software team.

  Note: to properly compile the project copy uFreeLocalizer.dcu &
  uStringUtils.dcu files.
*)

unit uTest;

{$if CompilerVersion < 18.0}{$define D7}{$ifend}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, DBClient, Grids, DBGrids, ActnList, Menus,
  ComCtrls, uFreeLocalizer, uFrame;

const
  EnglishFile = 'testapp.english.lng';
  BelarusianFile = 'testapp.belarusian.lng';
  RussianFile = 'testapp.russian.lng';

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    btnStrings: TButton;
    btnNewForm: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1ID: TIntegerField;
    ClientDataSet1OrderNo: TStringField;
    ClientDataSet1Name: TStringField;
    ClientDataSet1Description: TStringField;
    cbAutoTranslation: TCheckBox;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ActionList1: TActionList;
    actOpen: TAction;
    actQuit: TAction;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ListView1: TListView;
    pnlLanguage: TPanel;
    btnLoad: TButton;
    rgLanguage: TRadioGroup;
    btnQuit: TButton;
    btnTranslate: TButton;
    btnTranslateAll: TButton;
    OpenDialog1: TOpenDialog;
    Frame11: TFrame1;
    StaticText1: TStaticText;
    N8: TMenuItem;
    actMessageFromDLL: TAction;
    DLL1: TMenuItem;
    actShowFormFromPackage: TAction;
    N9: TMenuItem;
    procedure btnStringsClick(Sender: TObject);
    procedure cbAutoTranslationClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure actQuitExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actOpenExecute(Sender: TObject);
    procedure btnTranslateClick(Sender: TObject);
    procedure btnTranslateAllClick(Sender: TObject);
    procedure actMessageFromDLLExecute(Sender: TObject);
    procedure actShowFormFromPackageExecute(Sender: TObject);
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

{$R *.dfm}

resourcestring
  Str1 = #13#10'Прывітанне, свет!';     // Try to edit these resource strings,
  Str2 = ''''#13#10'Прывітанне, свет!'; // then makelng and updatelng.
  Str3 = '''Прывітанне, свет!';         // You'll see how String Versioning System
  Str4 = 'Прывітанне, свет!''';         // will catch the modifications
  Str5 = 'Прывітанне, свет!'#13#10'';
  Str6 = 'Прывітанне, '#13#10'свет!';
  Str7 = 'Прывітанне, '''#13#10'свет!';
{$ifndef D7}
  IdInNativeLangНовыРадок = 'Радок з ідэнтыфікатарам на беларускай мове';
{$endif}

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
{$ifndef D7}
  Memo1.Lines.Add(IdInNativeLangНовыРадок);
{$endif}

  ListView1.Repaint;
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
    if LanguageFile = EnglishFile then
      rgLanguage.ItemIndex := 0
    else if LanguageFile = BelarusianFile then
      rgLanguage.ItemIndex := 1
    else
      rgLanguage.ItemIndex := 2;
    cbAutoTranslation.Checked := AutoTranslate;
  end;
  dbgrid1.Repaint;
end;

procedure ShowDllMessage; external 'testdll.dll';
procedure SetLanguageFileForDll(const s: pchar); external 'testdll.dll';

procedure TForm1.actMessageFromDLLExecute(Sender: TObject);
var
  s: string;
begin
  // Set current language file for DLL
  s := FreeLocalizer.LanguageFile;
  s := StringReplace(s, 'testapp', 'testdll', []);
  // testapp.english.lng --> testdll.english.lng
  SetLanguageFileForDll(pchar(s));

  ShowDllMessage;
end;

procedure TForm1.actOpenExecute(Sender: TObject);
var
  f: TForm1;
begin
  f := TForm1.Create(Self);
  try
    f.ShowModal;
  finally
    f.Free;
  end;
end;

procedure TForm1.actQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.actShowFormFromPackageExecute(Sender: TObject);
// Load a package dynamically and show a form
// Thanks Zarko Gajic for info
// http://delphi.about.com/b/2005/02/05/using-packages-in-delphi.htm
var
  hm: HModule;
  showfrm: procedure(Owner: TCustomForm);
  setlang: procedure(const s: string);
  s: string;
begin
  hm := LoadPackage(ExtractFilePath(ParamStr(0)) + 'TestPackage.bpl');
  if hm <> 0 then
    try
      @setlang := GetProcAddress(hm, 'SetLanguageFileForPackage');
      if assigned(setlang) then begin
        // Set current language file for package
        s := FreeLocalizer.LanguageFile;
        s := StringReplace(s, 'testapp', 'testpackage', []);
        // testapp.english.lng --> testpackage.english.lng
        setlang(s);

        @showfrm := GetProcAddress(hm, 'ShowFormInPackage');
        if assigned(showfrm) then
          showfrm(Self)
        else
          ShowMessage('Execute routine not found!');

      end else
        ShowMessage('SetLanguageFileForPackage routine not found!');
    finally
      UnloadPackage(hm);
    end
  else
    ShowMessage('Package not found!');
end;

end.
