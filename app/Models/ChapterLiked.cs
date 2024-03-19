using System;
using System.Collections.Generic;

namespace app.Models;

public partial class ChapterLiked
{
    public int UserId { get; set; }

    public long ChapterId { get; set; }

    public bool? Status { get; set; }

    public virtual Chapter Chapter { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
