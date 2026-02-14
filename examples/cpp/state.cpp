#include <iostream>
#include <memory>
#include <string>

class Document;

class State {
public:
    virtual ~State() = default;
    virtual void publish(Document& doc) = 0;
    virtual std::string name() const = 0;
};

class Draft : public State {
public:
    void publish(Document& doc) override;
    std::string name() const override { return "Draft"; }
};

class Review : public State {
public:
    void publish(Document& doc) override;
    std::string name() const override { return "Review"; }
};

class Published : public State {
public:
    void publish(Document& doc) override {
        std::cout << "  Already published. No changes." << std::endl;
    }
    std::string name() const override { return "Published"; }
};

class Document {
    std::unique_ptr<State> state_;
    std::string content_;
public:
    Document(const std::string& content) : state_(std::make_unique<Draft>()), content_(content) {}
    void setState(std::unique_ptr<State> state) { state_ = std::move(state); }
    void publish() {
        std::cout << "  Current state: " << state_->name() << std::endl;
        state_->publish(*this);
    }
    std::string getStateName() const { return state_->name(); }
};

void Draft::publish(Document& doc) {
    std::cout << "  Moving from Draft to Review" << std::endl;
    doc.setState(std::make_unique<Review>());
}

void Review::publish(Document& doc) {
    std::cout << "  Moving from Review to Published" << std::endl;
    doc.setState(std::make_unique<Published>());
}

int main() {
    std::cout << "=== State: Document Workflow ===" << std::endl;

    Document doc("My Article");

    std::cout << "\nPublish attempt 1:" << std::endl;
    doc.publish();

    std::cout << "\nPublish attempt 2:" << std::endl;
    doc.publish();

    std::cout << "\nPublish attempt 3:" << std::endl;
    doc.publish();

    std::cout << "\nFinal state: " << doc.getStateName() << std::endl;

    return 0;
}
