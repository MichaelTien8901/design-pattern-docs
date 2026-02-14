namespace DesignPatterns.ChainOfResponsibility
{
    public enum Priority { Low, Medium, High, Critical }

    public class SupportTicket
    {
        public string Issue { get; }
        public Priority Priority { get; }
        public SupportTicket(string issue, Priority priority) { Issue = issue; Priority = priority; }
    }

    public abstract class SupportHandler
    {
        private SupportHandler? _next;

        public SupportHandler SetNext(SupportHandler next)
        {
            _next = next;
            return next;
        }

        public virtual void Handle(SupportTicket ticket)
        {
            if (_next != null) _next.Handle(ticket);
            else Console.WriteLine($"  No handler for: {ticket.Issue}");
        }
    }

    public class FrontDesk : SupportHandler
    {
        public override void Handle(SupportTicket ticket)
        {
            if (ticket.Priority == Priority.Low)
                Console.WriteLine($"  FrontDesk handled: {ticket.Issue}");
            else
                base.Handle(ticket);
        }
    }

    public class TechSupport : SupportHandler
    {
        public override void Handle(SupportTicket ticket)
        {
            if (ticket.Priority == Priority.Medium)
                Console.WriteLine($"  TechSupport handled: {ticket.Issue}");
            else
                base.Handle(ticket);
        }
    }

    public class Engineering : SupportHandler
    {
        public override void Handle(SupportTicket ticket)
        {
            if (ticket.Priority >= Priority.High)
                Console.WriteLine($"  Engineering handled: {ticket.Issue}");
            else
                base.Handle(ticket);
        }
    }

    public static class Demo
    {
        public static void Run()
        {
            var front = new FrontDesk();
            front.SetNext(new TechSupport()).SetNext(new Engineering());

            var tickets = new[]
            {
                new SupportTicket("Password reset", Priority.Low),
                new SupportTicket("Email not syncing", Priority.Medium),
                new SupportTicket("Server crash", Priority.High),
                new SupportTicket("Data breach", Priority.Critical),
            };

            foreach (var t in tickets)
                front.Handle(t);
        }
    }
}
