{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvJVCLAboutProperty.PAS, released on 2003-01-07.

The Initial Developer of the Original Code is Michael Beck [mbeck att bigfoot dott com]
Portions created by Michael Beck are Copyright (C) 2002 Michael Beck
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvJVCLAboutEditor.pas 10610 2006-05-19 13:35:08Z elahn $

unit JvJVCLAboutEditor;

{$I jvcl.inc}

interface

uses
  SysUtils,
  {$IFDEF COMPILER6_UP}
  DesignEditors, DesignIntf;
  {$ELSE}
  DsgnIntf;
  {$ENDIF COMPILER6_UP}

type
  TJVCLAboutDialogProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

implementation

uses
  JvJVCLAboutForm, JVCLVer, JvDsgnConsts;

procedure TJVCLAboutDialogProperty.Edit;
begin
  TJvJVCLAboutForm.Execute(False);
end;

function TJVCLAboutDialogProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TJVCLAboutDialogProperty.GetValue: string;
begin
  Result := Format(RsVersions, [JVCL_VERSIONSTRING]);
end;

end.


