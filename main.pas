unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, Spin, XMLPropStorage, ComCtrls, PointerTab, ExtMessage,
  LiveTimer, ConsMixer, UOSEngine, UOSPlayer, MPlayerCtrl, NetSocket,
  lNetComponents, ueled, Menus, EditBtn, lNet;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    force_mpv: TCheckBox;
    meter2: TProgressBar;
    meter1: TProgressBar;
    server: TNetSocket;
    timer_meter: TIdleTimer;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    force_mpv_caption: TLabel;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    N1: TMenuItem;
    speed: TSpinEdit;
    historia_napisy: TSpinEdit;
    synchro_video: TFloatSpinEdit;
    server_on: TCheckBox;
    ComboBox1: TComboBox;
    amixer: TConsMixer;
    czas_pomiarowy: TLiveTimer;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    server_on_caption: TLabel;
    Label16: TLabel;
    Panel11: TPanel;
    MainMenu1: TMainMenu;
    Memo2: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    mess: TExtMessage;
    Label10: TLabel;
    led4: TuELED;
    OpenAudio: TOpenDialog;
    OpenRawNapisy: TOpenDialog;
    opoznienie_napisow: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    led: TuELED;
    led1: TuELED;
    led2: TuELED;
    led3: TuELED;
    Memo1: TMemo;
    mplayer: TMPlayerControl;
    mplayer2: TMPlayerControl;
    OpenFilm: TOpenDialog;
    OpenNapisy: TOpenDialog;
    opoznienie: TSpinEdit;
    Panel1: TPanel;
    me: TPointerTab;
    Panel10: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    SaveNapisy: TSaveDialog;
    stat: TProgressBar;
    SaveSound: TSaveDialog;
    Splitter1: TSplitter;
    opozniony_start: TTimer;
    stat1: TProgressBar;
    stat2: TProgressBar;
    TimeEdit1: TTimeEdit;
    TimeEdit2: TTimeEdit;
    play_synchro: TTimer;
    timer_czas_end: TTimer;
    timer_time_display: TTimer;
    timer_mplayer2: TTimer;
    timer_delay_sound: TTimer;
    timer_czas: TTimer;
    time_display: TLabel;
    silnik: TUOSEngine;
    rec: TUOSPlayer;
    v_ts: TuELED;
    XMLPropStorage1: TXMLPropStorage;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure led1DblClick(Sender: TObject);
    procedure led2DblClick(Sender: TObject);
    procedure led3DblClick(Sender: TObject);
    procedure led4DblClick(Sender: TObject);
    procedure meCreateElement(Sender: TObject; var AWskaznik: Pointer);
    procedure meDestroyElement(Sender: TObject; var AWskaznik: Pointer);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure meReadElement(Sender: TObject; var AWskaznik: Pointer);
    procedure meWriteElement(Sender: TObject; var AWskaznik: Pointer);
    procedure mplayerStop(Sender: TObject);
    procedure serverError(const aMsg: string; aSocket: TLSocket);
    procedure serverReceiveString(aMsg: string; aSocket: TLSocket);
    procedure opozniony_startTimer(Sender: TObject);
    procedure play_synchroTimer(Sender: TObject);
    procedure soAfterStart(Sender: TObject);
    procedure soAfterStop(Sender: TObject);
    procedure timer_czasTimer(Sender: TObject);
    procedure timer_czas_endTimer(Sender: TObject);
    procedure timer_delay_soundTimer(Sender: TObject);
    procedure timer_meterStopTimer(Sender: TObject);
    procedure timer_meterTimer(Sender: TObject);
    procedure timer_mplayer2Timer(Sender: TObject);
    procedure timer_time_displayTimer(Sender: TObject);
    procedure XMLPropStorage1RestoreProperties(Sender: TObject);
    procedure XMLPropStorage1SaveProperties(Sender: TObject);
  private
    napisy: TStringList;
    film,wave,audio: string;
    procedure test;
    procedure start_init;
    procedure start_init_2;
    procedure wczytaj_napisy;
    procedure film_start;
    procedure film_stop;
    procedure rec_start;
    procedure rec_stop;
    procedure procedura_startu;
    function load_napisy_srt: integer;
    function load_napisy_youtube: integer;
    function load_napisy_raw: integer;
    procedure SendToAll(adres_ip,rodzaj: string; const ramka: string; dolacz_czas_wyslania_ramki: boolean = false);
  public

  end;

var
  Form1: TForm1;

implementation

uses
  ecode, about, cverinfo, pobieranie;

