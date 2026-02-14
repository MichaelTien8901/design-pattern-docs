{$mode objfpc}{$H+}
program interpreter;

uses SysUtils;

type
  IExpression = interface
    function Interpret: Integer;
  end;

  TNumberExpr = class(TInterfacedObject, IExpression)
  private
    FValue: Integer;
  public
    constructor Create(AValue: Integer);
    function Interpret: Integer;
  end;

  TAddExpr = class(TInterfacedObject, IExpression)
  private
    FLeft, FRight: IExpression;
  public
    constructor Create(ALeft, ARight: IExpression);
    function Interpret: Integer;
  end;

  TSubtractExpr = class(TInterfacedObject, IExpression)
  private
    FLeft, FRight: IExpression;
  public
    constructor Create(ALeft, ARight: IExpression);
    function Interpret: Integer;
  end;

constructor TNumberExpr.Create(AValue: Integer);
begin FValue := AValue; end;

function TNumberExpr.Interpret: Integer;
begin Result := FValue; end;

constructor TAddExpr.Create(ALeft, ARight: IExpression);
begin FLeft := ALeft; FRight := ARight; end;

function TAddExpr.Interpret: Integer;
begin Result := FLeft.Interpret + FRight.Interpret; end;

constructor TSubtractExpr.Create(ALeft, ARight: IExpression);
begin FLeft := ALeft; FRight := ARight; end;

function TSubtractExpr.Interpret: Integer;
begin Result := FLeft.Interpret - FRight.Interpret; end;

function ParseExpr(const Expr: string): IExpression;
var
  Tokens: array of string;
  I, Num: Integer;
  S: string;
  Right: IExpression;
begin
  // Simple tokenizer: split by spaces
  SetLength(Tokens, 0);
  S := '';
  for I := 1 to Length(Expr) do
  begin
    if Expr[I] = ' ' then
    begin
      if S <> '' then
      begin
        SetLength(Tokens, Length(Tokens) + 1);
        Tokens[High(Tokens)] := S;
        S := '';
      end;
    end
    else
      S := S + Expr[I];
  end;
  if S <> '' then
  begin
    SetLength(Tokens, Length(Tokens) + 1);
    Tokens[High(Tokens)] := S;
  end;

  Num := StrToInt(Tokens[0]);
  Result := TNumberExpr.Create(Num);

  I := 1;
  while I < Length(Tokens) do
  begin
    Right := TNumberExpr.Create(StrToInt(Tokens[I + 1]));
    if Tokens[I] = '+' then
      Result := TAddExpr.Create(Result, Right)
    else
      Result := TSubtractExpr.Create(Result, Right);
    Inc(I, 2);
  end;
end;

var
  Expressions: array[0..2] of string = ('3 + 5', '10 - 2 + 4', '100 - 50 - 25');
  I: Integer;
  Parsed: IExpression;
begin
  WriteLn('=== Interpreter Pattern: Arithmetic Expressions ===');
  WriteLn;

  for I := 0 to High(Expressions) do
  begin
    Parsed := ParseExpr(Expressions[I]);
    WriteLn('  ', Expressions[I], ' = ', Parsed.Interpret);
  end;
end.
