{*******************************************************}
{                                                       }
{         Vladimir Gaitanoff Delphi VCL Library         }
{         ConstsRC - russian Consts messages            }
{                                                       }
{         Copyright (c) 1997, 1998                      }
{                                                       }
{*******************************************************}

{$I VG.INC }
{$D-,L-}

unit ConstsRc;

interface

procedure InitResStringsConsts;
procedure FreeResStringsConsts;

implementation
uses Consts, vgUtils;

{$IFDEF _D3_}
resourcestring
  SAssignError                  =  '���������� ��������� %s %s';
  SFCreateError                 =  '���������� ������� ���� %s';
  SFOpenError                   =  '���������� ������� ���� %s';
  SReadError                    =  '������ ������ �� ������';
  SWriteError                   =  '������ ������ � �����';
  SMemoryStreamError            =  '������������ ������ ��� ���������� memory stream';
  SCantWriteResourceStreamError =  '���������� ������ � resource stream, �������� ��� ������';
  SDuplicateReference           =  'WriteObject ������ ������ ��� ������ ����������';
  SClassNotFound                =  '����� %s �� ������';
  SInvalidImage                 =  '������������ ������ ������';
  SResNotFound                  =  '������ %s �� ������';
  SClassMismatch                =  'Resource %s ������������� ������';
  SListIndexError               =  '������ ������ ��� ������';
  SSortedListError              =  '�������� ����������� ��� ������������� ������� �����';
  SDuplicateString              =  '������ ����� �� ��������� ����������';
  SInvalidTabIndex              =  '������ �������� ��� ������';
  SDuplicateName                =  '���������� � ������ %s ��� ����������';
  SInvalidName                  =  '''%s'' - ������������ ��� ��� ����������';
  SDuplicateClass               =  '����� � ������ %s ��� ����������';
  SInvalidInteger               =  '''%s'' �� ������������� ��������';
  SLineTooLong                  =  '������� ������� ������';
  SInvalidPropertyValue         =  '�������� �������� ��������';
  SInvalidPropertyPath          =  '�������� ���� ��������';
  SUnknownProperty              =  '�������� �� ����������';
  SReadOnlyProperty             =  '�������� ������ ��� ������';
  SPropertyException            =  '������ ��� ������ %s.%s: %s';
  SAncestorNotFound             =  '������ ��� ''%s'' �� ������';
  SInvalidBitmap                =  '������������ ��������';
  SInvalidIcon                  =  '������������ ������';
  SInvalidMetafile              =  '������������ ��������';
  SBitmapEmpty                  =  '�������� �����';
  SChangeIconSize               =  '������ �������� ������ ������';
  SUnknownExtension             =  '����������� ���������� ��� ����� � ������������ (.%s)';
  SUnknownClipboardFormat       =  '���������������� ������ ������ ������';
  SOutOfResources               =  '��������� ��������� �������';
  SNoCanvasHandle               =  '������ �� ��������� ��������';
  SInvalidImageSize             =  '�������� ������ �����������';
  STooManyImages                =  '������� ����� �����������';
  SDimsDoNotMatch               =   '������� ����������� �� ������������� �������� ������ �����������';
  SInvalidImageList             =  '�������� ������ �����������';
  SReplaceImage                 =  '������ �������� �����������';
  SImageIndexError              =  '�������� ������ ������ �����������';
  SWindowDCError                =  '������ �������� Device Context ��� ����';
  SClientNotSet                 =  '������ TDrag �� ���������������';
  SWindowClass                  =  '������ �������� ������ ����';
  SWindowCreate                 =  '������ �������� ����';
  SCannotFocus                  =  '������ �������� ����� ������������ ��� ���������� ����';
  SParentRequired               =  '������� ���������� ''%s'' �� ����� ����-��������';
  SMDIChildNotVisible           =  '���������� ������ �������� ����� MDI';
  SVisibleChanged               =  '���������� �������� Visible � OnShow ��� OnHide';
  SCannotShowModal              =  '������ ������� ������� ���� ���������';
  SScrollBarRange               =  '�������� ���������� ��� ������';
  SPropertyOutOfRange           =  '�������� %s ��� ������';
  SMenuIndexError               =  '������ ���� ��� ������';
  SMenuReinserted               =  '���� ��������� ������';
  SMenuNotFound                 =  '������� ��� � ����';
  SNoTimers                     =  '��� ��������� ��������';
  SNotPrinting                  =  '������� ������ �� ��������';
  SPrinting                     =  '���� ������';
  SPrinterIndexError            =  '������ �������� ��� ������';
  SInvalidPrinter               =  '��������� ������� �������';
  SDeviceOnPort                 =  '%s on %s';
  SGroupIndexTooLow             =  'GroupIndex �� ����� ���� ������ ���  GroupIndex �������� ����������� ����';
  STwoMDIForms                  =  '������ ����� ����� ��� ���� MDI ����� �� ����������';
  SNoMDIForm                    =  '���������� ������� �����. ��� �������� MDI �����';
  SRegisterError                =  '������������ ����������� ����������';
  SImageCanvasNeedsBitmap       =  '����������� ����� ��������������, ������ ���� ��� �������� ��������';
  SControlParentSetToSelf       =  '������� ���������� �� ����� ���� ��� ���� ���������';
  SOKButton                     =  'OK';
  SCancelButton                 =  '������';
  SYesButton                    =  '&��';
  SNoButton                     =  '&���';
  SHelpButton                   =  '&�������';
  SCloseButton                  =  '&�������';
  SIgnoreButton                 =  '&�����.';
  SRetryButton                  =  '&���������';
  SAbortButton                  =  '��������';
  SAllButton                    =  '&���';

  SCannotDragForm               =  '���������� ����������� �����';
  SPutObjectError               =  'PutObject ��� ��������������� ��������';
  SCardDLLNotLoaded             =  '���������� ��������� CARDS.DLL';
  SDuplicateCardId              =  '������ �������� CardId';

  SDdeErr                       =  'DDE ������ ������ ($0%x)';
  SDdeConvErr                   =  '������ DDE - ����� �� ����������� ($0%x)';
  SDdeMemErr                    =  '��������� ������ ��� �������� ������ ��� DDE ($0%x)';
  SDdeNoConnect                 =  '��� ����������� ���������� DDE �����';

  SFB                           =  '��';
  SFG                           =  '��';
  SBG                           =  '��';
  SOldTShape                    =  '������ ��������� ������ ������ TShape';
  SVMetafiles                   =  '���������';
  SVEnhMetafiles                =  '����������� ���������';
  SVIcons                       =  '������';
  SVBitmaps                     =  '��������';
  SGridTooLarge                 =  '������� ������� ������� ��� ��������';
  STooManyDeleted               =  '������� ����� ����� ��� �������� �������';
  SIndexOutOfRange              =  '������ ������� ��� ������';
  SFixedColTooBig               =  '����� ������������� �������� ������ ���� ������ ��� ����� ��������';
  SFixedRowTooBig               =  '����� ������������� ����� ������ ���� ������ ��� ����� �����';
  SParseError                   =  '%s � ������ %d';
  SIdentifierExpected           =  '�������� �������������';
  SStringExpected               =  '��������� ������';
  SNumberExpected               =  '��������� �����';
  SCharExpected                 =  '���������''%s'' ';
  SSymbolExpected               =  '��������� %s';
  SInvalidNumber                =  '�������� �����';
  SInvalidString                =  '�������� ��������� ���������';
  SInvalidProperty              =  '�������� �������� ��������';
  SInvalidBinary                =  '�������� �������� ��������';
  SOutlineIndexError            =  'Outline: ������ �� ������';
  SOutlineExpandError           =  '�������� ������ ���� �������';
  SInvalidCurrentItem           =  '�������� �������� ��� �������� ��������';
  SMaskErr                      =  '������� �������� ��������';
  SMaskEditErr                  =  '������� �������� ��������. ����������� Esc ��� ������ ���������';
  SOutlineError                 =  'Outline: �������� ������';
  SOutlineBadLevel              =  '�������� ���������� ������';
  SOutlineSelection             =  '�������� ���������';
  SOutlineFileLoad              =  '����� �������� �����';
  SOutlineLongLine              =  '������� ������� ������';
  SOutlineMaxLevels             =  'Outline: ���������� ������������ �����������';

  SMsgDlgWarning                =  '��������������';
  SMsgDlgError                  =  '������';
  SMsgDlgInformation            =  '����������';
  SMsgDlgConfirm                =  '�������������';
  SMsgDlgYes                    =  '&��';
  SMsgDlgNo                     =  '&���';
  SMsgDlgOK                     =  'OK';
  SMsgDlgCancel                 =  '������';
  SMsgDlgHelp                   =  '&�������';
  SMsgDlgHelpNone               =  '������� �� ��������';
  SMsgDlgHelpHelp               =  '�������';
  SMsgDlgAbort                  =  '��������';
  SMsgDlgRetry                  =  '&���������';
  SMsgDlgIgnore                 =  '&�����.';
  SMsgDlgAll                    =  '&���';

  SmkcBkSp                      =  'BkSp';
  SmkcTab                       =  'Tab';
  SmkcEsc                       =  'Esc';
  SmkcEnter                     =  'Enter';
  SmkcSpace                     =  'Space';
  SmkcPgUp                      =  'PgUp';
  SmkcPgDn                      =  'PgDn';
  SmkcEnd                       =  'End';
  SmkcHome                      =  'Home';
  SmkcLeft                      =  'Left';
  SmkcUp                        =  'Up';
  SmkcRight                     =  'Right';
  SmkcDown                      =  'Down';
  SmkcIns                       =  'Ins';
  SmkcDel                       =  'Del';
  SmkcShift                     =  'Shift+';
  SmkcCtrl                      =  'Ctrl+';
  SmkcAlt                       =  'Alt+';

  srUnknown                     =  '(����������)';
  srNone                        =  '(���)';
  SOutOfRange                   =  '�������� ������ ���� ����� %d � %d';
  SCannotCreateName             =  '������ ������� ��� ������ �� ��������� ��� ���������� ��� �����';

  SDateEncodeError              =  '�������� �������� ��� �������������� � ����';
  STimeEncodeError              =  '�������� �������� ��� �������������� �� �����';
  SInvalidDate                  =  '''%s'' - ������������ ����';
  SInvalidTime                  =  '''%s'' - ����������� �����';
  SInvalidDateTime              =  '''%s'' - ������������ ���� ��� �����';
  SInvalidFileName              =  '������������ ��� ����� - %s';
  SDefaultFilter                =  '��� ����� (*.*)|*.*';
  sAllFilter                    =  '���';
  SNoVolumeLabel                =  ': [ - ��� ����� ���� - ]';
  SInsertLineError              =  '���������� �������� ������';

  SConfirmCreateDir             =  '��������� ����� �� ����������. ������� ?';
  SSelectDirCap                 =  '����� �����';
  SDirNameCap                   =  '���  &�����:';
  SDrivesCap                    =  '&�����:';
  SDirsCap                      =  '&�����:';
  SFilesCap                     =  '&�����: (*.*)';
  SNetworkCap                   =  '&����...';

  SColorPrefix                  =  '����';
  SColorTags                    =  'ABCDEFGHIJKLMNOP';

  SInvalidClipFmt               =  '�������� ������ ������ ������';
  SIconToClipboard              =  '����� ������ �� ������������ ������';

  SDefault                      =  '���������';

  SInvalidMemoSize              =  '����� ������ ��� 32 ��';
  SCustomColors                 =  '����� ������������';
  SInvalidPrinterOp             =  '�������� �� �������������� �� ��������� ��������';
  SNoDefaultPrinter             =  '������� �� ��������� �� ������';

  SIniFileWriteError            =  '��� ����������� ������ � %s';

  SBitsIndexError               =  '������� ������ ��� ������';

  SUntitled                     =  '(��� �����)';

  SInvalidRegType               =  '�������� ��� ������ ��� ''%s''';
  SRegCreateFailed              =  '���� ��� �������� ����� ��� %s';
  SRegSetDataFailed             =  '���� ��� ��������� ���� ��� ''%s''';
  SRegGetDataFailed             =  '���� ��� ��������� ���� ��� ''%s''';

  SUnknownConversion            =  'RichEdit: ���������� ������ �������������� ��� ���������� (.%s)';
  SDuplicateMenus               =  '���� ''%s'' ��� ������������ � ������ �����';

