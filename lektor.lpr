program lektor;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, LazUTF8, DefaultTranslator, LCLTranslator, // this includes the LCL widgetset
  Forms, main, uecontrols, abbrevia, lnetvisual, about;

{$R *.res}

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

begin
  lang:=getlang;
  if lang<>'pl' then lang:='en';
  SetDefaultLang(lang);
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFAbout, FAbout);
  Application.Run;
end.

