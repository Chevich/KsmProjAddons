object Form1: TForm1
  Left = 192
  Top = 114
  Width = 496
  Height = 480
  Caption = 'Test Application'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 289
    Height = 89
    Lines.Strings = (
      'Text in Memo.'
      ''
      'Kryvich'#39's Delphi Localizer')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnStrings: TButton
    Left = 304
    Top = 8
    Width = 177
    Height = 25
    Caption = 'Resource strings'
    TabOrder = 1
    OnClick = btnStringsClick
  end
  object btnNewForm: TButton
    Left = 304
    Top = 40
    Width = 177
    Height = 25
    Caption = 'Open'
    TabOrder = 2
    OnClick = btnNewFormClick
  end
  object cbAutoTranslation: TCheckBox
    Left = 304
    Top = 80
    Width = 177
    Height = 17
    Caption = 'Auto translation'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = cbAutoTranslationClick
  end
  object pnlLanguage: TPanel
    Left = 8
    Top = 104
    Width = 129
    Height = 193
    TabOrder = 4
    object rgLanguage: TRadioGroup
      Left = 8
      Top = 8
      Width = 113
      Height = 81
      Caption = 'Select language:'
      ItemIndex = 0
      Items.Strings = (
        'English'
        'Belarusian'
        'Russian')
      TabOrder = 0
    end
    object btnLoad: TButton
      Left = 8
      Top = 96
      Width = 113
      Height = 25
      Caption = 'Load'
      TabOrder = 1
      OnClick = btnLoadClick
    end
    object btnTranslate: TButton
      Left = 8
      Top = 128
      Width = 113
      Height = 25
      Caption = 'Translate'
      TabOrder = 2
      OnClick = btnTranslateClick
    end
    object btnTranslateAll: TButton
      Left = 8
      Top = 160
      Width = 113
      Height = 25
      Caption = 'Translate all !!!'
      TabOrder = 3
      OnClick = btnTranslateAllClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 144
    Top = 104
    Width = 337
    Height = 120
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Title.Caption = '#'
        Width = 25
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'OrderNo'
        Title.Caption = 'Order #'
        Width = 52
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name'
        Title.Caption = 'Item name'
        Width = 88
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Description'
        Title.Caption = 'Item description'
        Width = 131
        Visible = True
      end>
  end
  inline Frame11: TFrame1
    Left = 8
    Top = 304
    TabOrder = 6
    inherited gbInFrame: TGroupBox
      inherited mmInFrame: TMemo
        Lines.Strings = (
          'New text for the memo placed in'
          'Frame')
      end
    end
  end
  object StaticText1: TStaticText
    Left = 144
    Top = 232
    Width = 233
    Height = 65
    AutoSize = False
    Caption = 
      'Try to change captions on the form, try to remove and rename som' +
      'e controls and resource strings to see how the String Version Co' +
      'ntrol System (SVCS) works'
    TabOrder = 7
  end
  object btnClose: TButton
    Left = 392
    Top = 232
    Width = 91
    Height = 65
    Cancel = True
    Caption = 'Close'
    TabOrder = 8
    OnClick = btnCloseClick
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 152
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = btnNewFormClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = btnCloseClick
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
    end
    object Window1: TMenuItem
      Caption = 'Window'
    end
    object Help1: TMenuItem
      Caption = 'Help'
    end
  end
end
