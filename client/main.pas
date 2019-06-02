unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, XMLPropStorage, lNetComponents, lNet, PointerTab,
  LiveTimer, NetSocket;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    czas_pomiarowy: TLiveTimer;
    Edit1: TEdit;
    Label1: TLabel;
    me: TPointerTab;
    Memo1: TMemo;
    Memo2: TMemo;
    client: TNetSocket;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    SpeedButton1: TSpeedButton;
    Splitter1: TSplitter;
    stat: TProgressBar;
    stat1: TProgressBar;
    stat2: TProgressBar;
    StatusBar1: TStatusBar;
    close_delay: TTimer;
    autorun: TTimer;
    timer_czas: TTimer;
    XMLPropStorage1: TXMLPropStorage;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure clientTimeVector(aTimeVector: integer);
    procedure close_delayTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure meCreateElement(Sender: TObject; var AWskaznik: Pointer);
    procedure meDestroyElement(Sender: TObject; var AWskaznik: Pointer);
    procedure meReadElement(Sender: TObject; var AWskaznik: Pointer);
    procedure meWriteElement(Sender: TObject; var AWskaznik: Pointer);
    procedure clientConnect(aSocket: TLSocket);
    procedure clientDisconnect(aSocket: TLSocket);
    procedure clientError(const aMsg: string; aSocket: TLSocket);
    procedure clientReceiveString(aMsg: string; aSocket: TLSocket);
    procedure SpeedButton1Click(Sender: TObject);
    procedure timer_czasTimer(Sender: TObject);
  private
    komendy: TStringList;
    function reconnect: boolean;
    procedure synchronize_time;
    procedure wczytaj_tekst;
    procedure pobierz_status;
    function czytaj_i_usun_pierwsza_zmienna(var wartosc: string; znacznik: string = '$'): string;
    procedure wlacz;
    procedure wylacz;
    procedure wczytaj_napisy;
  public

  end;

var
  Form1: TForm1;

implementation

uses
  ecode;

type
  TElement = record
    start,stop: integer;
    tekst: string;
  end;
  TElementKolejki = record
    komenda: string;
  end;
  TTabelaNtp = record
    t1,t2,t3,t4: integer;
    wynik: integer;
  end;

var
  element: TElement;
  pp: ^TElement;

var
  _BLOKUJ: boolean = false;
  client_err: integer = 0;
  start_net: boolean = true;
  operacja: integer = 0; {1: synchronizacja czasu, 2: wczytanie tekstu}
  operacja_count: integer = 0;
  operacja_index: integer = 0;
  pom,wczytano,wczytano_count,speed,opoznienie_napisow: integer;
  czas_elementu,czas_elementu2,czas_max: integer;
  ntp_count: integer;
  ntp_t1: integer;
  ntp_srednia: integer;
  wektor_czasu: integer = 0;

{$R *.lfm}

{ TForm1 }

procedure TForm1.autorunTimer(Sender: TObject);
var
  s: string;
  b: boolean;
begin
  if _BLOKUJ or (komendy.Count=0) then exit;
  s:=komendy[0];
  komendy.Delete(0);
  if s='ntp' then
  begin
    _BLOKUJ:=true;
    client.GetTimeVector;
  end else
  if s='wczytaj_tekst' then wczytaj_tekst else
  if s='status' then pobierz_status else
  if s='start' then
  begin
    //if CheckBox2.Checked then client.SendMessage('CTL$'+Edit1.Text+'$start:1')
    //else client.SendMessage('CTL$'+Edit1.Text+'$start:1');
    client.SendString('CTL$'+Edit1.Text+'$start');
  end else
  if s='stop' then client.SendString('CTL$'+Edit1.Text+'$stop');
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  komendy.Add('start');
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  komendy.Add('stop');
end;

procedure TForm1.clientTimeVector(aTimeVector: integer);
begin
  _BLOKUJ:=false;
  czas_pomiarowy.Correction:=aTimeVector;
  StatusBar1.Panels[2].Text:='Wektor czasu: '+IntToStr(aTimeVector)+' ms.';
end;

procedure TForm1.close_delayTimer(Sender: TObject);
begin
  close_delay.Enabled:=false;
  close;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  me.Clear;
  if client.Active then
  begin
    CloseAction:=caNone;
    client.Disconnect;
    close_delay.Enabled:=true;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  komendy:=TStringList.Create;
  Memo1.Clear;
  Memo2.Clear;
  SetConfDir('lektor');
  XMLPropStorage1.FileName:=MyConfDir('client.xml');
  XMLPropStorage1.Active:=true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  komendy.Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if start_net then
  begin
    start_net:=false;
    if Edit1.Text<>'' then SpeedButton1.Click;
  end;
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

