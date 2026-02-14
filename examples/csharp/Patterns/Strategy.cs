namespace DesignPatterns.Strategy
{
    public interface IPaymentStrategy
    {
        void Pay(decimal amount);
    }

    public class CreditCardPayment : IPaymentStrategy
    {
        private readonly string _cardNumber;
        public CreditCardPayment(string cardNumber) => _cardNumber = cardNumber;
        public void Pay(decimal amount) =>
            Console.WriteLine($"  Paid ${amount} with credit card ending in {_cardNumber[^4..]}");
    }

    public class PayPalPayment : IPaymentStrategy
    {
        private readonly string _email;
        public PayPalPayment(string email) => _email = email;
        public void Pay(decimal amount) =>
            Console.WriteLine($"  Paid ${amount} via PayPal ({_email})");
    }

    public class CryptoPayment : IPaymentStrategy
    {
        private readonly string _walletAddress;
        public CryptoPayment(string wallet) => _walletAddress = wallet;
        public void Pay(decimal amount) =>
            Console.WriteLine($"  Paid ${amount} in crypto to {_walletAddress[..8]}...");
    }

    public class ShoppingCart
    {
        private readonly List<(string Item, decimal Price)> _items = new();

        public void AddItem(string item, decimal price) => _items.Add((item, price));

        public void Checkout(IPaymentStrategy strategy)
        {
            var total = _items.Sum(i => i.Price);
            Console.WriteLine($"  Cart total: ${total}");
            strategy.Pay(total);
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var cart = new ShoppingCart();
            cart.AddItem("Book", 29.99m);
            cart.AddItem("Pen", 4.99m);

            Console.WriteLine("--- Credit Card ---");
            cart.Checkout(new CreditCardPayment("4111111111112222"));

            Console.WriteLine("--- PayPal ---");
            cart.Checkout(new PayPalPayment("user@example.com"));

            Console.WriteLine("--- Crypto ---");
            cart.Checkout(new CryptoPayment("0xABCDEF1234567890"));
        }
    }
}
