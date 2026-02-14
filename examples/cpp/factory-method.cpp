#include <iostream>
#include <memory>
#include <string>

// Product interface
class Transport {
public:
    virtual ~Transport() = default;
    virtual std::string deliver() const = 0;
};

class Truck : public Transport {
public:
    std::string deliver() const override {
        return "Delivering by land in a truck";
    }
};

class Ship : public Transport {
public:
    std::string deliver() const override {
        return "Delivering by sea in a ship";
    }
};

// Creator
class Logistics {
public:
    virtual ~Logistics() = default;
    virtual std::unique_ptr<Transport> createTransport() const = 0;

    std::string planDelivery() const {
        auto transport = createTransport();
        return "Logistics planned: " + transport->deliver();
    }
};

class RoadLogistics : public Logistics {
public:
    std::unique_ptr<Transport> createTransport() const override {
        return std::make_unique<Truck>();
    }
};

class SeaLogistics : public Logistics {
public:
    std::unique_ptr<Transport> createTransport() const override {
        return std::make_unique<Ship>();
    }
};

int main() {
    std::cout << "=== Factory Method: Transport Logistics ===" << std::endl;

    std::unique_ptr<Logistics> road = std::make_unique<RoadLogistics>();
    std::cout << road->planDelivery() << std::endl;

    std::unique_ptr<Logistics> sea = std::make_unique<SeaLogistics>();
    std::cout << sea->planDelivery() << std::endl;

    return 0;
}
