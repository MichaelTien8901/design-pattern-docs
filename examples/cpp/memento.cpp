#include <iostream>
#include <memory>
#include <stack>
#include <string>

class EditorMemento {
    std::string text_;
public:
    EditorMemento(const std::string& text) : text_(text) {}
    const std::string& getText() const { return text_; }
};

class TextEditor {
    std::string text_;
public:
    void type(const std::string& words) { text_ += words; }
    std::string getText() const { return text_; }
    std::unique_ptr<EditorMemento> save() const {
        return std::make_unique<EditorMemento>(text_);
    }
    void restore(const EditorMemento& memento) {
        text_ = memento.getText();
    }
};

class History {
    std::stack<std::unique_ptr<EditorMemento>> snapshots_;
public:
    void push(std::unique_ptr<EditorMemento> memento) {
        snapshots_.push(std::move(memento));
    }
    std::unique_ptr<EditorMemento> pop() {
        if (snapshots_.empty()) return nullptr;
        auto m = std::move(snapshots_.top());
        snapshots_.pop();
        return m;
    }
};

int main() {
    std::cout << "=== Memento: Text Editor Undo ===" << std::endl;

    TextEditor editor;
    History history;

    editor.type("Hello");
    history.push(editor.save());
    std::cout << "Typed: \"" << editor.getText() << "\"" << std::endl;

    editor.type(", World");
    history.push(editor.save());
    std::cout << "Typed: \"" << editor.getText() << "\"" << std::endl;

    editor.type("!!!");
    std::cout << "Typed: \"" << editor.getText() << "\"" << std::endl;

    auto m = history.pop();
    if (m) editor.restore(*m);
    std::cout << "Undo:  \"" << editor.getText() << "\"" << std::endl;

    m = history.pop();
    if (m) editor.restore(*m);
    std::cout << "Undo:  \"" << editor.getText() << "\"" << std::endl;

    return 0;
}
