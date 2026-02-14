#include <iostream>
#include <memory>
#include <string>

enum class Priority { LOW, MEDIUM, HIGH };

struct Ticket {
    std::string description;
    Priority priority;
};

class SupportHandler {
    std::shared_ptr<SupportHandler> next_;
public:
    virtual ~SupportHandler() = default;
    SupportHandler& setNext(std::shared_ptr<SupportHandler> next) {
        next_ = next;
        return *next_;
    }
    virtual void handle(const Ticket& ticket) {
        if (next_) next_->handle(ticket);
        else std::cout << "  No handler available for: " << ticket.description << std::endl;
    }
};

class FrontDesk : public SupportHandler {
public:
    void handle(const Ticket& ticket) override {
        if (ticket.priority == Priority::LOW) {
            std::cout << "  FrontDesk handled: " << ticket.description << std::endl;
        } else {
            std::cout << "  FrontDesk escalating: " << ticket.description << std::endl;
            SupportHandler::handle(ticket);
        }
    }
};

class Engineer : public SupportHandler {
public:
    void handle(const Ticket& ticket) override {
        if (ticket.priority == Priority::MEDIUM) {
            std::cout << "  Engineer handled: " << ticket.description << std::endl;
        } else {
            std::cout << "  Engineer escalating: " << ticket.description << std::endl;
            SupportHandler::handle(ticket);
        }
    }
};

class Manager : public SupportHandler {
public:
    void handle(const Ticket& ticket) override {
        std::cout << "  Manager handled: " << ticket.description << std::endl;
    }
};

int main() {
    std::cout << "=== Chain of Responsibility: Support Ticket Handling ===" << std::endl;

    auto front = std::make_shared<FrontDesk>();
    auto eng = std::make_shared<Engineer>();
    auto mgr = std::make_shared<Manager>();
    front->setNext(eng).setNext(mgr);

    std::cout << "\nLow priority ticket:" << std::endl;
    front->handle({"Password reset", Priority::LOW});

    std::cout << "\nMedium priority ticket:" << std::endl;
    front->handle({"Bug in production", Priority::MEDIUM});

    std::cout << "\nHigh priority ticket:" << std::endl;
    front->handle({"Server down!", Priority::HIGH});

    return 0;
}
