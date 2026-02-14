{$mode objfpc}{$H+}
program memento;

uses SysUtils, Classes;

type
  TEditorMemento = class(TObject)
  private
    FContent: string;
    FCursorPos: Integer;
  public
    constructor Create(const AContent: string; ACursorPos: Integer);
    property Content: string read FContent;
    property CursorPos: Integer read FCursorPos;
  end;

  TTextEditor = class(TObject)
  private
    FContent: string;
    FCursorPos: Integer;
  public
    procedure TypeText(const S: string);
    function Save: TEditorMemento;
    procedure Restore(M: TEditorMemento);
    procedure Show;
  end;

  THistory = class(TObject)
  private
    FStates: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Push(M: TEditorMemento);
    function Pop: TEditorMemento;
    function Count: Integer;
  end;

constructor TEditorMemento.Create(const AContent: string; ACursorPos: Integer);
begin
  inherited Create;
  FContent := AContent;
  FCursorPos := ACursorPos;
end;

procedure TTextEditor.TypeText(const S: string);
begin
  FContent := FContent + S;
  FCursorPos := Length(FContent);
end;

function TTextEditor.Save: TEditorMemento;
begin
  Result := TEditorMemento.Create(FContent, FCursorPos);
end;

procedure TTextEditor.Restore(M: TEditorMemento);
begin
  FContent := M.Content;
  FCursorPos := M.CursorPos;
end;

procedure TTextEditor.Show;
begin
  WriteLn('  Content: "', FContent, '" (cursor at ', FCursorPos, ')');
end;

constructor THistory.Create;
begin
  inherited;
  FStates := TList.Create;
end;

destructor THistory.Destroy;
var
  I: Integer;
begin
  for I := 0 to FStates.Count - 1 do
    TEditorMemento(FStates[I]).Free;
  FStates.Free;
  inherited;
end;

procedure THistory.Push(M: TEditorMemento);
begin
  FStates.Add(M);
end;

function THistory.Pop: TEditorMemento;
begin
  if FStates.Count = 0 then
    Result := nil
  else
  begin
    Result := TEditorMemento(FStates[FStates.Count - 1]);
    FStates.Delete(FStates.Count - 1);
  end;
end;

function THistory.Count: Integer;
begin
  Result := FStates.Count;
end;

var
  Editor: TTextEditor;
  History: THistory;
  M: TEditorMemento;
begin
  WriteLn('=== Memento Pattern: Text Editor Undo ===');
  WriteLn;

  Editor := TTextEditor.Create;
  History := THistory.Create;

  History.Push(Editor.Save);
  Editor.TypeText('Hello');
  Editor.Show;

  History.Push(Editor.Save);
  Editor.TypeText(' World');
  Editor.Show;

  History.Push(Editor.Save);
  Editor.TypeText('!!!');
  Editor.Show;

  WriteLn;
  WriteLn('Undoing...');
  M := History.Pop;
  if M <> nil then begin Editor.Restore(M); M.Free; end;
  Editor.Show;

  WriteLn('Undoing...');
  M := History.Pop;
  if M <> nil then begin Editor.Restore(M); M.Free; end;
  Editor.Show;

  WriteLn('Undoing...');
  M := History.Pop;
  if M <> nil then begin Editor.Restore(M); M.Free; end;
  Editor.Show;

  Editor.Free;
  History.Free;
end.
