using System;
using System.Collections.Generic;

namespace app.Models;

public partial class RefundRequest
{
    public long RequestId { get; set; }

    public int WalletId { get; set; }

    public decimal Amount { get; set; }

    public DateTime RequestTime { get; set; }

    public DateTime? ResponseTime { get; set; }

    public bool? Status { get; set; }

    public virtual Wallet Wallet { get; set; } = null!;
}
