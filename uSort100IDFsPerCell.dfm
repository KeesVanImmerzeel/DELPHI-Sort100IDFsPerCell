object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Sort100IDFsPerCell'
  ClientHeight = 456
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 688
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 0
    OnClick = Button1Click
  end
  object LabeledEditInputDir: TLabeledEdit
    Left = 32
    Top = 24
    Width = 731
    Height = 21
    EditLabel.Width = 102
    EditLabel.Height = 13
    EditLabel.Caption = 'Input folder with idf'#39's'
    TabOrder = 1
    OnClick = LabeledEditInputDirClick
  end
  object LabeledEditOutputDir: TLabeledEdit
    Left = 32
    Top = 128
    Width = 731
    Height = 21
    EditLabel.Width = 538
    EditLabel.Height = 13
    EditLabel.Caption = 
      'Output folder for integer ESRII grids; ALLE BESTAANDE GRIDS IN D' +
      'EZE FOLDER WORDEN EERST VERWIJDERD!'
    TabOrder = 2
    OnClick = LabeledEditOutputDirClick
  end
  object LabeledEditIDFnamePrefix: TLabeledEdit
    Left = 32
    Top = 72
    Width = 145
    Height = 21
    EditLabel.Width = 126
    EditLabel.Height = 13
    EditLabel.Caption = 'IDF filename prefix (dh1_)'
    TabOrder = 3
    Text = 'dh1_'
    OnChange = LabeledEditIDFnamePrefixChange
  end
  object Memo1: TMemo
    Left = 32
    Top = 176
    Width = 481
    Height = 73
    Lines.Strings = (
      
        '100 (effect) berekenings resultaten van iMod (idf'#39's) worden op c' +
        'elbasis gesorteerd. Het resultaat '
      
        'wordt vermenigvuldigd met 100 en als ESRII grid weggeschreven. B' +
        'ovendien geexporteerd naar '
      'ESRII asc bestand.'
      ''
      'Voor Antea 11/5/2017')
    TabOrder = 4
  end
  object LargeRealArray1: TLargeRealArray
    Left = 600
    Top = 216
  end
end
