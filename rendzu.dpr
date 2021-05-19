//Created by https://www.youtube.com/channel/UCuMU7RQOBND14Fqd0koAGqA
program rendzu;

uses
  Vcl.Forms,
  main in 'main.pas' {MainForm},
  GraphicsControl in 'GraphicsControl.pas',
  Pobot in 'Pobot.pas',
  PatternReader in 'PatternReader.pas';

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := true;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
