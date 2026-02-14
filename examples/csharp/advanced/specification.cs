using System;
using System.Collections.Generic;
using System.Linq;

// Specification interface
public interface ISpecification<T>
{
    bool IsSatisfiedBy(T candidate);
    ISpecification<T> And(ISpecification<T> other);
    ISpecification<T> Or(ISpecification<T> other);
    ISpecification<T> Not();
}

// Base specification with composition methods
public abstract class Specification<T> : ISpecification<T>
{
    public abstract bool IsSatisfiedBy(T candidate);

    public ISpecification<T> And(ISpecification<T> other) => new AndSpecification<T>(this, other);
    public ISpecification<T> Or(ISpecification<T> other) => new OrSpecification<T>(this, other);
    public ISpecification<T> Not() => new NotSpecification<T>(this);
}

// Composite specifications
public class AndSpecification<T> : Specification<T>
{
    private readonly ISpecification<T> _left, _right;
    public AndSpecification(ISpecification<T> left, ISpecification<T> right)
    { _left = left; _right = right; }
    public override bool IsSatisfiedBy(T candidate) =>
        _left.IsSatisfiedBy(candidate) && _right.IsSatisfiedBy(candidate);
}

public class OrSpecification<T> : Specification<T>
{
    private readonly ISpecification<T> _left, _right;
    public OrSpecification(ISpecification<T> left, ISpecification<T> right)
    { _left = left; _right = right; }
    public override bool IsSatisfiedBy(T candidate) =>
        _left.IsSatisfiedBy(candidate) || _right.IsSatisfiedBy(candidate);
}

public class NotSpecification<T> : Specification<T>
{
    private readonly ISpecification<T> _spec;
    public NotSpecification(ISpecification<T> spec) { _spec = spec; }
    public override bool IsSatisfiedBy(T candidate) => !_spec.IsSatisfiedBy(candidate);
}

// Domain entity
public class Customer
{
    public string Name { get; set; }
    public int Age { get; set; }
    public string Country { get; set; }
    public override string ToString() => $"{Name}, {Age}, {Country}";
}

// Concrete specifications
public class AgeSpecification : Specification<Customer>
{
    private readonly int _minAge;
    public AgeSpecification(int minAge) { _minAge = minAge; }
    public override bool IsSatisfiedBy(Customer customer) => customer.Age >= _minAge;
}

public class CountrySpecification : Specification<Customer>
{
    private readonly string _country;
    public CountrySpecification(string country) { _country = country; }
    public override bool IsSatisfiedBy(Customer customer) => customer.Country == _country;
}

class Program
{
    static void Main()
    {
        var customers = new List<Customer>
        {
            new Customer { Name = "Alice", Age = 25, Country = "USA" },
            new Customer { Name = "Bob", Age = 17, Country = "USA" },
            new Customer { Name = "Charlie", Age = 30, Country = "UK" },
            new Customer { Name = "Diana", Age = 22, Country = "Canada" }
        };

        // Combine specs: (Age >= 18) AND (Country == "USA")
        var adultUSA = new AgeSpecification(18).And(new CountrySpecification("USA"));
        Console.WriteLine("Adult USA customers:");
        foreach (var c in customers.Where(c => adultUSA.IsSatisfiedBy(c)))
            Console.WriteLine($"  {c}");

        // (Age >= 25) OR (Country == "UK")
        var seniorOrUK = new AgeSpecification(25).Or(new CountrySpecification("UK"));
        Console.WriteLine("\nSenior or UK customers:");
        foreach (var c in customers.Where(c => seniorOrUK.IsSatisfiedBy(c)))
            Console.WriteLine($"  {c}");

        // NOT (Country == "USA")
        var notUSA = new CountrySpecification("USA").Not();
        Console.WriteLine("\nNon-USA customers:");
        foreach (var c in customers.Where(c => notUSA.IsSatisfiedBy(c)))
            Console.WriteLine($"  {c}");
    }
}
