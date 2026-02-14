namespace DesignPatterns.Visitor
{
    public interface IShape
    {
        void Accept(IShapeVisitor visitor);
    }

    public interface IShapeVisitor
    {
        void VisitCircle(Circle circle);
        void VisitRectangle(Rectangle rectangle);
    }

    public class Circle : IShape
    {
        public double Radius { get; }
        public Circle(double radius) => Radius = radius;
        public void Accept(IShapeVisitor visitor) => visitor.VisitCircle(this);
    }

    public class Rectangle : IShape
    {
        public double Width { get; }
        public double Height { get; }
        public Rectangle(double w, double h) { Width = w; Height = h; }
        public void Accept(IShapeVisitor visitor) => visitor.VisitRectangle(this);
    }

    public class XmlExportVisitor : IShapeVisitor
    {
        public void VisitCircle(Circle c) =>
            Console.WriteLine($"  <circle radius=\"{c.Radius}\"/>");

        public void VisitRectangle(Rectangle r) =>
            Console.WriteLine($"  <rectangle width=\"{r.Width}\" height=\"{r.Height}\"/>");
    }

    public class JsonExportVisitor : IShapeVisitor
    {
        public void VisitCircle(Circle c) =>
            Console.WriteLine($"  {{\"type\":\"circle\",\"radius\":{c.Radius}}}");

        public void VisitRectangle(Rectangle r) =>
            Console.WriteLine($"  {{\"type\":\"rectangle\",\"width\":{r.Width},\"height\":{r.Height}}}");
    }

    public static class Demo
    {
        public static void Run()
        {
            IShape[] shapes = { new Circle(5), new Rectangle(10, 20), new Circle(3) };

            Console.WriteLine("XML Export:");
            var xmlVisitor = new XmlExportVisitor();
            foreach (var s in shapes) s.Accept(xmlVisitor);

            Console.WriteLine("JSON Export:");
            var jsonVisitor = new JsonExportVisitor();
            foreach (var s in shapes) s.Accept(jsonVisitor);
        }
    }
}
