//Created by https://www.youtube.com/channel/UCuMU7RQOBND14Fqd0koAGqA
unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, GraphicsControl,
  Vcl.StdCtrls, Pobot;

type
  TMainForm = class(TForm)
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Graphics: TGraphicsControl;
    RobotController: TRobot;
  end;

var
  MainForm: TMainForm;

implementation


{$R *.dfm}

procedure TMainForm.Button2Click(Sender: TObject);
begin
  //Graphics.ReStart;

  WinExec(pansichar(AnsiString(ExtractFileName(Application.ExeName))), SW_SHOWNORMAL);
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Graphics := TGraphicsControl.Create(self);
  Graphics.Parent := self;
  Graphics.Top := 28;
  Graphics.Left := 4;

  RobotController := TRobot.Create(Graphics);

end;

end.