type
  TElement = record
    start,stop: integer;
    tekst: string;
  end;

const
  LINK_MPLAYERS_ENGINE = 'https://sourceforge.net/projects/paczki-do-moich-program-w/files/player_engine.zip/download';

resourcestring
  NAZWA_PROGRAMU = 'Lektor - Pomocnik Lektora';
  DialogFilter1 = 'Wszystkie obsługiwane pliki napisów';
  DialogFilter2 = 'Plik w formacie SRT';
  DialogFilter3 = 'Plik w surowym formacie Youtube';
  DialogFilter4 = 'Wszystkie pliki';
  DialogFilter5 = 'Pliki Video';
  DialogFilter6 = 'Pliki';
  DialogFilter7 = 'Plik tekstowy';
  DialogFilter8 = 'Pliki Audio';
  DialogFilter9 = 'Pliki napisów';
  MENU_001 = 'Format tego pliku wygląda następująco:';
  MENU_002 = 'Linia pierwsza';
  MENU_003 = 'Linia druga';
  MENU_004 = 'Linia trzecia';
  MENU_005 = 'Linia czwarta';
  MENU_006 = 'Linia kolejna i tak dalej';
  MENU_007 = 'Jeśli jesteście na youtube na filmie z napisami, możecie je sobie skopiować właśnie w takim formacie.';
  MENU_008 = 'Czym jest surowy plik youtube?';
  MENU_009 = 'Zostaną zainstalowane silniki wideo, archiwum zostanie ściągnięte ze zdalnego hosta, następnie zawartość zostanie rozpakowana. Istniejące pliki zostaną nadpisane.';
  MENU_010 = 'Kontynuować?';
  MENU_011 = 'Lektor - Instalacja Silników Video';
  MENU_012 = 'Silniki Video zostały wgrane i są gotowe do użycia.';
  Trans_000 = 'Informacja';
  Trans_001 = 'Brak załadowanych napisów, operacja anulowana.';

var
  element: TElement;
  pp: ^TElement;

var
  autorun: boolean = true;
  katalog: string = '';
  sound_master_data: record
    active: boolean;
    value: integer;
    percent: integer;
  end;
  b_napisy: boolean = false;
  b_film: boolean = false;
  b_play: boolean = false;
  b_audio: boolean = false;
  b_alternative_system_sound: boolean = false;
  b_server_on: boolean = false;
  czas_elementu,czas_elementu2,czas_max: integer;
  pom,wczytano,wczytano_count: integer;
  rec_delay: boolean = false;
  nauka: boolean = false;

var {server}
  server_err: integer = 0;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  s1,s2,s3: string;
begin
  GetProgramVersion(s1,s2,s3);
  Caption:=NAZWA_PROGRAMU+' (ver. '+s3+')';
  OpenNapisy.Filter:=DialogFilter1+'|*.srt;*.youtube|'+DialogFilter2+'|*.srt|'+DialogFilter3+'|*.youtube|'+DialogFilter4+'|*.*';
  OpenFilm.Filter:=DialogFilter5+'|*.avi;*mp4;*.mkv;*.webm|'+DialogFilter6+' *.mp4|*.mp4|'+DialogFilter4+'|*.*';
  SaveSound.Filter:=DialogFilter6+' Wave|*.wav';
  OpenRawNapisy.Filter:=DialogFilter7+'|*.txt';
  OpenAudio.Filter:=DialogFilter5+'|*.avi;*mp4;*.mkv;*.webm|'+DialogFilter8+'|*.wav;*.flac;*.ogg;*.mp3;*.mp2|'+DialogFilter4+'|*.*';
  SaveNapisy.Filter:=DialogFilter9+' *.srt|*.srt';
  {$IFDEF MSWINDOWS}
  //force_mpv.Enabled:=false;
  //force_mpv.Checked:=false;
  //force_mpv_caption.Enabled:=false;
  {$ELSE}
  MenuItem8.Visible:=false;
  {$ENDIF}
  SetConfDir('lektor');
  XMLPropStorage1.FileName:=MyConfDir('config.xml');
  XMLPropStorage1.Active:=true;
  b_alternative_system_sound:=silnik.LoadLibrary;
  Panel6.Visible:=false;
  napisy:=TStringList.Create;
  BitBtn3.Enabled:=false;
  BitBtn4.Enabled:=false;
  mplayer.StartParam:='-vo x11 -zoom -fs -softvol';
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
  SaveSound.InitialDir:=katalog;
  if SaveSound.Execute then
  begin
    katalog:=ExtractFilePath(SaveSound.FileName);
    wave:=SaveSound.FileName;
    led3.Active:=true;
    //Caption:='Lektor ('+wave+')';
  end;
  test;
