#include <iostream>
#include <string>
#include <vector>

struct Book {
    std::string title;
    std::string author;
};

class BookCollection {
    std::vector<Book> books_;
public:
    void addBook(const std::string& title, const std::string& author) {
        books_.push_back({title, author});
    }

    class Iterator {
        const std::vector<Book>& books_;
        size_t index_;
    public:
        Iterator(const std::vector<Book>& books, size_t index) : books_(books), index_(index) {}
        bool operator!=(const Iterator& other) const { return index_ != other.index_; }
        Iterator& operator++() { ++index_; return *this; }
        const Book& operator*() const { return books_[index_]; }
    };

    Iterator begin() const { return Iterator(books_, 0); }
    Iterator end() const { return Iterator(books_, books_.size()); }
    size_t size() const { return books_.size(); }
};

int main() {
    std::cout << "=== Iterator: Book Collection ===" << std::endl;

    BookCollection collection;
    collection.addBook("Design Patterns", "GoF");
    collection.addBook("Clean Code", "Robert Martin");
    collection.addBook("Refactoring", "Martin Fowler");

    std::cout << "\nIterating over " << collection.size() << " books:" << std::endl;
    for (const auto& book : collection) {
        std::cout << "  \"" << book.title << "\" by " << book.author << std::endl;
    }

    return 0;
}
