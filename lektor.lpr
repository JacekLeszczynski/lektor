program lektor;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, CustApp, ExtParams, cverinfo,
  Interfaces, LazUTF8, DefaultTranslator, LCLTranslator, // this includes the LCL widgetset
  Forms, main, uecontrols, abbrevia, lnetvisual, about;

{$R *.res}

type

  { TLektor }

  TLektor = class(TCustomApplication)
  protected
    procedure DoRun; override;
  private
    par: TExtParams;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  lang: string;

function GetLang: string;
var
  T: string; // unused FallBackLang
  i: integer;
begin
  Result := '';
  { We use the same method that is used in LCLTranslator unit }

  for i := 1 to Paramcount - 1 do
    if (ParamStrUTF8(i) = '--LANG') or (ParamStrUTF8(i) = '-l') or
      (ParamStrUTF8(i) = '--lang') then
      Result := ParamStrUTF8(i + 1);

  //Win32 user may decide to override locale with LANG variable.
  if Result = '' then
    Result := GetEnvironmentVariableUTF8('LANG');

  if Result = '' then
    LazGetLanguageIDs(Result, {%H-}T);

  if length(Result)>2 then Result:=copy(Result,1,2);
end;

{ TLektor }

procedure TLektor.DoRun;
var
  v1,v2,v3,v4: integer;
  go_exit: boolean;
begin
  inherited DoRun;
  go_exit:=false;
  lang:=getlang;
  if (lang<>'pl') and (lang<>'ru') then lang:='en';
  SetDefaultLang(lang);

  par:=TExtParams.Create(nil);
  try
    par.Execute;
    if par.IsParam('ver') then
    begin
      GetProgramVersion(v1,v2,v3,v4);
      writeln(v1,'.',v2,'.',v3,'-',v4);
      go_exit:=true;
    end;
  finally
    par.Free;
  end;

  if go_exit then
  begin
    terminate;
    exit;
  end;

  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFAbout, FAbout);
  Application.Run;
  Terminate;
end;

constructor TLektor.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TLektor.Destroy;
begin
  inherited Destroy;
end;

var
  L: TLektor;

begin
  L:=TLektor.Create(nil);
  L.Title:='Lektor - Pomocnik Lektora';
  L.Run;
  L.Free;
end.

