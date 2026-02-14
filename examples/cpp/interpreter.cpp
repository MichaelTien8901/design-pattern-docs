#include <iostream>
#include <memory>
#include <string>
#include <sstream>
#include <vector>

class IExpression {
public:
    virtual ~IExpression() = default;
    virtual int interpret() const = 0;
};

class NumberExpr : public IExpression {
    int value_;
public:
    NumberExpr(int v) : value_(v) {}
    int interpret() const override { return value_; }
};

class AddExpr : public IExpression {
    std::unique_ptr<IExpression> left_, right_;
public:
    AddExpr(std::unique_ptr<IExpression> l, std::unique_ptr<IExpression> r)
        : left_(std::move(l)), right_(std::move(r)) {}
    int interpret() const override {
        return left_->interpret() + right_->interpret();
    }
};

class SubtractExpr : public IExpression {
    std::unique_ptr<IExpression> left_, right_;
public:
    SubtractExpr(std::unique_ptr<IExpression> l, std::unique_ptr<IExpression> r)
        : left_(std::move(l)), right_(std::move(r)) {}
    int interpret() const override {
        return left_->interpret() - right_->interpret();
    }
};

std::unique_ptr<IExpression> parse(const std::string& expression) {
    std::istringstream iss(expression);
    int num;
    iss >> num;
    std::unique_ptr<IExpression> result = std::make_unique<NumberExpr>(num);

    std::string op;
    while (iss >> op >> num) {
        auto right = std::make_unique<NumberExpr>(num);
        if (op == "+")
            result = std::make_unique<AddExpr>(std::move(result), std::move(right));
        else
            result = std::make_unique<SubtractExpr>(std::move(result), std::move(right));
    }
    return result;
}

int main() {
    std::cout << "=== Interpreter: Arithmetic Expressions ===\n\n";

    std::vector<std::string> expressions = {"3 + 5", "10 - 2 + 4", "100 - 50 - 25"};
    for (const auto& expr : expressions) {
        auto parsed = parse(expr);
        std::cout << "  " << expr << " = " << parsed->interpret() << "\n";
    }
    return 0;
}
