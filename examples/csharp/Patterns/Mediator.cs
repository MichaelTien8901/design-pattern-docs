namespace DesignPatterns.Mediator
{
    public interface IChatMediator
    {
        void SendMessage(string message, User sender);
        void AddUser(User user);
    }

    public class ChatRoom : IChatMediator
    {
        private readonly List<User> _users = new();

        public void AddUser(User user)
        {
            _users.Add(user);
            Console.WriteLine($"  {user.Name} joined the chat");
        }

        public void SendMessage(string message, User sender)
        {
            foreach (var user in _users)
                if (user != sender)
                    user.Receive(message, sender.Name);
        }
    }

    public class User
    {
        public string Name { get; }
        private readonly IChatMediator _chat;

        public User(string name, IChatMediator chat)
        {
            Name = name;
            _chat = chat;
            _chat.AddUser(this);
        }

        public void Send(string message)
        {
            Console.WriteLine($"  {Name} sends: {message}");
            _chat.SendMessage(message, this);
        }

        public void Receive(string message, string from)
        {
            Console.WriteLine($"  {Name} received from {from}: {message}");
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var chat = new ChatRoom();
            var alice = new User("Alice", chat);
            var bob = new User("Bob", chat);
            var charlie = new User("Charlie", chat);

            alice.Send("Hi everyone!");
            bob.Send("Hey Alice!");
        }
    }
}
