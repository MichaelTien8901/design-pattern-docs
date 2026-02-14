#include <iostream>
#include <string>

class JSONAnalytics {
public:
    void processJSON(const std::string& json) const {
        std::cout << "Processing JSON data: " << json << std::endl;
    }
};

class XMLData {
public:
    std::string getXML() const {
        return "<data><name>Widget</name><price>9.99</price></data>";
    }
};

class XMLToJSONAdapter : public JSONAnalytics {
    XMLData xmlData_;
public:
    XMLToJSONAdapter(const XMLData& data) : xmlData_(data) {}

    void analyze() {
        std::string xml = xmlData_.getXML();
        std::cout << "Adapter: Converting XML to JSON" << std::endl;
        std::cout << "  Input XML: " << xml << std::endl;
        std::string json = R"({"name": "Widget", "price": 9.99})";
        std::cout << "  Converted JSON: " << json << std::endl;
        processJSON(json);
    }
};

int main() {
    std::cout << "=== Adapter: XML to JSON ===" << std::endl;

    XMLData xmlData;
    XMLToJSONAdapter adapter(xmlData);
    adapter.analyze();

    return 0;
}
