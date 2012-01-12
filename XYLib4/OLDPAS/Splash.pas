{            }
{ SplashForm }
{            }
Unit Splash;

Interface

Uses SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
     Forms, Dialogs, StdCtrls, Gauges, ExtCtrls, XCtrls,
     XSplash, RXCtrls;

type
  TSplashForm = class(TXSplashForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Label1: TLabel;
    Image1: TImage;
    TaskLab: TXLabel;
    AutsLab: TXLabel;
    HardLab: TXLabel;
    Bevel2: TBevel;
    Progress: TGauge;
    ProgressBevel: TBevel;
  protected
    function  GetHardLab: String;override;
    procedure SetHardLab(Const Value: String);override;
    function  GetTaskLab: String;override;
    procedure SetTaskLab(Const Value: String);override;
    function  GetAutsLab: String;override;
    procedure SetAutsLab(Const Value: String);override;
    function  GetImage: TImage;override;
    function  GetVisProgress: Boolean;override;
    procedure SetVisProgress(Value: Boolean);override;
    function  GetProgress: Integer;override;
    procedure SetProgress(Value: Integer);override;
    procedure SetProgressCount(Value: Integer);override;
  public
{    Procedure Init(ACount: Integer; Const ABmp, AHard, ATask,
              Auts: String);}
  end;

Var SplashForm: TSplashForm=nil;

Implementation

Uses XMisc, XTFC;

{$R *.DFM}

Function TSplashForm.GetHardLab: String;
begin
  Result:=HardLab.Caption;
end;

Procedure TSplashForm.SetHardLab(Const Value: String);
begin
  HardLab.Caption:=Value;
end;

Function TSplashForm.GetTaskLab: String;
begin
  Result:=TaskLab.Caption;
end;

Procedure TSplashForm.SetTaskLab(Const Value: String);
begin
  TaskLab.Caption:=Value;
end;

Function TSplashForm.GetAutsLab: String;
begin
  Result:=AutsLab.Caption;
end;

Procedure TSplashForm.SetAutsLab(Const Value: String);
begin
  AutsLab.Caption:=Value;
end;

Function TSplashForm.GetImage: TImage;
begin
  Result:=Image1;
end;

Function TSplashForm.GetVisProgress: Boolean;
begin
  Result:=Progress.Visible;
end;

Procedure TSplashForm.SetVisProgress(Value: Boolean);
begin
  if Value then begin
    Progress.Visible:=True;
    ProgressBevel.Visible:=True;
  end else begin
    Progress.Visible:=False;
    ProgressBevel.Visible:=False;
  end;
end;

Function TSplashForm.GetProgress: Integer;
begin
  Result:=Progress.Progress;
end;

Procedure TSplashForm.SetProgress(Value: Integer);
begin
  Progress.Progress:=Value;
  Update;
end;

Procedure TSplashForm.SetProgressCount(Value: Integer);
begin
  Inherited;
  Progress.MaxValue:=GetProgressCount*10;
  Show;
end;

{
Procedure TSplashForm.Init(ACount: Integer; Const ABmp, AHard, ATask,
              Auts: String);
begin
  if AHard<>'' then
  HardLab.Caption:=AHard;
  if ATask<>'' then
  TaskLab.Caption:=ATask;
  if Auts<>'' then
  AutsLab.Caption:=Auts;
  if ABmp<>'' then Image1.Picture.LoadFromFile(ABmp);
  XProgressCount:=ACount;
end;
}

Initialization
  RegisterAliasXSplash(scDefaultClass, TSplashForm);
Finalization
  UnRegisterXSplash(TSplashForm);
end.
