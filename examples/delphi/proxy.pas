{$mode objfpc}{$H+}
program proxy;

uses SysUtils;

type
  TImage = class(TObject)
  public
    procedure Display; virtual; abstract;
  end;

  TRealImage = class(TImage)
  private
    FFilename: string;
    procedure LoadFromDisk;
  public
    constructor Create(const AFilename: string);
    procedure Display; override;
  end;

  TProxyImage = class(TImage)
  private
    FFilename: string;
    FRealImage: TRealImage;
  public
    constructor Create(const AFilename: string);
    destructor Destroy; override;
    procedure Display; override;
  end;

procedure TRealImage.LoadFromDisk;
begin
  WriteLn('  [Loading "', FFilename, '" from disk...]');
end;

constructor TRealImage.Create(const AFilename: string);
begin
  inherited Create;
  FFilename := AFilename;
  LoadFromDisk;
end;

procedure TRealImage.Display;
begin
  WriteLn('  Displaying: ', FFilename);
end;

constructor TProxyImage.Create(const AFilename: string);
begin
  inherited Create;
  FFilename := AFilename;
  FRealImage := nil;
end;

destructor TProxyImage.Destroy;
begin
  FRealImage.Free;
  inherited;
end;

procedure TProxyImage.Display;
begin
  if FRealImage = nil then
    FRealImage := TRealImage.Create(FFilename);
  FRealImage.Display;
end;

var
  Img: TProxyImage;
begin
  WriteLn('=== Proxy Pattern: Lazy-Loading Image ===');
  WriteLn;

  Img := TProxyImage.Create('photo.jpg');
  WriteLn('Proxy created (image NOT loaded yet)');
  WriteLn;

  WriteLn('First display call:');
  Img.Display;
  WriteLn;

  WriteLn('Second display call (cached):');
  Img.Display;

  Img.Free;
end.
