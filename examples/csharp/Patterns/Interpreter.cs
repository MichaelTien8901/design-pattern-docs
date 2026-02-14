namespace DesignPatterns.Interpreter
{
    // Simple expression language: "3 + 5 - 2"
    public interface IExpression
    {
        int Interpret();
    }

    public class NumberExpression : IExpression
    {
        private readonly int _value;
        public NumberExpression(int value) => _value = value;
        public int Interpret() => _value;
    }

    public class AddExpression : IExpression
    {
        private readonly IExpression _left, _right;
        public AddExpression(IExpression left, IExpression right) { _left = left; _right = right; }
        public int Interpret() => _left.Interpret() + _right.Interpret();
    }

    public class SubtractExpression : IExpression
    {
        private readonly IExpression _left, _right;
        public SubtractExpression(IExpression left, IExpression right) { _left = left; _right = right; }
        public int Interpret() => _left.Interpret() - _right.Interpret();
    }

    public static class Parser
    {
        public static IExpression Parse(string expression)
        {
            var tokens = expression.Split(' ');
            IExpression result = new NumberExpression(int.Parse(tokens[0]));

            for (int i = 1; i < tokens.Length; i += 2)
            {
                var op = tokens[i];
                var right = new NumberExpression(int.Parse(tokens[i + 1]));
                result = op == "+" ? new AddExpression(result, right)
                                   : new SubtractExpression(result, right);
            }
            return result;
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var expressions = new[] { "3 + 5", "10 - 2 + 4", "100 - 50 - 25" };
            foreach (var expr in expressions)
            {
                var parsed = Parser.Parse(expr);
                Console.WriteLine($"  {expr} = {parsed.Interpret()}");
            }
        }
    }
}
