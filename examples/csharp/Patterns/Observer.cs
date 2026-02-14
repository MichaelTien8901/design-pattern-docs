namespace DesignPatterns.Observer
{
    public interface IObserver
    {
        void Update(float temperature, float humidity, float pressure);
    }

    public class WeatherStation
    {
        private readonly List<IObserver> _observers = new();
        private float _temperature, _humidity, _pressure;

        public void Register(IObserver observer) => _observers.Add(observer);
        public void Remove(IObserver observer) => _observers.Remove(observer);

        public void SetMeasurements(float temp, float humidity, float pressure)
        {
            _temperature = temp; _humidity = humidity; _pressure = pressure;
            Console.WriteLine($"  WeatherStation: new data ({temp}F, {humidity}%, {pressure}hPa)");
            foreach (var o in _observers) o.Update(temp, humidity, pressure);
        }
    }

    public class CurrentConditionsDisplay : IObserver
    {
        public void Update(float temperature, float humidity, float pressure) =>
            Console.WriteLine($"  CurrentConditions: {temperature}F, {humidity}% humidity");
    }

    public class ForecastDisplay : IObserver
    {
        private float _lastPressure = 1013.25f;

        public void Update(float temperature, float humidity, float pressure)
        {
            var forecast = pressure > _lastPressure ? "improving" :
                           pressure < _lastPressure ? "worsening" : "stable";
            Console.WriteLine($"  Forecast: Weather is {forecast}");
            _lastPressure = pressure;
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var station = new WeatherStation();
            station.Register(new CurrentConditionsDisplay());
            station.Register(new ForecastDisplay());

            station.SetMeasurements(75, 65, 1013.1f);
            Console.WriteLine();
            station.SetMeasurements(80, 70, 1015.2f);
        }
    }
}
