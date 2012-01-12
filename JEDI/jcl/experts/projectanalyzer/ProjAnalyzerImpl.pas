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
{ The Original Code is ProjAnalyzerImpl.pas.                                                       }
{                                                                                                  }
{ The Initial Developer of the Original Code is documented in the accompanying                     }
{ help file JCL.chm. Portions created by these individuals are Copyright (C) of these individuals. }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Last modified: $Date:: 2008-09-27 12:26:07 +0200 (sam., 27 sept. 2008)                       $ }
{ Revision:      $Rev:: 2498                                                                     $ }
{ Author:        $Author:: outchy                                                                $ }
{                                                                                                  }
{**************************************************************************************************}

unit ProjAnalyzerImpl;

{$I jcl.inc}

interface

uses
  Classes, Menus, ActnList, ToolsAPI, SysUtils, Graphics, Dialogs, Forms,
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  JclOtaUtils, ProjAnalyzerFrm;

type
  TJclProjectAnalyzerExpert = class(TJclOTAExpert)
  private
    FBuildMenuItem: TMenuItem;
    FBuildAction: TAction;
    {$IFDEF BDS4_UP}
    FProjectManagerNotifierIndex: Integer;
    {$ENDIF BDS4_UP}
    procedure ActionExecute(Sender: TObject);
    procedure ActionUpdate(Sender: TObject);
    procedure AnalyzeProject(const AProject: IOTAProject);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure RegisterCommands; override;
    procedure UnregisterCommands; override;
  end;

  {$IFDEF BDS4_UP}
  TProjectManagerNotifier = class(TNotifierObject, IOTANotifier, INTAProjectMenuCreatorNotifier)
  private
    FProjectAnalyser: TJclProjectAnalyzerExpert;
    FOTAProjectManager: IOTAProjectManager;
    procedure AnalyzeProjectMenuClick(Sender: TObject);
  protected
    { INTAProjectMenuCreatorNotifier }
    function AddMenu(const Ident: string): TMenuItem;
    function CanHandle(const Ident: string): Boolean;
  public
    constructor Create(AProjectAnalyzer: TJclProjectAnalyzerExpert; const AOTAProjectManager: IOTAProjectManager);
  end;
  {$ENDIF BDS4_UP}

// design package entry point
procedure Register;

// expert DLL entry point
function JCLWizardInit(const BorlandIDEServices: IBorlandIDEServices;
  RegisterProc: TWizardRegisterProc;
  var TerminateProc: TWizardTerminateProc): Boolean; stdcall;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jcl.svn.sourceforge.net/svnroot/jcl/tags/JCL-1.105-Build3400/jcl/experts/projectanalyzer/ProjAnalyzerImpl.pas $';
    Revision: '$Revision: 2498 $';
    Date: '$Date: 2008-09-27 12:26:07 +0200 (sam., 27 sept. 2008) $';
    LogPath: 'JCL\experts\projectanalyser'
    );
{$ENDIF UNITVERSIONING}

implementation

{$R ProjAnalyzerIcon.res}

uses
  JclDebug, JclFileUtils, JclOtaConsts, 
  JclOtaResources;

procedure Register;
begin
  try
    RegisterPackageWizard(TJclProjectAnalyzerExpert.Create);
  except
    on ExceptionObj: TObject do
    begin
      JclExpertShowExceptionDialog(ExceptionObj);
      raise;
    end;
  end;
end;

var
  JCLWizardIndex: Integer;

procedure JclWizardTerminate;
begin
  try
    if JCLWizardIndex <> -1 then
      TJclOTAExpertBase.GetOTAWizardServices.RemoveWizard(JCLWizardIndex);
  except
    on ExceptionObj: TObject do
    begin
      JclExpertShowExceptionDialog(ExceptionObj);
    end;
  end;
end;

function JCLWizardInit(const BorlandIDEServices: IBorlandIDEServices;
    RegisterProc: TWizardRegisterProc;
    var TerminateProc: TWizardTerminateProc): Boolean stdcall;
begin
  try
    TerminateProc := JclWizardTerminate;

    JCLWizardIndex := TJclOTAExpertBase.GetOTAWizardServices.AddWizard(TJclProjectAnalyzerExpert.Create);

    Result := True;
  except
    on ExceptionObj: TObject do
    begin
      JclExpertShowExceptionDialog(ExceptionObj);
      Result := False;
    end;
  end;
end;

//=== { TJclProjectAnalyzerExpert } ==========================================

constructor TJclProjectAnalyzerExpert.Create;
begin
  inherited Create(JclProjectAnalyzerExpertName);
end;

destructor TJclProjectAnalyzerExpert.Destroy;
begin
  FreeAndNil(ProjectAnalyzerForm);
  inherited Destroy;
end;

