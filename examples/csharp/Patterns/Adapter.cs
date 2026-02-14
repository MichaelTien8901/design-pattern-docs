namespace DesignPatterns.Adapter
{
    // Existing XML service
    public class XmlDataSource
    {
        public string GetXmlData() =>
            "<data><name>Alice</name><age>30</age></data>";
    }

    // Target interface the client expects
    public interface IJsonDataSource
    {
        string GetJsonData();
    }

    // Adapter
    public class XmlToJsonAdapter : IJsonDataSource
    {
        private readonly XmlDataSource _xmlSource;

        public XmlToJsonAdapter(XmlDataSource xmlSource) => _xmlSource = xmlSource;

        public string GetJsonData()
        {
            var xml = _xmlSource.GetXmlData();
            // Simplified conversion for demonstration
            return xml
                .Replace("<data>", "{ ")
                .Replace("</data>", " }")
                .Replace("<name>", "\"name\": \"")
                .Replace("</name>", "\", ")
                .Replace("<age>", "\"age\": ")
                .Replace("</age>", "");
        }
    }

    public class AnalyticsClient
    {
        public void ProcessJson(IJsonDataSource source)
        {
            Console.WriteLine($"Processing JSON: {source.GetJsonData()}");
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var xmlSource = new XmlDataSource();
            Console.WriteLine($"XML source: {xmlSource.GetXmlData()}");

            var adapter = new XmlToJsonAdapter(xmlSource);
            var client = new AnalyticsClient();
            client.ProcessJson(adapter);
        }
    }
}
