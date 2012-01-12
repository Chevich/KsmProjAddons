unit EtvReg;

interface
procedure Register;

implementation
uses Classes,DsgnIntf,DB,
  EtvDB, EtvLook, EtvContr, EtvGrid, EtvTable,
  EtvFind, EtvForms,EtvDsgn, EtvExp, EtvFilt, EtvMisc, EtvProp,
  EtvDBFun,EtvRich{,EtvDBase},EtvShb;

procedure Register;
begin
  RegisterFields([TEtvListField, TEtvLookField]);

  RegisterComponents('EtvDB', [TEtvTable,TEtvQuery,TEtvClientDataSet]);
  RegisterComponents('EtvDB', [TEtvPageControl,TEtvDBGrid,TEtvDBEdit,TEtvDBCombo,TEtvDBLookupCombo,TEtvDBText,TEtvDBRichEdit]);
  RegisterComponents('EtvDB', [TEtvDMInfo,TEtvDBSortingCombo,TEtvFindDlg,TEtvFilter,TEtvRecordCloner]);

  RegisterClasses([TEtvTabSheet]);

  RegisterPropertyEditor(TypeInfo(string), TField, 'LookupFilterField',TEtvLookupFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TField, 'LookupLevelUp',TEtvLookupFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TField, 'LookupLevelDown',TEtvLookupFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TField, 'LookupFilterKey',TEtvFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TField, 'LookupAddFields',TEtvLookupFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TField, 'LookupGridFields',TEtvLookupFieldProperty);

  RegisterPropertyEditor(TypeInfo(string), TEtvCustomDBLookupCombo, 'LookupFilterField',TEtvLookupProperty);
  RegisterPropertyEditor(TypeInfo(string), TEtvCustomDBLookupCombo, 'LookupLevelUp',TEtvLookupProperty);
  RegisterPropertyEditor(TypeInfo(string), TEtvCustomDBLookupCombo, 'LookupLevelDown',TEtvLookupProperty);
  RegisterPropertyEditor(TypeInfo(string), TEtvCustomDBLookupCombo, 'LookupFilterKey',TEtvLookProperty);


  RegisterPropertyEditor(TypeInfo(string), TEtvDBText, 'LookField',TEtvLookupResultProperty);
  RegisterPropertyEditor(TypeInfo(Word), TEtvLookField, 'Size',nil);

  RegisterPropertyEditor(TypeInfo(string), TEtvLookupLevelItem, 'FilterField',TEtvLookupLevelFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TEtvLookupLevelItem, 'KeyField',TEtvLookupLevelFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TEtvLookupLevelItem, 'ResultFields',TEtvLookupLevelFieldProperty);

  {RegisterPropertyEditor(TypeInfo(TDataSetCol), TEtvFilter, 'SubDataSets',TDataSetListProperty);}
  RegisterPropertyEditor(TypeInfo(TDataSetCol), TEtvRecordCloner, 'SubDataSets',TDataSetListProperty);

  RegisterComponentEditor(TEtvDMInfo, TEtvDMEditor);
  RegisterComponentEditor(TEtvTable, TEtvDataSetEditor);
  RegisterComponentEditor(TEtvQuery, TEtvDataSetEditor);

  RegisterComponentEditor(TEtvDBLookupCombo, TEtvDBLookupComboEditor);

  RegisterComponentEditor(TEtvDBCombo, TEtvDBFieldControlEditor);
  RegisterComponentEditor(TEtvDBEdit, TEtvDBFieldControlEditor);
  RegisterComponentEditor(TEtvDBText, TEtvDBFieldControlEditor);

  RegisterComponentEditor(TEtvDBSortingCombo, TEtvDBControlEditor);
  RegisterComponentEditor(TEtvFilter, TEtvDBControlEditor);
  RegisterComponentEditor(TEtvFindDlg, TEtvDBControlEditor);
  RegisterComponentEditor(TEtvPageControl, TEtvPageControlEditor);
  RegisterComponentEditor(TEtvTabSheet, TEtvPageControlEditor);

  RegisterComponentEditor(TDataSource, TEtvDataSourceEditor);

  RegisterComponents('EtvDB',[{TEtvDataBase,}TEtvShb]);

  EtvExp.RegisterExp;
end;

end.
