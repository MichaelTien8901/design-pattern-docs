{$mode objfpc}{$H+}
program bridge;

uses SysUtils;

type
  TDevice = class(TObject)
  private
    FVolume: Integer;
    FOn: Boolean;
  public
    constructor Create;
    function GetName: string; virtual; abstract;
    procedure TurnOn; virtual;
    procedure TurnOff; virtual;
    procedure SetVolume(V: Integer); virtual;
    function GetVolume: Integer;
    function IsOn: Boolean;
  end;

  TTV = class(TDevice)
  public
    function GetName: string; override;
  end;

  TRadio = class(TDevice)
  public
    function GetName: string; override;
  end;

  TRemoteControl = class(TObject)
  protected
    FDevice: TDevice;
  public
    constructor Create(ADevice: TDevice);
    procedure TogglePower;
    procedure VolumeUp; virtual;
    procedure VolumeDown; virtual;
  end;

  TAdvancedRemote = class(TRemoteControl)
  public
    procedure Mute;
  end;

constructor TDevice.Create;
begin
  inherited;
  FVolume := 50;
  FOn := False;
end;

procedure TDevice.TurnOn;
begin
  FOn := True;
  WriteLn('  ', GetName, ' is ON');
end;

procedure TDevice.TurnOff;
begin
  FOn := False;
  WriteLn('  ', GetName, ' is OFF');
end;

procedure TDevice.SetVolume(V: Integer);
begin
  if V < 0 then V := 0;
  if V > 100 then V := 100;
  FVolume := V;
  WriteLn('  ', GetName, ' volume: ', FVolume);
end;

function TDevice.GetVolume: Integer;
begin
  Result := FVolume;
end;

function TDevice.IsOn: Boolean;
begin
  Result := FOn;
end;

function TTV.GetName: string;
begin
  Result := 'TV';
end;

function TRadio.GetName: string;
begin
  Result := 'Radio';
end;

constructor TRemoteControl.Create(ADevice: TDevice);
begin
  inherited Create;
  FDevice := ADevice;
end;

procedure TRemoteControl.TogglePower;
begin
  if FDevice.IsOn then
    FDevice.TurnOff
  else
    FDevice.TurnOn;
end;

procedure TRemoteControl.VolumeUp;
begin
  FDevice.SetVolume(FDevice.GetVolume + 10);
end;

procedure TRemoteControl.VolumeDown;
begin
  FDevice.SetVolume(FDevice.GetVolume - 10);
end;

procedure TAdvancedRemote.Mute;
begin
  WriteLn('  [Muting]');
  FDevice.SetVolume(0);
end;

var
  TV: TTV;
  Radio: TRadio;
  Remote: TRemoteControl;
  AdvRemote: TAdvancedRemote;
begin
  WriteLn('=== Bridge Pattern: Remote Control + Devices ===');
  WriteLn;

  TV := TTV.Create;
  Remote := TRemoteControl.Create(TV);
  WriteLn('Basic remote with TV:');
  Remote.TogglePower;
  Remote.VolumeUp;
  Remote.VolumeUp;
  Remote.Free;
  TV.Free;

  WriteLn;
  Radio := TRadio.Create;
  AdvRemote := TAdvancedRemote.Create(Radio);
  WriteLn('Advanced remote with Radio:');
  AdvRemote.TogglePower;
  AdvRemote.VolumeUp;
  AdvRemote.Mute;
  AdvRemote.Free;
  Radio.Free;
end.
