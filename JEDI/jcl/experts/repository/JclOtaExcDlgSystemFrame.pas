{**************************************************************************************************}
{                                                                                                  }
{ Project JEDI Code Library (JCL)                                                                  }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is JclOtaExcDlgSystemFrame.pas.                                                }
{                                                                                                  }
{ The Initial Developer of the Original Code is Florent Ouchet                                     }
{         <outchy att users dott sourceforge dott net>                                             }
{ Portions created by Florent Ouchet are Copyright (C) of Florent Ouchet. All rights reserved.     }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Last modified: $Date:: 2008-09-24 22:40:10 +0200 (mer., 24 sept. 2008)                         $ }
{ Revision:      $Rev:: 2496                                                                     $ }
{ Author:        $Author:: outchy                                                                $ }
{                                                                                                  }
{**************************************************************************************************}

unit JclOtaExcDlgSystemFrame;

interface

{$I jcl.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  JclOtaExcDlgRepository, JclOtaWizardFrame;

type
  TJclOtaExcDlgSystemPage = class(TJclWizardFrame)
    CheckBoxDelayed: TCheckBox;
    CheckBoxHookDll: TCheckBox;
    CheckBoxLogFile: TCheckBox;
    LabelLogFileName: TLabel;
    EditLogFileName: TEdit;
    CheckBoxModuleList: TCheckBox;
    CheckBoxOSInfo: TCheckBox;
    CheckBoxActiveControls: TCheckBox;
    CheckBoxMainThreadOnly: TCheckBox;
    CheckBoxUnitVersioning: TCheckBox;
    procedure CheckBoxLogFileClick(Sender: TObject);
    procedure CheckBoxModuleListClick(Sender: TObject);
  private
    FParams: TJclOtaExcDlgParams;
    procedure UpdateLogEdits;
  protected
    function GetSupportsNext: Boolean; override;
  public
    constructor Create(AOwner: TComponent; AParams: TJclOtaExcDlgParams); reintroduce;

    procedure PageActivated(Direction: TJclWizardDirection); override;
    procedure PageDesactivated(Direction: TJclWizardDirection); override;

    property Params: TJclOtaExcDlgParams read FParams write FParams;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jcl.svn.sourceforge.net/svnroot/jcl/tags/JCL-1.105-Build3400/jcl/experts/repository/JclOtaExcDlgSystemFrame.pas $';
    Revision: '$Revision: 2496 $';
    Date: '$Date: 2008-09-24 22:40:10 +0200 (mer., 24 sept. 2008) $';
    LogPath: 'JCL\experts\repository'
    );
{$ENDIF UNITVERSIONING}

implementation

{$R *.dfm}

uses
  JclOtaResources;

//=== { TJclOtaExcDlgSystemPage } ============================================

procedure TJclOtaExcDlgSystemPage.CheckBoxLogFileClick(Sender: TObject);
begin
  UpdateLogEdits;
end;

procedure TJclOtaExcDlgSystemPage.CheckBoxModuleListClick(Sender: TObject);
begin
  CheckBoxUnitVersioning.Enabled := CheckBoxModuleList.Checked;
end;

constructor TJclOtaExcDlgSystemPage.Create(AOwner: TComponent;
  AParams: TJclOtaExcDlgParams);
begin
  FParams := AParams;
  inherited Create(AOwner);

  Caption := RsExcDlgSystemOptions;
  CheckBoxDelayed.Caption := RsDelayedStackTrace;
  CheckBoxHookDll.Caption := RsHookDll;
  CheckBoxLogFile.Caption := RsLogTrace;
  LabelLogFileName.Caption := RsFileName;
  CheckBoxModuleList.Caption := RsModuleList;
  CheckBoxUnitVersioning.Caption := RsUnitVersioning;
  CheckBoxOSInfo.Caption := RsOSInfo;
  CheckBoxActiveControls.Caption := RsActiveControls;
  CheckBoxMainThreadOnly.Caption := RsMainThreadOnly;
end;

function TJclOtaExcDlgSystemPage.GetSupportsNext: Boolean;
begin
  Result := (not CheckBoxLogFile.Checked) or (EditLogFileName.Text <> '');
end;

procedure TJclOtaExcDlgSystemPage.PageActivated(Direction: TJclWizardDirection);
begin
  inherited PageActivated(Direction);

  CheckBoxDelayed.Checked := Params.DelayedTrace;
  CheckBoxHookDll.Checked := Params.HookDll;
  CheckBoxLogFile.Checked := Params.LogFile;
  EditLogFileName.Text := Params.LogFileName;
  CheckBoxModuleList.Checked := Params.ModuleList;
  CheckBoxUnitVersioning.Checked := Params.UnitVersioning;
  CheckBoxOSInfo.Checked := Params.OSInfo;
  CheckBoxActiveControls.Checked := Params.ActiveControls;
  CheckBoxMainThreadOnly.Checked := Params.MainThreadOnly;

  UpdateLogEdits;
end;

procedure TJclOtaExcDlgSystemPage.PageDesactivated(
  Direction: TJclWizardDirection);
begin
  inherited PageDesactivated(Direction);

  Params.DelayedTrace := CheckBoxDelayed.Checked;
  Params.HookDll := CheckBoxHookDll.Checked;
  Params.LogFile := CheckBoxLogFile.Checked;
  Params.LogFileName := EditLogFileName.Text;
  Params.ModuleList := CheckBoxModuleList.Checked;
  Params.UnitVersioning := CheckBoxUnitVersioning.Checked;
  Params.OSInfo := CheckBoxOSInfo.Checked;
  Params.ActiveControls := CheckBoxActiveControls.Checked;
  Params.MainThreadOnly := CheckBoxMainThreadOnly.Checked;
end;

procedure TJclOtaExcDlgSystemPage.UpdateLogEdits;
begin
  if CheckBoxLogFile.Checked then
  begin
    EditLogFileName.Enabled := True;
    EditLogFileName.Color := clWindow;
  end
  else
  begin
    EditLogFileName.Enabled := False;
    EditLogFileName.ParentColor := True;
  end;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
