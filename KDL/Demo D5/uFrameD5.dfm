object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 475
  Height = 110
  TabOrder = 0
  object gbInFrame: TGroupBox
    Left = 0
    Top = 0
    Width = 473
    Height = 105
    Caption = 'These controls placed in Frame component'
    TabOrder = 0
    object lbInFrame: TListBox
      Left = 8
      Top = 16
      Width = 201
      Height = 81
      ItemHeight = 13
      Items.Strings = (
        'First Item'
        'Item 2'
        'Item 3'
        'Item 4'
        'Last item')
      TabOrder = 0
    end
    object mmInFrame: TMemo
      Left = 216
      Top = 16
      Width = 249
      Height = 81
      Lines.Strings = (
        'Contents of this memo control'
        'will replaced in the form')
      TabOrder = 1
    end
  end
end
