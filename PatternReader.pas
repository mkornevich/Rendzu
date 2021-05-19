unit PatternReader;

interface

uses System.SysUtils, System.generics.Collections, System.Classes;

type
  PatternType = TList<TList<SmallInt>>;

  TPatternReader = Class(TObject)
    private
      PatternList: TList<PatternType>;
      PatternFile: TStringList;
    public
      constructor Create;

      procedure open(path: String);
      function GetPattern(id: Integer): PatternType;
      function GetCount: Integer;
  End;

implementation

{ TPatternReader }

constructor TPatternReader.Create;
begin
  PatternFile := TStringList.Create;
end;

function TPatternReader.GetCount: Integer;
begin
  Result := PatternList.Count;
end;

function TPatternReader.GetPattern(id: Integer): PatternType;
begin
  Result := PatternList[id];
end;

procedure TPatternReader.open(path: String);
var
I, J: Integer;
IsAdded: Boolean;
ChildLs: TList<SmallInt>;
ParrentLs: PatternType;
begin
  IsAdded := false;

  PatternList := TList<PatternType>.Create;

  PatternFile.LoadFromFile(path);
  for I := 0 to PatternFile.Count - 1 do
    begin
      if PatternFile[I] = 'begin' then
        begin
          IsAdded := true;
          ParrentLs := TList<TList<SmallInt>>.Create;
          Continue;
        end;
      if PatternFile[I] = 'end' then
        begin
          IsAdded := false;
          PatternList.Add(ParrentLs);
        end;

      if IsAdded then
        begin
          ChildLs := TList<SmallInt>.Create;

          for J := 1 to PatternFile[i].Length do
          begin
            //ShowMessage(PatternFile[I][]);
            ChildLs.Add(StrToInt(PatternFile[I][J]));

          end;

          ParrentLs.add(ChildLs);
        end;

    end;
end;

end.
