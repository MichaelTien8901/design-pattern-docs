{$mode objfpc}{$H+}
program flyweight;

uses SysUtils, Classes;

type
  { Flyweight: shared character style }
  TCharStyle = class(TObject)
  private
    FFont: string;
    FSize: Integer;
    FBold: Boolean;
  public
    constructor Create(const AFont: string; ASize: Integer; ABold: Boolean);
    function Describe: string;
  end;

  { Flyweight factory }
  TStyleFactory = class(TObject)
  private
    FStyles: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function GetStyle(const AFont: string; ASize: Integer; ABold: Boolean): TCharStyle;
    function StyleCount: Integer;
  end;

  { Context: character with extrinsic state }
  TCharacter = record
    Ch: Char;
    Row, Col: Integer;
    Style: TCharStyle;
  end;

constructor TCharStyle.Create(const AFont: string; ASize: Integer; ABold: Boolean);
begin
  inherited Create;
  FFont := AFont;
  FSize := ASize;
  FBold := ABold;
end;

function TCharStyle.Describe: string;
begin
  Result := Format('%s/%d/%s', [FFont, FSize, BoolToStr(FBold, 'bold', 'normal')]);
end;

constructor TStyleFactory.Create;
begin
  inherited;
  FStyles := TStringList.Create;
  FStyles.OwnsObjects := True;
end;

destructor TStyleFactory.Destroy;
begin
  FStyles.Free;
  inherited;
end;

function TStyleFactory.GetStyle(const AFont: string; ASize: Integer; ABold: Boolean): TCharStyle;
var
  Key: string;
  Idx: Integer;
begin
  Key := Format('%s_%d_%s', [AFont, ASize, BoolToStr(ABold, 'b', 'n')]);
  Idx := FStyles.IndexOf(Key);
  if Idx >= 0 then
    Result := TCharStyle(FStyles.Objects[Idx])
  else
  begin
    Result := TCharStyle.Create(AFont, ASize, ABold);
    FStyles.AddObject(Key, Result);
  end;
end;

function TStyleFactory.StyleCount: Integer;
begin
  Result := FStyles.Count;
end;

var
  Factory: TStyleFactory;
  Chars: array[0..9] of TCharacter;
  I: Integer;
  Text: string;
begin
  WriteLn('=== Flyweight Pattern: Character Styles in Text Editor ===');
  WriteLn;

  Factory := TStyleFactory.Create;
  Text := 'HelloWorld';

  for I := 0 to Length(Text) - 1 do
  begin
    Chars[I].Ch := Text[I + 1];
    Chars[I].Row := 0;
    Chars[I].Col := I;
    if I < 5 then
      Chars[I].Style := Factory.GetStyle('Arial', 12, True)
    else
      Chars[I].Style := Factory.GetStyle('Arial', 12, False);
  end;

  for I := 0 to Length(Text) - 1 do
    WriteLn(Format('  Char "%s" at (%d,%d) style=[%s]',
      [Chars[I].Ch, Chars[I].Row, Chars[I].Col, Chars[I].Style.Describe]));

  WriteLn;
  WriteLn('Total characters: ', Length(Text));
  WriteLn('Unique style objects: ', Factory.StyleCount);

  Factory.Free;
end.
