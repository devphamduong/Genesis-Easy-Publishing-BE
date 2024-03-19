using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Transaction
{
    public long TransactionId { get; set; }

    public int WalletId { get; set; }

    public int? StoryId { get; set; }

    public long? ChapterId { get; set; }

    public decimal Amount { get; set; }

    public decimal FundBefore { get; set; }

    public decimal FundAfter { get; set; }

    public decimal RefundBefore { get; set; }

    public decimal RefundAfter { get; set; }

    public DateTime TransactionTime { get; set; }

    public bool? Status { get; set; }

    public string? Description { get; set; }

    public virtual Chapter? Chapter { get; set; }

    public virtual Story? Story { get; set; }

    public virtual Wallet Wallet { get; set; } = null!;
}
