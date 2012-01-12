Unit DiDate;

Interface

Uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ExtCtrls, Mask, ToolEdit, RXCtrls;

type
  TDialDate = class(TForm)
    Bevel1: TBevel;
    RxLabel1: TRxLabel;
    RxLabel2: TRxLabel;
    DateEditBe: TDateEdit;
    DateEditEn: TDateEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    procedure VisibleSecondDate(aVisible:boolean);
    { Public declarations }
  end;

var DialDate: TDialDate;

Implementation

{$R *.DFM}

procedure TDialDate.VisibleSecondDate(aVisible:boolean);
begin
  RxLabel2.Visible:=aVisible;
  DateEditEn.Visible:=aVisible;
  if aVisible then begin
    RxLabel1.Caption:='От даты';
    BitBtn1.Top:=168;
    BitBtn2.Top:=168;
    Bevel1.Height:=153;
    Height:=125;
  end else begin
    RxLabel1.Caption:='На дату';
    BitBtn1.Top:=59;
    BitBtn2.Top:=59;
    Bevel1.Height:=45;
    Height:=115;
  end;
end;

end.
