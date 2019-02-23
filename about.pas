unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFAbout }

  TFAbout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    wersja: TLabel;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FAbout: TFAbout;

implementation

uses
  cverinfo;

{$R *.lfm}

{ TFAbout }

procedure TFAbout.FormCreate(Sender: TObject);
var
  s1,s2,s3: string;
begin
  GetProgramVersion(s1,s2,s3);
  wersja.Caption:='(ver. '+s3+')';
end;

end.

