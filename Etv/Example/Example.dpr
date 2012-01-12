program Example;

uses
  Forms,
  etvDB,
  Unit1 in 'Unit1.pas' {Form1},
  fBase in '..\fBase.pas' {FormBase},
  DMod1 in 'DMod1.pas' {DM1: TDataModule},
  Unit2 in 'Unit2.pas' {FormPeople};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TForm1, Form1);
  CreateEtvApp(true);
  Application.Run;
end.
