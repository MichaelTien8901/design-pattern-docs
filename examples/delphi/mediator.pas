{$mode objfpc}{$H+}
program mediator;

uses SysUtils, Classes;

type
  TChatRoom = class;

  TUser = class(TObject)
  private
    FName: string;
    FRoom: TChatRoom;
  public
    constructor Create(const AName: string);
    property Name: string read FName;
    procedure JoinRoom(ARoom: TChatRoom);
    procedure Send(const Msg: string);
    procedure Receive(const FromName, Msg: string);
  end;

  TChatRoom = class(TObject)
  private
    FUsers: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddUser(U: TUser);
    procedure Broadcast(Sender: TUser; const Msg: string);
  end;

constructor TUser.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
  FRoom := nil;
end;

procedure TUser.JoinRoom(ARoom: TChatRoom);
begin
  FRoom := ARoom;
  ARoom.AddUser(Self);
  WriteLn('  ', FName, ' joined the chat room');
end;

procedure TUser.Send(const Msg: string);
begin
  WriteLn('  ', FName, ' sends: "', Msg, '"');
  if FRoom <> nil then
    FRoom.Broadcast(Self, Msg);
end;

procedure TUser.Receive(const FromName, Msg: string);
begin
  WriteLn('    ', FName, ' received from ', FromName, ': "', Msg, '"');
end;

constructor TChatRoom.Create;
begin
  inherited;
  FUsers := TList.Create;
end;

destructor TChatRoom.Destroy;
begin
  FUsers.Free;
  inherited;
end;

procedure TChatRoom.AddUser(U: TUser);
begin
  FUsers.Add(U);
end;

procedure TChatRoom.Broadcast(Sender: TUser; const Msg: string);
var
  I: Integer;
  U: TUser;
begin
  for I := 0 to FUsers.Count - 1 do
  begin
    U := TUser(FUsers[I]);
    if U <> Sender then
      U.Receive(Sender.Name, Msg);
  end;
end;

var
  Room: TChatRoom;
  Alice, Bob, Charlie: TUser;
begin
  WriteLn('=== Mediator Pattern: Chat Room ===');
  WriteLn;

  Room := TChatRoom.Create;
  Alice := TUser.Create('Alice');
  Bob := TUser.Create('Bob');
  Charlie := TUser.Create('Charlie');

  Alice.JoinRoom(Room);
  Bob.JoinRoom(Room);
  Charlie.JoinRoom(Room);
  WriteLn;

  Alice.Send('Hi everyone!');
  WriteLn;
  Bob.Send('Hey Alice!');

  Alice.Free; Bob.Free; Charlie.Free;
  Room.Free;
end.