end;

procedure TForm1.BitBtn7Click(Sender: TObject);
begin
  OpenAudio.InitialDir:=katalog;
  if OpenAudio.Execute then
  begin
    katalog:=ExtractFilePath(OpenAudio.FileName);
    audio:=OpenAudio.FileName;
    b_audio:=true;
    led4.Active:=true;
  end;
  test;
end;

procedure TForm1.BitBtn8Click(Sender: TObject);
begin
  if nauka then BitBtn9.Click;
  nauka:=true;
  if Memo2.Lines.Count=0 then exit;
  element.start:=czas_pomiarowy.GetIndexTime;
  Memo1.Lines.Add('- - - - - - - - -');
  Memo1.Lines.Add(Memo2.Lines[0]);
  while Memo1.Lines.Count>3 do Memo1.Lines.Delete(0);
  Memo2.Clear;
end;

procedure TForm1.BitBtn9Click(Sender: TObject);
begin
  if CheckBox2.Checked then
  begin
    if not nauka then exit;
    nauka:=false;
    element.stop:=czas_pomiarowy.GetIndexTime;
    me.Edit(wczytano);
    inc(wczytano);
    me.Read(wczytano);
    if me.Count>wczytano then Memo2.Lines.Add(element.tekst);
    Memo1.Lines.Add(Memo1.Lines[0]);
  end else begin
    me.Read(wczytano-1);
    element.stop:=czas_pomiarowy.GetIndexTime;
    me.Edit(wczytano-1);
  end;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  if CheckBox2.Checked then CheckBox5.Checked:=false;
  BitBtn8.Visible:=CheckBox2.Checked;
  BitBtn9.Visible:=CheckBox2.Checked;
  nauka:=false;
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
begin
  if CheckBox5.Checked then CheckBox2.Checked:=false;
  BitBtn9.Visible:=CheckBox5.Checked;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  a: integer;
begin
  case ComboBox1.ItemIndex of
    0: a:=16;
    1: a:=25;
    else a:=16;
  end;
  Memo1.Font.Size:=a;
  Memo2.Font.Size:=a;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  i: integer;
begin
  SendToAll('all','info','exit');
  i:=0;
  rec_delay:=false;
  if BitBtn4.Enabled then BitBtn4.Click;
  while led.Active do
  begin
    inc(i);
    sleep(250);
    application.ProcessMessages;
    if i>22 then
    begin
      ShowMessage('Nagrywanie dźwięku nie wyłączyło się, anuluję wyjście. Wyłącz zapis dźwięku i spróbuj jeszcze raz.');
      CloseAction:=caNone;
      break;
    end;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  ext: string;
  l: integer;
begin
  OpenNapisy.InitialDir:=katalog;
  if OpenNapisy.Execute then
  begin
    katalog:=ExtractFilePath(OpenNapisy.FileName);
    napisy.LoadFromFile(OpenNapisy.FileName);
    ext:=ExtractFileExt(OpenNapisy.FileName);

    if ext='.srt' then l:=load_napisy_srt else
    if ext='.youtube' then l:=load_napisy_youtube;

    napisy.Clear;
    b_napisy:=l>0;
    led2.Active:=l>0;
  end;
  test;
  SendToAll('all','info','load_subtitle');
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  OpenFilm.InitialDir:=katalog;
  if OpenFilm.Execute then
  begin
    katalog:=ExtractFilePath(OpenFilm.FileName);
    film:=OpenFilm.FileName;
    b_film:=true;
    led1.Active:=true;
    led4DblClick(Sender);
  end;
  test;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  //if FileExists(wave) then if not mess.ShowConfirmationYesNo('Plik lektora już istnieje i zostanie nadpisany,^czy chcesz kontynuować?') then exit;
  BitBtn3.Enabled:=false;
  application.ProcessMessages;
  if CheckBox1.Checked then opozniony_start.Enabled:=true else procedura_startu;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  b_play:=false;
  rec_delay:=false;
  timer_czas.Enabled:=false;
  timer_czas_end.Enabled:=false;
  timer_time_display.Enabled:=false;
  Memo2.Visible:=false;
  rec_stop;
  film_stop;
  stat.Position:=0;
  stat1.Position:=0;
  stat2.Position:=0;
  czas_pomiarowy.Stop;
  test;
  SendToAll('all','info','stop');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if b_alternative_system_sound then silnik.UnLoadLibrary;
  napisy.Free;
  me.Clear;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if Panel6.Visible then mplayer2.Height:=mplayer.Height;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  mix: TStringList;
  mix_data: TAmixerSget;
