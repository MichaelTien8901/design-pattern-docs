#include <iostream>
#include <memory>
#include <string>

class Text {
public:
    virtual ~Text() = default;
    virtual std::string render() const = 0;
};

class PlainText : public Text {
    std::string content_;
public:
    PlainText(const std::string& content) : content_(content) {}
    std::string render() const override { return content_; }
};

class TextDecorator : public Text {
protected:
    std::unique_ptr<Text> wrapped_;
public:
    TextDecorator(std::unique_ptr<Text> text) : wrapped_(std::move(text)) {}
};

class BoldDecorator : public TextDecorator {
public:
    using TextDecorator::TextDecorator;
    std::string render() const override {
        return "<b>" + wrapped_->render() + "</b>";
    }
};

class ItalicDecorator : public TextDecorator {
public:
    using TextDecorator::TextDecorator;
    std::string render() const override {
        return "<i>" + wrapped_->render() + "</i>";
    }
};

int main() {
    std::cout << "=== Decorator: Text Formatting ===" << std::endl;

    auto plain = std::make_unique<PlainText>("Hello, World!");
    std::cout << "Plain: " << plain->render() << std::endl;

    auto bold = std::make_unique<BoldDecorator>(std::make_unique<PlainText>("Hello, World!"));
    std::cout << "Bold: " << bold->render() << std::endl;

    auto boldItalic = std::make_unique<ItalicDecorator>(
        std::make_unique<BoldDecorator>(std::make_unique<PlainText>("Hello, World!")));
    std::cout << "Bold+Italic: " << boldItalic->render() << std::endl;

    return 0;
}
