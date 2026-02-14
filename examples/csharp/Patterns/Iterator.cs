namespace DesignPatterns.Iterator
{
    public class Book
    {
        public string Title { get; }
        public string Author { get; }
        public Book(string title, string author) { Title = title; Author = author; }
        public override string ToString() => $"\"{Title}\" by {Author}";
    }

    public interface IIterator<T>
    {
        bool HasNext();
        T Next();
    }

    public interface IIterableCollection<T>
    {
        IIterator<T> CreateIterator();
    }

    public class BookCollection : IIterableCollection<Book>
    {
        private readonly List<Book> _books = new();
        public void Add(Book book) => _books.Add(book);
        public int Count => _books.Count;
        public Book this[int index] => _books[index];
        public IIterator<Book> CreateIterator() => new BookIterator(this);
    }

    public class BookIterator : IIterator<Book>
    {
        private readonly BookCollection _collection;
        private int _index;

        public BookIterator(BookCollection collection) => _collection = collection;
        public bool HasNext() => _index < _collection.Count;
        public Book Next() => _collection[_index++];
    }

    public static class Demo
    {
        public static void Run()
        {
            var books = new BookCollection();
            books.Add(new Book("Design Patterns", "Gang of Four"));
            books.Add(new Book("Clean Code", "Robert C. Martin"));
            books.Add(new Book("Refactoring", "Martin Fowler"));

            var iterator = books.CreateIterator();
            while (iterator.HasNext())
                Console.WriteLine($"  {iterator.Next()}");
        }
    }
}
