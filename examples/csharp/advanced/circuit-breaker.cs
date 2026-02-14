using System;
using System.Threading;

namespace DesignPatterns.Advanced.CircuitBreaker
{
    // Circuit breaker implementation with three states
    public class CircuitBreaker
    {
        private enum State { Closed, Open, HalfOpen }

        private State _state = State.Closed;
        private int _failureCount = 0;
        private readonly int _failureThreshold;
        private readonly TimeSpan _timeout;
        private DateTime _lastFailureTime;

        public CircuitBreaker(int failureThreshold = 3, int timeoutSeconds = 5)
        {
            _failureThreshold = failureThreshold;
            _timeout = TimeSpan.FromSeconds(timeoutSeconds);
        }

        public T Execute<T>(Func<T> operation)
        {
            if (_state == State.Open)
            {
                if (DateTime.Now - _lastFailureTime >= _timeout)
                {
                    _state = State.HalfOpen;
                    Console.WriteLine("Circuit Half-Open - testing recovery");
                }
                else
                {
                    throw new InvalidOperationException("Circuit is OPEN - fast failing");
                }
            }

            try
            {
                T result = operation();
                RecordSuccess();
                return result;
            }
            catch (Exception ex)
            {
                RecordFailure();
                throw new Exception($"Operation failed: {ex.Message}", ex);
            }
        }

        private void RecordSuccess()
        {
            _failureCount = 0;
            _state = State.Closed;
            Console.WriteLine("Success - Circuit Closed");
        }

        private void RecordFailure()
        {
            _failureCount++;
            _lastFailureTime = DateTime.Now;

            if (_failureCount >= _failureThreshold)
            {
                _state = State.Open;
                Console.WriteLine($"Threshold reached ({_failureCount}) - Circuit OPEN");
            }
        }
    }

    // Simulated unreliable service
    class UnreliableService
    {
        private int _callCount = 0;

        public string Call()
        {
            _callCount++;
            if (_callCount <= 3 || _callCount == 10)
                throw new Exception("Service unavailable");
            return "Service response OK";
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var breaker = new CircuitBreaker(failureThreshold: 3, timeoutSeconds: 2);
            var service = new UnreliableService();

            for (int i = 1; i <= 12; i++)
            {
                try
                {
                    Console.Write($"Call {i}: ");
                    var result = breaker.Execute(() => service.Call());
                    Console.WriteLine(result);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Failed - {ex.Message}");
                }

                if (i == 6) Thread.Sleep(2100); // Wait for timeout to expire
            }
        }
    }
}