{$ENDIF}

procedure InitResStringsConsts;
begin
{$IFDEF _D3_}
  CopyResString(@SAssignError                  , @Consts.SAssignError                  , True);
  CopyResString(@SFCreateError                 , @Consts.SFCreateError                 , True);
  CopyResString(@SFOpenError                   , @Consts.SFOpenError                   , True);
  CopyResString(@SReadError                    , @Consts.SReadError                    , True);
  CopyResString(@SWriteError                   , @Consts.SWriteError                   , True);
  CopyResString(@SMemoryStreamError            , @Consts.SMemoryStreamError            , True);
  CopyResString(@SCantWriteResourceStreamError , @Consts.SCantWriteResourceStreamError , True);
  CopyResString(@SDuplicateReference           , @Consts.SDuplicateReference           , True);
  CopyResString(@SClassNotFound                , @Consts.SClassNotFound                , True);
  CopyResString(@SInvalidImage                 , @Consts.SInvalidImage                 , True);
  CopyResString(@SResNotFound                  , @Consts.SResNotFound                  , True);
  CopyResString(@SClassMismatch                , @Consts.SClassMismatch                , True);
  CopyResString(@SListIndexError               , @Consts.SListIndexError               , True);
  CopyResString(@SSortedListError              , @Consts.SSortedListError              , True);
  CopyResString(@SDuplicateString              , @Consts.SDuplicateString              , True);    
  CopyResString(@SInvalidTabIndex              , @Consts.SInvalidTabIndex              , True);    
  CopyResString(@SDuplicateName                , @Consts.SDuplicateName                , True);    
  CopyResString(@SInvalidName                  , @Consts.SInvalidName                  , True);    
  CopyResString(@SDuplicateClass               , @Consts.SDuplicateClass               , True);    
  CopyResString(@SInvalidInteger               , @Consts.SInvalidInteger               , True);    
  CopyResString(@SLineTooLong                  , @Consts.SLineTooLong                  , True);
  CopyResString(@SInvalidPropertyValue         , @Consts.SInvalidPropertyValue         , True);
  CopyResString(@SInvalidPropertyPath          , @Consts.SInvalidPropertyPath          , True);
  CopyResString(@SUnknownProperty              , @Consts.SUnknownProperty              , True);    
  CopyResString(@SReadOnlyProperty             , @Consts.SReadOnlyProperty             , True);    
  CopyResString(@SPropertyException            , @Consts.SPropertyException            , True);    
  CopyResString(@SAncestorNotFound             , @Consts.SAncestorNotFound             , True);
  CopyResString(@SInvalidBitmap                , @Consts.SInvalidBitmap                , True);    
  CopyResString(@SInvalidIcon                  , @Consts.SInvalidIcon                  , True);    
  CopyResString(@SInvalidMetafile              , @Consts.SInvalidMetafile              , True);    
  CopyResString(@SBitmapEmpty                  , @Consts.SBitmapEmpty                  , True);
  CopyResString(@SChangeIconSize               , @Consts.SChangeIconSize               , True);    
  CopyResString(@SUnknownExtension             , @Consts.SUnknownExtension             , True);
  CopyResString(@SUnknownClipboardFormat       , @Consts.SUnknownClipboardFormat       , True);
  CopyResString(@SOutOfResources               , @Consts.SOutOfResources               , True);
  CopyResString(@SNoCanvasHandle               , @Consts.SNoCanvasHandle               , True);    
  CopyResString(@SInvalidImageSize             , @Consts.SInvalidImageSize             , True);    
  CopyResString(@STooManyImages                , @Consts.STooManyImages                , True);    
  CopyResString(@SDimsDoNotMatch               , @Consts.SDimsDoNotMatch               , True);    
  CopyResString(@SInvalidImageList             , @Consts.SInvalidImageList             , True);
  CopyResString(@SReplaceImage                 , @Consts.SReplaceImage                 , True);    
  CopyResString(@SImageIndexError              , @Consts.SImageIndexError              , True);
  CopyResString(@SWindowDCError                , @Consts.SWindowDCError                , True);
  CopyResString(@SClientNotSet                 , @Consts.SClientNotSet                 , True);
  CopyResString(@SWindowClass                  , @Consts.SWindowClass                  , True);    
  CopyResString(@SWindowCreate                 , @Consts.SWindowCreate                 , True);    
  CopyResString(@SCannotFocus                  , @Consts.SCannotFocus                  , True);    
  CopyResString(@SParentRequired               , @Consts.SParentRequired               , True);
  CopyResString(@SMDIChildNotVisible           , @Consts.SMDIChildNotVisible           , True);
  CopyResString(@SVisibleChanged               , @Consts.SVisibleChanged               , True);    
  CopyResString(@SCannotShowModal              , @Consts.SCannotShowModal              , True);    
  CopyResString(@SScrollBarRange               , @Consts.SScrollBarRange               , True);    
  CopyResString(@SPropertyOutOfRange           , @Consts.SPropertyOutOfRange           , True);    
  CopyResString(@SMenuIndexError               , @Consts.SMenuIndexError               , True);
  CopyResString(@SMenuReinserted               , @Consts.SMenuReinserted               , True);
  CopyResString(@SMenuNotFound                 , @Consts.SMenuNotFound                 , True);
  CopyResString(@SNoTimers                     , @Consts.SNoTimers                     , True);    
  CopyResString(@SNotPrinting                  , @Consts.SNotPrinting                  , True);
  CopyResString(@SPrinting                     , @Consts.SPrinting                     , True);    
  CopyResString(@SPrinterIndexError            , @Consts.SPrinterIndexError            , True);    
  CopyResString(@SInvalidPrinter               , @Consts.SInvalidPrinter               , True);    
  CopyResString(@SDeviceOnPort                 , @Consts.SDeviceOnPort                 , True);    
  CopyResString(@SGroupIndexTooLow             , @Consts.SGroupIndexTooLow             , True);
  CopyResString(@STwoMDIForms                  , @Consts.STwoMDIForms                  , True);
  CopyResString(@SNoMDIForm                    , @Consts.SNoMDIForm                    , True);
  CopyResString(@SRegisterError                , @Consts.SRegisterError                , True);    
  CopyResString(@SImageCanvasNeedsBitmap       , @Consts.SImageCanvasNeedsBitmap       , True);
  CopyResString(@SControlParentSetToSelf       , @Consts.SControlParentSetToSelf       , True);    
  CopyResString(@SOKButton                     , @Consts.SOKButton                     , True);
  CopyResString(@SCancelButton                 , @Consts.SCancelButton                 , True);    
  CopyResString(@SYesButton                    , @Consts.SYesButton                    , True);    
  CopyResString(@SNoButton                     , @Consts.SNoButton                     , True);    
  CopyResString(@SHelpButton                   , @Consts.SHelpButton                   , True);    
  CopyResString(@SCloseButton                  , @Consts.SCloseButton                  , True);    
  CopyResString(@SIgnoreButton                 , @Consts.SIgnoreButton                 , True);
  CopyResString(@SRetryButton                  , @Consts.SRetryButton                  , True);
  CopyResString(@SAbortButton                  , @Consts.SAbortButton                  , True);
  CopyResString(@SAllButton                    , @Consts.SAllButton                    , True);    

  CopyResString(@SCannotDragForm               , @Consts.SCannotDragForm               , True);    
  CopyResString(@SPutObjectError               , @Consts.SPutObjectError               , True);    
  CopyResString(@SCardDLLNotLoaded             , @Consts.SCardDLLNotLoaded             , True);    
  CopyResString(@SDuplicateCardId              , @Consts.SDuplicateCardId              , True);    

  CopyResString(@SDdeErr                       , @Consts.SDdeErr                       , True);
  CopyResString(@SDdeConvErr                   , @Consts.SDdeConvErr                   , True);
  CopyResString(@SDdeMemErr                    , @Consts.SDdeMemErr                    , True);    
  CopyResString(@SDdeNoConnect                 , @Consts.SDdeNoConnect                 , True);    

  CopyResString(@SFB                           , @Consts.SFB                           , True);
  CopyResString(@SFG                           , @Consts.SFG                           , True);    
  CopyResString(@SBG                           , @Consts.SBG                           , True);    
  CopyResString(@SOldTShape                    , @Consts.SOldTShape                    , True);    
  CopyResString(@SVMetafiles                   , @Consts.SVMetafiles                   , True);
  CopyResString(@SVEnhMetafiles                , @Consts.SVEnhMetafiles                , True);    
  CopyResString(@SVIcons                       , @Consts.SVIcons                       , True);
  CopyResString(@SVBitmaps                     , @Consts.SVBitmaps                     , True);
  CopyResString(@SGridTooLarge                 , @Consts.SGridTooLarge                 , True);
  CopyResString(@STooManyDeleted               , @Consts.STooManyDeleted               , True);    
  CopyResString(@SIndexOutOfRange              , @Consts.SIndexOutOfRange              , True);    
  CopyResString(@SFixedColTooBig               , @Consts.SFixedColTooBig               , True);    
  CopyResString(@SFixedRowTooBig               , @Consts.SFixedRowTooBig               , True);    
  CopyResString(@SParseError                   , @Consts.SParseError                   , True);
  CopyResString(@SIdentifierExpected           , @Consts.SIdentifierExpected           , True);    
  CopyResString(@SStringExpected               , @Consts.SStringExpected               , True);
  CopyResString(@SNumberExpected               , @Consts.SNumberExpected               , True);
  CopyResString(@SCharExpected                 , @Consts.SCharExpected                 , True);
  CopyResString(@SSymbolExpected               , @Consts.SSymbolExpected               , True);    
  CopyResString(@SInvalidNumber                , @Consts.SInvalidNumber                , True);    
  CopyResString(@SInvalidString                , @Consts.SInvalidString                , True);    
  CopyResString(@SInvalidProperty              , @Consts.SInvalidProperty              , True);
  CopyResString(@SInvalidBinary                , @Consts.SInvalidBinary                , True);
  CopyResString(@SOutlineIndexError            , @Consts.SOutlineIndexError            , True);    
  CopyResString(@SOutlineExpandError           , @Consts.SOutlineExpandError           , True);    
  CopyResString(@SInvalidCurrentItem           , @Consts.SInvalidCurrentItem           , True);    
  CopyResString(@SMaskErr                      , @Consts.SMaskErr                      , True);    
  CopyResString(@SMaskEditErr                  , @Consts.SMaskEditErr                  , True);
  CopyResString(@SOutlineError                 , @Consts.SOutlineError                 , True);
  CopyResString(@SOutlineBadLevel              , @Consts.SOutlineBadLevel              , True);
  CopyResString(@SOutlineSelection             , @Consts.SOutlineSelection             , True);    
  CopyResString(@SOutlineFileLoad              , @Consts.SOutlineFileLoad              , True);
  CopyResString(@SOutlineLongLine              , @Consts.SOutlineLongLine              , True);    
  CopyResString(@SOutlineMaxLevels             , @Consts.SOutlineMaxLevels             , True);    

  CopyResString(@SMsgDlgWarning                , @Consts.SMsgDlgWarning                , True);    
  CopyResString(@SMsgDlgError                  , @Consts.SMsgDlgError                  , True);
  CopyResString(@SMsgDlgInformation            , @Consts.SMsgDlgInformation            , True);    
  CopyResString(@SMsgDlgConfirm                , @Consts.SMsgDlgConfirm                , True);
  CopyResString(@SMsgDlgYes                    , @Consts.SMsgDlgYes                    , True);    
  CopyResString(@SMsgDlgNo                     , @Consts.SMsgDlgNo                     , True);
  CopyResString(@SMsgDlgOK                     , @Consts.SMsgDlgOK                     , True);    
  CopyResString(@SMsgDlgCancel                 , @Consts.SMsgDlgCancel                 , True);
  CopyResString(@SMsgDlgHelp                   , @Consts.SMsgDlgHelp                   , True);    
  CopyResString(@SMsgDlgHelpNone               , @Consts.SMsgDlgHelpNone               , True);    
  CopyResString(@SMsgDlgHelpHelp               , @Consts.SMsgDlgHelpHelp               , True);    
  CopyResString(@SMsgDlgAbort                  , @Consts.SMsgDlgAbort                  , True);    
  CopyResString(@SMsgDlgRetry                  , @Consts.SMsgDlgRetry                  , True);    
  CopyResString(@SMsgDlgIgnore                 , @Consts.SMsgDlgIgnore                 , True);
  CopyResString(@SMsgDlgAll                    , @Consts.SMsgDlgAll                    , True);

  CopyResString(@SmkcBkSp                      , @Consts.SmkcBkSp                      , True);    
  CopyResString(@SmkcTab                       , @Consts.SmkcTab                       , True);    
  CopyResString(@SmkcEsc                       , @Consts.SmkcEsc                       , True);    
  CopyResString(@SmkcEnter                     , @Consts.SmkcEnter                     , True);    
  CopyResString(@SmkcSpace                     , @Consts.SmkcSpace                     , True);    
  CopyResString(@SmkcPgUp                      , @Consts.SmkcPgUp                      , True);    
  CopyResString(@SmkcPgDn                      , @Consts.SmkcPgDn                      , True);
  CopyResString(@SmkcEnd                       , @Consts.SmkcEnd                       , True);
  CopyResString(@SmkcHome                      , @Consts.SmkcHome                      , True);
  CopyResString(@SmkcLeft                      , @Consts.SmkcLeft                      , True);    
  CopyResString(@SmkcUp                        , @Consts.SmkcUp                        , True);    
  CopyResString(@SmkcRight                     , @Consts.SmkcRight                     , True);    
  CopyResString(@SmkcDown                      , @Consts.SmkcDown                      , True);
  CopyResString(@SmkcIns                       , @Consts.SmkcIns                       , True);    
  CopyResString(@SmkcDel                       , @Consts.SmkcDel                       , True);    
  CopyResString(@SmkcShift                     , @Consts.SmkcShift                     , True);    
  CopyResString(@SmkcCtrl                      , @Consts.SmkcCtrl                      , True);
  CopyResString(@SmkcAlt                       , @Consts.SmkcAlt                       , True);    

  CopyResString(@SrUnknown                     , @Consts.SrUnknown                     , True);
  CopyResString(@SrNone                        , @Consts.SrNone                        , True);
  CopyResString(@SOutOfRange                   , @Consts.SOutOfRange                   , True);    
  CopyResString(@SCannotCreateName             , @Consts.SCannotCreateName             , True);    

  CopyResString(@SDateEncodeError              , @Consts.SDateEncodeError              , True);    
  CopyResString(@STimeEncodeError              , @Consts.STimeEncodeError              , True);
  CopyResString(@SInvalidDate                  , @Consts.SInvalidDate                  , True);    
  CopyResString(@SInvalidTime                  , @Consts.SInvalidTime                  , True);
  CopyResString(@SInvalidDateTime              , @Consts.SInvalidDateTime              , True);    
  CopyResString(@SInvalidFileName              , @Consts.SInvalidFileName              , True);
  CopyResString(@SDefaultFilter                , @Consts.SDefaultFilter                , True);    
  CopyResString(@SAllFilter                    , @Consts.SAllFilter                    , True);    
  CopyResString(@SNoVolumeLabel                , @Consts.SNoVolumeLabel                , True);    
  CopyResString(@SInsertLineError              , @Consts.SInsertLineError              , True);

  CopyResString(@SConfirmCreateDir             , @Consts.SConfirmCreateDir             , True);    
  CopyResString(@SSelectDirCap                 , @Consts.SSelectDirCap                 , True);    
  CopyResString(@SDirNameCap                   , @Consts.SDirNameCap                   , True);    
  CopyResString(@SDrivesCap                    , @Consts.SDrivesCap                    , True);    
  CopyResString(@SDirsCap                      , @Consts.SDirsCap                      , True);
  CopyResString(@SFilesCap                     , @Consts.SFilesCap                     , True);
  CopyResString(@SNetworkCap                   , @Consts.SNetworkCap                   , True);

  CopyResString(@SColorPrefix                  , @Consts.SColorPrefix                  , True);
  CopyResString(@SColorTags                    , @Consts.SColorTags                    , True);    

  CopyResString(@SInvalidClipFmt               , @Consts.SInvalidClipFmt               , True);    
  CopyResString(@SIconToClipboard              , @Consts.SIconToClipboard              , True);    

  CopyResString(@SDefault                      , @Consts.SDefault                      , True);    

  CopyResString(@SInvalidMemoSize              , @Consts.SInvalidMemoSize              , True);    
  CopyResString(@SCustomColors                 , @Consts.SCustomColors                 , True);
  CopyResString(@SInvalidPrinterOp             , @Consts.SInvalidPrinterOp             , True);    
  CopyResString(@SNoDefaultPrinter             , @Consts.SNoDefaultPrinter             , True);

  CopyResString(@SIniFileWriteError            , @Consts.SIniFileWriteError            , True);

  CopyResString(@SBitsIndexError               , @Consts.SBitsIndexError               , True);    

  CopyResString(@SUntitled                     , @Consts.SUntitled                     , True);

  CopyResString(@SInvalidRegType               , @Consts.SInvalidRegType               , True);
  CopyResString(@SRegCreateFailed              , @Consts.SRegCreateFailed              , True);
  CopyResString(@SRegSetDataFailed             , @Consts.SRegSetDataFailed             , True);
  CopyResString(@SRegGetDataFailed             , @Consts.SRegGetDataFailed             , True);

  CopyResString(@SUnknownConversion            , @Consts.SUnknownConversion            , True);
  CopyResString(@SDuplicateMenus               , @Consts.SDuplicateMenus               , True);
{$ENDIF}
end;

