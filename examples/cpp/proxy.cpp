#include <iostream>
#include <memory>
#include <string>

class Image {
public:
    virtual ~Image() = default;
    virtual void display() const = 0;
};

class RealImage : public Image {
    std::string filename_;
public:
    RealImage(const std::string& filename) : filename_(filename) {
        std::cout << "Loading image from disk: " << filename_ << std::endl;
    }
    void display() const override {
        std::cout << "Displaying image: " << filename_ << std::endl;
    }
};

class LazyImageProxy : public Image {
    std::string filename_;
    mutable std::unique_ptr<RealImage> realImage_;
public:
    LazyImageProxy(const std::string& filename) : filename_(filename) {
        std::cout << "Proxy created for: " << filename_ << " (not loaded yet)" << std::endl;
    }
    void display() const override {
        if (!realImage_) {
            realImage_ = std::make_unique<RealImage>(filename_);
        }
        realImage_->display();
    }
};

int main() {
    std::cout << "=== Proxy: Lazy-Loading Image ===" << std::endl;

    LazyImageProxy image("photo.jpg");
    std::cout << "\nFirst display (triggers load):" << std::endl;
    image.display();
    std::cout << "\nSecond display (already loaded):" << std::endl;
    image.display();

    return 0;
}
