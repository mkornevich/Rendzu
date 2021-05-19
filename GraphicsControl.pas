unit GraphicsControl;

//сделать нормальное обращение и изменение игровой решетки


interface
  uses vcl.ExtCtrls, Classes, System.SysUtils, System.UITypes;

type
  GameArray = array[0..19, 0..19] of SmallInt;
  RobotImpuls = reference to procedure(x, y: SmallInt);

  TGraphicsControl = Class(TPaintBox)
  private
    FGameArray: GameArray;     // y x
    W, H, CurrentType: SmallInt;
    oX, oY, oX1, oY1: SmallInt;
    IsGameOwer: Boolean;
    RobotEvent: RobotImpuls;
    IsActiveRobotEvent: Boolean;
    procedure UpEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ClickEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure Paint; override;
    procedure PaintGame;
  public
    constructor Create(AOwner: TComponent);

    function ReadGameValue(x, y: SmallInt): SmallInt; //получить значение
    procedure WriteGameValue(x, y, Value: SmallInt); //задать значение
    // 1 это нолик, 2 это крестик, все остальное пустота

    procedure SetGameOver(x, y, x1, y1: SmallInt); //зачеркнуть поле и окончить игрунужно вызвать ресет
    procedure ReStart; // обнулить все в этом класе тобиж начать с начала
    procedure SetGameGetRobot(proc: RobotImpuls); //задать салблак функцию роботу срабатывает при подьеме мышки


  End;

implementation

uses vcl.forms, Vcl.Dialogs;

{ TGraphicsControl }



procedure TGraphicsControl.ClickEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (not IsGameOwer) and (FGameArray[y div w ,x div h] = 0) then
    begin
      FGameArray[y div w ,x div h] := 2;
      PaintGame;
    end
  else
    IsActiveRobotEvent := False;


    //ShowMessage(ReadGameValue(10,20).ToString);
end;

constructor TGraphicsControl.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
  W := 20;
  H := 20;

  Height := H*20;
  Width := W*20;

  OnMouseDown := ClickEvent;
  OnMouseUp := UpEvent;

  IsGameOwer := false;
  IsActiveRobotEvent := true;



end;

procedure TGraphicsControl.Paint;
begin
  PaintGame;
end;

procedure TGraphicsControl.PaintGame;
var
  I, J: Integer;
begin
  Canvas.Rectangle(0,0, Width, Height );

  for I := 1 to 19 do
    begin
      Canvas.MoveTo(0, h*i); Canvas.LineTo(Width, h*i);
      Canvas.MoveTo(w*i, 0); Canvas.LineTo(W*i,Width);
    end;



  for I := 0 to 19 do
  for J := 0 to 19 do
    begin
      if FGameArray[I, j] = 1 then
        begin
          Canvas.Pen.Width := 3;
          Canvas.Ellipse(j*w+2, i*h+2,j*w+w-2 ,i*h+h-2 );  //0 1
          Canvas.Pen.Width := 1;
        end;
      if FGameArray[I, j] = 2 then
        begin
          Canvas.Pen.Color := 255;
          Canvas.Pen.Width := 3;
          Canvas.MoveTo(j*w+4, i*h+4); Canvas.LineTo(j*w+w-4, i*h+h-4);
          Canvas.MoveTo(j*w+w-4, i*h+4); Canvas.LineTo(j*w + 4, i*h+h-4);
          Canvas.Pen.Color := 0;
          Canvas.Pen.Width := 1;
        end;;   // крестик   2

    end;

  if (oX1 > 3) or (oY1 > 3) or (oX > 3) or (oY > 3) then
    begin
      Canvas.Pen.Width := 3;
      Canvas.MoveTo(oX * W + W div 2, oY * H + H div 2);
      Canvas.LineTo(oX1 * W + W div 2, oY1 * H + H div 2);
      Canvas.Pen.Width := 1;
      IsGameOwer := True;
    end;

end;

function TGraphicsControl.ReadGameValue(x, y: SmallInt): SmallInt;
begin
if (y > 19) or (x > 19) or (y < 0) or (X < 0) then Result := 0 else Result := FGameArray[y, x];
end;

procedure TGraphicsControl.ReStart;
var
  I, J: Integer;
begin
  for I := 0 to 19 do
    for J := 0 to 19 do
      begin
        FGameArray[I, J] := 0;
      end;

  oX := 0;
  oY := 0;
  oX1 := 0;
  oY1 := 0;

  IsGameOwer := False;

  PaintGame;
end;

procedure TGraphicsControl.SetGameGetRobot(proc: RobotImpuls);
begin
  RobotEvent := proc;
end;

procedure TGraphicsControl.SetGameOver(x, y, x1, y1: SmallInt);
begin
  oX := x;
  oY := y;
  oX1 := x1;
  oY1 := y1;
  PaintGame;

end;

procedure TGraphicsControl.UpEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (IsGameOwer = False) and IsActiveRobotEvent then RobotEvent(x div w, y div h) else
  IsActiveRobotEvent := True;
end;

procedure TGraphicsControl.WriteGameValue(x, y, Value: SmallInt);
begin
  try
    if (not IsGameOwer) and ((x >= 0)or( X < 20)or( Y >= 0)or(Y < 20)) then FGameArray[y, x] := Value;
  Except on E: Exception do
    E := Exception.Create('Error with TGraphicsControl.WriteGameValue');
  end;
  PaintGame;
end;

end.
