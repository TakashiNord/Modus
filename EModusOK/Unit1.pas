unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AppEvnts, tlhelp32, Menus, Spin, ComCtrls;

type
  TForm1 = class(TForm)
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    Label1: TLabel;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Work: TMenuItem;
    Exit1: TMenuItem;
    Label2: TLabel;
    Label3: TLabel;
    EditHwnd: TEdit;
    Label5: TLabel;
    SpinEdit1: TSpinEdit;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Label6: TLabel;
    StatusBar1: TStatusBar;
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure WorkClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    found_window : HWnd;
    cnt : Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

 { коллбэк-функция проверки очередного найденного окна }
function EnumProc(hWindow: HWnd; Param: LongInt): Boolean; stdcall;
var
  buff: Array[0..255] of Char;
  s, s1: String;
begin
  result := true;
  If Boolean(GetClassName(hWindow, buff, SizeOf( buff ))) then
    begin
      s := AnsiLowerCase(StrPas(buff));
      GetWindowText( hWindow, buff, SizeOf( buff ) );
      s1 := AnsiLowerCase(StrPas(buff));
      // вот тут ищем кусок класса  CVIRTLVDChild  или кусок по имени Панели
      If pos(AnsiLowerCase('TF_DemoForm'), s) > 0 then
        begin
          // Showmessage(s);
          Form1.found_window := hWindow;
          Result := False;
        end;
    end;
end;

function EnumChildProc(WndCtrl : HWND; lParam : Longint) : Boolean; stdcall;
var
  buff : array[Byte] of Char;
  s, s1: String;
begin
  Result := True;

  If Boolean(GetClassName(WndCtrl, buff, SizeOf(buff))) then
    begin
      s := AnsiLowerCase(StrPas(buff));
      GetWindowText( WndCtrl, buff, SizeOf( buff ) );
      s1 := AnsiLowerCase(StrPas(buff));
      // вот тут ищем кусок класса  CVIRTLVDChild  или кусок по имени Панели
      If ((pos(AnsiLowerCase('TButton'), s) > 0)  and (pos(AnsiLowerCase('ok'), s1) > 0)) then
        begin
          Form1.found_window := WndCtrl;
          Result := False;
        end;
    end;
end;

procedure EnumTimer();
var
  Wnd: HWND;                   // Hahdle найденного окна
  Pos: TPoint;                 // Позиция курсора
  Rect: TRect;                 // Координаты окна
  buff: array[0..255] of char; // Буфер
  WndText: string;             // Текст окна
  NameClass: string;           // Класс окна

  WndBut: HWND;                   // Hahdle найденного окна
begin

