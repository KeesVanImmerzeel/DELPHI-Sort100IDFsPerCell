program Sort100IDFsPerCell;

uses
  Vcl.Forms,
  uSort100IDFsPerCell in 'uSort100IDFsPerCell.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
