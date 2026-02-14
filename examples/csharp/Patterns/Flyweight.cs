namespace DesignPatterns.Flyweight
{
    // Flyweight: shared character style
    public class CharacterStyle
    {
        public string Font { get; }
        public int Size { get; }
        public string Color { get; }

        public CharacterStyle(string font, int size, string color)
        {
            Font = font; Size = size; Color = color;
        }

        public override string ToString() => $"[{Font}, {Size}pt, {Color}]";
    }

    public class CharacterStyleFactory
    {
        private readonly Dictionary<string, CharacterStyle> _cache = new();

        public CharacterStyle GetStyle(string font, int size, string color)
        {
            var key = $"{font}_{size}_{color}";
            if (!_cache.ContainsKey(key))
            {
                _cache[key] = new CharacterStyle(font, size, color);
                Console.WriteLine($"  Created new style: {_cache[key]}");
            }
            return _cache[key];
        }

        public int StyleCount => _cache.Count;
    }

    public class Character
    {
        public char Char { get; }
        public CharacterStyle Style { get; }
        public int Row { get; }
        public int Col { get; }

        public Character(char c, CharacterStyle style, int row, int col)
        {
            Char = c; Style = style; Row = row; Col = col;
        }

        public override string ToString() =>
            $"'{Char}' at ({Row},{Col}) style={Style}";
    }

    public static class Demo
    {
        public static void Run()
        {
            var factory = new CharacterStyleFactory();
            var chars = new List<Character>();

            var text = "Hello";
            for (int i = 0; i < text.Length; i++)
                chars.Add(new Character(text[i], factory.GetStyle("Arial", 12, "black"), 0, i));

            var text2 = "World";
            for (int i = 0; i < text2.Length; i++)
                chars.Add(new Character(text2[i], factory.GetStyle("Arial", 12, "black"), 1, i));

            chars.Add(new Character('!', factory.GetStyle("Arial", 16, "red"), 1, 5));

            Console.WriteLine($"Total characters: {chars.Count}");
            Console.WriteLine($"Unique styles: {factory.StyleCount}");
        }
    }
}
