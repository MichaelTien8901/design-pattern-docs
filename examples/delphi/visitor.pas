{$mode objfpc}{$H+}
program visitor;

uses SysUtils;

type
  TShapeVisitor = class;

  TShape = class(TObject)
  public
    procedure Accept(V: TShapeVisitor); virtual; abstract;
  end;

  TCircle = class(TShape)
  private
    FRadius: Double;
  public
    constructor Create(ARadius: Double);
    property Radius: Double read FRadius;
    procedure Accept(V: TShapeVisitor); override;
  end;

  TRectangle = class(TShape)
  private
    FWidth, FHeight: Double;
  public
    constructor Create(AWidth, AHeight: Double);
    property Width: Double read FWidth;
    property Height: Double read FHeight;
    procedure Accept(V: TShapeVisitor); override;
  end;

  TShapeVisitor = class(TObject)
  public
    procedure VisitCircle(C: TCircle); virtual; abstract;
    procedure VisitRectangle(R: TRectangle); virtual; abstract;
  end;

  TXMLExportVisitor = class(TShapeVisitor)
  public
    procedure VisitCircle(C: TCircle); override;
    procedure VisitRectangle(R: TRectangle); override;
  end;

  TJSONExportVisitor = class(TShapeVisitor)
  public
    procedure VisitCircle(C: TCircle); override;
    procedure VisitRectangle(R: TRectangle); override;
  end;

constructor TCircle.Create(ARadius: Double);
begin
  inherited Create;
  FRadius := ARadius;
end;

procedure TCircle.Accept(V: TShapeVisitor);
begin
  V.VisitCircle(Self);
end;

constructor TRectangle.Create(AWidth, AHeight: Double);
begin
  inherited Create;
  FWidth := AWidth;
  FHeight := AHeight;
end;

procedure TRectangle.Accept(V: TShapeVisitor);
begin
  V.VisitRectangle(Self);
end;

procedure TXMLExportVisitor.VisitCircle(C: TCircle);
begin
  WriteLn('  <circle radius="', C.Radius:0:1, '"/>');
end;

procedure TXMLExportVisitor.VisitRectangle(R: TRectangle);
begin
  WriteLn('  <rectangle width="', R.Width:0:1, '" height="', R.Height:0:1, '"/>');
end;

procedure TJSONExportVisitor.VisitCircle(C: TCircle);
begin
  WriteLn('  {"type": "circle", "radius": ', C.Radius:0:1, '}');
end;

procedure TJSONExportVisitor.VisitRectangle(R: TRectangle);
begin
  WriteLn('  {"type": "rectangle", "width": ', R.Width:0:1, ', "height": ', R.Height:0:1, '}');
end;

var
  Shapes: array[0..2] of TShape;
  V: TShapeVisitor;
  I: Integer;
begin
  WriteLn('=== Visitor Pattern: Shape Export ===');
  WriteLn;

  Shapes[0] := TCircle.Create(5.0);
  Shapes[1] := TRectangle.Create(10.0, 20.0);
  Shapes[2] := TCircle.Create(3.5);

  WriteLn('XML Export:');
  V := TXMLExportVisitor.Create;
  for I := 0 to 2 do
    Shapes[I].Accept(V);
  V.Free;

  WriteLn;
  WriteLn('JSON Export:');
  V := TJSONExportVisitor.Create;
  for I := 0 to 2 do
    Shapes[I].Accept(V);
  V.Free;

  for I := 0 to 2 do
    Shapes[I].Free;
end.
