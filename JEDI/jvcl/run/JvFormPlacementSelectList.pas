{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Initial Developers of the Original Code is: Jens Fudickar
All Rights Reserved.

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvFormPlacementSelectList.pas 10612 2006-05-19 19:04:09Z jfudickar $

unit JvFormPlacementSelectList;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  SysUtils, Classes,
  JvAppStorage, JvFormPlacement, JvAppStorageSelectList;

type
  TJvFormStorageSelectList = class (TJvAppStorageSelectList)
  private
    FFormStorage: TJvFormStorage;
  protected
    function GetFormStorage: TJvFormStorage; virtual;
    procedure SetFormStorage(Value: TJvFormStorage); virtual;
    function GetAppStorage: TJvCustomAppStorage; override;
    procedure SetAppStorage(Value: TJvCustomAppStorage); override;
    function GetStoragePath: string; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function RestoreFormStorage(const ACaption: string = ''): Boolean;
    function SaveFormStorage(const ACaption: string = ''): Boolean;
  published
    property FormStorage: TJvFormStorage read GetFormStorage write SetFormStorage;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_37_PREPARATION/run/JvFormPlacementSelectList.pas $';
    Revision: '$Revision: 10612 $';
    Date: '$Date: 2006-05-19 21:04:09 +0200 (ven., 19 mai 2006) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

uses
  JvConsts;

function TJvFormStorageSelectList.GetFormStorage: TJvFormStorage;
begin
  Result := FFormStorage;
end;

procedure TJvFormStorageSelectList.SetFormStorage(Value: TJvFormStorage);
begin
  FFormStorage := Value;
end;

function TJvFormStorageSelectList.GetAppStorage: TJvCustomAppStorage;
begin
  if Assigned(FFormStorage) then
    Result := FFormStorage.AppStorage
  else
    Result := nil;
end;

procedure TJvFormStorageSelectList.SetAppStorage(Value: TJvCustomAppStorage);
begin
  if Assigned(FFormStorage) then
    FFormStorage.AppStorage := Value;
end;

function  TJvFormStorageSelectList.GetStoragePath: string;
begin
  if Assigned(AppStorage) then
    Result := AppStorage.ConcatPaths([FormStorage.AppStoragePath, SelectPath])
  else
    Result := FormStorage.AppStoragePath + PathDelim + SelectPath;
end;

procedure TJvFormStorageSelectList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFormStorage) then
    FFormStorage := nil;
end;

function TJvFormStorageSelectList.RestoreFormStorage(const ACaption: string = ''): Boolean;
var
  OldPath: string;
begin
  if Assigned(FormStorage) then
  begin
    OldPath := FormStorage.AppStoragePath;
    FormStorage.AppStoragePath := GetSelectListPath(sloLoad, ACaption);
    Result := FormStorage.AppStoragePath <> '';
    if Result then
      FormStorage.RestoreFormPlacement;
    FormStorage.AppStoragePath := OldPath;
  end
  else
    Result := False;
end;

function TJvFormStorageSelectList.SaveFormStorage(const ACaption: string = ''): Boolean;
var
  OldPath: string;
begin
  if Assigned(FormStorage) then
  begin
    OldPath := FormStorage.AppStoragePath;
    FormStorage.AppStoragePath := GetSelectListPath(sloStore, ACaption);
    Result := FormStorage.AppStoragePath <> '';
    if Result then
      FormStorage.SaveFormPlacement;
    FormStorage.AppStoragePath := OldPath;
  end
  else
    Result := False;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