begin
  if autorun then
  begin
    autorun:=false;
    {$IFDEF MSWINDOWS}
    //force_mpv.Checked:=false;
    {$ENDIF}
    ComboBox1Change(Sender);
    CheckBox2Change(Sender);
    if server_on.Checked then
    begin
      server.Port:=4665;
      b_server_on:=server.Connect;
      v_ts.Active:=b_server_on;
    end else b_server_on:=false;
    (* pobieramy wartość mixera - główny kanał *)
    sound_master_data.active:=false;
    mix:=TStringList.Create;
    try
      amixer.ExecuteMixer('scontrols','',mix);
      if pos('''Master''',mix.Text)>0 then
      begin
        amixer.ExecuteMixer('sget','Master',mix);
        mix_data:=amixer.ReadSGet(mix);
        sound_master_data.active:=true;
        sound_master_data.value:=mix_data.value;
        sound_master_data.percent:=mix_data.percent;
      end;
    finally
      mix.Free;
    end;
    {$IFDEF MSWINDOWS}
    if (not FileExists('mplayer\mplayer.exe')) and (not FileExists('mpv\mpv.exe')) then
      mess.ShowWarning('Brak zainstalowanych silników wideo!^Wgraj jeden z silników do właściwego katalogu, lub skorzystaj z opcji automatycznej instalacji, wybierając odpowiednią opcję z menu programu.^^Póki tego nie zrobisz, wyświetlanie wideo nie będzie możliwe.');
    {$ENDIF}
  end;
end;

procedure TForm1.led1DblClick(Sender: TObject);
begin
  film:='';
  b_film:=false;
  led1.Active:=false;
  test;
end;

procedure TForm1.led2DblClick(Sender: TObject);
begin
  me.Clear;
  b_napisy:=false;
  led2.Active:=false;
  SendToAll('all','info','load_subtitle');
end;

procedure TForm1.led3DblClick(Sender: TObject);
begin
  wave:='';
  led3.Active:=false;
  test;
end;

procedure TForm1.led4DblClick(Sender: TObject);
begin
  b_audio:=false;
  led4.Active:=false;
end;

procedure TForm1.meCreateElement(Sender: TObject; var AWskaznik: Pointer);
begin
  new(pp);
  AWskaznik:=pp;
end;

procedure TForm1.meDestroyElement(Sender: TObject; var AWskaznik: Pointer);
begin
  pp:=AWskaznik;
  dispose(pp);
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
var
  t: TStringList;
  i: integer;
  s,s1,s2: string;
  td: TDateTime;
begin
  if not b_napisy then
  begin
    mess.ShowInformation(Trans_000,Trans_001);
    exit;
  end;
  SaveNapisy.InitialDir:=katalog;
  if SaveNapisy.Execute then
  begin
    katalog:=ExtractFilePath(SaveNapisy.FileName);
    t:=TStringList.Create;
    try
      for i:=0 to me.Count-1 do
      begin
        me.Read(i);
        if i=0 then s:='.1' else s:=IntToStr(i+1);
        td:=IntegerToTime(element.start);
        s1:=FormatDateTime('hh:nn:ss,zzz',td);
        td:=IntegerToTime(element.stop);
        s2:=FormatDateTime('hh:nn:ss,zzz',td);
        t.Add(s);
        t.Add(s1+' --> '+s2);
        t.Add(element.tekst);
        t.Add('');
      end;
      t.SaveToFile(SaveNapisy.FileName);
    finally
      t.Free;
    end;
    mess.ShowInformation('Plik napisów został zapisany poprawnie.');
  end;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
var
  l: integer;
begin
  OpenRawNapisy.InitialDir:=katalog;
  if OpenRawNapisy.Execute then
  begin
    katalog:=ExtractFilePath(OpenRawNapisy.FileName);
    napisy.LoadFromFile(OpenRawNapisy.FileName);
    l:=load_napisy_raw;
    napisy.Clear;
    b_napisy:=l>0;
    led2.Active:=l>0;
  end;
  test;
  SendToAll('all','info','load_subtitle');
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
var
  s: TStringList;
