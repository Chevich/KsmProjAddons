{*******************************************************}
{                                                       }
{         Vladimir Gaitanoff Delphi VCL Library         }
{         DBCnstRC - russian DBConsts messages          }
{                                                       }
{         Copyright (c) 1997, 1998                      }
{                                                       }
{*******************************************************}

{$I VG.INC }
{$D-,L-}

unit DBCnstRC;

interface
uses SysUtils, Forms, Dialogs;

procedure InitResStringsDBConsts;
procedure FreeResStringsDBConsts;

implementation
uses DBConsts, vgUtils;

{$IFDEF _D3_}

resourcestring
//  SDuplicateDatabaseName         = '������������� ��� ���� ������ ''%s''';
//  SDuplicateSessionName          = '������������� ��� ������ ''%s''';
//  SInvalidSessionName            = '�������� ��� ������ %s';
//  SDatabaseNameMissing           = '�� ������� ����� ���� ������';
//  SSessionNameMissing            = '����������� ��� ������';
//  SDatabaseOpen                  = '������ ��������� ������ �������� �� �������� ���� ������';
//  SDatabaseClosed                = '������ ��������� ������ �������� �� �������� ���� ������';
//  SDatabaseHandleSet             = 'Handle ����������� ������ ������';
  SDataSetOpen                   = '������ ��������� ������ �������� �� �������� ������ ������';
  SDataSetClosed                 = '������ ��������� ������ �������� �� �������� ������ ������';
//  SSessionActive                 = '������ ��������� ������ �������� ��� �������� ������';
//  SHandleError                   = '������ �������� ����������� �������';
//  SUnknownFieldType              = '���� ''%s'' ����������� ����';
{$IFDEF _D4_}
  SFieldNotFound                 = '���� ''%s'' �� �������';
{$ELSE}
  SFieldNotFound                 = '%s: ���� ''%s'' �� �������';
{$ENDIF}
  SDataSetMissing                = '���� ''%s''  �� ������� � ������� ������';
  SDataSetEmpty                  = '������ ��������� ������ �������� �� ������ ������ ������';
  SFieldTypeMismatch             = '���� ''%s'' �� ���������� ����';
//  SInvalidFloatField             = '���������� ������������� ���� ''%s'' � ����� � ��������� ������';
//  SInvalidIntegerField           = '���������� ������������� ���� ''%s'' � ����� �����';
  SFieldRangeError               = '%g �������� �������� ��� ���� ''%s''. ���������� �������� �� %g �� %g';
  SInvalidIntegerValue           = '''%s'' �������� ������������� �������� ��� ���� ''%s''';
  SInvalidFloatValue             = '''%s'' �������� �������� � ��������� ������ ��� ���� ''%s''';
  SInvalidBoolValue              = '''%s'' �������� ���������� �������� ��� ���� ''%s''';
  SNotEditing                    = '����� ������ �� ��������� � ������ ������� ��� ������';
//  STableMismatch                 = '�������� � �������� ������� ������������';
  SDataSetReadOnly               = '������ �������������� ������� "������ ��� ������"';
  SFieldReadOnly                 = '���� ''%s'' ������ ��������';
  SNotIndexField                 = '���� ''%s'' �� ������������� � �� ����� ���� ��������';
  SFieldRequired                 = '���� ''%s'' ������ ����� ��������';
  SFieldAccessError              = '������ ���������� � ���� ''%s'' ��� � ���� %s';
//  SFieldAssignError              = '���� ''%s'' � ''%s'' �� ���������� �� ����������';
  SFieldValueError               = '������������ �������� ��� ���� ''%s''';
//  SFieldUndefinedType            = '���� ''%s'' ����������� ����';
//  SFieldUnsupportedType          = '���� ''%s'' ����������������� ����';
  SInvalidCalcType               = '���� ''%s'' �� ����� ���� �����������';
  SInvalidFieldSize              = '������������ ������ ����';
  SCircularDataLink              = '�������� ����� �� ���������';
  SFieldIndexError               = '������ ���� ��� ���������';
//  SCompositeIndexError           = 'Cannot use array of Field values with Expression Indices';
  SNoFieldIndexes                = '��� �������� ��������';
  SIndexFieldMissing             = '��� ������� � ���������� ���� ''%s''';
  SDuplicateFieldName            = '������������� ��� ���� ''%s''';
  SDuplicateIndexName            = '������������� ��� ������� ''%s''';
  SFieldNameMissing              = '����������� ��� ����';
  SNoIndexForFields              = '� ������� ''%s'' ��� ������� �� ���� ''%s''';
  STextFalse                     = '����';
  STextTrue                      = '������';
