{$mode objfpc}{$H+}
program state;

uses SysUtils;

type
  TDocument = class;

  TDocState = class(TObject)
  public
    function GetName: string; virtual; abstract;
    procedure Publish(Doc: TDocument); virtual; abstract;
  end;

  TDraftState = class(TDocState)
  public
    function GetName: string; override;
    procedure Publish(Doc: TDocument); override;
  end;

  TReviewState = class(TDocState)
  public
    function GetName: string; override;
    procedure Publish(Doc: TDocument); override;
  end;

  TPublishedState = class(TDocState)
  public
    function GetName: string; override;
    procedure Publish(Doc: TDocument); override;
  end;

  TDocument = class(TObject)
  private
    FState: TDocState;
    FTitle: string;
  public
    constructor Create(const ATitle: string);
    destructor Destroy; override;
    procedure ChangeState(NewState: TDocState);
    procedure Publish;
    procedure Show;
    property Title: string read FTitle;
  end;

function TDraftState.GetName: string;
begin
  Result := 'Draft';
end;

procedure TDraftState.Publish(Doc: TDocument);
begin
  WriteLn('  Moving from Draft to Review');
  Doc.ChangeState(TReviewState.Create);
end;

function TReviewState.GetName: string;
begin
  Result := 'Review';
end;

procedure TReviewState.Publish(Doc: TDocument);
begin
  WriteLn('  Moving from Review to Published');
  Doc.ChangeState(TPublishedState.Create);
end;

function TPublishedState.GetName: string;
begin
  Result := 'Published';
end;

procedure TPublishedState.Publish(Doc: TDocument);
begin
  WriteLn('  Already published, no change');
end;

constructor TDocument.Create(const ATitle: string);
begin
  inherited Create;
  FTitle := ATitle;
  FState := TDraftState.Create;
end;

destructor TDocument.Destroy;
begin
  FState.Free;
  inherited;
end;

procedure TDocument.ChangeState(NewState: TDocState);
begin
  FState.Free;
  FState := NewState;
end;

procedure TDocument.Publish;
begin
  FState.Publish(Self);
end;

procedure TDocument.Show;
begin
  WriteLn('  Document "', FTitle, '" is in state: ', FState.GetName);
end;

var
  Doc: TDocument;
begin
  WriteLn('=== State Pattern: Document Workflow ===');
  WriteLn;

  Doc := TDocument.Create('Design Patterns Guide');
  Doc.Show;
  WriteLn;

  Doc.Publish;
  Doc.Show;
  WriteLn;

  Doc.Publish;
  Doc.Show;
  WriteLn;

  Doc.Publish;
  Doc.Show;

  Doc.Free;
end.
