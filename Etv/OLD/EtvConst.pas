Unit EtvConst;

Interface
Uses Windows;

Const
  DefaultHeadColor=10930928{clCream - use as lookup datalist head color};

  ShortCutHome=16420; {Ctrl+Home}
  ShortCutPrior=VK_PRIOR;
  ShortCutNext=VK_NEXT;
  ShortCutEnd=16419; {Ctrl+End}
  ShortCutIns=16491; {Ctrl+Vk_Add(Gray_Plus)}
  ShortCutDel=16493; {Ctrl+Vk_Subtract(Gray_Minus)}
  ShortCutPost=16470; {Ctrl+V}
  ShortCutCancel=0;
  ShortCutRefresh=vk_F5;
  ShortCutClone=0;
  ShortCutSearch=16454; {Ctrl+F}
  ShortCutSearchAgain=16460; {Ctrl+L}

ResourceString
  SNeedQueryClass='You must define "OtherQueryClass" from unit EtvOther'+#13+
                  'or turn on "BDE_IS_USED" in the Etv.Inc'+#13+
                  'for generation of Query';
  SPropSQLAbsent='Property "SQL" is absent in the dataset';
  {Common}
  SCancelCaption='������';
  SCaseSensitive='��������� �������';
  SFindBtnCaption='�����';
  SPrinterSetup='��������� ��������';

  {EtvTable}
  SError='������ ';
  SAutoCorrectInit='���� �������������';
  SAutoCorrectFieldProcess='���� ��������� ���� ';
  SAutoCorrectFieldLengthProcess='������ ����� ��� ���� ';
  SAutoCorrectFieldOtherProcess='������ DisplayWidth � .. ��� ���� ';
  SAutoCorrectSetTableParams='��������� ���������� �������';
  SLabelPump='��������� �����';
  SLabelPumpTableMissing='����������� ��� �������';
  SLabelPumpAidTables='���� ����������� ��������������� ������';
  SLabelPumpTableProcess='���� ��������� ��������� �������';
  SLabelPumpFieldProcess='���� ��������� ����';
  SLabelPumpFieldCheckLength='�������� ����� ��� ����';
  SLabelPumpFieldLabel='���������� DisplayLabels ��� ����';
  SLabelPumpTableNotFound='������� %s �� �������';
  SLabelPumpView='��������� ����� ��� View';
  SLabelPumpViewFieldsProcess='���� ��������� ����� ��������� �������';
  SSetLengthFieldsByDataError='������ ��� ������� ���� �����';

  {EtvGrid}
  SDialVisibleFields='��������� �����';
  SVisibleFields='������� ����';
  SInvisibleFields='��������� ����';
  SGridPrintError='������ ��� ������ �������';
  SGridPrintRecord='������ ������';
  SGridPrintRecordError='������ ��� ������ ������';
  SGridSetLengthFieldsByDataScan='������ ���� �����';

  {EtvLook}
  SInvalidValue='�������� ��������';
  SInvalidInformation='������������ ����������';

  {EtvTabSheet}
  SGridOrRecord='������� - ���� ������';

  {EtvPopup}
  sCloneRecord='����������� ������';
  sPopupFont='�����';
  sPopupBaseFont='�������� �����';
  sPopupParagraph='�����';
  sPopupSearchReplace='����� / ������';
  sPopupSearchReplaceAgain='����� / ������ �����';
  sPopupCopy='����������';
  sPopupPaste='��������';
  sPopupSelectAll='�������� ���';
  sPopupPrint='������';
  SPopupClear='��������';
{sPopupPicFilter='����������� �����|*.bmp;*.emf;*.ico|��� �����|*.*';}
  SLoadFromFile='��������� �� �����';
  SSaveToFile='�������� � ����';
  SPopupStretch='�������';

  {fBase}
  SOneRecordTabs='�����';
  SGridTabs='�������';
  SListOfFilter='������ ��������';
  SCurrentFilter='������� ������: ';
  SfBaseCaption='����������';
  SButtonReturn='�������';
  SButtonReturnHint='������� ��������';
  SSortingComboHint='����������';
  SFindKeyDialogHint='����� �� ����� ����������';
  SButtonFilterPanelHint='�������';
  SButtonFilterEditHint='�������������� ��������';
  SComboFilterListHint='������ ��������';
  SFilterDlgBtnExternalSetHint='��������� ��������� �������';
  SItemRefresh='���������� ���� ����������';

  SNavFirst='������ ������';
  SNavPrior='���������� ������';
  SNavNext='��������� ������';
  SNavLast='��������� ������';
  SNavInsert='�������� ������';
  SNavDelete='������� ������';
  SNavEdit='������������� ������';
  SNavPost='�������������';
  SNavCancel='������';
  SNavRefresh='�����������';

  {EtvFilt}
  S_Or='���';
  S_And='�';
  S_Not='��';
  S_Number='�';
  S_Null='�����';
  S_Like='~';
  SFilterInvalid='��������� ������� �����������';
  SFilterNumber='������ #';
  SChangeFilterSetAsError='��������� ��������� ������ ��� ����������� �������';
  SFilterLoadError='������ ��� �������� ������ �������';

  {Filter - dialog}
  SFilterDlgCaption='����������� ��������';
  SFilterDlgBtnPredHint='���������� ������';
  SFilterDlgBtnNextHint='��������� ������';
  SFilterDlgBtnAddHint='�������� ������';
  SFilterDlgBtnDeleteHint='������� ������';
  SFilterDlgBtnRestoreHint='������ ������� ���������';
  SFilterDlgFilterNameHint='�������� �������';

  SFilterDlgBtnAddCondCaption='��������';
  SFilterDlgBtnAddCondHint='�������� ������� (Ctrl+�����_����)';
  SFilterDlgBtnDeleteCondCaption='�������';
  SFilterDlgBtnDeleteCondHint='������� ������� (Ctrl+�����_�����)';
  SFilterDlgAutoTotalCaption='"�" ��� ���� �������';

  SFilterDlgBtnSetCaption='���������� �������';
  SFilterDlgBtnSetHint='��������� ������� (�������)';
  SFilterDlgBtnNoneCaption='���������';
  SFilterDlgBtnNoneHint='���������� �������������� �������';
  SFilterDlgBtnCancelHint='������ ��������� ���������';
  SFilterDlgTotalHint=' �������� ������ ����� ���������. ��������,'+#10+
                      ' �1 � (�2 ��� �4), ��� �1 - ������ �������';
  SFilterDlgSubTotalHint=' ������ '' | '' - ����������� ����� �������';
  SFilterDlgAllOrAnyCaption='��� ����';
  SFilterDlgAllOrAnyHint='������� ������ ����������� ��� ���� �������';

  {KeyDld}
  SKeyDlgSortingMissing='���� ���������� ������������! ����� ����������';
  SKeyDlgRecordNotFound='����� ������ �� �������!';
  SKeyDlgGotoNearest='����� ���������?';
  SKeyDlgFieldsEmpty='�� ������ �������� �� ����������! ����� ����������!';
  SKeyDlgCaption='����� �� ����� ����������';
  SKeyDlgNoPartialKey='������ ����������';

  {EtvPrint}
  SPrinterError='������ ��� ����������� � ��������';
  SPrinterOpenDocError='������ ��� �������� ��������� ��� ��������';
  SPrinterOpenFileError='������ ��� �������� ����� ���������';
  SPrinterCloseDocError='������ ��� �������� ���������';
  SPrinterProcessDocError='������ ��� ������ ��������� �� �������';
  SPrinterProcessFileError='������ ��� ������ ��������� � ����';
  SPrinterNothingToPrintError='�������� ������';

  {EtvDataBase}
  SDBPasswordIncorrect='������ ����������!';
  SProgramDown='��������� �����������!';
  SCancelDialPassword='������ ����� ������';

  {EtvPas}
  SCantRun='H��������� ���������';

  {EtvMisc}
  SCloneRecordQuestion='�����������?';

  {DiPara}
  sParagraphName='�����';
  sParagraphFirstIndent='������ ������';
  sParagraphLeftIndent='������ �����';
  sParagraphRightIndent='������ ������';
  sParagraphLeftAlignmentHint='�� ������ ����';
  sParagraphCenterAlignmentHint='�� ������';
  sParagraphRightAlignmentHint='�� ������� ����';
  sParagraphBulletHint='������';

  {DiSearch}
  sSearchSearchCaption='�����';
  sSearchReplaceCaption='������';
  sSearchReplaceAllCaption='�������� ���';
  sSearchLabelFind='�����';
  sSearchLabelReplace='�������� ��';
  sSearchOptions='���������';
  sSearchWholeWord='������ ����� �������';
  sSearchPromtReplace='������ �� ������';
  sSearchScope='��������';
  sSearchGlobal='���';
  sSearchSelected='��������� �����';
  sSearchFrom='������� �';
  sSearchOnly='������ ���';
  sSearchCurrentRecordName='������� ������';
  sSearchOrigin='������';
  sSearchFromCursor='� ������� �������';
  sSearchEntire='� ������ ���������';
  sSearchTextNotFound='������ ''%s'' �� �������';

  {DiPrint}
  sDiPrintCaption='��������� ������';
  sDiPrintCommonTabs='�����';
  sDiPrintTitle='���������';
  sDiPrintCopies='����� �����';
  sDiPrintMode='����� ������';
  sDiPrintTextMode='���������';
  sDiPrintGraphicsMode='�����������';
  sDiPrintFileMode='����';
  sDiPrintPrintRange='��������';
  sDiPrintExample='��������: 1,3,5-12';
  sDiPrintAll='���';
  sDiPrintPages='������';
  sDiPrintPrinter='�������';
  sDiPrintFilenameHint='��� �����';
  sDiPrintPageTabs='��������';
  sDiPrintMargins='����';
  sDiPrintTop='�������';
  sDiPrintLeft='�����';
  sDiPrintRight='������';
  sDiPrintBottom='������';
  sDiPrintPaperSize='������ ������';
  sDiPrintPaperWidth='������';
  sDiPrintPaperHeight='������';
  sDiPrintOrientation='����������';
  sDiPrintPortrait='�������';
  sDiPrintLandscape='���������';
  sDiPrintWOPages='��� ������� (����� ��������� � ����)';
  sDiPrintNumberingTabS='���������';
  sDiPrintNumberingPosition='���������';
  sDiPrintNumberFirst='����� ������ ��������';
  sDiPrintNumberFormat='������';
  sDiPrintNumberFirstPage='����� �� ������ ��������';
  sDiPrintNumberTemplate='- # -';
  sDiPrintNumberFont='����� (����������� �����)';
  sDiPrintTextTabS='��������� ������';
  sDiPrintGroupTextMode='��������� �����';
  sDiPrintGroupGraphicsMode='����������� �����';
  sDiPrintInterval='����������� ��������';
  sDiPrintFontDefault='�� ���������';
  sDiPrintFontNormal='�����';
  sDiPrintFontElite='�����';
  sDiPrintFontCond='������';
  sDiPrintFontCondElite='������ �����';
  sDiPrintFontTitle='����� ���������';
  sDiPrintFontText='����� ������';

implementation

end.
