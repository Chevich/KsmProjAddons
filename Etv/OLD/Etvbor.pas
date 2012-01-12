unit EtvBor;   (* Igo *)

interface
uses Windows,classes,graphics,controls,grids,stdctrls,forms,comctrls,Printers,
db,dbctrls,dbgrids;

{$I Etv.inc}

type

  TDBComboBoxBorland = class(TCustomComboBox)
  {private}
  public
    FDataLink: TFieldDataLink;
  end;

  TControlBorland = class(TComponent)
  {private}
  public
    FParent: TWinControl;
    FWindowProc: TWndMethod;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
  end;

  TCustomDBGridBorland = class(TCustomGrid)
   {private}
   public
    FIndicators: TImageList;
    FTitleFont: TFont;
    FReadOnly: Boolean;
    FOriginalImeName: TImeName;
    FOriginalImeMode: TImeMode;
    FUserChange: Boolean;
    {$IFDEF Delphi4}
    FIsESCKey: Boolean;
    {$ENDIF}
    FLayoutFromDataset: Boolean;
    FOptions: TDBGridOptions;
    FTitleOffset, FIndicatorOffset: Byte;
    FUpdateLock: Byte;
    FLayoutLock: Byte;
    FInColExit: Boolean;
    FDefaultDrawing: Boolean;
    FSelfChangingTitleFont: Boolean;
    FSelecting: Boolean;
    FSelRow: Integer;
    FDataLink: TGridDataLink;
  end;

  TListSourceLinkBorland = class(TDataLink)
  {private}
  public
    FDBLookupControl: TDBLookupControl;
  end;

 TDBLookupControlBorland = class(TCustomControl)
  {private}
  public
    FLookupSource: TDataSource;
    FDataLink: TDataSourceLink;
    FListLink: TListSourceLink;
    FDataFieldName: string;
    FKeyFieldName: string;
    FListFieldName: string;
    FListFieldIndex: Integer;
    FDataField: TField;
    FMasterField: TField;
    FKeyField: TField;
    FListField: TField;
    FListFields: TList;
    FKeyValue: Variant;
    FSearchText: string;
    FLookupMode: Boolean;
    FListActive: Boolean;
    {$IFNDEF Delphi4}
    FFocused: Boolean;
    {$ENDIF}
  end;

  TDBLookupListBoxBorland = class(TDBLookupControl)
  {private}
  public
    FRecordIndex: Integer;
    FRecordCount: Integer;
    FRowCount: Integer;
    FBorderStyle: TBorderStyle;
    FPopup: Boolean;
    FKeySelected: Boolean;
  end;

  TDBLookupComboBoxBorland = class(TDBLookupControl)
  {private}
  public
    FDataList: TPopupDataList;
    FButtonWidth: Integer;
    FText: string;
    FDropDownRows: Integer;
    FDropDownWidth: Integer;
    FDropDownAlign: TDropDownAlign;
    FListVisible: Boolean;
    FPressed: Boolean;
  end;

TFieldBorland = class(TComponent)
  {private}
  public
    FDataSet: TDataSet;
    FFieldName: string;
    {$IFDEF Delphi4}
    FFields: TFields;
    {$ENDIF}
    FDataType: TFieldType;
    FReadOnly: Boolean;
    FFieldKind: TFieldKind;
    FAlignment: TAlignment;
    FVisible: Boolean;
    FRequired: Boolean;
    FValidating: Boolean;
    FSize: Word;
    FOffset: Word;
    FFieldNo: Integer;
    FDisplayWidth: Integer;
    FDisplayLabel: string;
    FEditMask: string;
    FValueBuffer: Pointer;
    FLookupDataSet: TDataSet;
    FKeyFields: string;
    FLookupKeyFields: string;
    FLookupResultField: string;
  end;

TGridDataLinkBorland = class(TDataLink)
  public
    FGrid: TCustomDBGrid;
end;

TDataSourceLinkBorland = class(TDataLink)
  public
  FDBLookupControl: TDBLookupControl;
end;

{$IFNDEF Delphi4}
TCustomFormBorland = class(TScrollingWinControl)
  public
    FActiveControl: TWinControl;
    FFocusedControl: TWinControl;
    FBorderIcons: TBorderIcons;
    FBorderStyle: TFormBorderStyle;
    FWindowState: TWindowState;
    FShowAction: TShowAction;
    FKeyPreview: Boolean;
    FActive: Boolean;
    FFormStyle: TFormStyle;
    FPosition: TPosition;
    FTileMode: TTileMode;
    FFormState: TFormState;
end;
{$ENDIF}



TDBRichEditBorland=class(TRichEdit)
  public
  FDataLink: TFieldDataLink;
  FAutoDisplay: Boolean;
  FFocused: Boolean;
  FMemoLoaded: Boolean;
  FDataSave: string;
end;

IMPLEMENTATION

end.