procedure FreeResStringsConsts;
begin
{$IFDEF _D3_}
  RestoreResString(@Consts.SAssignError                  );
  RestoreResString(@Consts.SFCreateError                 );
  RestoreResString(@Consts.SFOpenError                   );
  RestoreResString(@Consts.SReadError                    );
  RestoreResString(@Consts.SWriteError                   );
  RestoreResString(@Consts.SMemoryStreamError            );
  RestoreResString(@Consts.SCantWriteResourceStreamError );
  RestoreResString(@Consts.SDuplicateReference           );
  RestoreResString(@Consts.SClassNotFound                );
  RestoreResString(@Consts.SInvalidImage                 );
  RestoreResString(@Consts.SResNotFound                  );
  RestoreResString(@Consts.SClassMismatch                );
  RestoreResString(@Consts.SListIndexError               );
  RestoreResString(@Consts.SSortedListError              );    
  RestoreResString(@Consts.SDuplicateString              );    
  RestoreResString(@Consts.SInvalidTabIndex              );    
  RestoreResString(@Consts.SDuplicateName                );
  RestoreResString(@Consts.SInvalidName                  );    
  RestoreResString(@Consts.SDuplicateClass               );    
  RestoreResString(@Consts.SInvalidInteger               );
  RestoreResString(@Consts.SLineTooLong                  );
  RestoreResString(@Consts.SInvalidPropertyValue         );
  RestoreResString(@Consts.SInvalidPropertyPath          );
  RestoreResString(@Consts.SUnknownProperty              );    
  RestoreResString(@Consts.SReadOnlyProperty             );    
  RestoreResString(@Consts.SPropertyException            );    
  RestoreResString(@Consts.SAncestorNotFound             );
  RestoreResString(@Consts.SInvalidBitmap                );    
  RestoreResString(@Consts.SInvalidIcon                  );
  RestoreResString(@Consts.SInvalidMetafile              );
  RestoreResString(@Consts.SBitmapEmpty                  );
  RestoreResString(@Consts.SChangeIconSize               );    
  RestoreResString(@Consts.SUnknownExtension             );    
  RestoreResString(@Consts.SUnknownClipboardFormat       );    
  RestoreResString(@Consts.SOutOfResources               );    
  RestoreResString(@Consts.SNoCanvasHandle               );    
  RestoreResString(@Consts.SInvalidImageSize             );    
  RestoreResString(@Consts.STooManyImages                );
  RestoreResString(@Consts.SDimsDoNotMatch               );    
  RestoreResString(@Consts.SInvalidImageList             );
  RestoreResString(@Consts.SReplaceImage                 );
  RestoreResString(@Consts.SImageIndexError              );
  RestoreResString(@Consts.SWindowDCError                );
  RestoreResString(@Consts.SClientNotSet                 );
  RestoreResString(@Consts.SWindowClass                  );    
  RestoreResString(@Consts.SWindowCreate                 );    
  RestoreResString(@Consts.SCannotFocus                  );    
  RestoreResString(@Consts.SParentRequired               );
  RestoreResString(@Consts.SMDIChildNotVisible           );
  RestoreResString(@Consts.SVisibleChanged               );
  RestoreResString(@Consts.SCannotShowModal              );
  RestoreResString(@Consts.SScrollBarRange               );    
  RestoreResString(@Consts.SPropertyOutOfRange           );    
  RestoreResString(@Consts.SMenuIndexError               );    
  RestoreResString(@Consts.SMenuReinserted               );    
  RestoreResString(@Consts.SMenuNotFound                 );    
  RestoreResString(@Consts.SNoTimers                     );    
  RestoreResString(@Consts.SNotPrinting                  );
  RestoreResString(@Consts.SPrinting                     );
  RestoreResString(@Consts.SPrinterIndexError            );    
  RestoreResString(@Consts.SInvalidPrinter               );    
  RestoreResString(@Consts.SDeviceOnPort                 );
  RestoreResString(@Consts.SGroupIndexTooLow             );
  RestoreResString(@Consts.STwoMDIForms                  );
  RestoreResString(@Consts.SNoMDIForm                    );
  RestoreResString(@Consts.SRegisterError                );    
  RestoreResString(@Consts.SImageCanvasNeedsBitmap       );
  RestoreResString(@Consts.SControlParentSetToSelf       );    
  RestoreResString(@Consts.SOKButton                     );
  RestoreResString(@Consts.SCancelButton                 );    
  RestoreResString(@Consts.SYesButton                    );
  RestoreResString(@Consts.SNoButton                     );
  RestoreResString(@Consts.SHelpButton                   );    
  RestoreResString(@Consts.SCloseButton                  );    
  RestoreResString(@Consts.SIgnoreButton                 );    
  RestoreResString(@Consts.SRetryButton                  );
  RestoreResString(@Consts.SAbortButton                  );    
  RestoreResString(@Consts.SAllButton                    );    

  RestoreResString(@Consts.SCannotDragForm               );
  RestoreResString(@Consts.SPutObjectError               );    
  RestoreResString(@Consts.SCardDLLNotLoaded             );    
  RestoreResString(@Consts.SDuplicateCardId              );

  RestoreResString(@Consts.SDdeErr                       );
  RestoreResString(@Consts.SDdeConvErr                   );
  RestoreResString(@Consts.SDdeMemErr                    );
  RestoreResString(@Consts.SDdeNoConnect                 );

  RestoreResString(@Consts.SFB                           );
  RestoreResString(@Consts.SFG                           );
  RestoreResString(@Consts.SBG                           );
  RestoreResString(@Consts.SOldTShape                    );
  RestoreResString(@Consts.SVMetafiles                   );
  RestoreResString(@Consts.SVEnhMetafiles                );
  RestoreResString(@Consts.SVIcons                       );
  RestoreResString(@Consts.SVBitmaps                     );
  RestoreResString(@Consts.SGridTooLarge                 );
  RestoreResString(@Consts.STooManyDeleted               );
  RestoreResString(@Consts.SIndexOutOfRange              );
  RestoreResString(@Consts.SFixedColTooBig               );
  RestoreResString(@Consts.SFixedRowTooBig               );    
  RestoreResString(@Consts.SParseError                   );
  RestoreResString(@Consts.SIdentifierExpected           );
  RestoreResString(@Consts.SStringExpected               );
  RestoreResString(@Consts.SNumberExpected               );
  RestoreResString(@Consts.SCharExpected                 );
  RestoreResString(@Consts.SSymbolExpected               );    
  RestoreResString(@Consts.SInvalidNumber                );    
  RestoreResString(@Consts.SInvalidString                );    
  RestoreResString(@Consts.SInvalidProperty              );
  RestoreResString(@Consts.SInvalidBinary                );
  RestoreResString(@Consts.SOutlineIndexError            );
  RestoreResString(@Consts.SOutlineExpandError           );
  RestoreResString(@Consts.SInvalidCurrentItem           );    
  RestoreResString(@Consts.SMaskErr                      );    
  RestoreResString(@Consts.SMaskEditErr                  );    
  RestoreResString(@Consts.SOutlineError                 );    
  RestoreResString(@Consts.SOutlineBadLevel              );    
  RestoreResString(@Consts.SOutlineSelection             );    
  RestoreResString(@Consts.SOutlineFileLoad              );
  RestoreResString(@Consts.SOutlineLongLine              );
  RestoreResString(@Consts.SOutlineMaxLevels             );    

  RestoreResString(@Consts.SMsgDlgWarning                );
  RestoreResString(@Consts.SMsgDlgError                  );
  RestoreResString(@Consts.SMsgDlgInformation            );
  RestoreResString(@Consts.SMsgDlgConfirm                );
  RestoreResString(@Consts.SMsgDlgYes                    );    
  RestoreResString(@Consts.SMsgDlgNo                     );
  RestoreResString(@Consts.SMsgDlgOK                     );    
  RestoreResString(@Consts.SMsgDlgCancel                 );
  RestoreResString(@Consts.SMsgDlgHelp                   );    
  RestoreResString(@Consts.SMsgDlgHelpNone               );
  RestoreResString(@Consts.SMsgDlgHelpHelp               );
  RestoreResString(@Consts.SMsgDlgAbort                  );    
  RestoreResString(@Consts.SMsgDlgRetry                  );    
  RestoreResString(@Consts.SMsgDlgIgnore                 );    
  RestoreResString(@Consts.SMsgDlgAll                    );

  RestoreResString(@Consts.SmkcBkSp                      );    
  RestoreResString(@Consts.SmkcTab                       );
  RestoreResString(@Consts.SmkcEsc                       );
  RestoreResString(@Consts.SmkcEnter                     );    
  RestoreResString(@Consts.SmkcSpace                     );    
  RestoreResString(@Consts.SmkcPgUp                      );
  RestoreResString(@Consts.SmkcPgDn                      );
  RestoreResString(@Consts.SmkcEnd                       );
  RestoreResString(@Consts.SmkcHome                      );
  RestoreResString(@Consts.SmkcLeft                      );    
  RestoreResString(@Consts.SmkcUp                        );    
  RestoreResString(@Consts.SmkcRight                     );    
  RestoreResString(@Consts.SmkcDown                      );
  RestoreResString(@Consts.SmkcIns                       );    
  RestoreResString(@Consts.SmkcDel                       );
  RestoreResString(@Consts.SmkcShift                     );
  RestoreResString(@Consts.SmkcCtrl                      );
  RestoreResString(@Consts.SmkcAlt                       );    

  RestoreResString(@Consts.SrUnknown                     );    
  RestoreResString(@Consts.SrNone                        );    
  RestoreResString(@Consts.SOutOfRange                   );    
  RestoreResString(@Consts.SCannotCreateName             );

  RestoreResString(@Consts.SDateEncodeError              );    
  RestoreResString(@Consts.STimeEncodeError              );
  RestoreResString(@Consts.SInvalidDate                  );
  RestoreResString(@Consts.SInvalidTime                  );
  RestoreResString(@Consts.SInvalidDateTime              );
  RestoreResString(@Consts.SInvalidFileName              );
  RestoreResString(@Consts.SDefaultFilter                );    
  RestoreResString(@Consts.SAllFilter                    );    
  RestoreResString(@Consts.SNoVolumeLabel                );    
  RestoreResString(@Consts.SInsertLineError              );

  RestoreResString(@Consts.SConfirmCreateDir             );
  RestoreResString(@Consts.SSelectDirCap                 );
  RestoreResString(@Consts.SDirNameCap                   );    
  RestoreResString(@Consts.SDrivesCap                    );    
  RestoreResString(@Consts.SDirsCap                      );    
  RestoreResString(@Consts.SFilesCap                     );    
  RestoreResString(@Consts.SNetworkCap                   );    

  RestoreResString(@Consts.SColorPrefix                  );
  RestoreResString(@Consts.SColorTags                    );

  RestoreResString(@Consts.SInvalidClipFmt               );    
  RestoreResString(@Consts.SIconToClipboard              );

  RestoreResString(@Consts.SDefault                      );

  RestoreResString(@Consts.SInvalidMemoSize              );    
  RestoreResString(@Consts.SCustomColors                 );
  RestoreResString(@Consts.SInvalidPrinterOp             );    
  RestoreResString(@Consts.SNoDefaultPrinter             );

  RestoreResString(@Consts.SIniFileWriteError            );

  RestoreResString(@Consts.SBitsIndexError               );    

  RestoreResString(@Consts.SUntitled                     );    

  RestoreResString(@Consts.SInvalidRegType               );    
  RestoreResString(@Consts.SRegCreateFailed              );    
  RestoreResString(@Consts.SRegSetDataFailed             );
  RestoreResString(@Consts.SRegGetDataFailed             );

  RestoreResString(@Consts.SUnknownConversion            );
  RestoreResString(@Consts.SDuplicateMenus               );
{$ENDIF}
end;

{$IFDEF _D3_}
initialization

finalization
  FreeResStringsConsts;
{$ENDIF}

end.
