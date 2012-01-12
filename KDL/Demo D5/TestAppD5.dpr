program TestAppD5;

uses
  Forms,
  uTestD5 in 'uTestD5.pas' {Form1},
  uFrameD5 in 'uFrameD5.pas' {Frame1: TFrame},
  uFreeLocalizer in '..\uFreeLocalizer.pas',
  uStringUtils in '..\uStringUtils.pas',
  uLegacyCode in '..\uLegacyCode.pas';

{$R *.RES}

begin
  Application.Initialize;

  FreeLocalizer.ErrorProcessing := epMessage;
  FreeLocalizer.AutoTranslate := True;
  FreeLocalizer.LanguageFile := EnglishFile;

  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
