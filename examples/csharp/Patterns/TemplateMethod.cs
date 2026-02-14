namespace DesignPatterns.TemplateMethod
{
    public abstract class DataMiner
    {
        // Template method
        public void Mine(string path)
        {
            var rawData = OpenFile(path);
            var data = ExtractData(rawData);
            var parsed = ParseData(data);
            AnalyzeData(parsed);
            SendReport();
        }

        protected abstract string OpenFile(string path);
        protected abstract string[] ExtractData(string rawData);
        protected abstract Dictionary<string, string> ParseData(string[] data);

        protected void AnalyzeData(Dictionary<string, string> data)
        {
            Console.WriteLine($"    Analyzing {data.Count} records...");
        }

        protected void SendReport()
        {
            Console.WriteLine("    Report sent!");
        }
    }

    public class CsvMiner : DataMiner
    {
        protected override string OpenFile(string path)
        {
            Console.WriteLine($"    Opening CSV file: {path}");
            return "name,age\nAlice,30\nBob,25";
        }

        protected override string[] ExtractData(string rawData)
        {
            Console.WriteLine("    Extracting CSV rows...");
            return rawData.Split('\n')[1..];
        }

        protected override Dictionary<string, string> ParseData(string[] data)
        {
            Console.WriteLine("    Parsing CSV data...");
            var result = new Dictionary<string, string>();
            foreach (var row in data)
            {
                var cols = row.Split(',');
                result[cols[0]] = cols[1];
            }
            return result;
        }
    }

    public class JsonMiner : DataMiner
    {
        protected override string OpenFile(string path)
        {
            Console.WriteLine($"    Opening JSON file: {path}");
            return "[{\"name\":\"Alice\"},{\"name\":\"Bob\"}]";
        }

        protected override string[] ExtractData(string rawData)
        {
            Console.WriteLine("    Extracting JSON elements...");
            return new[] { "Alice", "Bob" };
        }

        protected override Dictionary<string, string> ParseData(string[] data)
        {
            Console.WriteLine("    Parsing JSON data...");
            var result = new Dictionary<string, string>();
            for (int i = 0; i < data.Length; i++)
                result[$"item{i}"] = data[i];
            return result;
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            Console.WriteLine("  CSV Mining:");
            new CsvMiner().Mine("data.csv");

            Console.WriteLine("  JSON Mining:");
            new JsonMiner().Mine("data.json");
        }
    }
}
