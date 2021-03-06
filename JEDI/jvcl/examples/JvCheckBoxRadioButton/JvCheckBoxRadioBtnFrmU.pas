{******************************************************************

                       JEDI-VCL Demo

 Copyright (C) 2002 Project JEDI

 Original author:

 You may retrieve the latest version of this file at the JEDI-JVCL
 home page, located at http://jvcl.sourceforge.net

 The contents of this file are used with permission, subject to
 the Mozilla Public License Version 1.1 (the "License"); you may
 not use this file except in compliance with the License. You may
 obtain a copy of the License at
 http://www.mozilla.org/MPL/MPL-1_1Final.html

 Software distributed under the License is distributed on an
 "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 implied. See the License for the specific language governing
 rights and limitations under the License.

******************************************************************}

unit JvCheckBoxRadioBtnFrmU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvCheckBox, JvRadioButton, Buttons,
  ExtCtrls, JvEdit, JvExControls, JvComponent, JvLabel, ImgList;

type
  TJvCheckBoxRadioBtnFrm = class(TForm)
    chkShowToolTips: TJvCheckBox;
    edPrefix: TJvEdit;
    rbOption1: TJvRadioButton;
    rbOption2: TJvRadioButton;
    rbOption3: TJvRadioButton;
    lblOption1: TJvLabel;
    lblOption2: TJvLabel;
    lblOption3: TJvLabel;
    lblPrefix: TJvLabel;
    ImageList1: TImageList;
    chkShowPrefix: TJvCheckBox;
    lblInfo: TJvLabel;
    JvLabel1: TJvLabel;
  end;

var
  JvCheckBoxRadioBtnFrm: TJvCheckBoxRadioBtnFrm;

implementation

{$R *.dfm}

end.
