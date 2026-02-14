namespace DesignPatterns.State
{
    public interface IDocumentState
    {
        void Publish(Document doc);
        void Review(Document doc);
        string Name { get; }
    }

    public class Document
    {
        public IDocumentState State { get; set; }
        public string Title { get; }

        public Document(string title)
        {
            Title = title;
            State = new DraftState();
        }

        public void Publish() => State.Publish(this);
        public void Review() => State.Review(this);
        public override string ToString() => $"Document(\"{Title}\", state={State.Name})";
    }

    public class DraftState : IDocumentState
    {
        public string Name => "Draft";
        public void Publish(Document doc)
        {
            Console.WriteLine("  Draft -> cannot publish directly, need review first");
        }
        public void Review(Document doc)
        {
            Console.WriteLine("  Draft -> sending for Review");
            doc.State = new ReviewState();
        }
    }

    public class ReviewState : IDocumentState
    {
        public string Name => "Review";
        public void Publish(Document doc)
        {
            Console.WriteLine("  Review -> Publishing document");
            doc.State = new PublishedState();
        }
        public void Review(Document doc)
        {
            Console.WriteLine("  Already in review");
        }
    }

    public class PublishedState : IDocumentState
    {
        public string Name => "Published";
        public void Publish(Document doc) => Console.WriteLine("  Already published");
        public void Review(Document doc) => Console.WriteLine("  Already published, cannot review");
    }

    public static class Demo
    {
        public static void Run()
        {
            var doc = new Document("Design Patterns Guide");
            Console.WriteLine($"  {doc}");

            doc.Publish();   // can't publish from draft
            doc.Review();    // draft -> review
            Console.WriteLine($"  {doc}");

            doc.Publish();   // review -> published
            Console.WriteLine($"  {doc}");

            doc.Review();    // already published
        }
    }
}
