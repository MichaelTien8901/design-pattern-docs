#include <iostream>
#include <memory>
#include <string>
#include <vector>

class Circle;
class Rectangle;

class ShapeVisitor {
public:
    virtual ~ShapeVisitor() = default;
    virtual void visitCircle(const Circle& c) = 0;
    virtual void visitRectangle(const Rectangle& r) = 0;
};

class Shape {
public:
    virtual ~Shape() = default;
    virtual void accept(ShapeVisitor& visitor) const = 0;
};

class Circle : public Shape {
    double radius_;
public:
    Circle(double r) : radius_(r) {}
    double getRadius() const { return radius_; }
    void accept(ShapeVisitor& visitor) const override { visitor.visitCircle(*this); }
};

class Rectangle : public Shape {
    double width_, height_;
public:
    Rectangle(double w, double h) : width_(w), height_(h) {}
    double getWidth() const { return width_; }
    double getHeight() const { return height_; }
    void accept(ShapeVisitor& visitor) const override { visitor.visitRectangle(*this); }
};

class XMLExportVisitor : public ShapeVisitor {
public:
    void visitCircle(const Circle& c) override {
        std::cout << "  <circle radius=\"" << c.getRadius() << "\"/>" << std::endl;
    }
    void visitRectangle(const Rectangle& r) override {
        std::cout << "  <rectangle width=\"" << r.getWidth() << "\" height=\"" << r.getHeight() << "\"/>" << std::endl;
    }
};

class JSONExportVisitor : public ShapeVisitor {
public:
    void visitCircle(const Circle& c) override {
        std::cout << "  {\"type\": \"circle\", \"radius\": " << c.getRadius() << "}" << std::endl;
    }
    void visitRectangle(const Rectangle& r) override {
        std::cout << "  {\"type\": \"rectangle\", \"width\": " << r.getWidth()
                  << ", \"height\": " << r.getHeight() << "}" << std::endl;
    }
};

int main() {
    std::cout << "=== Visitor: Shape Export ===" << std::endl;

    std::vector<std::unique_ptr<Shape>> shapes;
    shapes.push_back(std::make_unique<Circle>(5.0));
    shapes.push_back(std::make_unique<Rectangle>(10.0, 20.0));
    shapes.push_back(std::make_unique<Circle>(3.5));

    std::cout << "\nXML Export:" << std::endl;
    XMLExportVisitor xmlVisitor;
    for (const auto& shape : shapes) shape->accept(xmlVisitor);

    std::cout << "\nJSON Export:" << std::endl;
    JSONExportVisitor jsonVisitor;
    for (const auto& shape : shapes) shape->accept(jsonVisitor);

    return 0;
}