procedure TForm1.clientConnect(aSocket: TLSocket);
begin
  StatusBar1.Panels[0].Text:='Serwer: '+Edit1.Text;
  StatusBar1.Panels[1].Text:='Połączenie: OK';
  komendy.Clear;
  komendy.Add('ntp');
  komendy.Add('wczytaj_tekst');
  komendy.Add('status');
  operacja:=0;
  _BLOKUJ:=false;
  autorun.Enabled:=true;
end;

procedure TForm1.clientDisconnect(aSocket: TLSocket);
begin
  autorun.Enabled:=false;
  StatusBar1.Panels[0].Text:='Serwer: ';
  StatusBar1.Panels[1].Text:='Połączenie:';
end;

procedure TForm1.clientError(const aMsg: string; aSocket: TLSocket);
begin
  inc(client_err);
end;

procedure TForm1.clientReceiveString(aMsg: string; aSocket: TLSocket);
var
  WYSLIJ_STRING: string;
  czas_odebrania_ramki: integer;
  ctl,s: string;
  adresat,komenda,odpowiedz: string;
  numer,start,stop,pom,i: integer;
  tekst: string;
begin
  czas_odebrania_ramki:=TimeToInteger;
  s:=aMsg;
  WYSLIJ_STRING:='';
  ctl:=czytaj_i_usun_pierwsza_zmienna(s);
  if ctl<>'CTL' then exit;
  adresat:=czytaj_i_usun_pierwsza_zmienna(s);
  if (adresat=Edit1.Text) or (adresat='all') then
  begin
    komenda:=czytaj_i_usun_pierwsza_zmienna(s);
    odpowiedz:=s;
    if komenda='info' then
    begin
      if odpowiedz='start' then client.SendString('CTL$'+Edit1.Text+'$index_time') else
      if odpowiedz='stop' then wylacz else
      if odpowiedz='exit' then
      begin
        client.Disconnect(true);
        close;
      end else
      if odpowiedz='load_subtitle' then wczytaj_tekst;
    end else
    if komenda='count' then
    begin
      operacja_count:=StrToInt(odpowiedz);
      if operacja=1 then
      begin
        if operacja_count=0 then
        begin
          me.Clear;
          operacja:=0;
          _BLOKUJ:=false;
        end else client.SendString('CTL$'+Edit1.Text+'$segment$0');
        Memo1.Lines.Add('Do zsynchronizowania: '+IntToStr(operacja_count)+' ramek');
      end;
    end else
    if komenda='segment' then
    begin
      numer:=StrToInt(GetLineToStr(odpowiedz,1,':'));
      start:=StrToInt(GetLineToStr(odpowiedz,2,':'));
      stop:=StrToInt(GetLineToStr(odpowiedz,3,':'));
      for i:=1 to 3 do
      begin
        pom:=pos(':',odpowiedz);
        delete(odpowiedz,1,pom);
      end;
      tekst:=odpowiedz;
      element.start:=start;
      element.stop:=stop;
      element.tekst:=tekst;
      if operacja=1 then
      begin
        me.Add;
        if numer<operacja_count-1 then
        begin
          WYSLIJ_STRING:='CTL$'+Edit1.Text+'$segment$'+IntToStr(numer+1);
        end else begin
          Memo1.Lines.Add('Ramki tekstu zostały wczytane.');
          wczytano_count:=me.Count;
          operacja:=0;
          _BLOKUJ:=false;
        end;
      end;
    end else
    if komenda='segments' then
    begin
      me.Clear;
      while odpowiedz<>'' do
      begin
        s:=czytaj_i_usun_pierwsza_zmienna(odpowiedz,#9);
        element.start:=StrToInt(czytaj_i_usun_pierwsza_zmienna(odpowiedz,':'));
        element.stop:=StrToInt(czytaj_i_usun_pierwsza_zmienna(odpowiedz,':'));
        element.tekst:=s;
        me.Add;
      end;
    end else
    if komenda='index_time' then
    begin
      czas_pomiarowy.Start(StrToInt(czytaj_i_usun_pierwsza_zmienna(odpowiedz,':')));
      speed:=StrToInt(czytaj_i_usun_pierwsza_zmienna(odpowiedz,':'));
      opoznienie_napisow:=StrToInt(czytaj_i_usun_pierwsza_zmienna(odpowiedz,':'));
      wczytano:=StrToInt(odpowiedz);
      if wczytano>1 then dec(wczytano);
      wlacz;
    end else
    if komenda='status' then
    begin
      _BLOKUJ:=false;
      Memo1.Lines.Add('STATUS: '+odpowiedz);
      if odpowiedz='1' then client.SendString('CTL$'+Edit1.Text+'$index_time') else wylacz;
    end;
  end;
  if WYSLIJ_STRING<>'' then
  begin
    client.SendString(WYSLIJ_STRING);
    WYSLIJ_STRING:='';
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  reconnect;
end;

procedure TForm1.timer_czasTimer(Sender: TObject);
begin
  wczytaj_napisy;
end;

function TForm1.reconnect: boolean;
begin
  if client.Active then client.Disconnect;
  sleep(200);
  client.Host:=Edit1.Text;
  client.Port:=4665;
  result:=client.Connect;
end;

procedure TForm1.synchronize_time;
begin
  _BLOKUJ:=true;
  ntp_count:=0;
  ntp_srednia:=0;
  ntp_t1:=TimeToInteger;
  client.SendString('CTL$'+Edit1.Text+'$ntp');
end;

procedure TForm1.wczytaj_tekst;
begin
  _BLOKUJ:=true;
  operacja:=1;
  me.Clear;
  client.SendString('CTL$'+Edit1.Text+'$count');
end;

procedure TForm1.pobierz_status;
begin
  _BLOKUJ:=true;
  client.SendString('CTL$'+Edit1.Text+'$status');
end;

function TForm1.czytaj_i_usun_pierwsza_zmienna(var wartosc: string;
  znacznik: string): string;
var
  s,ss: string;
  a: integer;
begin
  ss:=wartosc;
  a:=pos(znacznik,ss);
  if a>0 then
  begin
    s:=copy(ss,1,a-1);
    delete(ss,1,a);
  end;
  wartosc:=ss;
  result:=s;
end;

procedure TForm1.wlacz;
var
  a,b,max: integer;
begin
  Memo1.Clear;
  Memo2.Clear;
  stat1.Min:=0;
  stat1.Position:=0;
  stat2.Min:=0;
  stat2.Position:=0;
  a:=me.Count;
  me.Read(a-1);
  a:=element.start;
  b:=element.stop;
  max:=a;
  if b>max then max:=b;
  if speed=100 then stat1.Max:=max
               else stat1.Max:=round(max*(100/speed));
  timer_czas.Enabled:=true;
end;

procedure TForm1.wylacz;
begin
  timer_czas.Enabled:=false;
  czas_pomiarowy.Stop;
  Memo1.Clear;
  Memo2.Clear;
end;

procedure TForm1.wczytaj_napisy;
var
  i: integer;
  czas: integer;
  s,s2: string;
  start2,stop2: integer;
begin
  if wczytano>wczytano_count then
  begin
    wylacz;
    exit;
  end;
  pom:=czas_pomiarowy.GetIndexTime;
  if me.Count>wczytano+1 then
  begin
    me.Read(wczytano+1);
    start2:=element.start;
    s2:=element.tekst;
    stop2:=element.stop;
  end;
  me.Read(wczytano);
  if speed=100 then czas:=element.start else czas:=round(element.start*(100/speed));
  if Memo1.Visible and (wczytano=0) and (Memo1.Lines.Count=0) then Memo1.Lines.Add(element.tekst);
  if pom-(opoznienie_napisow*10)>=czas then
  begin
    czas_elementu:=pom;
    if speed=100 then
    begin
      stat.Min:=0;
      stat.Max:=element.stop-element.start;
      stat2.Max:=start2-element.stop;
    end else begin
      stat.Min:=0;
      stat.Max:=round((element.stop-element.start)*(100/speed));
      stat2.Max:=round((start2-element.stop)*(100/speed));
    end;
    czas_elementu2:=czas_elementu+stat.Max;
    if Memo1.Visible then
    begin
      if not CheckBox1.Checked then Memo2.Lines.Add(' - - - - - - -');
      Memo2.Lines.Add(element.tekst);
      if me.Count>wczytano+1 then
      begin
        me.Read(wczytano+1);
        s:=element.tekst;
      end else s:='';
      Memo1.Clear;
      Memo1.Lines.Add(s);
    end else Memo2.Lines.Add(element.tekst);
    inc(wczytano);
    if CheckBox1.Checked then
      while Memo2.Lines.Count>10 do Memo2.Lines.Delete(0)
    else
      while Memo2.Lines.Count>3 do Memo2.Lines.Delete(0);
  end;
  if stat.Position<stat.Max then stat2.Position:=0 else stat2.Position:=pom-czas_elementu2;
  stat.Position:=pom-czas_elementu;
  stat1.Position:=pom;
end;

end.

