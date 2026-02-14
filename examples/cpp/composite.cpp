#include <iostream>
#include <memory>
#include <string>
#include <vector>

class FileSystemComponent {
public:
    virtual ~FileSystemComponent() = default;
    virtual void display(const std::string& indent = "") const = 0;
    virtual int getSize() const = 0;
};

class File : public FileSystemComponent {
    std::string name_;
    int size_;
public:
    File(const std::string& name, int size) : name_(name), size_(size) {}
    void display(const std::string& indent = "") const override {
        std::cout << indent << "File: " << name_ << " (" << size_ << " KB)" << std::endl;
    }
    int getSize() const override { return size_; }
};

class Directory : public FileSystemComponent {
    std::string name_;
    std::vector<std::shared_ptr<FileSystemComponent>> children_;
public:
    Directory(const std::string& name) : name_(name) {}
    void add(std::shared_ptr<FileSystemComponent> comp) { children_.push_back(comp); }
    void display(const std::string& indent = "") const override {
        std::cout << indent << "Directory: " << name_ << " (" << getSize() << " KB)" << std::endl;
        for (const auto& child : children_) child->display(indent + "  ");
    }
    int getSize() const override {
        int total = 0;
        for (const auto& child : children_) total += child->getSize();
        return total;
    }
};

int main() {
    std::cout << "=== Composite: File System ===" << std::endl;

    auto root = std::make_shared<Directory>("root");
    auto docs = std::make_shared<Directory>("docs");
    auto src = std::make_shared<Directory>("src");

    docs->add(std::make_shared<File>("readme.md", 5));
    docs->add(std::make_shared<File>("guide.pdf", 120));
    src->add(std::make_shared<File>("main.cpp", 15));
    src->add(std::make_shared<File>("utils.cpp", 10));
    root->add(docs);
    root->add(src);
    root->add(std::make_shared<File>("Makefile", 2));

    root->display();

    return 0;
}