//  SInvalidBatchMove              = '�������� �������� �������� ��������';
//  SEmptySQLStatement             = '��� ���������� ���������� ����������';
//  SNoParameterValue              = '�� ������ �������� ��������� ''%s''';
//  SNoParameterType               = '�� ����� ��� ��������� ''%s''';
//  SParameterNotFound             = '�������� ''%s'' �� ������';
//  SParamAccessError              = '�������� ��� ��� ��������� � ��������� ''%s'' ';
//  SLoginError                    = '���������� ���������� ����� � ����� ������ ''%s''';
//  SBeginTransError               = '���� ������ %s ��� ����� �������� ����������';
//  SEndTransError                 = '���� ������ %s �� ����� �������� ����������';
//  SInitError                     = '������ ��� ������� ������������� Borland Database Engine ( $%.4x)';
//  SDatasetDesigner               = 'Fields &Editor...';
//  SDatabaseEditor                = 'Database &Editor...';
//  SExplore                       = 'E&xplore';
//  SDesignLoadFailed              = '��� ����������� ��������� RPTSMITH.EXE';
//  SRunLoadFailed                 = '��� ����������� ��������� RS_RUN.EXE';
//  SInvalidServer                 = '�������� ��� �������';
//  SReportVerb                    = 'Edit Report...';
//  SIncorrectVersion              = '���������� ����� ����� ����� ������ ReportSmith';
//  SCannotGetVersionInfo          = '���������� ������� ���������� � ������ �� %s';
//  SUnableToLoadAPIDLL            = '��� ����������� ��������� ReportSmith DLL: %s';
//  SNoFile                        = '��������� Reportsmith ���� ''%s'' �� ����������';
  SFirstRecord                   = '������ ������';
  SPriorRecord                   = '���������� ������';
  SNextRecord                    = '��������� ������';
  SLastRecord                    = '��������� ������';
  SInsertRecord                  = '�������� ������';
  SDeleteRecord                  = '������� ������';
  SEditRecord                    = '������� ������';
  SPostEdit                      = '������������� ���������';
  SCancelEdit                    = '�������� ���������';
  SRefreshRecord                 = '�������� ������';
  SDeleteRecordQuestion          = '������� ������?';
  SDeleteMultipleRecordsQuestion = '������� ��� ��������� ������?';
//  SReportFilter                  = '����� ������� (*.rpt)|*.rpt';
//  SInvalidFieldRegistration      = '�������� ����������� ����';
//  SLinkDesigner                  = '���� ''%s'', �� ������ Detail Fields, ������ ���� ���������';
//  SLinkDetail                    = '������� ''%s'' �� ����� ���� �������';
//  SLinkMasterSource              = '�������� MasterSource � ''%s'' ������ ���� ��������� � DataSource';
//  SLinkMaster                    = '��� ����������� ������� MasterSource �������';
  STooManyColumns                = 'Grid ������� ������ �� ����������� ����� ��� 256 ��������';
//  SIDAPILangID                   = '0009';
//  SDisconnectDatabase            = '���� ������ ������ ������������. ����������� � ����������?';
//  SBDEError                      = '������ BDE $%.4x';
//  SLookupSourceError             = '������ ������������ ������������� DataSource � LookupSource';
//  SLookupTableError              = 'LookupSource ������ ���� ����������� � ���������� TTable';
//  SLookupIndexError              = '%s ������ ���� �������� �������� � ������� ��� ������';
//  SParameterTypes                = ';Input;Output;Input/Output;Result';
//  SInvalidParamFieldType         = '������ ���� ������ ������ ��� ����';
//  STruncationError               = '�������� ''%s'' ������ ��� ������';
//  SInvalidVersion                = '��� ����������� ��������� ��������� ������';
//  SNoIndexFiles                  = '(���)';
//  SIndexDoesNotExist             = '������ �� ����������. ������: %s';
//  SNoTableName                   = '�� ������� �������� TableName';
//  SBatchExecute                  = 'Execute';
//  SNoCachedUpdates               = '�� � ������ cached update';
//  SNoOldValueUpdate              = '��� ����������� �������� ������ ��������';
  SLookupInfoError               = 'Lookup-���������� ��� ���� ''%s''  ������������';
