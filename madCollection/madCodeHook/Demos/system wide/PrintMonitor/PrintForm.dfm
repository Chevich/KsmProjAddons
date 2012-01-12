object FPrintMonitor: TFPrintMonitor
  Left = 199
  Top = 124
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'PrintMonitor'
  ClientHeight = 251
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object LogLV: TListView
    Left = 8
    Top = 9
    Width = 609
    Height = 232
    Columns = <
      item
        Caption = 'time'
        Width = 54
      end
      item
        Caption = 'process'
        Width = 120
      end
      item
        Caption = 'api'
        Width = 80
      end
      item
        Caption = 'parameters'
        Width = 234
      end
      item
        Caption = 'result'
        Width = 100
      end>
    ColumnClick = False
    TabOrder = 0
    ViewStyle = vsReport
  end
end
