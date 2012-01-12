{$A8,B-,C-,D-,E-,F-,G+,H+,I+,J-,K-,L-,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y-,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}

program TestApp;

uses
  Forms,
  uTest in 'uTest.pas' {Form1},
  uFreeLocalizer in '..\uFreeLocalizer.pas',
  uStringUtils in '..\uStringUtils.pas',
  uFrame in 'uFrame.pas' {Frame1: TFrame};

{$R *.res}

begin
  Application.Initialize;

  FreeLocalizer.ErrorProcessing := epMessage;
  FreeLocalizer.AutoTranslate := True;
  FreeLocalizer.LanguageFile := EnglishFile;

  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
