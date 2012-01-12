{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExStdCtrls.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas dott Hausladen att gmx dott de]
Portions created by Andreas Hausladen are Copyright (C) 2003 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvExStdCtrls.pas 11802 2008-05-12 19:54:51Z ahuser $

unit JvExStdCtrls;

{$I jvcl.inc}
{MACROINCLUDE JvExControls.macros}

WARNINGHEADER

interface

uses
  Windows, Messages,
  {$IFDEF HAS_UNIT_TYPES}
  Types,
  {$ENDIF HAS_UNIT_TYPES}
  SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  JvConsts, JvTypes, JvThemes, JVCLVer, JvExControls;

type
  WINCONTROL_DECL_DEFAULT(CustomGroupBox)

  {$DEFINE HASAUTOSIZE}

  CONTROL_DECL_DEFAULT(CustomLabel)

  CONTROL_DECL_DEFAULT(Label)

  {$UNDEF HASAUTOSIZE}

  EDITCONTROL_DECL_DEFAULT(CustomEdit)

  EDITCONTROL_DECL_DEFAULT(CustomMemo)

  {$IFDEF COMPILER6_UP}
  WINCONTROL_DECL_DEFAULT(CustomCombo)
  {$ENDIF COMPILER6_UP}

  WINCONTROL_DECL_DEFAULT(CustomComboBox)

  WINCONTROL_DECL_DEFAULT(ButtonControl)

  WINCONTROL_DECL_DEFAULT(Button)

  WINCONTROL_DECL_DEFAULT(CustomCheckBox)

  WINCONTROL_DECL_DEFAULT(RadioButton)

  WINCONTROL_DECL_DEFAULT(CustomListBox)

  WINCONTROL_DECL_DEFAULT(ScrollBar)

  WINCONTROL_DECL_DEFAULT(GroupBox)

  WINCONTROL_DECL_DEFAULT(CheckBox)

  WINCONTROL_DECL_DEFAULT(CustomStaticText)

  WINCONTROL_DECL_DEFAULT(StaticText)

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_37_PREPARATION/devtools/JvExVCL/src/JvExStdCtrls.pas $';
    Revision: '$Revision: 11802 $';
    Date: '$Date: 2008-05-12 21:54:51 +0200 (lun., 12 mai 2008) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

WINCONTROL_IMPL_DEFAULT(CustomGroupBox)

{$DEFINE HASAUTOSIZE}

CONTROL_IMPL_DEFAULT(CustomLabel)

CONTROL_IMPL_DEFAULT(Label)

{$UNDEF HASAUTOSIZE}

EDITCONTROL_IMPL_DEFAULT(CustomEdit)

EDITCONTROL_IMPL_DEFAULT(CustomMemo)

{$IFDEF COMPILER6_UP}
WINCONTROL_IMPL_DEFAULT(CustomCombo)
{$ENDIF COMPILER6_UP}

WINCONTROL_IMPL_DEFAULT(CustomComboBox)

WINCONTROL_IMPL_DEFAULT(ButtonControl)

WINCONTROL_IMPL_DEFAULT(Button)

WINCONTROL_IMPL_DEFAULT(CustomCheckBox)

WINCONTROL_IMPL_DEFAULT(RadioButton)

WINCONTROL_IMPL_DEFAULT(CustomListBox)

WINCONTROL_IMPL_DEFAULT(ScrollBar)

WINCONTROL_IMPL_DEFAULT(GroupBox)

WINCONTROL_IMPL_DEFAULT(CheckBox)

WINCONTROL_IMPL_DEFAULT(CustomStaticText)

WINCONTROL_IMPL_DEFAULT(StaticText)

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
