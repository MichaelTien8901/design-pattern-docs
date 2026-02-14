namespace DesignPatterns.Builder
{
    public class House
    {
        public int Walls { get; set; }
        public bool HasRoof { get; set; }
        public bool HasGarage { get; set; }
        public bool HasPool { get; set; }
        public bool HasGarden { get; set; }

        public override string ToString()
        {
            var features = new List<string> { $"{Walls} walls" };
            if (HasRoof) features.Add("roof");
            if (HasGarage) features.Add("garage");
            if (HasPool) features.Add("pool");
            if (HasGarden) features.Add("garden");
            return $"House with {string.Join(", ", features)}";
        }
    }

    public interface IHouseBuilder
    {
        IHouseBuilder BuildWalls(int count);
        IHouseBuilder BuildRoof();
        IHouseBuilder BuildGarage();
        IHouseBuilder BuildPool();
        IHouseBuilder BuildGarden();
        House Build();
    }

    public class HouseBuilder : IHouseBuilder
    {
        private readonly House _house = new();
        public IHouseBuilder BuildWalls(int count) { _house.Walls = count; return this; }
        public IHouseBuilder BuildRoof() { _house.HasRoof = true; return this; }
        public IHouseBuilder BuildGarage() { _house.HasGarage = true; return this; }
        public IHouseBuilder BuildPool() { _house.HasPool = true; return this; }
        public IHouseBuilder BuildGarden() { _house.HasGarden = true; return this; }
        public House Build() => _house;
    }

    public class Director
    {
        public House BuildSimpleHouse(IHouseBuilder builder) =>
            builder.BuildWalls(4).BuildRoof().Build();

        public House BuildLuxuryHouse(IHouseBuilder builder) =>
            builder.BuildWalls(4).BuildRoof().BuildGarage().BuildPool().BuildGarden().Build();
    }

    public static class Demo
    {
        public static void Run()
        {
            var director = new Director();
            Console.WriteLine(director.BuildSimpleHouse(new HouseBuilder()));
            Console.WriteLine(director.BuildLuxuryHouse(new HouseBuilder()));
        }
    }
}
