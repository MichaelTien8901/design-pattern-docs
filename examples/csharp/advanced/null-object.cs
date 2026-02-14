using System;

namespace DesignPatterns.Advanced.NullObject
{
    // Logger interface
    interface ILogger
    {
        void Log(string message);
        void LogError(string error);
    }

    // Real logger implementation
    class ConsoleLogger : ILogger
    {
        public void Log(string message)
        {
            Console.WriteLine($"[INFO] {message}");
        }

        public void LogError(string error)
        {
            Console.WriteLine($"[ERROR] {error}");
        }
    }

    // Null Object implementation - does nothing silently
    class NullLogger : ILogger
    {
        public void Log(string message)
        {
            // Do nothing - no output
        }

        public void LogError(string error)
        {
            // Do nothing - no output
        }
    }

    // Client class that uses logger
    class UserService
    {
        private readonly ILogger _logger;

        public UserService(ILogger logger)
        {
            _logger = logger;
        }

        public void CreateUser(string username)
        {
            _logger.Log($"Creating user: {username}");

            // Business logic here
            if (string.IsNullOrEmpty(username))
            {
                _logger.LogError("Username cannot be empty");
                return;
            }

            _logger.Log($"User {username} created successfully");
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            Console.WriteLine("=== With ConsoleLogger ===");
            var serviceWithLogging = new UserService(new ConsoleLogger());
            serviceWithLogging.CreateUser("alice");
            serviceWithLogging.CreateUser("");

            Console.WriteLine("\n=== With NullLogger ===");
            var serviceWithoutLogging = new UserService(new NullLogger());
            serviceWithoutLogging.CreateUser("bob");
            serviceWithoutLogging.CreateUser("");

            Console.WriteLine("(No output from NullLogger - operations completed silently)");
        }
    }
}
