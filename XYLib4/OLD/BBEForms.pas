unit BBEForms;

interface

uses
  ABEForms, StdCtrls, DBIndex, Nav, ExtCtrls, XDBForms,
  Controls, Grids, DBGrids, EtvGrid, XECtrls, ComCtrls, Classes, XMisc,EtvContr,
  SrcIndex, Menus;

type
  TBBEForm = class(TABEForm)
    DetailPages: TXPageControl;
    TabSheet1: TEtvTabSheet;
    TabSheet2: TEtvTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Initialization
  RegisterXForm(TBBEForm);
Finalization
  UnRegisterXForm(TBBEForm);
end.
