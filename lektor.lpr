program lektor;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, DefaultTranslator, // this includes the LCL widgetset
  Forms, main, uecontrols, abbrevia, lnetvisual, about;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFAbout, FAbout);
  Application.Run;
end.

