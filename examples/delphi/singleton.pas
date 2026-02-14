{$mode objfpc}{$H+}
program singleton;

uses SysUtils;

type
  TAppConfig = class(TObject)
  private
    class var FInstance: TAppConfig;
  public
    AppName: string;
    Version: string;
    Debug: Boolean;
    constructor CreatePrivate;
    class function GetInstance: TAppConfig;
    class procedure FreeInstance_;
    procedure Show;
  end;

constructor TAppConfig.CreatePrivate;
begin
  inherited Create;
  AppName := 'MyApp';
  Version := '1.0.0';
  Debug := False;
end;

class function TAppConfig.GetInstance: TAppConfig;
begin
  if FInstance = nil then
    FInstance := TAppConfig.CreatePrivate;
  Result := FInstance;
end;

class procedure TAppConfig.FreeInstance_;
begin
  FreeAndNil(FInstance);
end;

procedure TAppConfig.Show;
begin
  WriteLn(Format('  AppName=%s, Version=%s, Debug=%s',
    [AppName, Version, BoolToStr(Debug, 'True', 'False')]));
end;

var
  Cfg1, Cfg2: TAppConfig;
begin
  WriteLn('=== Singleton Pattern: AppConfig ===');
  WriteLn;

  Cfg1 := TAppConfig.GetInstance;
  WriteLn('Config from Cfg1:');
  Cfg1.Show;

  Cfg1.Debug := True;
  Cfg1.Version := '2.0.0';

  Cfg2 := TAppConfig.GetInstance;
  WriteLn('Config from Cfg2 (after Cfg1 modified it):');
  Cfg2.Show;

  WriteLn('Same instance? ', Cfg1 = Cfg2);

  TAppConfig.FreeInstance_;
end.
