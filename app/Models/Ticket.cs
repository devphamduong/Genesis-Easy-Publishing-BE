using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Ticket
{
    public int TicketId { get; set; }

    public int UserId { get; set; }

    public DateTime TicketDate { get; set; }

    public bool? Status { get; set; }

    public bool? Seen { get; set; }

    public virtual User User { get; set; } = null!;
}
