using System;
using System.Collections.Generic;
using System.Linq;

// Generic repository interface
public interface IRepository<T> where T : class
{
    T GetById(int id);
    IEnumerable<T> GetAll();
    void Add(T entity);
    void Update(T entity);
    void Delete(int id);
}

// Entity class
public class User
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }

    public override string ToString() => $"User {Id}: {Name} ({Email})";
}

// In-memory repository implementation
public class InMemoryRepository<T> : IRepository<T> where T : class
{
    private readonly Dictionary<int, T> _data = new();
    private readonly Func<T, int> _getIdFunc;
    private readonly Action<T, int> _setIdFunc;
    private int _nextId = 1;

    public InMemoryRepository(Func<T, int> getIdFunc, Action<T, int> setIdFunc)
    {
        _getIdFunc = getIdFunc;
        _setIdFunc = setIdFunc;
    }

    public T GetById(int id)
    {
        return _data.TryGetValue(id, out var entity) ? entity : null;
    }

    public IEnumerable<T> GetAll()
    {
        return _data.Values.ToList();
    }

    public void Add(T entity)
    {
        _setIdFunc(entity, _nextId);
        _data[_nextId] = entity;
        _nextId++;
    }

    public void Update(T entity)
    {
        int id = _getIdFunc(entity);
        if (!_data.ContainsKey(id))
            throw new InvalidOperationException($"Entity with ID {id} not found");
        _data[id] = entity;
    }

    public void Delete(int id)
    {
        if (!_data.Remove(id))
            throw new InvalidOperationException($"Entity with ID {id} not found");
    }
}

class Program
{
    static void Main()
    {
        // Create repository
        var userRepo = new InMemoryRepository<User>(
            u => u.Id,
            (u, id) => u.Id = id
        );

        // Create (Add)
        userRepo.Add(new User { Name = "Alice", Email = "alice@example.com" });
        userRepo.Add(new User { Name = "Bob", Email = "bob@example.com" });
        userRepo.Add(new User { Name = "Charlie", Email = "charlie@example.com" });

        // Read (GetAll)
        Console.WriteLine("All users:");
        foreach (var user in userRepo.GetAll())
            Console.WriteLine($"  {user}");

        // Read (GetById)
        var user2 = userRepo.GetById(2);
        Console.WriteLine($"\nUser with ID 2: {user2}");

        // Update
        user2.Email = "bob.updated@example.com";
        userRepo.Update(user2);
        Console.WriteLine($"Updated: {userRepo.GetById(2)}");

        // Delete
        userRepo.Delete(1);
        Console.WriteLine($"\nAfter deleting user 1, total users: {userRepo.GetAll().Count()}");
    }
}
