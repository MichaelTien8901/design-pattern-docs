using System;
using System.Collections.Generic;

// Message broker for pub-sub
public class MessageBroker
{
    private readonly Dictionary<string, List<Action<string>>> _subscriptions = new();

    public void Subscribe(string topic, Action<string> handler)
    {
        if (!_subscriptions.ContainsKey(topic))
            _subscriptions[topic] = new List<Action<string>>();

        _subscriptions[topic].Add(handler);
        Console.WriteLine($"[Broker] Subscribed to topic '{topic}'");
    }

    public void Unsubscribe(string topic, Action<string> handler)
    {
        if (_subscriptions.ContainsKey(topic))
            _subscriptions[topic].Remove(handler);
    }

    public void Publish(string topic, string message)
    {
        Console.WriteLine($"\n[Broker] Publishing to '{topic}': {message}");

        if (!_subscriptions.ContainsKey(topic))
        {
            Console.WriteLine($"[Broker] No subscribers for topic '{topic}'");
            return;
        }

        foreach (var handler in _subscriptions[topic])
        {
            handler(message);
        }
    }
}

// Subscriber implementations
class EmailService
{
    public void OnOrderPlaced(string message)
    {
        Console.WriteLine($"  [EmailService] Sending confirmation email for: {message}");
    }
}

class InventoryService
{
    public void OnOrderPlaced(string message)
    {
        Console.WriteLine($"  [InventoryService] Updating stock for: {message}");
    }
}

class AnalyticsService
{
    public void OnOrderPlaced(string message)
    {
        Console.WriteLine($"  [AnalyticsService] Recording metrics for: {message}");
    }

    public void OnUserRegistered(string message)
    {
        Console.WriteLine($"  [AnalyticsService] Tracking new user: {message}");
    }
}

class Program
{
    static void Main()
    {
        var broker = new MessageBroker();

        // Create subscribers
        var emailService = new EmailService();
        var inventoryService = new InventoryService();
        var analyticsService = new AnalyticsService();

        // Subscribe to topics
        broker.Subscribe("order.placed", emailService.OnOrderPlaced);
        broker.Subscribe("order.placed", inventoryService.OnOrderPlaced);
        broker.Subscribe("order.placed", analyticsService.OnOrderPlaced);
        broker.Subscribe("user.registered", analyticsService.OnUserRegistered);

        // Publishers send messages without knowing subscribers
        Console.WriteLine("\n--- Publishing Events ---");
        broker.Publish("order.placed", "Order #1234 - Widget x5");
        broker.Publish("order.placed", "Order #1235 - Gadget x2");
        broker.Publish("user.registered", "User: alice@example.com");
        broker.Publish("product.viewed", "Product: Widget Pro");
    }
}
