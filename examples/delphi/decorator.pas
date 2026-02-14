{$mode objfpc}{$H+}
program decorator;

uses SysUtils;

type
  TText = class(TObject)
  public
    function GetContent: string; virtual; abstract;
  end;

  TPlainText = class(TText)
  private
    FContent: string;
  public
    constructor Create(const AContent: string);
    function GetContent: string; override;
  end;

  TTextDecorator = class(TText)
  protected
    FWrapped: TText;
    FOwns: Boolean;
  public
    constructor Create(AWrapped: TText; AOwns: Boolean = True);
    destructor Destroy; override;
  end;

  TBoldDecorator = class(TTextDecorator)
  public
    function GetContent: string; override;
  end;

  TItalicDecorator = class(TTextDecorator)
  public
    function GetContent: string; override;
  end;

  TUnderlineDecorator = class(TTextDecorator)
  public
    function GetContent: string; override;
  end;

constructor TPlainText.Create(const AContent: string);
begin
  inherited Create;
  FContent := AContent;
end;

function TPlainText.GetContent: string;
begin
  Result := FContent;
end;

constructor TTextDecorator.Create(AWrapped: TText; AOwns: Boolean);
begin
  inherited Create;
  FWrapped := AWrapped;
  FOwns := AOwns;
end;

destructor TTextDecorator.Destroy;
begin
  if FOwns then
    FWrapped.Free;
  inherited;
end;

function TBoldDecorator.GetContent: string;
begin
  Result := '<b>' + FWrapped.GetContent + '</b>';
end;

function TItalicDecorator.GetContent: string;
begin
  Result := '<i>' + FWrapped.GetContent + '</i>';
end;

function TUnderlineDecorator.GetContent: string;
begin
  Result := '<u>' + FWrapped.GetContent + '</u>';
end;

var
  T: TText;
begin
  WriteLn('=== Decorator Pattern: Text Formatting ===');
  WriteLn;

  T := TPlainText.Create('Hello World');
  WriteLn('Plain:           ', T.GetContent);
  T.Free;

  T := TBoldDecorator.Create(TPlainText.Create('Hello World'));
  WriteLn('Bold:            ', T.GetContent);
  T.Free;

  T := TItalicDecorator.Create(TBoldDecorator.Create(TPlainText.Create('Hello World')));
  WriteLn('Bold + Italic:   ', T.GetContent);
  T.Free;

  T := TUnderlineDecorator.Create(TItalicDecorator.Create(TBoldDecorator.Create(TPlainText.Create('Hello World'))));
  WriteLn('Bold+Italic+Uline: ', T.GetContent);
  T.Free;
end.
