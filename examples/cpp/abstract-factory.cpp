#include <iostream>
#include <memory>
#include <string>

// Abstract products
class Button {
public:
    virtual ~Button() = default;
    virtual std::string render() const = 0;
};

class Checkbox {
public:
    virtual ~Checkbox() = default;
    virtual std::string render() const = 0;
};

// Windows variants
class WindowsButton : public Button {
public:
    std::string render() const override { return "Rendering Windows button"; }
};

class WindowsCheckbox : public Checkbox {
public:
    std::string render() const override { return "Rendering Windows checkbox"; }
};

// Linux variants
class LinuxButton : public Button {
public:
    std::string render() const override { return "Rendering Linux button"; }
};

class LinuxCheckbox : public Checkbox {
public:
    std::string render() const override { return "Rendering Linux checkbox"; }
};

// Abstract factory
class GUIFactory {
public:
    virtual ~GUIFactory() = default;
    virtual std::unique_ptr<Button> createButton() const = 0;
    virtual std::unique_ptr<Checkbox> createCheckbox() const = 0;
};

class WindowsFactory : public GUIFactory {
public:
    std::unique_ptr<Button> createButton() const override {
        return std::make_unique<WindowsButton>();
    }
    std::unique_ptr<Checkbox> createCheckbox() const override {
        return std::make_unique<WindowsCheckbox>();
    }
};

class LinuxFactory : public GUIFactory {
public:
    std::unique_ptr<Button> createButton() const override {
        return std::make_unique<LinuxButton>();
    }
    std::unique_ptr<Checkbox> createCheckbox() const override {
        return std::make_unique<LinuxCheckbox>();
    }
};

void buildUI(const GUIFactory& factory) {
    auto button = factory.createButton();
    auto checkbox = factory.createCheckbox();
    std::cout << button->render() << std::endl;
    std::cout << checkbox->render() << std::endl;
}

int main() {
    std::cout << "=== Abstract Factory: GUI Widgets ===" << std::endl;

    std::cout << "\nWindows GUI:" << std::endl;
    WindowsFactory winFactory;
    buildUI(winFactory);

    std::cout << "\nLinux GUI:" << std::endl;
    LinuxFactory linFactory;
    buildUI(linFactory);

    return 0;
}
