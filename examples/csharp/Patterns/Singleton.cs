namespace DesignPatterns.Singleton
{
    public sealed class AppConfig
    {
        private static readonly Lazy<AppConfig> _instance = new(() => new AppConfig());
        public static AppConfig Instance => _instance.Value;

        public string AppName { get; set; } = "MyApp";
        public string Version { get; set; } = "1.0.0";
        public bool DebugMode { get; set; }

        private AppConfig() { }

        public override string ToString() =>
            $"AppConfig(app={AppName}, version={Version}, debug={DebugMode})";
    }

    public static class Demo
    {
        public static void Run()
        {
            var config1 = AppConfig.Instance;
            var config2 = AppConfig.Instance;

            config1.DebugMode = true;
            Console.WriteLine($"config1: {config1}");
            Console.WriteLine($"config2: {config2}");
            Console.WriteLine($"Same instance: {ReferenceEquals(config1, config2)}");
        }
    }
}
