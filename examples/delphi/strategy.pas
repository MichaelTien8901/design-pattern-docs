{$mode objfpc}{$H+}
program strategy;

uses SysUtils;

type
  TPaymentStrategy = class(TObject)
  public
    function Pay(Amount: Double): string; virtual; abstract;
  end;

  TCreditCardPayment = class(TPaymentStrategy)
  private
    FCardNumber: string;
  public
    constructor Create(const ACardNumber: string);
    function Pay(Amount: Double): string; override;
  end;

  TPayPalPayment = class(TPaymentStrategy)
  private
    FEmail: string;
  public
    constructor Create(const AEmail: string);
    function Pay(Amount: Double): string; override;
  end;

  TBitcoinPayment = class(TPaymentStrategy)
  private
    FWallet: string;
  public
    constructor Create(const AWallet: string);
    function Pay(Amount: Double): string; override;
  end;

  TShoppingCart = class(TObject)
  private
    FTotal: Double;
    FStrategy: TPaymentStrategy;
  public
    constructor Create;
    procedure AddItem(const Name: string; Price: Double);
    procedure SetPaymentStrategy(S: TPaymentStrategy);
    procedure Checkout;
  end;

constructor TCreditCardPayment.Create(const ACardNumber: string);
begin
  inherited Create;
  FCardNumber := ACardNumber;
end;

function TCreditCardPayment.Pay(Amount: Double): string;
begin
  Result := Format('Paid $%.2f with Credit Card ending in %s',
    [Amount, Copy(FCardNumber, Length(FCardNumber) - 3, 4)]);
end;

constructor TPayPalPayment.Create(const AEmail: string);
begin
  inherited Create;
  FEmail := AEmail;
end;

function TPayPalPayment.Pay(Amount: Double): string;
begin
  Result := Format('Paid $%.2f via PayPal (%s)', [Amount, FEmail]);
end;

constructor TBitcoinPayment.Create(const AWallet: string);
begin
  inherited Create;
  FWallet := AWallet;
end;

function TBitcoinPayment.Pay(Amount: Double): string;
begin
  Result := Format('Paid $%.2f with Bitcoin wallet %s', [Amount, FWallet]);
end;

constructor TShoppingCart.Create;
begin
  inherited;
  FTotal := 0;
  FStrategy := nil;
end;

procedure TShoppingCart.AddItem(const Name: string; Price: Double);
begin
  FTotal := FTotal + Price;
  WriteLn('  Added "', Name, '" - $', Price:0:2);
end;

procedure TShoppingCart.SetPaymentStrategy(S: TPaymentStrategy);
begin
  FStrategy := S;
end;

procedure TShoppingCart.Checkout;
begin
  if FStrategy <> nil then
    WriteLn('  ', FStrategy.Pay(FTotal))
  else
    WriteLn('  No payment strategy set!');
end;

var
  Cart: TShoppingCart;
  CC: TCreditCardPayment;
  PP: TPayPalPayment;
  BTC: TBitcoinPayment;
begin
  WriteLn('=== Strategy Pattern: Payment Processing ===');
  WriteLn;

  Cart := TShoppingCart.Create;
  Cart.AddItem('Keyboard', 49.99);
  Cart.AddItem('Mouse', 29.99);
  WriteLn;

  CC := TCreditCardPayment.Create('4111111111111234');
  PP := TPayPalPayment.Create('user@example.com');
  BTC := TBitcoinPayment.Create('1A2b3C...');

  WriteLn('Pay with credit card:');
  Cart.SetPaymentStrategy(CC);
  Cart.Checkout;

  WriteLn('Pay with PayPal:');
  Cart.SetPaymentStrategy(PP);
  Cart.Checkout;

  WriteLn('Pay with Bitcoin:');
  Cart.SetPaymentStrategy(BTC);
  Cart.Checkout;

  CC.Free; PP.Free; BTC.Free; Cart.Free;
end.