procedure TJclProjectAnalyzerExpert.ActionExecute(Sender: TObject);
var
  ActiveProject: IOTAProject;
begin
  try
    ActiveProject := GetActiveProject;
    if ActiveProject <> nil then
      AnalyzeProject(ActiveProject)
    else
      raise EJclExpertException.CreateTrace(RsENoActiveProject);
  except
    on ExceptionObj: TObject do
    begin
      JclExpertShowExceptionDialog(ExceptionObj);
      raise;
    end;
  end;
end;

procedure TJclProjectAnalyzerExpert.ActionUpdate(Sender: TObject);
var
  ActiveProject: IOTAProject;
  ProjectName: string;
begin
  try
    ActiveProject := GetActiveProject;
    if Assigned(ActiveProject) then
      ProjectName := ExtractFileName(ActiveProject.FileName)
    else
      ProjectName := '';
    FBuildAction.Enabled := Assigned(ActiveProject);
    if not FBuildAction.Enabled then
      ProjectName := RsProjectNone;
    FBuildAction.Caption := Format(RsAnalyzeActionCaption, [ProjectName]);
  except
    on ExceptionObj: TObject do
    begin
      JclExpertShowExceptionDialog(ExceptionObj);
      raise;
    end;
  end;
end;

procedure TJclProjectAnalyzerExpert.AnalyzeProject(const AProject: IOTAProject);
var
  BuildOK, Succ: Boolean;
  ProjOptions: IOTAProjectOptions;
  SaveMapFile: Variant;
  ProjectName, OutputDirectory: string;
  ProjectFileName, MapFileName, ExecutableFileName: TFileName;
begin
  try
    JclDisablePostCompilationProcess := True;

    ProjectFileName := AProject.FileName;
    ProjectName := ExtractFileName(ProjectFileName);
    Succ := False;

    ProjOptions := AProject.ProjectOptions;
    if not Assigned(ProjOptions) then
      raise EJclExpertException.CreateTrace(RsENoProjectOptions);
      
    OutputDirectory := GetOutputDirectory(AProject);
    MapFileName := GetMapFileName(AProject);

    if ProjectAnalyzerForm = nil then
    begin
      ProjectAnalyzerForm := TProjectAnalyzerForm.Create(Application, Settings);
      ProjectAnalyzerForm.Show;
    end;
    ProjectAnalyzerForm.ClearContent;
    ProjectAnalyzerForm.StatusBarText := Format(RsBuildingProject, [ProjectName]);

    SaveMapFile := ProjOptions.Values[MapFileOptionName];
    ProjOptions.Values[MapFileOptionName] := MapFileOptionDetailed;
    // workaround for MsBuild, the project has to be saved (seems useless with Delphi 2007 update 1)
    ProjOptions.ModifiedState := True;
    //TempActiveProject.Save(False, True);

    BuildOK := AProject.ProjectBuilder.BuildProject(cmOTABuild, False);

    ProjOptions.Values[MapFileOptionName] := SaveMapFile;
    // workaround for MsBuild, the project has to be saved (seems useless with Delphi 2007 update 1)
    ProjOptions.ModifiedState := True;
    //TempActiveProject.Save(False, True);

    if BuildOK then
    begin // Build was successful, continue ...
      Succ := FileExists(MapFileName) and FindExecutableName(MapFileName, OutputDirectory, ExecutableFileName);
      if Succ then
      begin // MAP files was created
        ProjectAnalyzerForm.SetFileName(ExecutableFileName, MapFileName, ProjectName);
        ProjectAnalyzerForm.Show;
      end;
      if Integer(SaveMapFile) <> MapFileOptionDetailed then
      begin // delete MAP and DRC file
        DeleteFile(MapFileName);
        DeleteFile(ChangeFileExt(MapFileName, DrcFileExtension));
      end;
    end;
    if not Succ then
    begin
      ProjectAnalyzerForm.StatusBarText := '';
      if BuildOK then
        MessageDlg(RsCantFindFiles, mtError, [mbOk], 0);
    end;
  finally
    JclDisablePostCompilationProcess := False;
  end;
end;

procedure TJclProjectAnalyzerExpert.RegisterCommands;
var
  IDEMainMenu: TMainMenu;
  IDEProjectItem: TMenuItem;
  IDEActionList: TActionList;
  I: Integer;
  ImageBmp: TBitmap;
  NTAServices: INTAServices;
  {$IFDEF BDS4_UP}
  OTAProjectManager: IOTAProjectManager;
  {$ENDIF BDS4_UP}
