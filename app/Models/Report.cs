using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Report
{
    public int ReportId { get; set; }

    public int UserId { get; set; }

    public int? StoryId { get; set; }

    public long? ChapterId { get; set; }

    public int? IssueId { get; set; }

    public long? TransactionId { get; set; }

    public int? CommentId { get; set; }

    public string ReportTitle { get; set; } = null!;

    public string ReportContent { get; set; } = null!;

    public DateTime ReportDate { get; set; }

    public bool? Status { get; set; }

    public virtual Chapter? Chapter { get; set; }

    public virtual Comment? Comment { get; set; }

    public virtual StoryIssue? Issue { get; set; }

    public virtual Story? Story { get; set; }

    public virtual Transaction? Transaction { get; set; }

    public virtual User User { get; set; } = null!;
}
