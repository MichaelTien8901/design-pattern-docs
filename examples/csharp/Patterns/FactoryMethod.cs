namespace DesignPatterns.FactoryMethod
{
    // Product interface
    public interface ITransport
    {
        string Deliver();
    }

    // Concrete products
    public class Truck : ITransport
    {
        public string Deliver() => "Delivering by land in a truck";
    }

    public class Ship : ITransport
    {
        public string Deliver() => "Delivering by sea in a ship";
    }

    // Creator
    public abstract class Logistics
    {
        public abstract ITransport CreateTransport();

        public string PlanDelivery()
        {
            var transport = CreateTransport();
            return $"Logistics: {transport.Deliver()}";
        }
    }

    // Concrete creators
    public class RoadLogistics : Logistics
    {
        public override ITransport CreateTransport() => new Truck();
    }

    public class SeaLogistics : Logistics
    {
        public override ITransport CreateTransport() => new Ship();
    }

    public static class Demo
    {
        public static void Run()
        {
            Logistics logistics = new RoadLogistics();
            Console.WriteLine(logistics.PlanDelivery());

            logistics = new SeaLogistics();
            Console.WriteLine(logistics.PlanDelivery());
        }
    }
}
