{$mode objfpc}{$H+}
program factory_method;

uses SysUtils;

type
  TTransport = class(TObject)
  public
    function Deliver: string; virtual; abstract;
  end;

  TTruck = class(TTransport)
  public
    function Deliver: string; override;
  end;

  TShip = class(TTransport)
  public
    function Deliver: string; override;
  end;

  TLogistics = class(TObject)
  public
    function CreateTransport: TTransport; virtual; abstract;
    procedure PlanDelivery;
  end;

  TRoadLogistics = class(TLogistics)
  public
    function CreateTransport: TTransport; override;
  end;

  TSeaLogistics = class(TLogistics)
  public
    function CreateTransport: TTransport; override;
  end;

function TTruck.Deliver: string;
begin
  Result := 'Delivering by land in a truck';
end;

function TShip.Deliver: string;
begin
  Result := 'Delivering by sea in a ship';
end;

function TRoadLogistics.CreateTransport: TTransport;
begin
  Result := TTruck.Create;
end;

function TSeaLogistics.CreateTransport: TTransport;
begin
  Result := TShip.Create;
end;

procedure TLogistics.PlanDelivery;
var
  Transport: TTransport;
begin
  Transport := CreateTransport;
  WriteLn(Transport.Deliver);
  Transport.Free;
end;

var
  Logistics: TLogistics;
begin
  WriteLn('=== Factory Method Pattern: Transport Logistics ===');
  WriteLn;

  WriteLn('Road logistics:');
  Logistics := TRoadLogistics.Create;
  Logistics.PlanDelivery;
  Logistics.Free;

  WriteLn('Sea logistics:');
  Logistics := TSeaLogistics.Create;
  Logistics.PlanDelivery;
  Logistics.Free;
end.
