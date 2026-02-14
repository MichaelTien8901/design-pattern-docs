#include <iostream>
#include <string>
#include <map>

class AppConfig {
    std::map<std::string, std::string> settings_;

    AppConfig() {
        settings_["app_name"] = "MyApp";
        settings_["version"] = "1.0.0";
        std::cout << "AppConfig initialized" << std::endl;
    }

public:
    AppConfig(const AppConfig&) = delete;
    AppConfig& operator=(const AppConfig&) = delete;

    static AppConfig& instance() {
        static AppConfig inst;
        return inst;
    }

    std::string get(const std::string& key) const {
        auto it = settings_.find(key);
        return it != settings_.end() ? it->second : "";
    }

    void set(const std::string& key, const std::string& value) {
        settings_[key] = value;
    }
};

int main() {
    std::cout << "=== Singleton: AppConfig ===" << std::endl;

    auto& config1 = AppConfig::instance();
    std::cout << "app_name: " << config1.get("app_name") << std::endl;

    config1.set("theme", "dark");

    auto& config2 = AppConfig::instance();
    std::cout << "theme: " << config2.get("theme") << std::endl;
    std::cout << "Same instance: " << (&config1 == &config2 ? "yes" : "no") << std::endl;

    return 0;
}
