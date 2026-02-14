{$mode objfpc}{$H+}
program composite;

uses SysUtils, Classes;

type
  TFileComponent = class(TObject)
  private
    FName: string;
  public
    constructor Create(const AName: string);
    property Name: string read FName;
    function GetSize: Integer; virtual; abstract;
    procedure Display(Indent: Integer); virtual; abstract;
  end;

  TFile_ = class(TFileComponent)
  private
    FSize: Integer;
  public
    constructor Create(const AName: string; ASize: Integer);
    function GetSize: Integer; override;
    procedure Display(Indent: Integer); override;
  end;

  TDirectory = class(TFileComponent)
  private
    FChildren: TList;
  public
    constructor Create(const AName: string);
    destructor Destroy; override;
    procedure Add(Child: TFileComponent);
    function GetSize: Integer; override;
    procedure Display(Indent: Integer); override;
  end;

constructor TFileComponent.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;

constructor TFile_.Create(const AName: string; ASize: Integer);
begin
  inherited Create(AName);
  FSize := ASize;
end;

function TFile_.GetSize: Integer;
begin
  Result := FSize;
end;

procedure TFile_.Display(Indent: Integer);
begin
  WriteLn(StringOfChar(' ', Indent), '- ', FName, ' (', FSize, ' bytes)');
end;

constructor TDirectory.Create(const AName: string);
begin
  inherited Create(AName);
  FChildren := TList.Create;
end;

destructor TDirectory.Destroy;
var
  I: Integer;
begin
  for I := 0 to FChildren.Count - 1 do
    TFileComponent(FChildren[I]).Free;
  FChildren.Free;
  inherited;
end;

procedure TDirectory.Add(Child: TFileComponent);
begin
  FChildren.Add(Child);
end;

function TDirectory.GetSize: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FChildren.Count - 1 do
    Result := Result + TFileComponent(FChildren[I]).GetSize;
end;

procedure TDirectory.Display(Indent: Integer);
var
  I: Integer;
begin
  WriteLn(StringOfChar(' ', Indent), '+ ', FName, ' (', GetSize, ' bytes)');
  for I := 0 to FChildren.Count - 1 do
    TFileComponent(FChildren[I]).Display(Indent + 2);
end;

var
  Root, Src, Docs: TDirectory;
begin
  WriteLn('=== Composite Pattern: File System ===');
  WriteLn;

  Root := TDirectory.Create('project');
  Root.Add(TFile_.Create('README.md', 1024));

  Src := TDirectory.Create('src');
  Src.Add(TFile_.Create('main.pas', 4096));
  Src.Add(TFile_.Create('utils.pas', 2048));
  Root.Add(Src);

  Docs := TDirectory.Create('docs');
  Docs.Add(TFile_.Create('guide.pdf', 8192));
  Root.Add(Docs);

  Root.Display(0);
  Root.Free;
end.
