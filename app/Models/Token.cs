using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Token
{
    public string Token1 { get; set; } = null!;

    public int UserId { get; set; }

    public string RefreshToken { get; set; } = null!;

    public DateTime ExpiredDate { get; set; }

    public virtual User User { get; set; } = null!;
}
