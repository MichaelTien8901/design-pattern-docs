#include <iostream>
#include <memory>
#include <string>

class PaymentStrategy {
public:
    virtual ~PaymentStrategy() = default;
    virtual void pay(double amount) const = 0;
};

class CreditCardPayment : public PaymentStrategy {
    std::string cardNumber_;
public:
    CreditCardPayment(const std::string& card) : cardNumber_(card) {}
    void pay(double amount) const override {
        std::cout << "  Paid $" << amount << " with Credit Card ending in "
                  << cardNumber_.substr(cardNumber_.size() - 4) << std::endl;
    }
};

class PayPalPayment : public PaymentStrategy {
    std::string email_;
public:
    PayPalPayment(const std::string& email) : email_(email) {}
    void pay(double amount) const override {
        std::cout << "  Paid $" << amount << " via PayPal (" << email_ << ")" << std::endl;
    }
};

class BitcoinPayment : public PaymentStrategy {
public:
    void pay(double amount) const override {
        std::cout << "  Paid $" << amount << " with Bitcoin" << std::endl;
    }
};

class ShoppingCart {
    double total_ = 0;
public:
    void addItem(const std::string& item, double price) {
        total_ += price;
        std::cout << "Added " << item << " ($" << price << ")" << std::endl;
    }
    void checkout(const PaymentStrategy& strategy) {
        std::cout << "Checking out total: $" << total_ << std::endl;
        strategy.pay(total_);
    }
};

int main() {
    std::cout << "=== Strategy: Payment Processing ===" << std::endl;

    ShoppingCart cart;
    cart.addItem("Keyboard", 49.99);
    cart.addItem("Mouse", 29.99);

    std::cout << "\nPay with credit card:" << std::endl;
    CreditCardPayment cc("4111111111111234");
    cart.checkout(cc);

    std::cout << "\nPay with PayPal:" << std::endl;
    PayPalPayment pp("user@example.com");
    cart.checkout(pp);

    std::cout << "\nPay with Bitcoin:" << std::endl;
    BitcoinPayment btc;
    cart.checkout(btc);

    return 0;
}
