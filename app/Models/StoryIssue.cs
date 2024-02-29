using System;
using System.Collections.Generic;

namespace app.Models;

public partial class StoryIssue
{
    public int IssueId { get; set; }

    public int UserId { get; set; }

    public int? StoryId { get; set; }

    public string IssueTitle { get; set; } = null!;

    public string IssueContent { get; set; } = null!;

    public DateTime IssueDate { get; set; }

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual ICollection<ReportContent> ReportContents { get; set; } = new List<ReportContent>();

    public virtual Story? Story { get; set; }

    public virtual User User { get; set; } = null!;
}
