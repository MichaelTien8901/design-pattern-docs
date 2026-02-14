namespace DesignPatterns.AbstractFactory
{
    public interface IButton { string Render(); }
    public interface ICheckbox { string Render(); }

    public interface IGUIFactory
    {
        IButton CreateButton();
        ICheckbox CreateCheckbox();
    }

    public class WindowsButton : IButton { public string Render() => "Rendering Windows button"; }
    public class WindowsCheckbox : ICheckbox { public string Render() => "Rendering Windows checkbox"; }

    public class LinuxButton : IButton { public string Render() => "Rendering Linux button"; }
    public class LinuxCheckbox : ICheckbox { public string Render() => "Rendering Linux checkbox"; }

    public class WindowsFactory : IGUIFactory
    {
        public IButton CreateButton() => new WindowsButton();
        public ICheckbox CreateCheckbox() => new WindowsCheckbox();
    }

    public class LinuxFactory : IGUIFactory
    {
        public IButton CreateButton() => new LinuxButton();
        public ICheckbox CreateCheckbox() => new LinuxCheckbox();
    }

    public class Application
    {
        private readonly IButton _button;
        private readonly ICheckbox _checkbox;

        public Application(IGUIFactory factory)
        {
            _button = factory.CreateButton();
            _checkbox = factory.CreateCheckbox();
        }

        public void Render()
        {
            Console.WriteLine(_button.Render());
            Console.WriteLine(_checkbox.Render());
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            Console.WriteLine("--- Windows GUI ---");
            new Application(new WindowsFactory()).Render();

            Console.WriteLine("--- Linux GUI ---");
            new Application(new LinuxFactory()).Render();
        }
    }
}
