namespace DesignPatterns.Proxy
{
    public interface IImage
    {
        void Display();
    }

    public class RealImage : IImage
    {
        private readonly string _filename;

        public RealImage(string filename)
        {
            _filename = filename;
            LoadFromDisk();
        }

        private void LoadFromDisk() =>
            Console.WriteLine($"  Loading image from disk: {_filename}");

        public void Display() =>
            Console.WriteLine($"  Displaying image: {_filename}");
    }

    public class LazyImageProxy : IImage
    {
        private readonly string _filename;
        private RealImage? _realImage;

        public LazyImageProxy(string filename) => _filename = filename;

        public void Display()
        {
            if (_realImage == null)
            {
                Console.WriteLine($"  Proxy: lazy-loading {_filename}");
                _realImage = new RealImage(_filename);
            }
            _realImage.Display();
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            Console.WriteLine("Creating proxy (no loading yet):");
            IImage image = new LazyImageProxy("photo.jpg");

            Console.WriteLine("First display (triggers load):");
            image.Display();

            Console.WriteLine("Second display (already loaded):");
            image.Display();
        }
    }
}
