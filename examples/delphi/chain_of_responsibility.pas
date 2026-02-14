{$mode objfpc}{$H+}
program chain_of_responsibility;

uses SysUtils;

type
  TTicketPriority = (tpLow, tpMedium, tpHigh, tpCritical);

  TSupportHandler = class(TObject)
  private
    FNext: TSupportHandler;
  public
    procedure SetNext(ANext: TSupportHandler);
    procedure Handle(Priority: TTicketPriority; const Issue: string); virtual;
  end;

  TFrontDesk = class(TSupportHandler)
  public
    procedure Handle(Priority: TTicketPriority; const Issue: string); override;
  end;

  TTechSupport = class(TSupportHandler)
  public
    procedure Handle(Priority: TTicketPriority; const Issue: string); override;
  end;

  TEngineer = class(TSupportHandler)
  public
    procedure Handle(Priority: TTicketPriority; const Issue: string); override;
  end;

  TManager = class(TSupportHandler)
  public
    procedure Handle(Priority: TTicketPriority; const Issue: string); override;
  end;

procedure TSupportHandler.SetNext(ANext: TSupportHandler);
begin
  FNext := ANext;
end;

procedure TSupportHandler.Handle(Priority: TTicketPriority; const Issue: string);
begin
  if FNext <> nil then
    FNext.Handle(Priority, Issue)
  else
    WriteLn('  No handler available for: ', Issue);
end;

procedure TFrontDesk.Handle(Priority: TTicketPriority; const Issue: string);
begin
  if Priority = tpLow then
    WriteLn('  FrontDesk handled: ', Issue)
  else
    inherited Handle(Priority, Issue);
end;

procedure TTechSupport.Handle(Priority: TTicketPriority; const Issue: string);
begin
  if Priority = tpMedium then
    WriteLn('  TechSupport handled: ', Issue)
  else
    inherited Handle(Priority, Issue);
end;

procedure TEngineer.Handle(Priority: TTicketPriority; const Issue: string);
begin
  if Priority = tpHigh then
    WriteLn('  Engineer handled: ', Issue)
  else
    inherited Handle(Priority, Issue);
end;

procedure TManager.Handle(Priority: TTicketPriority; const Issue: string);
begin
  if Priority = tpCritical then
    WriteLn('  Manager handled: ', Issue)
  else
    inherited Handle(Priority, Issue);
end;

var
  FD: TFrontDesk;
  TS: TTechSupport;
  EN: TEngineer;
  MG: TManager;
begin
  WriteLn('=== Chain of Responsibility: Support Ticket Handling ===');
  WriteLn;

  FD := TFrontDesk.Create;
  TS := TTechSupport.Create;
  EN := TEngineer.Create;
  MG := TManager.Create;

  FD.SetNext(TS);
  TS.SetNext(EN);
  EN.SetNext(MG);

  WriteLn('Submitting tickets to front desk:');
  FD.Handle(tpLow, 'Password reset');
  FD.Handle(tpMedium, 'Software installation');
  FD.Handle(tpHigh, 'Server crash');
  FD.Handle(tpCritical, 'Data breach detected');

  FD.Free; TS.Free; EN.Free; MG.Free;
end.