begin
  s:=TStringList.Create;
  s.Add(MENU_001);
  s.Add('');
  s.Add('00:09');
  s.Add(MENU_002+'...');
  s.Add('00:18');
  s.Add(MENU_003+'...');
  s.Add('00:24');
  s.Add(MENU_004+'...');
  s.Add('00:30');
  s.Add(MENU_005+'...');
  s.Add('00:38');
  s.Add(MENU_006+'...');
  s.Add('');
  s.Add(MENU_007);
  mess.ShowInformation(MENU_008,s.Text);
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  BitBtn5.Click;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  if mess.ShowConfirmationYesNo(MENU_009+'^^'+MENU_010) then
  begin
    FPobieranie:=TFPobieranie.Create(self);
    try
      FPobieranie.tytul:=MENU_011;
      FPobieranie.hide_dest_filename:=true;
      FPobieranie.show_info_end:=true;
      FPobieranie.info_end_caption:=MENU_012;
      FPobieranie.link_download:=LINK_MPLAYERS_ENGINE;
      FPobieranie.plik:='player_engine.zip';
      FPobieranie.unzipping:=true;
      FPobieranie.delete_for_exit:=true;
      FPobieranie.ShowModal;
    finally
      FPobieranie.Free;
    end;
  end;
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  FAbout.ShowModal;
end;

procedure TForm1.meReadElement(Sender: TObject; var AWskaznik: Pointer);
begin
  pp:=AWskaznik;
  element:=pp^;
end;

procedure TForm1.meWriteElement(Sender: TObject; var AWskaznik: Pointer);
begin
  pp^:=element;
  AWskaznik:=pp;
end;

procedure TForm1.mplayerStop(Sender: TObject);
begin
  //rec_delay:=false;
  BitBtn4.Click;
end;

procedure TForm1.serverError(const aMsg: string; aSocket: TLSocket);
begin
  inc(server_err);
end;

procedure TForm1.serverReceiveString(aMsg: string; aSocket: TLSocket);
var
  czas_otrzymania_ramki,czas_wyslania_ramki: integer;
  i: integer;
  s,ss,tekst: string;
  kod,ip,komenda,opcja: string;
  numer,start,stop: integer;
begin
  {
  "CTL"$IP_ADDRESS$COMMAND[$OPTION]
  }
  czas_otrzymania_ramki:=TimeToInteger;
  s:=aMsg;
  kod:=GetLineToStr(s,1,'$');
  if kod='CTL' then
  begin
    ip:=GetLineToStr(s,2,'$');
    komenda:=GetLineToStr(s,3,'$');
    opcja:=GetLineToStr(s,4,'$');
    if komenda='count' then SendToAll(ip,'count',IntToStr(me.Count)) else
    if komenda='segment' then
    begin
      numer:=StrToInt(opcja);
      me.Read(numer);
      start:=element.start;
      stop:=element.stop;
      tekst:=element.tekst;
      SendToAll(ip,'segment',IntToStr(numer)+':'+IntToStr(start)+':'+IntToStr(stop)+':'+tekst);
    end else if komenda='segments' then
    begin
      ss:='';
      for i:=0 to me.Count-1 do
      begin
        me.Read(i);
        start:=element.start;
        stop:=element.stop;
        tekst:=element.tekst;
        if i=0 then ss:=IntToStr(start)+':'+IntToStr(stop)+':'+tekst else ss:=ss+#9+IntToStr(start)+':'+IntToStr(stop)+':'+tekst;
      end;
      SendToAll(ip,'segments',ss);
    end else if komenda='start' then
    begin
      if BitBtn3.Enabled then
      begin
        BitBtn3.Click;
        SendToAll(ip,'start','1');
      end else SendToAll(ip,'start','0');
    end else if komenda='stop' then
    begin
      if BitBtn4.Enabled then
      begin
        BitBtn4.Click;
        SendToAll(ip,'stop','1');
      end else SendToAll(ip,'stop','0');
    end else if komenda='index_time' then
    begin
      SendToAll(ip,'index_time',IntToStr(czas_pomiarowy.GetIndexStartTime)+':'+IntToStr(speed.Value)+':'+IntToStr(trunc(opoznienie_napisow.Value*100))+':'+IntToStr(Wczytano));
    end else if komenda='status' then
    begin
      if b_play then SendToAll(ip,'status','1') else SendToAll(ip,'status','0');
    end;
  end;
end;

procedure TForm1.opozniony_startTimer(Sender: TObject);
begin
  opozniony_start.Enabled:=false;
  procedura_startu;
end;

procedure TForm1.play_synchroTimer(Sender: TObject);
begin
  play_synchro.Enabled:=false;
  start_init_2;
