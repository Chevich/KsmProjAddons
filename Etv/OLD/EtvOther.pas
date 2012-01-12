unit EtvOther;

interface
uses classes,controls,db,dbgrids,
     EtvFilt;

type TCreateOtherControl=function(aOwner:TComponent):TControl;

var
    {Controls for use in Etv}
    CreateOtherText:TCreateOtherControl;
    CreateOtherEdit:TCreateOtherControl;
    CreateOtherDateEdit:TCreateOtherControl;
    CreateOtherComboBox:TCreateOtherControl;
    CreateOtherMemo:TCreateOtherControl;
    {CreateOtherImage:TCreateOtherControl;}
    CreateOtherLookupComboBox:TCreateOtherControl;

    {DBControls for use in Etv}
    CreateOtherDBText:TCreateOtherControl;
    CreateOtherDBEdit:TCreateOtherControl;
    CreateOtherDBDateEdit:TCreateOtherControl;
    CreateOtherDBComboBox:TCreateOtherControl;
    CreateOtherDBMemo:TCreateOtherControl;
    CreateOtherDBImage:TCreateOtherControl;
    CreateOtherDBLookupComboBox:TCreateOtherControl;

    {Controls for use in EtvDBGrid}
    CreateOtherDBGridControls:
      function(aOwner:TDBGrid; Field:TField; c:Char):TWinControl;

    (* print from Etvdbgrid *)
    CreateOtherDBGridPrint: procedure(aGrid:TDBGrid);
    CreateOtherDBGridPrintRecord: procedure(aGrid:TDBGrid);

    {class of query for EtvFilter}
type TOtherQueryClass=class of TDataset;
var OtherQueryClass:TOtherQueryClass;
    {Load and save data of EtvFilter}
    CreateOtherOnFilterLoad:procedure(EtvFilter:TEtvFilter);
    CreateOtherOnFilterSave:procedure(EtvFilter:TEtvFilter);

implementation

end.
