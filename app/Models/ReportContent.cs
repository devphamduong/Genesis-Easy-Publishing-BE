using System;
using System.Collections.Generic;

namespace app.Models;

public partial class ReportContent
{
    public int ReportId { get; set; }

    public int UserId { get; set; }

    public int ReportTypeId { get; set; }

    public int? StoryId { get; set; }

    public long? ChapterId { get; set; }

    public int? IssueId { get; set; }

    public int? CommentId { get; set; }

    public string ReportContent1 { get; set; } = null!;

    public DateTime ReportDate { get; set; }

    public bool? Status { get; set; }

    public virtual Chapter? Chapter { get; set; }

    public virtual Comment? Comment { get; set; }

    public virtual StoryIssue? Issue { get; set; }

    public virtual ReportType ReportType { get; set; } = null!;

    public virtual Story? Story { get; set; }

    public virtual User User { get; set; } = null!;
}
