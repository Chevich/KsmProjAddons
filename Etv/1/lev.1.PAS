procedure TEtvInplaceLookupCombo.KeyPress(var Key: Char);
var WKey: Word;
    OldListVisible:boolean;
begin
  WKey:=Integer(Key);
  OldListVisible:=ListVisible;
  Inherited;
  if ((WKey=vk_Escape) and ((Not OldListVisible) or (TEtvLookField(TEtvDBGrid(FLookUp).SelectedField).EditOnEnter)))
  or ((WKey=vk_Return) and (Not ListVisible)) then begin
    Visible:=False;
    FLookup.SetFocus;
    if (WKey=vk_Return) then TWinControlSelf(FLookup).KeyDown(WKey,[]);
  end;
end;
