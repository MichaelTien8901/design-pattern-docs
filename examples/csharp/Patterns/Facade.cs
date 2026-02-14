namespace DesignPatterns.Facade
{
    public class Amplifier
    {
        public void On() => Console.WriteLine("  Amplifier on");
        public void SetVolume(int level) => Console.WriteLine($"  Amplifier volume set to {level}");
        public void Off() => Console.WriteLine("  Amplifier off");
    }

    public class DvdPlayer
    {
        public void On() => Console.WriteLine("  DVD Player on");
        public void Play(string movie) => Console.WriteLine($"  Playing \"{movie}\"");
        public void Stop() => Console.WriteLine("  DVD Player stopped");
        public void Off() => Console.WriteLine("  DVD Player off");
    }

    public class Projector
    {
        public void On() => Console.WriteLine("  Projector on");
        public void WideScreenMode() => Console.WriteLine("  Projector in widescreen mode");
        public void Off() => Console.WriteLine("  Projector off");
    }

    public class Lights
    {
        public void Dim(int level) => Console.WriteLine($"  Lights dimmed to {level}%");
        public void On() => Console.WriteLine("  Lights on");
    }

    public class HomeTheaterFacade
    {
        private readonly Amplifier _amp = new();
        private readonly DvdPlayer _dvd = new();
        private readonly Projector _projector = new();
        private readonly Lights _lights = new();

        public void WatchMovie(string movie)
        {
            Console.WriteLine($"Get ready to watch \"{movie}\"...");
            _lights.Dim(10);
            _projector.On();
            _projector.WideScreenMode();
            _amp.On();
            _amp.SetVolume(5);
            _dvd.On();
            _dvd.Play(movie);
        }

        public void EndMovie()
        {
            Console.WriteLine("Shutting down...");
            _dvd.Stop();
            _dvd.Off();
            _amp.Off();
            _projector.Off();
            _lights.On();
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var theater = new HomeTheaterFacade();
            theater.WatchMovie("The Matrix");
            Console.WriteLine();
            theater.EndMovie();
        }
    }
}
