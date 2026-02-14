using System;
using System.Collections.Generic;

namespace DesignPatterns.Advanced.DependencyInjection
{
    // Service interface and implementations
    interface IMessageService
    {
        void SendMessage(string message);
    }

    class EmailService : IMessageService
    {
        public void SendMessage(string message)
        {
            Console.WriteLine($"Email sent: {message}");
        }
    }

    class SmsService : IMessageService
    {
        public void SendMessage(string message)
        {
            Console.WriteLine($"SMS sent: {message}");
        }
    }

    // Client that depends on IMessageService
    class NotificationController
    {
        private readonly IMessageService _messageService;

        public NotificationController(IMessageService messageService)
        {
            _messageService = messageService;
        }

        public void NotifyUser(string message)
        {
            Console.WriteLine("Processing notification...");
            _messageService.SendMessage(message);
        }
    }

    // Simple DI Container
    class SimpleContainer
    {
        private readonly Dictionary<Type, Type> _registrations = new();

        public void Register<TInterface, TImplementation>() where TImplementation : TInterface
        {
            _registrations[typeof(TInterface)] = typeof(TImplementation);
        }

        public T Resolve<T>()
        {
            return (T)Resolve(typeof(T));
        }

        private object Resolve(Type type)
        {
            if (_registrations.TryGetValue(type, out Type implementationType))
            {
                type = implementationType;
            }

            var constructor = type.GetConstructors()[0];
            var parameters = constructor.GetParameters();
            var parameterInstances = new object[parameters.Length];

            for (int i = 0; i < parameters.Length; i++)
            {
                parameterInstances[i] = Resolve(parameters[i].ParameterType);
            }

            return Activator.CreateInstance(type, parameterInstances);
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var container = new SimpleContainer();

            // Register dependencies
            container.Register<IMessageService, EmailService>();

            // Resolve controller with injected dependency
            var controller = container.Resolve<NotificationController>();
            controller.NotifyUser("Welcome to Dependency Injection!");

            // Re-configure with different implementation
            container = new SimpleContainer();
            container.Register<IMessageService, SmsService>();

            var smsController = container.Resolve<NotificationController>();
            smsController.NotifyUser("DI makes testing easy!");
        }
    }
}
