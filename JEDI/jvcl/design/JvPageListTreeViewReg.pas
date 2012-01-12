{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPageListTreeViewReg.PAS, released on 2003-01-22.

The Initial Developer of the Original Code is Peter Th�rnqvist [peter3 at sourceforge dot net] .
Portions created by Peter Th�rnqvist are Copyright (C) 2003 Peter Th�rnqvist.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:

-----------------------------------------------------------------------------}
// $Id: JvPageListTreeViewReg.pas 11476 2007-08-18 16:59:46Z ahuser $

unit JvPageListTreeViewReg;

{$I jvcl.inc}

interface

procedure Register;

{$R JvPageListTreeViewReg.dcr}

implementation

uses
  Classes, ImgList, ComCtrls,
  {$IFDEF COMPILER6_UP}
  VCLEditors, DesignEditors, DesignIntf, DesignMenus,
  {$ELSE}
  DsgnIntf, Menus,
  {$ENDIF COMPILER6_UP}
  JvDsgnConsts,
  JvNavigationPane, JvPageList, JvPageListTreeView, JvPageListEditors,
  JvNavPaneEditors, JvTreeItemsEditorForm, JvPageLinkEditorForm, JvPageListEditorForm;

procedure Register;
const
  cItems = 'Items';
  cPageList = 'PageList';
  cActivePage = 'ActivePage';
  cImageIndex = 'ImageIndex';
begin
  RegisterComponents(RsPaletteNavPane, [TJvNavigationPane, TJvNavIconButton, TJvNavPanelButton,
    TJvNavPanelHeader, TJvNavPanelDivider, TJvOutlookSplitter, TJvNavPaneStyleManager, TJvNavPaneToolPanel]);

  RegisterComponents(RsPaletteListComboTree, [TJvSettingsTreeView,
    TJvPageListTreeView, TJvPageList]);

  RegisterPropertyEditor(TypeInfo(TTreeNodes), TCustomTreeView, cItems, TJvTreeItemsProperty);
  RegisterPropertyEditor(TypeInfo(TJvShowDesignCaption), nil, '', TJvShowDesignCaptionProperty);
  RegisterClasses([TJvSettingsTreeView, TJvPageListTreeView, TJvPageList, TJvStandardPage]);
  RegisterComponentEditor(TJvCustomPageList, TJvCustomPageEditor);
  RegisterComponentEditor(TJvCustomPage, TJvCustomPageEditor);
  {$IFDEF COMPILER5}
  RegisterPropertyEditor(TypeInfo(TComponent), TJvCustomPageListTreeView, cPageList, TJvPageListProperty);
  {$ENDIF COMPILER5}
  RegisterComponentEditor(TCustomTreeView, TJvTreeViewEditor);
  RegisterComponentEditor(TJvCustomPageListTreeView, TJvPageTreeViewEditor);
  // register for the standard TTreeView as well
  //  RegisterComponentEditor(TTreeView, TJvTreeViewEditor);
  RegisterPropertyEditor(TypeInfo(TJvPageLinks),
    TJvCustomPageListTreeView, '', TJvPageLinksProperty);
  RegisterPropertyEditor(TypeInfo(TJvCustomPage),
    TJvCustomPageList, cActivePage, TJvActivePageProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvSettingsTreeImages, '', TJvSettingsTreeImagesProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvNavPanelPage, cImageIndex, TJvNavPanePageImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvNavPanelHeader, cImageIndex, TJvNavPanelHeaderImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvNavPanelButton, cImageIndex, TJvNavPanelButtonImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvNavIconButton, cImageIndex, TJvNavIconButtonImageIndexProperty);

  //  RegisterPropertyEditor(TypeInfo(Integer), TJvSettingsTreeImages, 'CollapsedIndex', TJvSettingsTreeImagesProperty);
  //  RegisterPropertyEditor(TypeInfo(Integer), TJvSettingsTreeImages, 'ExpandedIndex', TJvSettingsTreeImagesProperty);
  //  RegisterPropertyEditor(TypeInfo(Integer), TJvSettingsTreeImages, 'ImageIndex', TJvSettingsTreeImagesProperty);
  //  RegisterPropertyEditor(TypeInfo(Integer), TJvSettingsTreeImages, 'SelectedIndex', TJvSettingsTreeImagesProperty);
end;

end.