{ 1 // Если точно известен Класс }
      Wnd:= FindWindow(PChar('TF_DemoForm'), Nil);

{ 2 // Если имя и класс неизвестно }
      Form1.found_window := Invalid_Handle_Value;
      // перечисление всех окон первого урвня:
      EnumWindows(@EnumProc, 0);
      If Form1.found_window <> Invalid_Handle_Value then  Wnd:=Form1.found_window;

      if IsWindow(Wnd) then
      begin

        GetWindowText( Wnd, buff, SizeOf( buff ) );
        WndText := StrPas( buff );
        GetClassName( Wnd, buff, SizeOf( buff ) );
        NameClass := StrPas( buff );
        Form1.EditHwnd.Text := WndText;

        // WndBut:= FindWindowEx(Wnd, 0, PChar('TButton'), Nil);
        Form1.found_window := Invalid_Handle_Value;
        EnumChildWindows(Wnd, @EnumChildProc, 0);
        If Form1.found_window <> Invalid_Handle_Value then  WndBut:=Form1.found_window;

        if  IsWindow(WndBut) then begin
           //ShowMessage('Find');
           SendMessage(WndBut, BM_CLICK, 0, 0);
           Form1.cnt :=Form1.cnt +1 ;
        end;

      end;

end;

procedure EnumTimer0();
var
  Wnd: HWND;                   // Hahdle найденного окна
  Pos: TPoint;                 // Позиция курсора
  Rect: TRect;                 // Координаты окна
  buff: array[0..255] of char; // Буфер
  WndText: string;             // Текст окна
  NameClass: string;           // Класс окна

  B: BOOL;
  ProcList: THandle;
  PE: TProcessEntry32;
  ExeName:string;

  rect1 : TRect;

  Style: Integer ;

  Bf : BOOL ;
  WndBut: HWND;                   // Hahdle найденного окна
begin

 // SchemeViewer.exe - Topaz_Graphics_View
 // PnView.exe   - CVIRTLVDChild.........
 ExeName:='SchemeViewer.exe';
 ProcList := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
 PE.dwSize := SizeOf(PE);
 B := Process32First(ProcList, PE);
 while B do begin
   Bf:=false;
   // if (UpperCase(PE.szExeFile) = UpperCase(ExtractFileName('SchemeViewer.exe'))) then Bf:=true;
   // if (UpperCase(PE.szExeFile) = UpperCase(ExtractFileName('SchemeAdjust.exe'))) then Bf:=true;
   Bf:=true;
   if (Bf=true) then
     begin

{ 1 // Если точно известен Класс }
      Wnd:= FindWindow(PChar('TF_DemoForm'), Nil);

{ 2 // Если имя и класс неизвестно }
      Form1.found_window := Invalid_Handle_Value;
      // перечисление всех окон первого урвня:
      EnumWindows(@EnumProc, 0);
      If Form1.found_window <> Invalid_Handle_Value then  Wnd:=Form1.found_window;

      if IsWindow(Wnd) then
      begin

        GetWindowText( Wnd, buff, SizeOf( buff ) );
        WndText := StrPas( buff );
        GetClassName( Wnd, buff, SizeOf( buff ) );
        NameClass := StrPas( buff );
        Form1.EditHwnd.Text := WndText;

        // WndBut:= FindWindowEx(Wnd, 0, PChar('TButton'), Nil);
        Form1.found_window := Invalid_Handle_Value;
        EnumChildWindows(Wnd, @EnumChildProc, 0);
        If Form1.found_window <> Invalid_Handle_Value then  WndBut:=Form1.found_window;

        if  IsWindow(WndBut) then begin
           //ShowMessage('Find');
           SendMessage(WndBut, BM_CLICK, 0, 0);
           Form1.cnt :=Form1.cnt +1 ;
        end;

      end;
      break ; // изменяем одно окно

     end;
   B := Process32Next(ProcList, PE);
 end;
 CloseHandle(ProcList);
end;

procedure TForm1.ApplicationEvents1Minimize(Sender: TObject);
begin
  // Hide the window and set its state variable to wsMinimized.
  WindowState := wsMinimized;

  // Show the animated tray icon and also a hint balloon.
  TrayIcon1.Visible := true;
  TrayIcon1.Animate := true;

  //Убираем с панели задач
  ShowWindow(Handle,SW_HIDE);  // Скрываем программу
  ShowWindow(Application.Handle,SW_HIDE);  // Скрываем кнопку с TaskBar'а
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
  GetWindowLong(Application.Handle, GWL_EXSTYLE) or (not WS_EX_APPWINDOW));

end;

procedure TForm1.WorkClick(Sender: TObject);
begin
   Form1.Show();
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 n: integer;
begin
   if (ComboBox1.ItemIndex=0) then Timer1.Enabled:=false;
   Sleep(1000);
   n:=500;
   try
    n:=StrToIntDef(IntToStr(SpinEdit1.Value) ,n);
   except
    n:=500;
    SpinEdit1.Value:=n;  SpinEdit1.Refresh;
   end;
   Timer1.Interval:=n;
   if (ComboBox1.ItemIndex=0) then Timer1.Enabled:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   Application.Terminate;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
    if (ComboBox1.ItemIndex=0) then Timer1.Enabled:=true
    else Timer1.Enabled:=false;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caNone; {отмена закрытия формы}
  Form1.ApplicationEvents1Minimize(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    cnt := 0;
    Timer1.Interval:=500;
    Timer1.Enabled:=true;
    EditHwnd.Text:= 'TF_DemoForm';
    if (Timer1.Enabled) then ComboBox1.ItemIndex:=0
    else  ComboBox1.ItemIndex:=1;
    SpinEdit1.Value:= Timer1.Interval ;
    //Form1.FormActivate(Sender);
    Form1.ApplicationEvents1Minimize(Sender);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 StatusBar1.Panels[0].Text:= 'Status='+TimeToStr(Now);
 EnumTimer();
 StatusBar1.Panels[1].Text:= 'Cnt='+IntToStr(cnt);
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  // Hide the tray icon and show the window,
  // setting its state property to wsNormal.
  TrayIcon1.Visible := true; //false;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();

  Form1.FocusControl(StatusBar1);

//TrayIcon1.ShowBalloonHint;
//ShowWindow(Handle,SW_RESTORE);
//SetForegroundWindow(Handle);
//TrayIcon1.Visible:=False;

end;

end.
