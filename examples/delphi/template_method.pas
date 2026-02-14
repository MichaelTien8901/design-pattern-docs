{$mode objfpc}{$H+}
program template_method;

uses SysUtils;

type
  TDataMiner = class(TObject)
  protected
    function OpenSource(const Path: string): string; virtual; abstract;
    function ExtractData(const Raw: string): string; virtual; abstract;
    function ParseData(const Data: string): string; virtual; abstract;
  public
    procedure Mine(const Path: string);
  end;

  TCSVMiner = class(TDataMiner)
  protected
    function OpenSource(const Path: string): string; override;
    function ExtractData(const Raw: string): string; override;
    function ParseData(const Data: string): string; override;
  end;

  TJSONMiner = class(TDataMiner)
  protected
    function OpenSource(const Path: string): string; override;
    function ExtractData(const Raw: string): string; override;
    function ParseData(const Data: string): string; override;
  end;

  TXMLMiner = class(TDataMiner)
  protected
    function OpenSource(const Path: string): string; override;
    function ExtractData(const Raw: string): string; override;
    function ParseData(const Data: string): string; override;
  end;

procedure TDataMiner.Mine(const Path: string);
var
  Raw, Data, Result_: string;
begin
  Raw := OpenSource(Path);
  Data := ExtractData(Raw);
  Result_ := ParseData(Data);
  WriteLn('  Analysis result: ', Result_);
end;

function TCSVMiner.OpenSource(const Path: string): string;
begin
  WriteLn('  Opening CSV file: ', Path);
  Result := 'name,age\nAlice,30\nBob,25';
end;

function TCSVMiner.ExtractData(const Raw: string): string;
begin
  WriteLn('  Extracting data from CSV rows');
  Result := 'Alice:30, Bob:25';
end;

function TCSVMiner.ParseData(const Data: string): string;
begin
  WriteLn('  Parsing CSV data');
  Result := '2 records found, avg age = 27.5';
end;

function TJSONMiner.OpenSource(const Path: string): string;
begin
  WriteLn('  Opening JSON file: ', Path);
  Result := '{"users":[{"name":"Alice"},{"name":"Bob"}]}';
end;

function TJSONMiner.ExtractData(const Raw: string): string;
begin
  WriteLn('  Extracting data from JSON objects');
  Result := 'Alice, Bob';
end;

function TJSONMiner.ParseData(const Data: string): string;
begin
  WriteLn('  Parsing JSON data');
  Result := '2 users found';
end;

function TXMLMiner.OpenSource(const Path: string): string;
begin
  WriteLn('  Opening XML file: ', Path);
  Result := '<users><user name="Alice"/><user name="Bob"/></users>';
end;

function TXMLMiner.ExtractData(const Raw: string): string;
begin
  WriteLn('  Extracting data from XML nodes');
  Result := 'Alice, Bob';
end;

function TXMLMiner.ParseData(const Data: string): string;
begin
  WriteLn('  Parsing XML data');
  Result := '2 user nodes found';
end;

var
  Miner: TDataMiner;
begin
  WriteLn('=== Template Method Pattern: Data Mining ===');
  WriteLn;

  WriteLn('CSV Mining:');
  Miner := TCSVMiner.Create;
  Miner.Mine('data.csv');
  Miner.Free;
  WriteLn;

  WriteLn('JSON Mining:');
  Miner := TJSONMiner.Create;
  Miner.Mine('data.json');
  Miner.Free;
  WriteLn;

  WriteLn('XML Mining:');
  Miner := TXMLMiner.Create;
  Miner.Mine('data.xml');
  Miner.Free;
end.
