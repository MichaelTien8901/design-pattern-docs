namespace DesignPatterns.Composite
{
    public abstract class FileSystemEntry
    {
        public string Name { get; }
        protected FileSystemEntry(string name) => Name = name;
        public abstract int GetSize();
        public abstract void Display(string indent = "");
    }

    public class File : FileSystemEntry
    {
        private readonly int _size;
        public File(string name, int size) : base(name) => _size = size;
        public override int GetSize() => _size;
        public override void Display(string indent = "") =>
            Console.WriteLine($"{indent}{Name} ({_size} KB)");
    }

    public class Directory : FileSystemEntry
    {
        private readonly List<FileSystemEntry> _children = new();
        public Directory(string name) : base(name) { }

        public void Add(FileSystemEntry entry) => _children.Add(entry);

        public override int GetSize() => _children.Sum(c => c.GetSize());

        public override void Display(string indent = "")
        {
            Console.WriteLine($"{indent}{Name}/ ({GetSize()} KB)");
            foreach (var child in _children)
                child.Display(indent + "  ");
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var root = new Directory("root");
            root.Add(new File("readme.txt", 5));

            var src = new Directory("src");
            src.Add(new File("main.cs", 12));
            src.Add(new File("utils.cs", 8));
            root.Add(src);

            var docs = new Directory("docs");
            docs.Add(new File("guide.pdf", 120));
            root.Add(docs);

            root.Display();
        }
    }
}