end;

procedure TForm1.soAfterStart(Sender: TObject);
begin
  led.Active:=true;
  timer_meter.Enabled:=true;
end;

procedure TForm1.soAfterStop(Sender: TObject);
begin
  led.Active:=false;
  timer_meter.Enabled:=false;
end;

procedure TForm1.timer_czasTimer(Sender: TObject);
begin
  if b_napisy then wczytaj_napisy;
end;

procedure TForm1.timer_czas_endTimer(Sender: TObject);
var
  indeks,t2: integer;
begin
  indeks:=czas_pomiarowy.GetIndexTime;
  if speed.Value=100 then t2:=TimeToInteger(TimeEdit2.Time)
                        else t2:=round(TimeToInteger(TimeEdit2.Time)*(100/speed.Value));
  if indeks>t2 then
  begin
    timer_czas_end.Enabled:=false;
    BitBtn4.Click;
  end;
end;

procedure TForm1.timer_delay_soundTimer(Sender: TObject);
begin
  timer_delay_sound.Enabled:=false;
  rec.Stop;
  test;
end;

procedure TForm1.timer_meterStopTimer(Sender: TObject);
begin
  meter2.Position:=0;
  meter1.Position:=0;
end;

procedure TForm1.timer_meterTimer(Sender: TObject);
var
  a,b: integer;
begin
  rec.GetMeter(a,b);
  if a>meter1.Position then meter1.Position:=a else if meter1.Position>0 then meter1.Position:=meter1.Position-1;
  if b>meter2.Position then meter2.Position:=b else if meter2.Position>0 then meter2.Position:=meter2.Position-1;
end;

procedure TForm1.timer_mplayer2Timer(Sender: TObject);
begin
  timer_mplayer2.Enabled:=false;
  mplayer2.Play;
end;

procedure TForm1.timer_time_displayTimer(Sender: TObject);
var
  t: integer;
begin
  t:=czas_pomiarowy.GetIndexTime;
  if speed.Value=100 then
    time_display.Caption:=FormatDateTime('hh:nn:ss',IntegerToTime(t))
  else
    time_display.Caption:=FormatDateTime('hh:nn:ss',IntegerToTime(round(t*speed.Value/100)));
end;

procedure TForm1.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  katalog:=XMLPropStorage1.ReadString('WorkDirectory','');
end;

procedure TForm1.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.WriteString('WorkDirectory',katalog);
end;

procedure TForm1.test;
begin
  BitBtn3.Enabled:=((b_napisy or b_film) and (not b_play) and (not led.Active));
  BitBtn4.Enabled:=b_play;
end;

procedure TForm1.start_init;
begin
  wczytano:=0;
  Memo1.Clear;
  stat1.Min:=0;
  stat1.Position:=0;
  stat2.Min:=0;
  stat2.Position:=0;
  film_start;
  if synchro_video.Value>0 then
  begin
    play_synchro.Interval:=round(synchro_video.Value*1000);
    play_synchro.Enabled:=true;
  end else start_init_2;
end;

procedure TForm1.start_init_2;
var
  a,i,pom,granica: integer;
begin
  if b_napisy then
  begin
    if speed.Value=100 then stat1.Max:=czas_max
                          else stat1.Max:=round(czas_max*(100/speed.Value));
    (* jeśli film startuje od innego czasu - przesuwam też napisy do tego czasu *)
    if CheckBox3.Checked then
    begin
      a:=me.Count;
      i:=0;
      granica:=TimeToInteger(TimeEdit1.Time);
      while i<a do
      begin
        me.Read(i);
        pom:=element.start;
        if pom>granica then break;
        inc(i);
      end;
      wczytano:=i;
    end;
  end;
  if CheckBox2.Checked or (film='') then
  begin
    Memo2.Clear;
    Memo2.Visible:=true;
  end;
  (* GO! *)
  if CheckBox3.Checked then
  begin
    if speed.Value=100 then czas_pomiarowy.Start(TimeToInteger-TimeToInteger(TimeEdit1.Time))
                          else czas_pomiarowy.Start(TimeToInteger-round(TimeToInteger(TimeEdit1.Time)*(100/speed.Value)));
  end else czas_pomiarowy.Start;
  b_play:=true;
  rec_start;
  (* reszta *)
  if b_napisy then
  begin
    if not CheckBox2.Checked then timer_czas.Enabled:=true else
    begin
      Memo2.Clear;
      me.Read(wczytano);
      Memo2.Lines.Add(element.tekst);
    end;
  end;
  timer_czas_end.Enabled:=CheckBox4.Checked;
  timer_time_display.Enabled:=true;
  test;
  SendToAll('all','info','start');
