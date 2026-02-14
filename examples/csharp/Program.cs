using System;

class Program
{
    static void Main(string[] args)
    {
        var patterns = new (string Name, Action Run)[]
        {
            // Creational
            ("Factory Method", DesignPatterns.FactoryMethod.Demo.Run),
            ("Abstract Factory", DesignPatterns.AbstractFactory.Demo.Run),
            ("Builder", DesignPatterns.Builder.Demo.Run),
            ("Prototype", DesignPatterns.Prototype.Demo.Run),
            ("Singleton", DesignPatterns.Singleton.Demo.Run),
            // Structural
            ("Adapter", DesignPatterns.Adapter.Demo.Run),
            ("Bridge", DesignPatterns.Bridge.Demo.Run),
            ("Composite", DesignPatterns.Composite.Demo.Run),
            ("Decorator", DesignPatterns.Decorator.Demo.Run),
            ("Facade", DesignPatterns.Facade.Demo.Run),
            ("Flyweight", DesignPatterns.Flyweight.Demo.Run),
            ("Proxy", DesignPatterns.Proxy.Demo.Run),
            // Behavioral
            ("Chain of Responsibility", DesignPatterns.ChainOfResponsibility.Demo.Run),
            ("Command", DesignPatterns.Command.Demo.Run),
            ("Iterator", DesignPatterns.Iterator.Demo.Run),
            ("Mediator", DesignPatterns.Mediator.Demo.Run),
            ("Memento", DesignPatterns.Memento.Demo.Run),
            ("Observer", DesignPatterns.Observer.Demo.Run),
            ("State", DesignPatterns.State.Demo.Run),
            ("Strategy", DesignPatterns.Strategy.Demo.Run),
            ("Template Method", DesignPatterns.TemplateMethod.Demo.Run),
            ("Visitor", DesignPatterns.Visitor.Demo.Run),
            ("Interpreter", DesignPatterns.Interpreter.Demo.Run),
        };

        foreach (var (name, run) in patterns)
        {
            Console.WriteLine(new string('=', 60));
            Console.WriteLine($"  {name} Pattern");
            Console.WriteLine(new string('=', 60));
            run();
            Console.WriteLine();
        }
    }
}
