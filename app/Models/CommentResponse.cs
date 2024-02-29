using System;
using System.Collections.Generic;

namespace app.Models;

public partial class CommentResponse
{
    public int CommentResponseId { get; set; }

    public int UserId { get; set; }

    public int? CommentId { get; set; }

    public string CommentContent { get; set; } = null!;

    public DateTime CommentDate { get; set; }

    public virtual Comment? Comment { get; set; }

    public virtual User User { get; set; } = null!;
}
