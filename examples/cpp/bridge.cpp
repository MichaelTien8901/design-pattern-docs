#include <iostream>
#include <memory>
#include <string>

class Device {
public:
    virtual ~Device() = default;
    virtual bool isEnabled() const = 0;
    virtual void enable() = 0;
    virtual void disable() = 0;
    virtual int getVolume() const = 0;
    virtual void setVolume(int vol) = 0;
    virtual std::string name() const = 0;
};

class TV : public Device {
    bool on_ = false;
    int volume_ = 30;
public:
    bool isEnabled() const override { return on_; }
    void enable() override { on_ = true; std::cout << "TV is now ON" << std::endl; }
    void disable() override { on_ = false; std::cout << "TV is now OFF" << std::endl; }
    int getVolume() const override { return volume_; }
    void setVolume(int v) override { volume_ = v; std::cout << "TV volume set to " << v << std::endl; }
    std::string name() const override { return "TV"; }
};

class Radio : public Device {
    bool on_ = false;
    int volume_ = 20;
public:
    bool isEnabled() const override { return on_; }
    void enable() override { on_ = true; std::cout << "Radio is now ON" << std::endl; }
    void disable() override { on_ = false; std::cout << "Radio is now OFF" << std::endl; }
    int getVolume() const override { return volume_; }
    void setVolume(int v) override { volume_ = v; std::cout << "Radio volume set to " << v << std::endl; }
    std::string name() const override { return "Radio"; }
};

class RemoteControl {
protected:
    std::shared_ptr<Device> device_;
public:
    RemoteControl(std::shared_ptr<Device> dev) : device_(dev) {}
    virtual ~RemoteControl() = default;
    void togglePower() {
        if (device_->isEnabled()) device_->disable();
        else device_->enable();
    }
    void volumeUp() { device_->setVolume(device_->getVolume() + 10); }
    void volumeDown() { device_->setVolume(device_->getVolume() - 10); }
};

class AdvancedRemote : public RemoteControl {
public:
    using RemoteControl::RemoteControl;
    void mute() { device_->setVolume(0); }
};

int main() {
    std::cout << "=== Bridge: Remote Control + Devices ===" << std::endl;

    auto tv = std::make_shared<TV>();
    RemoteControl remote(tv);
    std::cout << "\nBasic remote with TV:" << std::endl;
    remote.togglePower();
    remote.volumeUp();

    auto radio = std::make_shared<Radio>();
    AdvancedRemote advRemote(radio);
    std::cout << "\nAdvanced remote with Radio:" << std::endl;
    advRemote.togglePower();
    advRemote.volumeUp();
    advRemote.mute();

    return 0;
}
