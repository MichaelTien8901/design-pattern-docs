#include <iostream>
#include <memory>
#include <stack>
#include <string>

class TextEditor {
    std::string text_;
public:
    void insertText(const std::string& t) { text_ += t; }
    void deleteText(size_t count) {
        if (count <= text_.size()) text_.erase(text_.size() - count);
    }
    std::string getText() const { return text_; }
    void setText(const std::string& t) { text_ = t; }
};

class Command {
public:
    virtual ~Command() = default;
    virtual void execute() = 0;
    virtual void undo() = 0;
};

class InsertCommand : public Command {
    TextEditor& editor_;
    std::string text_;
public:
    InsertCommand(TextEditor& ed, const std::string& text) : editor_(ed), text_(text) {}
    void execute() override { editor_.insertText(text_); }
    void undo() override { editor_.deleteText(text_.size()); }
};

class DeleteCommand : public Command {
    TextEditor& editor_;
    size_t count_;
    std::string deleted_;
public:
    DeleteCommand(TextEditor& ed, size_t count) : editor_(ed), count_(count) {}
    void execute() override {
        std::string t = editor_.getText();
        deleted_ = t.substr(t.size() - count_);
        editor_.deleteText(count_);
    }
    void undo() override { editor_.insertText(deleted_); }
};

class CommandInvoker {
    std::stack<std::unique_ptr<Command>> history_;
public:
    void executeCommand(std::unique_ptr<Command> cmd) {
        cmd->execute();
        history_.push(std::move(cmd));
    }
    void undo() {
        if (!history_.empty()) {
            history_.top()->undo();
            history_.pop();
        }
    }
};

int main() {
    std::cout << "=== Command: Text Editor Operations ===" << std::endl;

    TextEditor editor;
    CommandInvoker invoker;

    invoker.executeCommand(std::make_unique<InsertCommand>(editor, "Hello"));
    std::cout << "After insert: \"" << editor.getText() << "\"" << std::endl;

    invoker.executeCommand(std::make_unique<InsertCommand>(editor, ", World!"));
    std::cout << "After insert: \"" << editor.getText() << "\"" << std::endl;

    invoker.executeCommand(std::make_unique<DeleteCommand>(editor, 7));
    std::cout << "After delete: \"" << editor.getText() << "\"" << std::endl;

    invoker.undo();
    std::cout << "After undo:   \"" << editor.getText() << "\"" << std::endl;

    invoker.undo();
    std::cout << "After undo:   \"" << editor.getText() << "\"" << std::endl;

    return 0;
}
