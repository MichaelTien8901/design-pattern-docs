#include <iostream>
#include <memory>
#include <string>
#include <unordered_map>

class CharacterStyle {
    std::string font_;
    int size_;
    std::string color_;
public:
    CharacterStyle(const std::string& font, int size, const std::string& color)
        : font_(font), size_(size), color_(color) {}

    void render(char c, int row, int col) const {
        std::cout << "  '" << c << "' at (" << row << "," << col
                  << ") [font=" << font_ << ", size=" << size_
                  << ", color=" << color_ << "]" << std::endl;
    }
};

class StyleFactory {
    std::unordered_map<std::string, std::shared_ptr<CharacterStyle>> styles_;
public:
    std::shared_ptr<CharacterStyle> getStyle(const std::string& font, int size, const std::string& color) {
        std::string key = font + "_" + std::to_string(size) + "_" + color;
        auto it = styles_.find(key);
        if (it == styles_.end()) {
            std::cout << "Creating new style: " << key << std::endl;
            auto style = std::make_shared<CharacterStyle>(font, size, color);
            styles_[key] = style;
            return style;
        }
        return it->second;
    }

    size_t styleCount() const { return styles_.size(); }
};

int main() {
    std::cout << "=== Flyweight: Character Style in Text Editor ===" << std::endl;

    StyleFactory factory;

    auto style1 = factory.getStyle("Arial", 12, "black");
    auto style2 = factory.getStyle("Arial", 12, "black");  // reused
    auto style3 = factory.getStyle("Times", 14, "red");

    std::cout << "\nRendering characters:" << std::endl;
    style1->render('H', 0, 0);
    style2->render('e', 0, 1);
    style3->render('l', 0, 2);

    std::cout << "\nTotal unique styles created: " << factory.styleCount() << std::endl;

    return 0;
}