end;

procedure TForm1.wczytaj_napisy;
var
  i: integer;
  czas,max: integer;
  s,s2: string;
  start2,stop2: integer;
begin
  pom:=czas_pomiarowy.GetIndexTime;
  if speed.Value=100 then max:=czas_max else max:=round(czas_max*(100/speed.Value));
  if pom-(opoznienie_napisow.Value*1000)>=max then
  begin
    if mplayer.Playing then timer_czas.Enabled:=false else BitBtn4.Click;
    exit;
  end;
  if wczytano>wczytano_count then exit;
  if me.Count>wczytano+1 then
  begin
    me.Read(wczytano+1);
    start2:=element.start;
    s2:=element.tekst;
    stop2:=element.stop;
  end;
  me.Read(wczytano);
  if speed.Value=100 then czas:=element.start else czas:=round(element.start*(100/speed.Value));
  if Memo2.Visible and (wczytano=0) and (Memo2.Lines.Count=0) then Memo2.Lines.Add(element.tekst);
  if pom-(opoznienie_napisow.Value*1000)>=czas then
  begin
    czas_elementu:=pom;
    if speed.Value=100 then
    begin
      stat.Min:=0;
      stat.Max:=element.stop-element.start;
      stat2.Max:=start2-element.stop;
    end else begin
      stat.Min:=0;
      stat.Max:=round((element.stop-element.start)*(100/speed.Value));
      stat2.Max:=round((start2-element.stop)*(100/speed.Value));
    end;
    czas_elementu2:=czas_elementu+stat.Max;
    if Memo2.Visible then
    begin
      Memo1.Lines.Add(' - - - - - - -');
      Memo1.Lines.Add(element.tekst);
      if me.Count>wczytano+1 then
      begin
        me.Read(wczytano+1);
        s:=element.tekst;
      end else s:='';
      Memo2.Clear;
      Memo2.Lines.Add(s);
    end else Memo1.Lines.Add(element.tekst);
    inc(wczytano);
    if Memo2.Visible then
      while Memo1.Lines.Count>3 do Memo1.Lines.Delete(0)
    else
      while Memo1.Lines.Count>historia_napisy.Value do Memo1.Lines.Delete(0);
  end;
  if stat.Position<stat.Max then stat2.Position:=0 else stat2.Position:=pom-czas_elementu2;
  stat.Position:=pom-czas_elementu;
  stat1.Position:=pom;
end;

procedure TForm1.film_start;
var
  ss,s,s2,s3: string;
  ss_mplayer: string;
begin
  if film='' then exit;
  ss_mplayer:='';
  {$IFDEF MSWINDOWS}
  if force_mpv.Checked then ss:='-vo direct3d -fs -subcp utf-8' else ss:='-vo directx -fs -subcp utf-8';
  {$ELSE}
  ss:='-vo x11 -fs';
  {$ENDIF}
  if force_mpv.Checked then mplayer.Engine:=meMPV else
  begin
    mplayer.Engine:=meMplayer;
    ss:=ss+' -zoom';
    if CheckBox6.Checked then ss_mplayer:=' -ao jack';
  end;
  mplayer2.Engine:=mplayer.Engine;
  if speed.Value=100 then s:='' else s:=' -speed '+FormatFloat('0.00',speed.Value/100);
  if b_audio then s2:=' -audiofile "'+audio+'"' else s2:='';
  if CheckBox3.Checked then s3:=' -ss '+FormatDateTime('hh:nn:ss',TimeEdit1.Time)+'' else s3:='';
  mplayer.StartParam:=ss+ss_mplayer+s+s2+s3;
  mplayer.Filename:=film;
  mplayer.Play;
  if not b_napisy then
  begin
    Panel6.Visible:=true;
    mplayer2.Height:=mplayer.Height;
    mplayer2.StartParam:=ss+s+s3;
    mplayer2.Filename:=film;
    timer_mplayer2.Interval:=opoznienie.Value*1000;
    timer_mplayer2.Enabled:=true;
  end;
end;

procedure TForm1.film_stop;
begin
  timer_mplayer2.Enabled:=false;
  mplayer.Stop;
  mplayer2.Stop;
  Panel6.Visible:=false;
end;

procedure TForm1.rec_start;
begin
  if wave='' then exit;
  rec_delay:=true;
  rec.FileName:=wave;
  rec.Start;
