{*******************************************************}
{                                                       }
{         Vladimir Gaitanoff Delphi VCL Library         }
{         DBCnstRC - Spanish DBConsts messages          }
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
         SDataSetOpen                   = 'Operaci�n no aplicable a un conjunto de datos abierto';
         SDataSetClosed                 = 'Operaci�n no aplicable a un conjunto de datos cerrado';
//  SSessionActive                 = '������ ��������� ������ �������� ��� �������� ������';
//  SHandleError                   = '������ �������� ����������� �������';
//  SUnknownFieldType              = '���� ''%s'' ����������� ����';
{$IFDEF _D4_}
         SFieldNotFound                 = 'Campo ''%s'' no encontrado';
{$ELSE}
         SFieldNotFound                 = '%s: Campo ''%s'' no encontrado';
{$ENDIF}
         SDataSetMissing                = 'El campo ''%s'' no tiene conjunto de datos';
         SDataSetEmpty                  = 'Operaci�n no aplicable a un conjunto de datos vac�o';
         SFieldTypeMismatch             = 'El campo ''%s'' no es del tipo esperado';
//  SInvalidFloatField             = '���������� ������������� ���� ''%s'' � ����� � ��������� ������';
//  SInvalidIntegerField           = '���������� ������������� ���� ''%s'' � ����� �����';
         SFieldRangeError               = '%g no es un valor correcto para el campo ''%s''. El rango admitido es desde %g hasta %g';
         SInvalidIntegerValue           =  '''%s'' no es un valor entero correcto para el campo ''%s''';
         SInvalidFloatValue             = '''%s'' no es un valor flotante correcto para el campo ''%s''';
         SInvalidBoolValue              =  '''%s'' no es un valor l�gico correcto para el campo ''%s''';
         SNotEditing                    = 'El conjunto de datos no esta en modo de edici�n o inserci�n';
//  STableMismatch                 = '�������� � �������� ������� ������������';
         SDataSetReadOnly               = 'No se puede modificar un conjunto de datos de s�lo lectura';
         SFieldReadOnly                 = 'El campo ''%s'' no puede ser modificado';
         SNotIndexField                 = 'El campo ''%s'' no est� indexado y no puede modificarse';
         SFieldRequired                 = 'El campo ''%s'' necesita un valor';
         SFieldAccessError              = 'No puedo convertir el valor del campo ''%s'' al tipo %s';
//  SFieldAssignError              = '���� ''%s'' � ''%s'' �� ���������� �� ����������';
         SFieldValueError               = 'Valor incorrecto para el campo ''%s''';
//  SFieldUndefinedType            = '���� ''%s'' ����������� ����';
//  SFieldUnsupportedType          = '���� ''%s'' ����������������� ����';
         SInvalidCalcType               = 'El campo ''%s'' no puede ser calculado o de b�squeda';
         SInvalidFieldSize              = 'Tama�o inv�lido de campo';
         SCircularDataLink              = 'Referencia circular en el enlace de datos';
         SFieldIndexError               = 'Indice de campo fuera de rango';
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
  SFirstRecord = 'Primer registro';
  SPriorRecord = 'Registro anterior';
  SNextRecord = 'Registro siguiente';
  SLastRecord = 'Ultimo registro';
  SInsertRecord = 'Insertar registro';
  SDeleteRecord = 'Eliminar registro';
         SEditRecord = 'Editar registro';
  SPostEdit = 'Grabar cambios';
  SCancelEdit = 'Cancelar cambios';
  SRefreshRecord = 'Actualizar datos';
  SDeleteRecordQuestion = '�Eliminar este registro?';
  SDeleteMultipleRecordsQuestion = '�Eliminar todos los registros seleccionados?';

//  SReportFilter                  = '����� ������� (*.rpt)|*.rpt';
//  SInvalidFieldRegistration      = '�������� ����������� ����';
//  SLinkDesigner                  = '���� ''%s'', �� ������ Detail Fields, ������ ���� ���������';
//  SLinkDetail                    = '������� ''%s'' �� ����� ���� �������';
//  SLinkMasterSource              = '�������� MasterSource � ''%s'' ������ ���� ��������� � DataSource';
//  SLinkMaster                    = '��� ����������� ������� MasterSource �������';
         STooManyColumns                =  'La rejilla intenta mostrar m�s de 256 columnas';
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
         SLookupInfoError               = 'La informaci�n de b�squeda para el campo ''%s'' est� incompleta';
//  SInvalidAliasName              = '�������� ��� ���������� %s';
         SDataSourceChange              = 'DataSource no puede cambiarse';
         SExprTermination               = 'Expresi�n de filtro terminada incorrectamente';
         SExprNameError = 'Nombre de campo incompleto';
         SExprStringError = 'Constante de cadena sin terminar';
         SExprInvalidChar = 'Car�cter incorrecto en expresi�n de filtro: ''%s''';
         SExprNoRParen = ''')'' esperado, pero %s encontrado';
         SExprExpected = 'Expresi�n esperada, pero %s encontrado';
//  SExprBadCompare                = '��������� ��������� ��������� ���� � ���������';
         SExprBadField = 'El campo ''%s'' no puede utilizarse e una expresi�n de filtro';
         SExprBadNullTest = 'NULL solo se permite con ''='' y ''<>''';
         SExprRangeError = 'Constante fuera de rango';
         SExprNotBoolean = 'El campo ''%s'' no es de tipo Boolean';
         SExprIncorrect = 'Expresi�n de filtro incorrectamente formada';
         SExprNothing = 'nada';
//  SNoFieldAccess                 = '��� ������� � ���� ''%s'' ��� ����������';
         SNotReplicatable               = 'El control no puede utilizarse en un DBCtrlGrid';
         SPropDefByLookup               = 'Propiedad ya definida por campo de b�squeda';
         SDataSourceFixed               = 'Operaci�n no permitida en un DBCtrlGrid';
         SFieldOutOfRange               = 'El valor del campo ''%s'' est� fuera de rango';
         SBCDOverflow                   = '(Desbordamiento)';
//  SUpdateWrongDB                 = '��� ����������� ��������������, %s �� ������� %s';
//  SUpdateFailed                  = '���� ��� ���������';
         SInvalidVarByteArray           = 'Tipo o tama�o del invariante inv�lido';
//  SSQLGenSelect                  = '���������� ������� �� ������� ���� ���� �������� ���� � ���� ���������� ����';
//  SSQLNotGenerated               = 'UpdateSQL- ��������� �� �������������, ��� ����� �����?';
//  SSQLDataSetOpen                = '���������� ���������� ����� ����� ��� %s';
//  SOldNewNonData                 = '���� %s - ��� �� ���� ������';  SLocalTransDirty               = 'The transaction isolation level must be dirty read for local databases';
//  SMemoTooLarge                  = '(Memo demasiado grande)';

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
