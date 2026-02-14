{$mode objfpc}{$H+}
program builder;

uses SysUtils;

type
  THouse = class(TObject)
  private
    FFoundation: string;
    FWalls: Integer;
    FRoof: string;
    FGarage: Boolean;
    FSwimmingPool: Boolean;
  public
    property Foundation: string read FFoundation write FFoundation;
    property Walls: Integer read FWalls write FWalls;
    property Roof: string read FRoof write FRoof;
    property Garage: Boolean read FGarage write FGarage;
    property SwimmingPool: Boolean read FSwimmingPool write FSwimmingPool;
    function Describe: string;
  end;

  THouseBuilder = class(TObject)
  private
    FHouse: THouse;
  public
    constructor Create;
    function SetFoundation(const AFoundation: string): THouseBuilder;
    function SetWalls(ACount: Integer): THouseBuilder;
    function SetRoof(const ARoof: string): THouseBuilder;
    function SetGarage(AValue: Boolean): THouseBuilder;
    function SetSwimmingPool(AValue: Boolean): THouseBuilder;
    function Build: THouse;
  end;

function THouse.Describe: string;
begin
  Result := Format('House [Foundation: %s, Walls: %d, Roof: %s, Garage: %s, Pool: %s]',
    [FFoundation, FWalls, FRoof,
     BoolToStr(FGarage, 'Yes', 'No'),
     BoolToStr(FSwimmingPool, 'Yes', 'No')]);
end;

constructor THouseBuilder.Create;
begin
  inherited Create;
  FHouse := THouse.Create;
end;

function THouseBuilder.SetFoundation(const AFoundation: string): THouseBuilder;
begin
  FHouse.Foundation := AFoundation;
  Result := Self;
end;

function THouseBuilder.SetWalls(ACount: Integer): THouseBuilder;
begin
  FHouse.Walls := ACount;
  Result := Self;
end;

function THouseBuilder.SetRoof(const ARoof: string): THouseBuilder;
begin
  FHouse.Roof := ARoof;
  Result := Self;
end;

function THouseBuilder.SetGarage(AValue: Boolean): THouseBuilder;
begin
  FHouse.Garage := AValue;
  Result := Self;
end;

function THouseBuilder.SetSwimmingPool(AValue: Boolean): THouseBuilder;
begin
  FHouse.SwimmingPool := AValue;
  Result := Self;
end;

function THouseBuilder.Build: THouse;
begin
  Result := FHouse;
  FHouse := THouse.Create;
end;

var
  B: THouseBuilder;
  H: THouse;
begin
  WriteLn('=== Builder Pattern: House Construction ===');
  WriteLn;

  B := THouseBuilder.Create;

  H := B.SetFoundation('Concrete')
        .SetWalls(4)
        .SetRoof('Tile')
        .SetGarage(True)
        .SetSwimmingPool(False)
        .Build;
  WriteLn('Standard house: ', H.Describe);
  H.Free;

  H := B.SetFoundation('Stone')
        .SetWalls(6)
        .SetRoof('Slate')
        .SetGarage(True)
        .SetSwimmingPool(True)
        .Build;
  WriteLn('Luxury house:   ', H.Describe);
  H.Free;

  B.Free;
end.
