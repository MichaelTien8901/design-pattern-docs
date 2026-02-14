cmake_minimum_required(VERSION 3.16)
project(DesignPatterns)
set(CMAKE_CXX_STANDARD 17)

# Creational
add_executable(factory-method factory-method.cpp)
add_executable(abstract-factory abstract-factory.cpp)
add_executable(builder builder.cpp)
add_executable(prototype prototype.cpp)
add_executable(singleton singleton.cpp)

# Structural
add_executable(adapter adapter.cpp)
add_executable(bridge bridge.cpp)
add_executable(composite composite.cpp)
add_executable(decorator decorator.cpp)
add_executable(facade facade.cpp)
add_executable(flyweight flyweight.cpp)
add_executable(proxy proxy.cpp)

# Behavioral
add_executable(chain-of-responsibility chain-of-responsibility.cpp)
add_executable(command command.cpp)
add_executable(iterator iterator.cpp)
add_executable(mediator mediator.cpp)
add_executable(memento memento.cpp)
add_executable(observer observer.cpp)
add_executable(state state.cpp)
add_executable(strategy strategy.cpp)
add_executable(template-method template-method.cpp)
add_executable(visitor visitor.cpp)
