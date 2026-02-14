#include <iostream>
#include <string>
#include <vector>
#include <map>

class DataMiner {
public:
    virtual ~DataMiner() = default;

    // Template method
    void mine(const std::string& path) {
        std::string raw = openFile(path);
        auto data = extractData(raw);
        auto parsed = parseData(data);
        analyzeData(parsed);
        std::cout << "  Report sent." << std::endl;
    }

protected:
    virtual std::string openFile(const std::string& path) = 0;
    virtual std::string extractData(const std::string& raw) = 0;
    virtual std::vector<std::string> parseData(const std::string& data) = 0;

    void analyzeData(const std::vector<std::string>& data) {
        std::cout << "  Analyzing " << data.size() << " records..." << std::endl;
    }
};

class CSVDataMiner : public DataMiner {
protected:
    std::string openFile(const std::string& path) override {
        std::cout << "  Opening CSV file: " << path << std::endl;
        return "name,age\nAlice,30\nBob,25";
    }
    std::string extractData(const std::string& raw) override {
        std::cout << "  Extracting CSV data" << std::endl;
        return raw;
    }
    std::vector<std::string> parseData(const std::string& data) override {
        std::cout << "  Parsing CSV rows" << std::endl;
        return {"Alice,30", "Bob,25"};
    }
};

class JSONDataMiner : public DataMiner {
protected:
    std::string openFile(const std::string& path) override {
        std::cout << "  Opening JSON file: " << path << std::endl;
        return R"([{"name":"Alice"},{"name":"Bob"}])";
    }
    std::string extractData(const std::string& raw) override {
        std::cout << "  Extracting JSON data" << std::endl;
        return raw;
    }
    std::vector<std::string> parseData(const std::string& data) override {
        std::cout << "  Parsing JSON objects" << std::endl;
        return {"Alice", "Bob"};
    }
};

class XMLDataMiner : public DataMiner {
protected:
    std::string openFile(const std::string& path) override {
        std::cout << "  Opening XML file: " << path << std::endl;
        return "<users><user>Alice</user><user>Bob</user></users>";
    }
    std::string extractData(const std::string& raw) override {
        std::cout << "  Extracting XML data" << std::endl;
        return raw;
    }
    std::vector<std::string> parseData(const std::string& data) override {
        std::cout << "  Parsing XML nodes" << std::endl;
        return {"Alice", "Bob"};
    }
};

int main() {
    std::cout << "=== Template Method: Data Mining ===" << std::endl;

    std::cout << "\nCSV Mining:" << std::endl;
    CSVDataMiner csv;
    csv.mine("data.csv");

    std::cout << "\nJSON Mining:" << std::endl;
    JSONDataMiner json;
    json.mine("data.json");

    std::cout << "\nXML Mining:" << std::endl;
    XMLDataMiner xml;
    xml.mine("data.xml");

    return 0;
}
