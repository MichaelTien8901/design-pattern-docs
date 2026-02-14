namespace DesignPatterns.Memento
{
    public class EditorMemento
    {
        public string Content { get; }
        public int CursorPosition { get; }
        public DateTime Timestamp { get; }

        public EditorMemento(string content, int cursorPos)
        {
            Content = content;
            CursorPosition = cursorPos;
            Timestamp = DateTime.Now;
        }
    }

    public class TextEditor
    {
        public string Content { get; set; } = "";
        public int CursorPosition { get; set; }

        public EditorMemento Save() => new(Content, CursorPosition);

        public void Restore(EditorMemento memento)
        {
            Content = memento.Content;
            CursorPosition = memento.CursorPosition;
        }

        public override string ToString() =>
            $"Editor(content=\"{Content}\", cursor={CursorPosition})";
    }

    public class History
    {
        private readonly Stack<EditorMemento> _snapshots = new();

        public void Push(EditorMemento memento) => _snapshots.Push(memento);

        public EditorMemento? Pop() =>
            _snapshots.Count > 0 ? _snapshots.Pop() : null;
    }

    public static class Demo
    {
        public static void Run()
        {
            var editor = new TextEditor();
            var history = new History();

            editor.Content = "Hello";
            editor.CursorPosition = 5;
            history.Push(editor.Save());
            Console.WriteLine($"  State 1: {editor}");

            editor.Content = "Hello World";
            editor.CursorPosition = 11;
            history.Push(editor.Save());
            Console.WriteLine($"  State 2: {editor}");

            editor.Content = "Hello World!!!";
            editor.CursorPosition = 14;
            Console.WriteLine($"  State 3: {editor}");

            Console.WriteLine("  --- Undo ---");
            var memento = history.Pop();
            if (memento != null) editor.Restore(memento);
            Console.WriteLine($"  After undo: {editor}");

            memento = history.Pop();
            if (memento != null) editor.Restore(memento);
            Console.WriteLine($"  After undo: {editor}");
        }
    }
}
