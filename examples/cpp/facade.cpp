#include <iostream>
#include <string>

class Amplifier {
public:
    void on() { std::cout << "  Amplifier on" << std::endl; }
    void setVolume(int level) { std::cout << "  Amplifier volume set to " << level << std::endl; }
    void off() { std::cout << "  Amplifier off" << std::endl; }
};

class DVDPlayer {
public:
    void on() { std::cout << "  DVD Player on" << std::endl; }
    void play(const std::string& movie) { std::cout << "  Playing: " << movie << std::endl; }
    void stop() { std::cout << "  DVD Player stopped" << std::endl; }
    void off() { std::cout << "  DVD Player off" << std::endl; }
};

class Projector {
public:
    void on() { std::cout << "  Projector on" << std::endl; }
    void wideScreenMode() { std::cout << "  Projector in widescreen mode" << std::endl; }
    void off() { std::cout << "  Projector off" << std::endl; }
};

class Lights {
public:
    void dim(int level) { std::cout << "  Lights dimmed to " << level << "%" << std::endl; }
    void on() { std::cout << "  Lights on" << std::endl; }
};

class HomeTheaterFacade {
    Amplifier amp_;
    DVDPlayer dvd_;
    Projector projector_;
    Lights lights_;
public:
    void watchMovie(const std::string& movie) {
        std::cout << "Get ready to watch a movie..." << std::endl;
        lights_.dim(10);
        projector_.on();
        projector_.wideScreenMode();
        amp_.on();
        amp_.setVolume(5);
        dvd_.on();
        dvd_.play(movie);
    }

    void endMovie() {
        std::cout << "Shutting down movie theater..." << std::endl;
        dvd_.stop();
        dvd_.off();
        amp_.off();
        projector_.off();
        lights_.on();
    }
};

int main() {
    std::cout << "=== Facade: Home Theater System ===" << std::endl;

    HomeTheaterFacade theater;
    theater.watchMovie("The Matrix");
    std::cout << std::endl;
    theater.endMovie();

    return 0;
}
