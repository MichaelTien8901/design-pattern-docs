{$mode objfpc}{$H+}
program facade;

uses SysUtils;

type
  TAmplifier = class(TObject)
  public
    procedure On_;
    procedure Off_;
    procedure SetVolume(V: Integer);
  end;

  TDVDPlayer = class(TObject)
  public
    procedure On_;
    procedure Off_;
    procedure Play(const Movie: string);
    procedure Stop;
  end;

  TProjector = class(TObject)
  public
    procedure On_;
    procedure Off_;
    procedure WideScreen;
  end;

  TLights = class(TObject)
  public
    procedure Dim(Level: Integer);
    procedure On_;
  end;

  THomeTheaterFacade = class(TObject)
  private
    FAmp: TAmplifier;
    FDVD: TDVDPlayer;
    FProj: TProjector;
    FLights: TLights;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WatchMovie(const Movie: string);
    procedure EndMovie;
  end;

procedure TAmplifier.On_; begin WriteLn('  Amplifier: ON'); end;
procedure TAmplifier.Off_; begin WriteLn('  Amplifier: OFF'); end;
procedure TAmplifier.SetVolume(V: Integer); begin WriteLn('  Amplifier: volume set to ', V); end;

procedure TDVDPlayer.On_; begin WriteLn('  DVD Player: ON'); end;
procedure TDVDPlayer.Off_; begin WriteLn('  DVD Player: OFF'); end;
procedure TDVDPlayer.Play(const Movie: string); begin WriteLn('  DVD Player: playing "', Movie, '"'); end;
procedure TDVDPlayer.Stop; begin WriteLn('  DVD Player: stopped'); end;

procedure TProjector.On_; begin WriteLn('  Projector: ON'); end;
procedure TProjector.Off_; begin WriteLn('  Projector: OFF'); end;
procedure TProjector.WideScreen; begin WriteLn('  Projector: widescreen mode'); end;

procedure TLights.Dim(Level: Integer); begin WriteLn('  Lights: dimmed to ', Level, '%'); end;
procedure TLights.On_; begin WriteLn('  Lights: ON (full)'); end;

constructor THomeTheaterFacade.Create;
begin
  inherited;
  FAmp := TAmplifier.Create;
  FDVD := TDVDPlayer.Create;
  FProj := TProjector.Create;
  FLights := TLights.Create;
end;

destructor THomeTheaterFacade.Destroy;
begin
  FAmp.Free; FDVD.Free; FProj.Free; FLights.Free;
  inherited;
end;

procedure THomeTheaterFacade.WatchMovie(const Movie: string);
begin
  WriteLn('Get ready to watch a movie...');
  FLights.Dim(10);
  FProj.On_;
  FProj.WideScreen;
  FAmp.On_;
  FAmp.SetVolume(7);
  FDVD.On_;
  FDVD.Play(Movie);
end;

procedure THomeTheaterFacade.EndMovie;
begin
  WriteLn('Shutting movie theater down...');
  FDVD.Stop;
  FDVD.Off_;
  FAmp.Off_;
  FProj.Off_;
  FLights.On_;
end;

var
  HT: THomeTheaterFacade;
begin
  WriteLn('=== Facade Pattern: Home Theater System ===');
  WriteLn;

  HT := THomeTheaterFacade.Create;
  HT.WatchMovie('The Matrix');
  WriteLn;
  HT.EndMovie;
  HT.Free;
end.
