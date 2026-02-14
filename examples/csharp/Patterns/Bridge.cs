namespace DesignPatterns.Bridge
{
    public interface IDevice
    {
        bool IsEnabled { get; }
        int Volume { get; set; }
        void Enable();
        void Disable();
        string Name { get; }
    }

    public class Tv : IDevice
    {
        public bool IsEnabled { get; private set; }
        public int Volume { get; set; } = 30;
        public string Name => "TV";
        public void Enable() { IsEnabled = true; }
        public void Disable() { IsEnabled = false; }
    }

    public class Radio : IDevice
    {
        public bool IsEnabled { get; private set; }
        public int Volume { get; set; } = 20;
        public string Name => "Radio";
        public void Enable() { IsEnabled = true; }
        public void Disable() { IsEnabled = false; }
    }

    public class RemoteControl
    {
        protected readonly IDevice Device;
        public RemoteControl(IDevice device) => Device = device;

        public virtual void TogglePower()
        {
            if (Device.IsEnabled) Device.Disable(); else Device.Enable();
            Console.WriteLine($"{Device.Name} power: {Device.IsEnabled}");
        }

        public void VolumeUp()
        {
            Device.Volume = Math.Min(100, Device.Volume + 10);
            Console.WriteLine($"{Device.Name} volume: {Device.Volume}");
        }

        public void VolumeDown()
        {
            Device.Volume = Math.Max(0, Device.Volume - 10);
            Console.WriteLine($"{Device.Name} volume: {Device.Volume}");
        }
    }

    public class AdvancedRemote : RemoteControl
    {
        public AdvancedRemote(IDevice device) : base(device) { }
        public void Mute()
        {
            Device.Volume = 0;
            Console.WriteLine($"{Device.Name} muted");
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var tv = new Tv();
            var remote = new RemoteControl(tv);
            remote.TogglePower();
            remote.VolumeUp();

            var radio = new Radio();
            var advRemote = new AdvancedRemote(radio);
            advRemote.TogglePower();
            advRemote.VolumeUp();
            advRemote.Mute();
        }
    }
}
