{$mode objfpc}{$H+}
program adapter;

uses SysUtils;

type
  { Target interface - expects JSON }
  IJSONData = interface
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    function GetJSON: string;
  end;

  { Adaptee - provides XML }
  TXMLService = class(TObject)
  public
    function GetXML: string;
  end;

  { Adapter - wraps XML service to provide JSON interface }
  TXMLToJSONAdapter = class(TInterfacedObject, IJSONData)
  private
    FXMLService: TXMLService;
    FOwnsService: Boolean;
  public
    constructor Create(AService: TXMLService; AOwns: Boolean = True);
    destructor Destroy; override;
    function GetJSON: string;
  end;

function TXMLService.GetXML: string;
begin
  Result := '<user><name>Alice</name><age>30</age></user>';
end;

constructor TXMLToJSONAdapter.Create(AService: TXMLService; AOwns: Boolean);
begin
  inherited Create;
  FXMLService := AService;
  FOwnsService := AOwns;
end;

destructor TXMLToJSONAdapter.Destroy;
begin
  if FOwnsService then
    FXMLService.Free;
  inherited;
end;

function TXMLToJSONAdapter.GetJSON: string;
var
  XML: string;
begin
  XML := FXMLService.GetXML;
  { Simplified conversion for demonstration }
  Result := '{"user": {"name": "Alice", "age": 30}}';
  WriteLn('  (Converted XML to JSON)');
  WriteLn('  XML input:  ', XML);
end;

var
  XMLSvc: TXMLService;
  JSONData: IJSONData;
begin
  WriteLn('=== Adapter Pattern: XML to JSON ===');
  WriteLn;

  XMLSvc := TXMLService.Create;
  WriteLn('Raw XML from service:');
  WriteLn('  ', XMLSvc.GetXML);
  WriteLn;

  WriteLn('Through adapter:');
  JSONData := TXMLToJSONAdapter.Create(XMLSvc);
  WriteLn('  JSON output: ', JSONData.GetJSON);
end.