end;

procedure TForm1.rec_stop;
begin
  if wave='' then exit;
  if rec_delay then
  begin
    rec_delay:=false;
    timer_delay_sound.Enabled:=true;
  end else begin
    rec.Stop;
  end;
end;

procedure TForm1.procedura_startu;
begin
  start_init;
end;

function TForm1.load_napisy_srt: integer;
var
  i,l: integer;
  krok: integer;
  c1,c2: integer;
  s,s1,s2,ss: string;
  //fs: TFormatSettings;
begin
  //fs.DecimalSeparator:='.';
  me.Clear;
  krok:=0;
  ss:='';
  for i:=0 to napisy.Count-1 do
  begin
    s:=napisy[i];
    if s='' then
    begin
      if ss<>'' then
      begin
        element.start:=c1;
        element.stop:=c2;
        element.tekst:=ss;
        czas_max:=c2;
        me.Add;
        ss:='';
      end;
      krok:=0;
      continue;
    end;
    if krok=0 then
    begin
      krok:=1;
      continue;
    end;
    if krok=1 then
    begin
      s1:=copy(s,1,12);
      s2:=copy(s,18,12);
      {$IFDEF MSWINDOWS}
      try
        c1:=TimeToInteger(StrToTime(s1));
        c2:=TimeToInteger(StrToTime(s2));
      except
        c1:=TimeToInteger(StrToTime(StringReplace(s1,',','.',[])));
        c2:=TimeToInteger(StrToTime(StringReplace(s2,',','.',[])));
      end;
      {$ELSE}
      c1:=TimeToInteger(StrToTime(StringReplace(s1,',','.',[])));
      c2:=TimeToInteger(StrToTime(StringReplace(s2,',','.',[])));
      {$ENDIF}
      krok:=2;
      continue;
    end;
    if krok=2 then
    begin
      if ss='' then ss:=s else ss:=ss+' '+s;
    end;
  end;
  l:=me.Count;
  wczytano_count:=l;
  result:=l;
end;

function TForm1.load_napisy_youtube: integer;
var
  i,l: integer;
  s,ss: string;

  czas: integer;
  hour,minutes,second: word;
begin
  me.Clear;
  ss:='';
  for i:=0 to napisy.Count-1 do
  begin
    s:=napisy[i];
    if (length(s)=5) and IsDigit(s[1]) and IsDigit(s[2]) and (s[3]=':') and IsDigit(s[4]) and IsDigit(s[5]) then
    begin
      if ss<>'' then
      begin
        element.start:=czas;
        element.stop:=czas;
        element.tekst:=ss;
        czas_max:=czas;
        me.Add;
        ss:='';
      end;
      try
        second:=StrToInt(copy(s,4,2));
        minutes:=StrToInt(copy(s,1,2));
        hour:=0;
        while minutes>60 do
        begin
          inc(hour);
          dec(minutes,60);
        end;
      except
        mess.ShowInformation(copy(s,1,2)+'^'+copy(s,4,2));
      end;
      czas:=TimeToInteger(hour,minutes,second,0);
      continue;
    end else begin
      if ss='' then ss:=s else ss:=ss+' '+s;
    end;
  end;
  if ss<>'' then
  begin
    element.start:=czas;
    element.stop:=czas;
    element.tekst:=ss;
    czas_max:=czas;
    me.Add;
    ss:='';
  end;
  l:=me.Count;
  for i:=0 to l-2 do
  begin
    me.Read(i+1);
    czas:=element.start;
    me.Read(i);
    element.stop:=czas;
    me.Edit(i);
  end;
  wczytano_count:=l;
  result:=l;
end;

function TForm1.load_napisy_raw: integer;
var
  i,l: integer;
  s: string;
begin
  me.Clear;
  for i:=0 to napisy.Count-1 do
  begin
    s:=napisy[i];
    element.start:=0;
    element.stop:=0;
    element.tekst:=s;
    czas_max:=0;
    me.Add;
  end;
  l:=me.Count;
  wczytano_count:=l;
  result:=l;
end;

procedure TForm1.SendToAll(adres_ip, rodzaj: string; const ramka: string;
  dolacz_czas_wyslania_ramki: boolean);
var
  n: integer;
  s: string;
begin
  s:='CTL$'+adres_ip+'$'+rodzaj+'$'+ramka;
  if dolacz_czas_wyslania_ramki then s:=s+':'+IntToStr(TimeToInteger);
  server.SendString(s);
end;

end.

