unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, NetSynHTTP;

type

  { TFAbout }

  TFAbout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    http: TNetSynHTTP;
    SpeedButton1: TSpeedButton;
    wersja: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    vMajorVersion,vMinorVersion,vRelease,vBuild: integer;
    function czy_jest_nowsza_wersja(v1,v2: integer): boolean;
  public

  end;

var
  FAbout: TFAbout;

implementation

uses
  cverinfo, ecode;

{$R *.lfm}

{ TFAbout }

resourcestring
  STR_001 = 'Istnieje nowsza wersja';
  STR_002 = 'Twoja wersja jest aktualna.';

procedure TFAbout.FormCreate(Sender: TObject);
var
  s1,s2,s3: string;
begin
  GetProgramVersion(vMajorVersion,vMinorVersion,vRelease,vBuild);
  GetProgramVersion(s1,s2,s3);
  wersja.Caption:='(ver. '+s3+')';
end;

procedure TFAbout.SpeedButton1Click(Sender: TObject);
var
  status,a,b: integer;
  s: string;
  major,minor: integer;
begin
  if SpeedButton1.Color=clRed then exit;
  status:=http.execute('https://sourceforge.net/projects/lektor-pomocnik-lektora/files/',s);
  a:=pos('Download Latest Version',s);
  if a>0 then
  begin
    delete(s,1,a);
    a:=pos('lektor_',s);
    if a>0 then
    begin
      delete(s,1,a-1);
      a:=pos('zip',s);
      b:=pos('tar.gz',s);
      if (b>0) and (b<a) then a:=b;
      if a>0 then delete(s,a,100000);
      s:=GetLineToStr(s,2,'_');
      major:=StrToInt(GetLineToStr(s,1,'.'));
      minor:=StrToInt(GetLineToStr(s,2,'.'));
      if czy_jest_nowsza_wersja(major,minor) then
      begin
        SpeedButton1.Caption:=STR_001+' '+IntToStr(major)+'.'+IntToStr(minor);
        SpeedButton1.Color:=clRed;
      end else begin
        SpeedButton1.Caption:=STR_002;
        SpeedButton1.Color:=clGreen;
      end;
    end;
  end;
end;

function TFAbout.czy_jest_nowsza_wersja(v1, v2: integer): boolean;
begin
  if (v1>vMajorVersion) or ((v1=vMajorVersion) and (v2>vMinorVersion)) then result:=true else result:=false;
end;

end.

