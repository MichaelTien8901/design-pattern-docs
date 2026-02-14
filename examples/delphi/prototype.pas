{$mode objfpc}{$H+}
program prototype;

uses SysUtils;

type
  TShape = class(TObject)
  private
    FColor: string;
  public
    property Color: string read FColor write FColor;
    function Clone: TShape; virtual; abstract;
    function Describe: string; virtual; abstract;
  end;

  TCircle = class(TShape)
  private
    FRadius: Integer;
  public
    constructor Create(ARadius: Integer; const AColor: string);
    property Radius: Integer read FRadius write FRadius;
    function Clone: TShape; override;
    function Describe: string; override;
  end;

  TRectangle = class(TShape)
  private
    FWidth, FHeight: Integer;
  public
    constructor Create(AWidth, AHeight: Integer; const AColor: string);
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    function Clone: TShape; override;
    function Describe: string; override;
  end;

constructor TCircle.Create(ARadius: Integer; const AColor: string);
begin
  inherited Create;
  FRadius := ARadius;
  FColor := AColor;
end;

function TCircle.Clone: TShape;
begin
  Result := TCircle.Create(FRadius, FColor);
end;

function TCircle.Describe: string;
begin
  Result := Format('Circle(radius=%d, color=%s)', [FRadius, FColor]);
end;

constructor TRectangle.Create(AWidth, AHeight: Integer; const AColor: string);
begin
  inherited Create;
  FWidth := AWidth;
  FHeight := AHeight;
  FColor := AColor;
end;

function TRectangle.Clone: TShape;
begin
  Result := TRectangle.Create(FWidth, FHeight, FColor);
end;

function TRectangle.Describe: string;
begin
  Result := Format('Rectangle(%dx%d, color=%s)', [FWidth, FHeight, FColor]);
end;

var
  C1, C2: TShape;
  R1, R2: TShape;
begin
  WriteLn('=== Prototype Pattern: Shape Cloning ===');
  WriteLn;

  C1 := TCircle.Create(10, 'red');
  C2 := C1.Clone;
  WriteLn('Original: ', C1.Describe);
  WriteLn('Clone:    ', C2.Describe);
  WriteLn('Same object? ', C1 = C2);
  WriteLn;

  R1 := TRectangle.Create(20, 30, 'blue');
  R2 := R1.Clone;
  TRectangle(R2).Width := 99;
  WriteLn('Original:  ', R1.Describe);
  WriteLn('Modified clone: ', R2.Describe);

  C1.Free; C2.Free; R1.Free; R2.Free;
end.