begin
  inherited RegisterCommands;

  NTAServices := GetNTAServices;

  // create actions
  FBuildAction := TAction.Create(nil);
  FBuildAction.Caption := Format(RsAnalyzeActionCaption, [RsProjectNone]);
  FBuildAction.Visible := True;
  FBuildAction.OnExecute := ActionExecute;
  FBuildAction.OnUpdate := ActionUpdate;
  FBuildAction.Name := JclProjectAnalyzeActionName;
  ImageBmp := TBitmap.Create;
  try
    ImageBmp.LoadFromResourceName(FindResourceHInstance(ModuleHInstance), 'PROJANALYZER');
    FBuildAction.ImageIndex := NTAServices.AddMasked(ImageBmp, clOlive);
  finally
    ImageBmp.Free;
  end;

  // create project manager notifier
  {$IFDEF BDS4_UP}
  OTAProjectManager := GetOTAProjectManager;
  FProjectManagerNotifierIndex := OTAProjectManager.AddMenuCreatorNotifier(TProjectManagerNotifier.Create(Self,
    OTAProjectManager));
  {$ENDIF BDS4_UP}

  // create menu item
  IDEMainMenu := NTAServices.MainMenu;
  IDEProjectItem := nil;
  with IDEMainMenu do
    for I := 0 to Items.Count - 1 do
      if Items[I].Name = 'ProjectMenu' then
      begin
        IDEProjectItem := Items[I];
        Break;
      end;
  if not Assigned(IDEProjectItem) then
    raise EJclExpertException.CreateTrace(RsENoProjectMenuItem);

  with IDEProjectItem do
    for I := 0 to Count - 1 do
      if Items[I].Name = 'ProjectInformationItem' then
      begin
        IDEActionList := TActionList(NTAServices.ActionList);
        if Assigned(Items[I].Action) then
          FBuildAction.Category := TContainedAction(Items[I].Action).Category;
        FBuildAction.ActionList := IDEActionList;
        RegisterAction(FBuildAction);
        FBuildMenuItem := TMenuItem.Create(nil);
        FBuildMenuItem.Name := JclProjectAnalyzeMenuName;
        FBuildMenuItem.Action := FBuildAction;

        IDEProjectItem.Insert(I + 1, FBuildMenuItem);

        System.Break;
      end;
  if not Assigned(FBuildMenuItem.Parent) then
    raise EJclExpertException.CreateTrace(RsAnalyseMenuItemNotInserted);
end;

procedure TJclProjectAnalyzerExpert.UnregisterCommands;
begin
  inherited UnregisterCommands;
  // remove notifier
  {$IFDEF BDS4_UP}
  if FProjectManagerNotifierIndex <> -1 then
    GetOTAProjectManager.RemoveMenuCreatorNotifier(FProjectManagerNotifierIndex);
  {$ENDIF BDS4_UP}

  UnregisterAction(FBuildAction);
  FreeAndNil(FBuildMenuItem);
  FreeAndNil(FBuildAction);
end;

{$IFDEF BDS4_UP}

//=== { TProjectManagerNotifier } ============================================

constructor TProjectManagerNotifier.Create(AProjectAnalyzer: TJclProjectAnalyzerExpert;
  const AOTAProjectManager: IOTAProjectManager);
begin
  inherited Create;
  FProjectAnalyser := AProjectAnalyzer;
  FOTAProjectManager := AOTAProjectManager;
end;

function TProjectManagerNotifier.AddMenu(const Ident: string): TMenuItem;
var
  SelectedIdent: string;
  AProject: IOTAProject;
begin
  try
    SelectedIdent := Ident;
    AProject := FOTAProjectManager.GetCurrentSelection(SelectedIdent);
    if AProject <> nil then
    begin
      // root item
      Result := TMenuItem.Create(nil);
      Result.Visible := True;
      Result.Caption := Format(RsAnalyzeActionCaption, [ExtractFileName(AProject.FileName)]);
      Result.OnClick := AnalyzeProjectMenuClick;
    end
    else
      raise EJclExpertException.CreateTrace(RsENoActiveProject);
  except
    on ExceptionObj: TObject do
    begin
      JclExpertShowExceptionDialog(ExceptionObj);
      raise;
    end;
  end;
end;

procedure TProjectManagerNotifier.AnalyzeProjectMenuClick(Sender: TObject);
var
  TempProject: IOTAProject;
  SelectedIdent: string;
begin
  try
    SelectedIdent := '';
    TempProject := FOTAProjectManager.GetCurrentSelection(SelectedIdent);
    if TempProject <> nil then
      FProjectAnalyser.AnalyzeProject(TempProject)
    else
      raise EJclExpertException.CreateTrace(RsENoActiveProject);
  except
    on ExceptionObj: TObject do
    begin
      JclExpertShowExceptionDialog(ExceptionObj);
      raise;
    end;
  end;
end;

function TProjectManagerNotifier.CanHandle(const Ident: string): Boolean;
begin
  Result := Ident = sProjectContainer;
end;

{$ENDIF BDS4_UP}

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
