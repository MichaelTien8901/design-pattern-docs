using System;
using System.Threading.Tasks;
using System.Linq;

class Program
{
    // Simulate async service calls
    static async Task<string> FetchUserData(int userId)
    {
        await Task.Delay(500); // Simulate network delay
        return $"User{userId}Data";
    }

    static async Task<string> FetchUserOrders(int userId)
    {
        await Task.Delay(300);
        return $"User{userId}Orders";
    }

    static async Task<string> FetchUserPreferences(int userId)
    {
        await Task.Delay(400);
        return $"User{userId}Preferences";
    }

    static async Task Main()
    {
        Console.WriteLine("=== Basic async/await (sequential) ===");
        var userData = await FetchUserData(1);
        Console.WriteLine($"Received: {userData}");

        Console.WriteLine("\n=== Chaining with ContinueWith ===");
        var task = FetchUserData(2)
            .ContinueWith(t =>
            {
                Console.WriteLine($"Processing: {t.Result}");
                return t.Result.ToUpper();
            })
            .ContinueWith(t =>
            {
                Console.WriteLine($"Final result: {t.Result}");
                return t.Result;
            });
        await task;

        Console.WriteLine("\n=== Parallel execution with Task.WhenAll ===");
        var startTime = DateTime.Now;

        var task1 = FetchUserData(3);
        var task2 = FetchUserOrders(3);
        var task3 = FetchUserPreferences(3);

        // Wait for all tasks to complete concurrently
        var results = await Task.WhenAll(task1, task2, task3);

        var elapsed = (DateTime.Now - startTime).TotalMilliseconds;
        Console.WriteLine($"Fetched all data in {elapsed:F0}ms (parallel):");
        foreach (var result in results)
        {
            Console.WriteLine($"  - {result}");
        }

        Console.WriteLine("\n=== Error handling with try/catch ===");
        try
        {
            await Task.Run(async () =>
            {
                await Task.Delay(100);
                throw new InvalidOperationException("Service unavailable");
            });
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Caught error: {ex.Message}");
        }

        Console.WriteLine("\n=== Combining and transforming ===");
        var combinedResult = await FetchUserData(4)
            .ContinueWith(async t1 =>
            {
                var orders = await FetchUserOrders(4);
                return $"{t1.Result} + {orders}";
            })
            .Unwrap();

        Console.WriteLine($"Combined: {combinedResult}");
    }
}
