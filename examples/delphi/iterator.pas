{$mode objfpc}{$H+}
program iterator;

uses SysUtils, Classes;

type
  TBook = class(TObject)
  private
    FTitle: string;
    FAuthor: string;
  public
    constructor Create(const ATitle, AAuthor: string);
    property Title: string read FTitle;
    property Author: string read FAuthor;
  end;

  TBookIterator = class(TObject)
  private
    FBooks: TList;
    FIndex: Integer;
  public
    constructor Create(ABooks: TList);
    function HasNext: Boolean;
    function Next: TBook;
    procedure Reset;
  end;

  TBookCollection = class(TObject)
  private
    FBooks: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddBook(const ATitle, AAuthor: string);
    function CreateIterator: TBookIterator;
    function Count: Integer;
  end;

constructor TBook.Create(const ATitle, AAuthor: string);
begin
  inherited Create;
  FTitle := ATitle;
  FAuthor := AAuthor;
end;

constructor TBookIterator.Create(ABooks: TList);
begin
  inherited Create;
  FBooks := ABooks;
  FIndex := 0;
end;

function TBookIterator.HasNext: Boolean;
begin
  Result := FIndex < FBooks.Count;
end;

function TBookIterator.Next: TBook;
begin
  Result := TBook(FBooks[FIndex]);
  Inc(FIndex);
end;

procedure TBookIterator.Reset;
begin
  FIndex := 0;
end;

constructor TBookCollection.Create;
begin
  inherited;
  FBooks := TList.Create;
end;

destructor TBookCollection.Destroy;
var
  I: Integer;
begin
  for I := 0 to FBooks.Count - 1 do
    TBook(FBooks[I]).Free;
  FBooks.Free;
  inherited;
end;

procedure TBookCollection.AddBook(const ATitle, AAuthor: string);
begin
  FBooks.Add(TBook.Create(ATitle, AAuthor));
end;

function TBookCollection.CreateIterator: TBookIterator;
begin
  Result := TBookIterator.Create(FBooks);
end;

function TBookCollection.Count: Integer;
begin
  Result := FBooks.Count;
end;

var
  Collection: TBookCollection;
  Iter: TBookIterator;
  B: TBook;
begin
  WriteLn('=== Iterator Pattern: Book Collection ===');
  WriteLn;

  Collection := TBookCollection.Create;
  Collection.AddBook('Design Patterns', 'GoF');
  Collection.AddBook('Clean Code', 'Robert C. Martin');
  Collection.AddBook('Refactoring', 'Martin Fowler');
  Collection.AddBook('The Pragmatic Programmer', 'Hunt & Thomas');

  WriteLn('Iterating over ', Collection.Count, ' books:');
  Iter := Collection.CreateIterator;
  while Iter.HasNext do
  begin
    B := Iter.Next;
    WriteLn('  - "', B.Title, '" by ', B.Author);
  end;

  Iter.Free;
  Collection.Free;
end.
