{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvInterpreterReg.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is John Doe.
Portions created by John Doe are Copyright (C) 2003 John Doe.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvInterpreterReg.pas 11601 2007-12-15 13:55:52Z ahuser $

unit JvInterpreterReg;

{$I jvcl.inc}

interface

procedure Register;

implementation

uses
  Classes,
  {$IFDEF COMPILER6_UP}
  DesignEditors, DesignIntf,
  {$ELSE}
  DsgnIntf,
  {$ENDIF COMPILER6_UP}
  JvDsgnConsts, JvDsgnConfig,
  JvInterpreterParser, JvInterpreter, JvInterpreter_all,
  JvInterpreter_Buttons, JvInterpreter_Classes,
  JvInterpreter_ComCtrls, JvInterpreter_Contnrs, JvInterpreter_Controls,
  {$IFNDEF DelphiPersonalEdition}
  JvInterpreter_Db, JvInterpreter_DbCtrls, JvInterpreter_DbGrids,
  JvInterpreter_DBTables,
   {$IFDEF INTERNET_COMPONENTS}
  JvInterpreter_httpapp,
   {$ENDIF INTERNET_COMPONENTS}
  {$IFDEF JVCL_UseQuickReport}
  JvInterpreter_Quickrpt,
  {$ENDIF JVCL_UseQuickReport}
  {$ENDIF !DelphiPersonalEdition}
  JvInterpreter_Dialogs, JvInterpreter_ExtCtrls, JvInterpreter_Forms,
  JvInterpreter_Graphics, JvInterpreter_Grids, JvInterpreter_JvEditor,
  JvInterpreter_JvInterpreter, JvInterpreter_JvUtils,
  JvInterpreter_Menus, JvInterpreter_StdCtrls, JvInterpreter_System,
  JvInterpreter_SysUtils, JvInterpreter_Types, JvInterpreter_Windows,
  JvInterpreterConst, JvInterpreterFm, JvDsgnEditors;

{$R JvInterpreterReg.dcr}

procedure Register;
begin
  RegisterComponents(RsPaletteInterpreter, [TJvInterpreterProgram, TJvInterpreterFm]);
  {$IFDEF JvInterpreter_INTEGERPROPERTY}
  if JvOptionRegisterGlobalDesignEditors then
  begin
    RegisterPropertyEditor(TypeInfo(Integer), TObject, '', TJvIntegerProperty);
    RegisterPropertyEditor(TypeInfo(Cardinal), TObject, '', TJvIntegerProperty);
    RegisterPropertyEditor(TypeInfo(Longint), TObject, '', TJvIntegerProperty);
    RegisterPropertyEditor(TypeInfo(Smallint), TObject, '', TJvIntegerProperty);
    RegisterPropertyEditor(TypeInfo(Shortint), TObject, '', TJvIntegerProperty);
    RegisterPropertyEditor(TypeInfo(Word), TObject, '', TJvIntegerProperty);
    RegisterPropertyEditor(TypeInfo(Byte), TObject, '', TJvIntegerProperty);
  end;
  {$ENDIF JvInterpreter_INTEGERPROPERTY}
end;

end.
