using System;
using System.Collections.Concurrent;
using System.Threading;

// Expensive resource to be pooled
class DatabaseConnection
{
    public int Id { get; }
    private static int _nextId = 1;

    public DatabaseConnection()
    {
        Id = _nextId++;
        Console.WriteLine($"  [Created new connection #{Id}]");
        Thread.Sleep(100); // Simulate expensive initialization
    }

    public void ExecuteQuery(string query)
    {
        Console.WriteLine($"  Connection #{Id} executing: {query}");
    }

    public void Reset()
    {
        Console.WriteLine($"  Connection #{Id} reset");
    }
}

// Object Pool implementation
class ObjectPool<T> where T : new()
{
    private readonly ConcurrentBag<T> _available = new();
    private int _totalCount = 0;
    private readonly int _maxSize;

    public ObjectPool(int maxSize)
    {
        _maxSize = maxSize;
    }

    public T Acquire()
    {
        if (_available.TryTake(out T item))
        {
            Console.WriteLine($"Reusing object from pool");
            return item;
        }

        if (_totalCount < _maxSize)
        {
            Interlocked.Increment(ref _totalCount);
            Console.WriteLine($"Creating new object (pool size: {_totalCount}/{_maxSize})");
            return new T();
        }

        throw new InvalidOperationException("Pool exhausted!");
    }

    public void Release(T item)
    {
        if (item is DatabaseConnection conn)
        {
            conn.Reset();
        }
        _available.Add(item);
        Console.WriteLine($"Released object back to pool (available: {_available.Count})");
    }

    public void PrintStats()
    {
        Console.WriteLine($"Pool stats - Total: {_totalCount}, Available: {_available.Count}, In use: {_totalCount - _available.Count}");
    }
}

class Program
{
    static void Main()
    {
        var pool = new ObjectPool<DatabaseConnection>(maxSize: 3);

        Console.WriteLine("=== Acquiring connections ===");
        var conn1 = pool.Acquire();
        conn1.ExecuteQuery("SELECT * FROM users");

        var conn2 = pool.Acquire();
        conn2.ExecuteQuery("INSERT INTO logs...");

        Console.WriteLine("\n=== Releasing and reusing ===");
        pool.Release(conn1);
        pool.PrintStats();

        var conn3 = pool.Acquire(); // Should reuse conn1
        conn3.ExecuteQuery("UPDATE products...");

        pool.Release(conn2);
        pool.Release(conn3);

        Console.WriteLine("\n=== Final stats ===");
        pool.PrintStats();
    }
}
