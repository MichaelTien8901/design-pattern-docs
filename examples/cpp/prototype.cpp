#include <iostream>
#include <memory>
#include <string>

class Shape {
public:
    virtual ~Shape() = default;
    virtual std::unique_ptr<Shape> clone() const = 0;
    virtual std::string describe() const = 0;
};

class Circle : public Shape {
    int radius_;
    std::string color_;
public:
    Circle(int radius, const std::string& color) : radius_(radius), color_(color) {}
    std::unique_ptr<Shape> clone() const override {
        return std::make_unique<Circle>(*this);
    }
    std::string describe() const override {
        return "Circle(radius=" + std::to_string(radius_) + ", color=" + color_ + ")";
    }
};

class Rectangle : public Shape {
    int width_, height_;
    std::string color_;
public:
    Rectangle(int w, int h, const std::string& color) : width_(w), height_(h), color_(color) {}
    std::unique_ptr<Shape> clone() const override {
        return std::make_unique<Rectangle>(*this);
    }
    std::string describe() const override {
        return "Rectangle(" + std::to_string(width_) + "x" + std::to_string(height_) + ", color=" + color_ + ")";
    }
};

int main() {
    std::cout << "=== Prototype: Shape Cloning ===" << std::endl;

    Circle circle(10, "red");
    std::cout << "Original: " << circle.describe() << std::endl;
    auto clonedCircle = circle.clone();
    std::cout << "Clone:    " << clonedCircle->describe() << std::endl;

    Rectangle rect(20, 30, "blue");
    std::cout << "Original: " << rect.describe() << std::endl;
    auto clonedRect = rect.clone();
    std::cout << "Clone:    " << clonedRect->describe() << std::endl;

    return 0;
}
