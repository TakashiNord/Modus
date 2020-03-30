object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ModusOK'
  ClientHeight = 187
  ClientWidth = 207
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 37
    Height = 13
    Caption = 'HWnd='
  end
  object Label2: TLabel
    Left = 8
    Top = 35
    Width = 76
    Height = 13
    Caption = 'Timer.Enabled='
  end
  object Label3: TLabel
    Left = 8
    Top = 60
    Width = 76
    Height = 13
    Caption = 'Timer.Interval='
  end
  object Label5: TLabel
    Left = 8
    Top = 90
    Width = 188
    Height = 13
    Caption = '-----------------------------------------------'
  end
  object Label6: TLabel
    Left = 65
    Top = 71
    Width = 19
    Height = 13
    Caption = '('#1084#1089')'
  end
  object EditHwnd: TEdit
    Left = 51
    Top = 8
    Width = 142
    Height = 21
    ReadOnly = True
    TabOrder = 0
    Text = 'EditHwnd'
  end
  object SpinEdit1: TSpinEdit
    Left = 89
    Top = 60
    Width = 64
    Height = 22
    Increment = 10
    MaxValue = 60000
    MinValue = 100
    TabOrder = 1
    Value = 500
  end
  object ComboBox1: TComboBox
    Left = 90
    Top = 33
    Width = 103
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    OnChange = ComboBox1Change
    Items.Strings = (
      'ON'
      'OFF')
  end
  object Button1: TButton
    Left = 152
    Top = 59
    Width = 41
    Height = 25
    Caption = 'Apply'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 124
    Top = 135
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 4
    OnClick = Button2Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 168
    Width = 207
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
    ExplicitLeft = 104
    ExplicitTop = 216
    ExplicitWidth = 0
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = PopupMenu1
    OnDblClick = TrayIcon1DblClick
    Left = 8
    Top = 104
  end
  object ApplicationEvents1: TApplicationEvents
    OnMinimize = ApplicationEvents1Minimize
    Left = 120
    Top = 104
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 48
    Top = 104
  end
  object PopupMenu1: TPopupMenu
    Left = 80
    Top = 104
    object Work: TMenuItem
      Caption = 'Option'
      OnClick = WorkClick
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
end
