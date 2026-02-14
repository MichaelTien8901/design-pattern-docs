{$mode objfpc}{$H+}
program command;

uses SysUtils, Classes;

type
  TTextDocument = class(TObject)
  private
    FContent: string;
  public
    property Content: string read FContent write FContent;
    procedure Append(const S: string);
    procedure DeleteLast(Count: Integer);
    procedure Show;
  end;

  TCommand = class(TObject)
  public
    procedure Execute; virtual; abstract;
    procedure Undo; virtual; abstract;
  end;

  TInsertCommand = class(TCommand)
  private
    FDoc: TTextDocument;
    FText: string;
  public
    constructor Create(ADoc: TTextDocument; const AText: string);
    procedure Execute; override;
    procedure Undo; override;
  end;

  TDeleteCommand = class(TCommand)
  private
    FDoc: TTextDocument;
    FCount: Integer;
    FDeleted: string;
  public
    constructor Create(ADoc: TTextDocument; ACount: Integer);
    procedure Execute; override;
    procedure Undo; override;
  end;

  TEditor = class(TObject)
  private
    FDoc: TTextDocument;
    FHistory: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExecuteCommand(Cmd: TCommand);
    procedure UndoLast;
    procedure Show;
  end;

procedure TTextDocument.Append(const S: string);
begin
  FContent := FContent + S;
end;

procedure TTextDocument.DeleteLast(Count: Integer);
begin
  Delete(FContent, Length(FContent) - Count + 1, Count);
end;

procedure TTextDocument.Show;
begin
  WriteLn('  Document: "', FContent, '"');
end;

constructor TInsertCommand.Create(ADoc: TTextDocument; const AText: string);
begin
  inherited Create;
  FDoc := ADoc;
  FText := AText;
end;

procedure TInsertCommand.Execute;
begin
  FDoc.Append(FText);
end;

procedure TInsertCommand.Undo;
begin
  FDoc.DeleteLast(Length(FText));
end;

constructor TDeleteCommand.Create(ADoc: TTextDocument; ACount: Integer);
begin
  inherited Create;
  FDoc := ADoc;
  FCount := ACount;
  FDeleted := '';
end;

procedure TDeleteCommand.Execute;
begin
  FDeleted := Copy(FDoc.Content, Length(FDoc.Content) - FCount + 1, FCount);
  FDoc.DeleteLast(FCount);
end;

procedure TDeleteCommand.Undo;
begin
  FDoc.Append(FDeleted);
end;

constructor TEditor.Create;
begin
  inherited;
  FDoc := TTextDocument.Create;
  FHistory := TList.Create;
end;

destructor TEditor.Destroy;
var
  I: Integer;
begin
  for I := 0 to FHistory.Count - 1 do
    TCommand(FHistory[I]).Free;
  FHistory.Free;
  FDoc.Free;
  inherited;
end;

procedure TEditor.ExecuteCommand(Cmd: TCommand);
begin
  Cmd.Execute;
  FHistory.Add(Cmd);
end;

procedure TEditor.UndoLast;
var
  Cmd: TCommand;
begin
  if FHistory.Count > 0 then
  begin
    Cmd := TCommand(FHistory[FHistory.Count - 1]);
    Cmd.Undo;
    FHistory.Delete(FHistory.Count - 1);
    Cmd.Free;
  end;
end;

procedure TEditor.Show;
begin
  FDoc.Show;
end;

var
  Ed: TEditor;
begin
  WriteLn('=== Command Pattern: Text Editor Operations ===');
  WriteLn;

  Ed := TEditor.Create;

  Ed.ExecuteCommand(TInsertCommand.Create(Ed.FDoc, 'Hello'));
  Ed.Show;

  Ed.ExecuteCommand(TInsertCommand.Create(Ed.FDoc, ' World'));
  Ed.Show;

  Ed.ExecuteCommand(TInsertCommand.Create(Ed.FDoc, '!!!'));
  Ed.Show;

  WriteLn('Undo:');
  Ed.UndoLast;
  Ed.Show;

  WriteLn('Undo:');
  Ed.UndoLast;
  Ed.Show;

  Ed.ExecuteCommand(TDeleteCommand.Create(Ed.FDoc, 2));
  WriteLn('Delete 2 chars:');
  Ed.Show;

  WriteLn('Undo delete:');
  Ed.UndoLast;
  Ed.Show;

  Ed.Free;
end.
