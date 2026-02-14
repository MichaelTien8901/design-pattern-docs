#include <iostream>
#include <memory>
#include <string>
#include <vector>

class Observer {
public:
    virtual ~Observer() = default;
    virtual void update(float temp, float humidity) = 0;
};

class WeatherStation {
    std::vector<Observer*> observers_;
    float temperature_ = 0;
    float humidity_ = 0;
public:
    void addObserver(Observer* obs) { observers_.push_back(obs); }
    void setMeasurements(float temp, float humidity) {
        temperature_ = temp;
        humidity_ = humidity;
        notify();
    }
    void notify() {
        for (auto* obs : observers_) obs->update(temperature_, humidity_);
    }
};

class PhoneDisplay : public Observer {
public:
    void update(float temp, float humidity) override {
        std::cout << "  Phone Display - Temp: " << temp << "F, Humidity: " << humidity << "%" << std::endl;
    }
};

class WindowDisplay : public Observer {
public:
    void update(float temp, float humidity) override {
        std::cout << "  Window Display - Temp: " << temp << "F, Humidity: " << humidity << "%" << std::endl;
    }
};

int main() {
    std::cout << "=== Observer: Weather Station ===" << std::endl;

    WeatherStation station;
    PhoneDisplay phone;
    WindowDisplay window;

    station.addObserver(&phone);
    station.addObserver(&window);

    std::cout << "\nWeather update 1:" << std::endl;
    station.setMeasurements(72.5f, 65.0f);

    std::cout << "\nWeather update 2:" << std::endl;
    station.setMeasurements(80.0f, 90.0f);

    return 0;
}
