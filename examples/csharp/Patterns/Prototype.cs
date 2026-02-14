namespace DesignPatterns.Prototype
{
    public abstract class Shape
    {
        public int X { get; set; }
        public int Y { get; set; }
        public string Color { get; set; } = "white";

        public abstract Shape Clone();
    }

    public class Circle : Shape
    {
        public int Radius { get; set; }

        public override Shape Clone() => new Circle
            { X = X, Y = Y, Color = Color, Radius = Radius };

        public override string ToString() =>
            $"Circle(x={X}, y={Y}, radius={Radius}, color={Color})";
    }

    public class Rectangle : Shape
    {
        public int Width { get; set; }
        public int Height { get; set; }

        public override Shape Clone() => new Rectangle
            { X = X, Y = Y, Color = Color, Width = Width, Height = Height };

        public override string ToString() =>
            $"Rectangle(x={X}, y={Y}, width={Width}, height={Height}, color={Color})";
    }

    public static class Demo
    {
        public static void Run()
        {
            var circle = new Circle { X = 10, Y = 20, Radius = 15, Color = "red" };
            var clonedCircle = (Circle)circle.Clone();
            clonedCircle.Radius = 25;
            Console.WriteLine($"Original:  {circle}");
            Console.WriteLine($"Cloned:    {clonedCircle}");

            var rect = new Rectangle { X = 5, Y = 5, Width = 30, Height = 20, Color = "blue" };
            var clonedRect = (Rectangle)rect.Clone();
            clonedRect.Color = "green";
            Console.WriteLine($"Original:  {rect}");
            Console.WriteLine($"Cloned:    {clonedRect}");
        }
    }
}
