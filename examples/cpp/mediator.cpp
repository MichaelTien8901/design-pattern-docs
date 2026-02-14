#include <iostream>
#include <memory>
#include <string>
#include <vector>

class User;

class ChatRoom {
    std::vector<User*> users_;
public:
    void addUser(User* user) { users_.push_back(user); }
    void sendMessage(const std::string& message, User* sender);
};

class User {
    std::string name_;
    ChatRoom& room_;
public:
    User(const std::string& name, ChatRoom& room) : name_(name), room_(room) {
        room_.addUser(this);
    }
    const std::string& getName() const { return name_; }
    void send(const std::string& message) {
        std::cout << name_ << " sends: " << message << std::endl;
        room_.sendMessage(message, this);
    }
    void receive(const std::string& message, const std::string& from) {
        std::cout << "  " << name_ << " received from " << from << ": " << message << std::endl;
    }
};

void ChatRoom::sendMessage(const std::string& message, User* sender) {
    for (auto* user : users_) {
        if (user != sender) {
            user->receive(message, sender->getName());
        }
    }
}

int main() {
    std::cout << "=== Mediator: Chat Room ===" << std::endl;

    ChatRoom room;
    User alice("Alice", room);
    User bob("Bob", room);
    User charlie("Charlie", room);

    std::cout << std::endl;
    alice.send("Hi everyone!");
    std::cout << std::endl;
    bob.send("Hey Alice!");

    return 0;
}
