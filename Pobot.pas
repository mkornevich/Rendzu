unit Pobot;

interface

uses System.SysUtils, GraphicsControl, PatternReader, System.Classes, Winapi.Windows;

type

  TRobot = Class(TObject)
    private type
      PointCN = record
        Row, Col: SmallInt;
        IsNull: Boolean;
      end;
    private
      Graphics: TGraphicsControl;
      Reader: TPatternReader;

      procedure OnGameEvent(x, y: SmallInt); // Как только игрок сделал ход

      function Rotate(Pattern: PatternType): PatternType; // поворот паттерна по часовой
      function Zerkal(Pattern: PatternType): PatternType; // отрожение по вертикали
      function ChangePos(Pattern: PatternType; ChangeValue: Byte): PatternType; // сменить позицию по значению

      procedure IsGameOver(Row, Col, TypeZn: SmallInt); // проверка на проигрыш
      function IsGameOverPoint(Row, Col, TypeZn: SmallInt): Boolean; //см выше

      function GetRobotPozitionOfPatterns(Row, Col: SmallInt): PointCN; // возвращает координату по шаблонам или false если нет
      function ComparePatternAndPole(Col, Row: SmallInt; Pattern: PatternType): PointCN; // функция сравнивает паттерн статично по координате если есть совпадение то true и кординаты иначе false


    public



      constructor Create(Graphics: TGraphicsControl);
      procedure ReStart;// перезапустить игру

  End;

implementation

uses vcl.dialogs, System.Generics.Collections;

{ TRobot }

function TRobot.ChangePos(Pattern: PatternType; ChangeValue: Byte): PatternType;
var
  I, ChangeValNew: Integer;
  BuffPattern: PatternType;
begin
Result := Pattern;

  if ChangeValue > 3 then Result := Zerkal(Pattern);
  if ChangeValue < 4 then ChangeValNew := ChangeValue else ChangeValNew := ChangeValue - 4;

  if (ChangeValue = 0) or (ChangeValue = 4) then Exit;

  for I := 0 to ChangeValNew - 1 do
    begin
      Result := Rotate(Result);
    end;


end;

function TRobot.ComparePatternAndPole(Col, Row: SmallInt;
  Pattern: PatternType): PointCN;
var
  RowC, ColC: SmallInt;
  I, J: Byte;
begin
  RowC := Pattern.Count + Row - 1;
  ColC := Pattern[0].Count + Col - 1;
  Result.IsNull := True;

  for I := Row to RowC do
    begin
      for J := Col to ColC do
        begin
          if (Pattern[I - Row][J - Col] = 1) and not(Graphics.ReadGameValue(J, I) = 1 ) then Exit;
          if (Pattern[I - Row][J - Col] = 2) and not(Graphics.ReadGameValue(J, I) = 2 ) then Exit;
          if (Pattern[I - Row][J - Col] = 3) and ((Graphics.ReadGameValue(J, I) = 1) or (Graphics.ReadGameValue(J, I) = 2)) then Exit;
          if (Pattern[I - Row][J - Col] = 4) then
            begin
              if (Graphics.ReadGameValue(J, I) = 1) or (Graphics.ReadGameValue(J, I) = 2) or ((J > 19) or (I > 19)) then Exit;
              Result.Col := J;
              Result.Row := I;
            end;
        end;
          if I = RowC then Result.IsNull := False;
    end;


    //Pattern.Clear;
end;

constructor TRobot.Create(Graphics: TGraphicsControl);
var
  V: PatternType;
  I: Integer;
  J: Integer;
begin
  Self.Graphics := Graphics;
  Self.Graphics.SetGameGetRobot(OnGameEvent);
  Reader := TPatternReader.Create;
  Reader.open('patterns.txt');


  //V := ChangePos(Reader.GetPattern(0), 3);
//  V := Rotate(Rotate(Rotate(Reader.GetPattern(0))));
//
//
//  for I := 0 to V.Count - 1 do
//    for J := 0 to V[0].Count - 1 do
//      Graphics.WriteGameValue(J, I, V[I][J]);
  //Graphics.WriteGameValue(3,0,2);
  //Graphics.WriteGameValue(3,1,2);



end;



function TRobot.GetRobotPozitionOfPatterns(Row, Col: SmallInt): PointCN;
var
  PatternBuff, PatBuffChange: PatternType;
  CountPattern, PatternMaxWight: Integer;
  I, R, C, PozF, BuffRow, BuffCol: Integer;
  PointBuff: PointCN;

  PPatternBuff: ^PatternType;

