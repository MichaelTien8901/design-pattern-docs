namespace DesignPatterns.Decorator
{
    public interface IText
    {
        string GetContent();
    }

    public class PlainText : IText
    {
        private readonly string _text;
        public PlainText(string text) => _text = text;
        public string GetContent() => _text;
    }

    public abstract class TextDecorator : IText
    {
        protected readonly IText Wrapped;
        protected TextDecorator(IText wrapped) => Wrapped = wrapped;
        public abstract string GetContent();
    }

    public class BoldDecorator : TextDecorator
    {
        public BoldDecorator(IText wrapped) : base(wrapped) { }
        public override string GetContent() => $"<b>{Wrapped.GetContent()}</b>";
    }

    public class ItalicDecorator : TextDecorator
    {
        public ItalicDecorator(IText wrapped) : base(wrapped) { }
        public override string GetContent() => $"<i>{Wrapped.GetContent()}</i>";
    }

    public class UnderlineDecorator : TextDecorator
    {
        public UnderlineDecorator(IText wrapped) : base(wrapped) { }
        public override string GetContent() => $"<u>{Wrapped.GetContent()}</u>";
    }

    public static class Demo
    {
        public static void Run()
        {
            IText text = new PlainText("Hello, World!");
            Console.WriteLine($"Plain:       {text.GetContent()}");

            text = new BoldDecorator(new PlainText("Hello, World!"));
            Console.WriteLine($"Bold:        {text.GetContent()}");

            text = new ItalicDecorator(new BoldDecorator(new PlainText("Hello, World!")));
            Console.WriteLine($"Bold+Italic: {text.GetContent()}");

            text = new UnderlineDecorator(
                new ItalicDecorator(new BoldDecorator(new PlainText("Hello, World!"))));
            Console.WriteLine($"All three:   {text.GetContent()}");
        }
    }
}
