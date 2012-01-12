{$A8,B-,C-,D-,E-,F-,G+,H+,I+,J-,K-,L-,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y-,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}

program TestApp;

uses
  uFreeLocalizer in '..\uFreeLocalizer.pas',
  uStringUtils in '..\uStringUtils.pas',
  UTF8VCL in '..\..\utf8vcl\UTF8VCL.pas',
  UTF8VCLUtils in '..\..\utf8vcl\UTF8VCLUtils.pas',
  UTF8VCLMessages in '..\..\utf8vcl\UTF8VCLMessages.pas',
  UTF8VCLControls in '..\..\utf8vcl\UTF8VCLControls.pas',
  UTF8VCLCommDlg in '..\..\utf8vcl\UTF8VCLCommDlg.pas',
  Forms,
  uTest in 'uTest.pas' {Form1},
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