begin
  CountPattern := Reader.GetCount;
  Result.IsNull := true;

  New(PPatternBuff);

  for I := 0 to CountPattern - 1 do
    begin
      PatternBuff := Reader.GetPattern(I);
      if PatternBuff.Count > PatternBuff[0].Count then PatternMaxWight := PatternBuff.Count else
        PatternMaxWight := PatternBuff[0].Count;

      if Row - 6 < 0 then BuffRow := 0 else BuffRow := Row - 6;
      if Col - 6 < 0 then BuffCol := 0 else BuffCol := Col - 6;



      for PozF := 0 to 7 do
        begin


          for R := BuffRow to Row + 6 do
            begin
              for C := BuffCol to Col + 6 do
                begin

                      PatBuffChange := ChangePos(PatternBuff, PozF);

                      PointBuff := ComparePatternAndPole(C, R, PatBuffChange);




                      if PointBuff.IsNull = false then
                        begin
                          Result := PointBuff;
                          Exit;
                        end;


                end;
            end;
        end;



    end;




end;

procedure TRobot.IsGameOver(Row, Col, TypeZn: SmallInt);
var
  I, J: Integer;
  ChCol, ChRow, BuffResult: SmallInt;
begin
  ChCol := Col - 4; if ChCol < 0 then ChCol := 0;
  ChRow := Row - 4; if ChRow < 0 then ChRow := 0;

  for I := ChRow to Row + 4 do
    for J := ChCol to Col + 4 do
      begin
          if IsGameOverPoint(i, J, TypeZn) then exit;
      end;
end;



function TRobot.IsGameOverPoint(Row, Col, TypeZn: SmallInt): Boolean;
var
  I: Integer;
  ArrCurrType: array[0..7] of Boolean;
begin

  for I := 0 to 7 do ArrCurrType[I] := True;
  Result := false;

  for I := 0 to 4 do
    begin

        if Graphics.ReadGameValue(Col + I, Row) <> TypeZn then ArrCurrType[0] := false else
          if (ArrCurrType[0] = True) and (I = 4) then
            begin
              Graphics.SetGameOver(Col, Row, Col + I, Row);
              Result := True;
              exit;
            end;

        if Graphics.ReadGameValue(Col + I, Row + I) <> TypeZn then ArrCurrType[1] := false else
          if (ArrCurrType[1] = True) and (I = 4) then
            begin
              Graphics.SetGameOver(Col, Row, Col + I, Row + I);
              Result := True;
              exit;
            end;

        if Graphics.ReadGameValue(Col, Row + I) <> TypeZn then ArrCurrType[2] := false else
          if (ArrCurrType[2] = True) and (I = 4) then
            begin
              Graphics.SetGameOver(Col, Row, Col, Row + I);
              Result := True;
              exit;
            end;

        if Graphics.ReadGameValue(Col + i, Row - i) <> TypeZn then ArrCurrType[3] := false else
          if (ArrCurrType[3] = True) and (I = 4) then
            begin
              Graphics.SetGameOver(Col, Row, Col + i, Row - I);
              Result := True;
              exit;
            end;
    end;



end;

procedure TRobot.OnGameEvent(x, y: SmallInt);
var
  P :PointCN;
begin
  IsGameOver(Y, X, 2);


  P := GetRobotPozitionOfPatterns(Y, X);
  if not p.IsNull then Graphics.WriteGameValue(P.Col, P.Row, 1);
  IsGameOver(P.Row, P.Col, 1);


end;

procedure TRobot.ReStart;
begin
  Graphics.ReStart;
end;

function TRobot.Rotate(Pattern: PatternType): PatternType;
var
  I, J: Integer;
  Line: TList<SmallInt>;
  PatCl: PatternType;
begin
  Result := PatternType.Create;
  //try
  for I := 0 to Pattern[0].Count - 1 do // строки
    begin

      Line := TList<SmallInt>.Create;

      for J := 0 to Pattern.Count - 1 do //колонки
       begin


            Line.Add(Pattern[(Pattern.Count - 1) - J][I]);
            //Pattern[(Pattern.Count - 1) - J].Clear;

        end;

      Result.Add(Line);

    end;

end;

function TRobot.Zerkal(Pattern: PatternType): PatternType;
var
  I: Integer;
begin
  Result := PatternType.Create;
  for I := Pattern.Count - 1 downto 0 do
    Result.Add(Pattern[I]);
end;

end.
