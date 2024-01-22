using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Comment
{
    public int CommentId { get; set; }

    public int UserId { get; set; }

    public int? StoryId { get; set; }

    public long? ChapterId { get; set; }

    public int? IssueId { get; set; }

    public string CommentContent { get; set; } = null!;

    public DateTime CommentDate { get; set; }

    public virtual Chapter? Chapter { get; set; }

    public virtual StoryIssue? Issue { get; set; }

    public virtual ICollection<Report> Reports { get; set; } = new List<Report>();

    public virtual Story? Story { get; set; }

    public virtual User User { get; set; } = null!;
}
