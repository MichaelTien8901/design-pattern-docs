{$mode objfpc}{$H+}
program abstract_factory;

uses SysUtils;

type
  TButton = class(TObject)
  public
    function Render: string; virtual; abstract;
  end;

  TCheckbox = class(TObject)
  public
    function Render: string; virtual; abstract;
  end;

  TWindowsButton = class(TButton)
  public
    function Render: string; override;
  end;

  TWindowsCheckbox = class(TCheckbox)
  public
    function Render: string; override;
  end;

  TLinuxButton = class(TButton)
  public
    function Render: string; override;
  end;

  TLinuxCheckbox = class(TCheckbox)
  public
    function Render: string; override;
  end;

  TGUIFactory = class(TObject)
  public
    function CreateButton: TButton; virtual; abstract;
    function CreateCheckbox: TCheckbox; virtual; abstract;
  end;

  TWindowsFactory = class(TGUIFactory)
  public
    function CreateButton: TButton; override;
    function CreateCheckbox: TCheckbox; override;
  end;

  TLinuxFactory = class(TGUIFactory)
  public
    function CreateButton: TButton; override;
    function CreateCheckbox: TCheckbox; override;
  end;

function TWindowsButton.Render: string;
begin
  Result := '[Windows Button]';
end;

function TWindowsCheckbox.Render: string;
begin
  Result := '[Windows Checkbox]';
end;

function TLinuxButton.Render: string;
begin
  Result := '[Linux Button]';
end;

function TLinuxCheckbox.Render: string;
begin
  Result := '[Linux Checkbox]';
end;

function TWindowsFactory.CreateButton: TButton;
begin
  Result := TWindowsButton.Create;
end;

function TWindowsFactory.CreateCheckbox: TCheckbox;
begin
  Result := TWindowsCheckbox.Create;
end;

function TLinuxFactory.CreateButton: TButton;
begin
  Result := TLinuxButton.Create;
end;

function TLinuxFactory.CreateCheckbox: TCheckbox;
begin
  Result := TLinuxCheckbox.Create;
end;

procedure RenderUI(Factory: TGUIFactory);
var
  Btn: TButton;
  Chk: TCheckbox;
begin
  Btn := Factory.CreateButton;
  Chk := Factory.CreateCheckbox;
  WriteLn('  Button: ', Btn.Render);
  WriteLn('  Checkbox: ', Chk.Render);
  Btn.Free;
  Chk.Free;
end;

var
  Factory: TGUIFactory;
begin
  WriteLn('=== Abstract Factory Pattern: GUI Widgets ===');
  WriteLn;

  WriteLn('Windows GUI:');
  Factory := TWindowsFactory.Create;
  RenderUI(Factory);
  Factory.Free;

  WriteLn('Linux GUI:');
  Factory := TLinuxFactory.Create;
  RenderUI(Factory);
  Factory.Free;
end.
