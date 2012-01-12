object Form1: TForm1
  Left = 632
  Top = 122
  Width = 733
  Height = 742
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 8
    Top = 80
    Width = 617
    Height = 21
    TabOrder = 0
    Text = 
      'http://test.itvx.com/ReportService.asmx/GetTemplateXML?TemplateI' +
      'd=5.1'
  end
  object Button1: TButton
    Left = 624
    Top = 79
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 112
    Width = 705
    Height = 569
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 40
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '192.168.92.3'
  end
  object Edit3: TEdit
    Left = 168
    Top = 40
    Width = 73
    Height = 21
    TabOrder = 4
    Text = '3128'
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 224
    Top = 240
  end
  object MainMenu: TMainMenu
    Left = 48
    Top = 192
  end
end
