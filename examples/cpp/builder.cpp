#include <iostream>
#include <memory>
#include <string>

class House {
public:
    std::string walls;
    std::string roof;
    std::string garage;
    std::string pool;

    void describe() const {
        std::cout << "House with " << walls << " walls, " << roof << " roof";
        if (!garage.empty()) std::cout << ", " << garage;
        if (!pool.empty()) std::cout << ", " << pool;
        std::cout << std::endl;
    }
};

class HouseBuilder {
public:
    virtual ~HouseBuilder() = default;
    virtual HouseBuilder& buildWalls() = 0;
    virtual HouseBuilder& buildRoof() = 0;
    virtual HouseBuilder& buildGarage() = 0;
    virtual HouseBuilder& buildPool() = 0;
    virtual std::unique_ptr<House> getResult() = 0;
};

class ConcreteHouseBuilder : public HouseBuilder {
    std::unique_ptr<House> house_;
public:
    ConcreteHouseBuilder() : house_(std::make_unique<House>()) {}

    HouseBuilder& buildWalls() override { house_->walls = "brick"; return *this; }
    HouseBuilder& buildRoof() override { house_->roof = "tile"; return *this; }
    HouseBuilder& buildGarage() override { house_->garage = "2-car garage"; return *this; }
    HouseBuilder& buildPool() override { house_->pool = "swimming pool"; return *this; }

    std::unique_ptr<House> getResult() override {
        auto result = std::move(house_);
        house_ = std::make_unique<House>();
        return result;
    }
};

class Director {
public:
    void buildMinimalHouse(HouseBuilder& builder) {
        builder.buildWalls().buildRoof();
    }
    void buildFullHouse(HouseBuilder& builder) {
        builder.buildWalls().buildRoof().buildGarage().buildPool();
    }
};

int main() {
    std::cout << "=== Builder: House Construction ===" << std::endl;

    ConcreteHouseBuilder builder;
    Director director;

    std::cout << "\nMinimal house:" << std::endl;
    director.buildMinimalHouse(builder);
    auto house1 = builder.getResult();
    house1->describe();

    std::cout << "\nFull house:" << std::endl;
    director.buildFullHouse(builder);
    auto house2 = builder.getResult();
    house2->describe();

    return 0;
}