//  SInvalidAliasName              = '�������� ��� ���������� %s';
  SDataSourceChange              = 'DataSource �� ����� ���� �������';
  SExprTermination               = '����������� ��������� ��������� �������';
  SExprNameError                 = '����������� ��� ����';
  SExprStringError               = '����������� ��������� ���������';
  SExprInvalidChar               = '������������ ������ � ��������� �������: ''%s''';
  SExprNoRParen                  = ''')'' ���������, �� ������� %s';
  SExprExpected                  = '��������� �����������, �� ������� %s';
//  SExprBadCompare                = '��������� ��������� ��������� ���� � ���������';
  SExprBadField                  = '���� ''%s'' �� ����� ���� ������������ � ��������� �������';
  SExprBadNullTest               = '����� Null ��������� ���� ��������� � "=" � "<>"';
  SExprRangeError                = '�������� ��������� ��� ������';
  SExprNotBoolean                = '���� ''%s'' �� ����������� ����';
  SExprIncorrect                 = '������� ������������ ��������� �������';
  SExprNothing                   = 'nothing';
//  SNoFieldAccess                 = '��� ������� � ���� ''%s'' ��� ����������';
  SNotReplicatable               = '������� ���������� �� ����� �������������� ��������� � DBCtrlGrid';
  SPropDefByLookup               = '�������� ��� ���������� lookup-�����';
  SDataSourceFixed               = '�������� �� ����������� � DBCtrlGrid';
  SFieldOutOfRange               = '�������� ���� ''%s'' ��� ������';
  SBCDOverflow                   = '(������������)';
//  SUpdateWrongDB                 = '��� ����������� ��������������, %s �� ������� %s';
//  SUpdateFailed                  = '���� ��� ���������';
  SInvalidVarByteArray           = 'Invalid variant type or size';
//  SSQLGenSelect                  = '���������� ������� �� ������� ���� ���� �������� ���� � ���� ���������� ����';
//  SSQLNotGenerated               = 'UpdateSQL- ��������� �� �������������, ��� ����� �����?';
//  SSQLDataSetOpen                = '���������� ���������� ����� ����� ��� %s';
//  SOldNewNonData                 = '���� %s - ��� �� ���� ������';  SLocalTransDirty               = 'The transaction isolation level must be dirty read for local databases';
//  SMemoTooLarge                  = '(Memo too large)';

{$ENDIF}

procedure InitResStringsDBConsts;
begin
{$IFDEF _D3_}
  CopyResString(@SDataSetOpen                   , @DBConsts.SDataSetOpen                   , True);
  CopyResString(@SDataSetClosed                 , @DBConsts.SDataSetClosed                 , True);
  CopyResString(@SUnknownFieldType              , @DBConsts.SUnknownFieldType              , True);
  CopyResString(@SFieldNotFound                 , @DBConsts.SFieldNotFound                 , True);
  CopyResString(@SDataSetMissing                , @DBConsts.SDataSetMissing                , True);
  CopyResString(@SDataSetEmpty                  , @DBConsts.SDataSetEmpty                  , True);
  CopyResString(@SFieldTypeMismatch             , @DBConsts.SFieldTypeMismatch             , True);
  CopyResString(@SFieldRangeError               , @DBConsts.SFieldRangeError               , True);
  CopyResString(@SInvalidIntegerValue           , @DBConsts.SInvalidIntegerValue           , True);
  CopyResString(@SInvalidFloatValue             , @DBConsts.SInvalidFloatValue             , True);
  CopyResString(@SInvalidBoolValue              , @DBConsts.SInvalidBoolValue              , True);
  CopyResString(@SNotEditing                    , @DBConsts.SNotEditing                    , True);
  CopyResString(@SDataSetReadOnly               , @DBConsts.SDataSetReadOnly               , True);
  CopyResString(@SFieldReadOnly                 , @DBConsts.SFieldReadOnly                 , True);
  CopyResString(@SNotIndexField                 , @DBConsts.SNotIndexField                 , True);
  CopyResString(@SFieldRequired                 , @DBConsts.SFieldRequired                 , True);
  CopyResString(@SFieldAccessError              , @DBConsts.SFieldAccessError              , True);
  CopyResString(@SFieldValueError               , @DBConsts.SFieldValueError               , True);
  CopyResString(@SInvalidCalcType               , @DBConsts.SInvalidCalcType               , True);
  CopyResString(@SInvalidFieldSize              , @DBConsts.SInvalidFieldSize              , True);
  CopyResString(@SCircularDataLink              , @DBConsts.SCircularDataLink              , True);
  CopyResString(@SFieldIndexError               , @DBConsts.SFieldIndexError               , True);
  CopyResString(@SNoFieldIndexes                , @DBConsts.SNoFieldIndexes                , True);
  CopyResString(@SIndexFieldMissing             , @DBConsts.SIndexFieldMissing             , True);
  CopyResString(@SDuplicateFieldName            , @DBConsts.SDuplicateFieldName            , True);
  CopyResString(@SDuplicateIndexName            , @DBConsts.SDuplicateIndexName            , True);
  CopyResString(@SFieldNameMissing              , @DBConsts.SFieldNameMissing              , True);
  CopyResString(@SNoIndexForFields              , @DBConsts.SNoIndexForFields              , True);
  CopyResString(@STextFalse                     , @DBConsts.STextFalse                     , True);
  CopyResString(@STextTrue                      , @DBConsts.STextTrue                      , True);
  CopyResString(@SFirstRecord                   , @DBConsts.SFirstRecord                   , True);
  CopyResString(@SPriorRecord                   , @DBConsts.SPriorRecord                   , True);
  CopyResString(@SNextRecord                    , @DBConsts.SNextRecord                    , True);
  CopyResString(@SLastRecord                    , @DBConsts.SLastRecord                    , True);
  CopyResString(@SInsertRecord                  , @DBConsts.SInsertRecord                  , True);
  CopyResString(@SDeleteRecord                  , @DBConsts.SDeleteRecord                  , True);
  CopyResString(@SEditRecord                    , @DBConsts.SEditRecord                    , True);
  CopyResString(@SPostEdit                      , @DBConsts.SPostEdit                      , True);
  CopyResString(@SCancelEdit                    , @DBConsts.SCancelEdit                    , True);
  CopyResString(@SRefreshRecord                 , @DBConsts.SRefreshRecord                 , True);
  CopyResString(@SDeleteRecordQuestion          , @DBConsts.SDeleteRecordQuestion          , True);
  CopyResString(@SDeleteMultipleRecordsQuestion , @DBConsts.SDeleteMultipleRecordsQuestion , True);
  CopyResString(@STooManyColumns                , @DBConsts.STooManyColumns                , True);
  CopyResString(@SLookupInfoError               , @DBConsts.SLookupInfoError               , True);
  CopyResString(@SDataSourceChange              , @DBConsts.SDataSourceChange              , True);
  CopyResString(@SExprTermination               , @DBConsts.SExprTermination               , True);
  CopyResString(@SExprNameError                 , @DBConsts.SExprNameError                 , True);
  CopyResString(@SExprStringError               , @DBConsts.SExprStringError               , True);
  CopyResString(@SExprInvalidChar               , @DBConsts.SExprInvalidChar               , True);
  CopyResString(@SExprNoRParen                  , @DBConsts.SExprNoRParen                  , True);
  CopyResString(@SExprExpected                  , @DBConsts.SExprExpected                  , True);
  CopyResString(@SExprBadField                  , @DBConsts.SExprBadField                  , True);
  CopyResString(@SExprBadNullTest               , @DBConsts.SExprBadNullTest               , True);
  CopyResString(@SExprRangeError                , @DBConsts.SExprRangeError                , True);
  CopyResString(@SExprNotBoolean                , @DBConsts.SExprNotBoolean                , True);
  CopyResString(@SExprIncorrect                 , @DBConsts.SExprIncorrect                 , True);
  CopyResString(@SExprNothing                   , @DBConsts.SExprNothing                   , True);
  CopyResString(@SNotReplicatable               , @DBConsts.SNotReplicatable               , True);
  CopyResString(@SPropDefByLookup               , @DBConsts.SPropDefByLookup               , True);
  CopyResString(@SDataSourceFixed               , @DBConsts.SDataSourceFixed               , True);
  CopyResString(@SFieldOutOfRange               , @DBConsts.SFieldOutOfRange               , True);
  CopyResString(@SBCDOverflow                   , @DBConsts.SBCDOverflow                   , True);
  CopyResString(@SInvalidVarByteArray           , @DBConsts.SInvalidVarByteArray           , True);
{$ENDIF}
end;

procedure FreeResStringsDBConsts;
begin
{$IFDEF _D3_}
  RestoreResString(@DBConsts.SDataSetOpen                   );
  RestoreResString(@DBConsts.SDataSetClosed                 );
  RestoreResString(@DBConsts.SUnknownFieldType              );
  RestoreResString(@DBConsts.SFieldNotFound                 );
  RestoreResString(@DBConsts.SDataSetMissing                );
  RestoreResString(@DBConsts.SDataSetEmpty                  );
  RestoreResString(@DBConsts.SFieldTypeMismatch             );
  RestoreResString(@DBConsts.SFieldRangeError               );
  RestoreResString(@DBConsts.SInvalidIntegerValue           );
  RestoreResString(@DBConsts.SInvalidFloatValue             );
  RestoreResString(@DBConsts.SInvalidBoolValue              );
  RestoreResString(@DBConsts.SNotEditing                    );
  RestoreResString(@DBConsts.SDataSetReadOnly               );
  RestoreResString(@DBConsts.SFieldReadOnly                 );
  RestoreResString(@DBConsts.SNotIndexField                 );
  RestoreResString(@DBConsts.SFieldRequired                 );
  RestoreResString(@DBConsts.SFieldAccessError              );
  RestoreResString(@DBConsts.SFieldValueError               );
  RestoreResString(@DBConsts.SInvalidCalcType               );
  RestoreResString(@DBConsts.SInvalidFieldSize              );
  RestoreResString(@DBConsts.SCircularDataLink              );
  RestoreResString(@DBConsts.SFieldIndexError               );
  RestoreResString(@DBConsts.SNoFieldIndexes                );
  RestoreResString(@DBConsts.SIndexFieldMissing             );
  RestoreResString(@DBConsts.SDuplicateFieldName            );
  RestoreResString(@DBConsts.SDuplicateIndexName            );
  RestoreResString(@DBConsts.SFieldNameMissing              );
  RestoreResString(@DBConsts.SNoIndexForFields              );
  RestoreResString(@DBConsts.STextFalse                     );
  RestoreResString(@DBConsts.STextTrue                      );
  RestoreResString(@DBConsts.SFirstRecord                   );
  RestoreResString(@DBConsts.SPriorRecord                   );
  RestoreResString(@DBConsts.SNextRecord                    );
  RestoreResString(@DBConsts.SLastRecord                    );
  RestoreResString(@DBConsts.SInsertRecord                  );
  RestoreResString(@DBConsts.SDeleteRecord                  );
  RestoreResString(@DBConsts.SEditRecord                    );
  RestoreResString(@DBConsts.SPostEdit                      );
  RestoreResString(@DBConsts.SCancelEdit                    );
  RestoreResString(@DBConsts.SRefreshRecord                 );
  RestoreResString(@DBConsts.SDeleteRecordQuestion          );
  RestoreResString(@DBConsts.SDeleteMultipleRecordsQuestion );
  RestoreResString(@DBConsts.STooManyColumns                );
  RestoreResString(@DBConsts.SLookupInfoError               );
  RestoreResString(@DBConsts.SDataSourceChange              );
  RestoreResString(@DBConsts.SExprTermination               );
  RestoreResString(@DBConsts.SExprNameError                 );
  RestoreResString(@DBConsts.SExprStringError               );
  RestoreResString(@DBConsts.SExprInvalidChar               );
  RestoreResString(@DBConsts.SExprNoRParen                  );
  RestoreResString(@DBConsts.SExprExpected                  );
  RestoreResString(@DBConsts.SExprBadField                  );
  RestoreResString(@DBConsts.SExprBadNullTest               );
  RestoreResString(@DBConsts.SExprRangeError                );
  RestoreResString(@DBConsts.SExprNotBoolean                );
  RestoreResString(@DBConsts.SExprIncorrect                 );
  RestoreResString(@DBConsts.SExprNothing                   );
  RestoreResString(@DBConsts.SNotReplicatable               );
  RestoreResString(@DBConsts.SPropDefByLookup               );
  RestoreResString(@DBConsts.SDataSourceFixed               );
  RestoreResString(@DBConsts.SFieldOutOfRange               );
  RestoreResString(@DBConsts.SBCDOverflow                   );
  RestoreResString(@DBConsts.SInvalidVarByteArray           );
{$ENDIF}
end;

{$IFDEF _D3_}
initialization

finalization
  FreeResStringsDBConsts;
{$ENDIF}
end.
