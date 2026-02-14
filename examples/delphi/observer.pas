{$mode objfpc}{$H+}
program observer;

uses SysUtils, Classes;

type
  TWeatherStation = class;

  IWeatherObserver = interface
    ['{11223344-5566-7788-99AA-BBCCDDEEFF00}']
    procedure Update(AStation: TWeatherStation);
  end;

  TWeatherStation = class(TObject)
  private
    FObservers: TInterfaceList;
    FTemperature: Double;
    FHumidity: Double;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Attach(Obs: IWeatherObserver);
    procedure NotifyAll;
    procedure SetMeasurements(ATemp, AHumidity: Double);
    property Temperature: Double read FTemperature;
    property Humidity: Double read FHumidity;
  end;

  TCurrentDisplay = class(TInterfacedObject, IWeatherObserver)
  public
    procedure Update(AStation: TWeatherStation);
  end;

  TStatisticsDisplay = class(TInterfacedObject, IWeatherObserver)
  private
    FCount: Integer;
    FSum: Double;
  public
    constructor Create;
    procedure Update(AStation: TWeatherStation);
  end;

constructor TWeatherStation.Create;
begin
  inherited;
  FObservers := TInterfaceList.Create;
end;

destructor TWeatherStation.Destroy;
begin
  FObservers.Free;
  inherited;
end;

procedure TWeatherStation.Attach(Obs: IWeatherObserver);
begin
  FObservers.Add(Obs);
end;

procedure TWeatherStation.NotifyAll;
var
  I: Integer;
begin
  for I := 0 to FObservers.Count - 1 do
    IWeatherObserver(FObservers[I]).Update(Self);
end;

procedure TWeatherStation.SetMeasurements(ATemp, AHumidity: Double);
begin
  FTemperature := ATemp;
  FHumidity := AHumidity;
  WriteLn('Weather station: temp=', ATemp:0:1, ', humidity=', AHumidity:0:1);
  NotifyAll;
end;

procedure TCurrentDisplay.Update(AStation: TWeatherStation);
begin
  WriteLn('  [Current Display] Temperature: ', AStation.Temperature:0:1,
          'C, Humidity: ', AStation.Humidity:0:1, '%');
end;

constructor TStatisticsDisplay.Create;
begin
  inherited;
  FCount := 0;
  FSum := 0;
end;

procedure TStatisticsDisplay.Update(AStation: TWeatherStation);
begin
  Inc(FCount);
  FSum := FSum + AStation.Temperature;
  WriteLn('  [Statistics Display] Avg temperature: ', (FSum / FCount):0:1, 'C (', FCount, ' readings)');
end;

var
  Station: TWeatherStation;
begin
  WriteLn('=== Observer Pattern: Weather Station ===');
  WriteLn;

  Station := TWeatherStation.Create;
  Station.Attach(TCurrentDisplay.Create);
  Station.Attach(TStatisticsDisplay.Create);

  Station.SetMeasurements(25.0, 65.0);
  WriteLn;
  Station.SetMeasurements(28.5, 70.0);
  WriteLn;
  Station.SetMeasurements(22.0, 90.0);

  Station.Free;
end.
