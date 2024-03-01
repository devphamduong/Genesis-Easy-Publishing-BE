using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Transaction
{
    public long TransactionId { get; set; }

    public int WalletId { get; set; }

    public decimal Amount { get; set; }

    public decimal FundBefore { get; set; }

    public decimal FundAfter { get; set; }

    public decimal RefundBefore { get; set; }

    public decimal RefundAfter { get; set; }

    public DateTime TransactionTime { get; set; }

    /// <summary>
    /// 0 mean Fail, 1 mean Pending, 2 mean Successful
    /// </summary>
    public bool? Status { get; set; }

    public string? Description { get; set; }

    public virtual Wallet Wallet { get; set; } = null!;
}
