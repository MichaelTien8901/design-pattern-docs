namespace DesignPatterns.Command
{
    public interface ICommand
    {
        void Execute();
        void Undo();
    }

    public class TextDocument
    {
        public string Content { get; set; } = "";
        public override string ToString() => $"\"{Content}\"";
    }

    public class InsertTextCommand : ICommand
    {
        private readonly TextDocument _doc;
        private readonly string _text;

        public InsertTextCommand(TextDocument doc, string text) { _doc = doc; _text = text; }
        public void Execute() { _doc.Content += _text; Console.WriteLine($"  Insert \"{_text}\" -> {_doc}"); }
        public void Undo() { _doc.Content = _doc.Content[..^_text.Length]; Console.WriteLine($"  Undo insert -> {_doc}"); }
    }

    public class DeleteTextCommand : ICommand
    {
        private readonly TextDocument _doc;
        private readonly int _count;
        private string _deleted = "";

        public DeleteTextCommand(TextDocument doc, int count) { _doc = doc; _count = count; }
        public void Execute()
        {
            _deleted = _doc.Content[^_count..];
            _doc.Content = _doc.Content[..^_count];
            Console.WriteLine($"  Delete {_count} chars -> {_doc}");
        }
        public void Undo() { _doc.Content += _deleted; Console.WriteLine($"  Undo delete -> {_doc}"); }
    }

    public class Editor
    {
        private readonly Stack<ICommand> _history = new();

        public void Execute(ICommand cmd)
        {
            cmd.Execute();
            _history.Push(cmd);
        }

        public void Undo()
        {
            if (_history.Count > 0)
                _history.Pop().Undo();
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var doc = new TextDocument();
            var editor = new Editor();

            editor.Execute(new InsertTextCommand(doc, "Hello"));
            editor.Execute(new InsertTextCommand(doc, " World"));
            editor.Execute(new DeleteTextCommand(doc, 5));
            editor.Undo();
            editor.Undo();
        }
    }
}
