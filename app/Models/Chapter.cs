using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Chapter
{
    public long ChapterId { get; set; }

    public int StoryId { get; set; }

    public int VolumeId { get; set; }

    public string ChapterTitle { get; set; } = null!;

    public string ChapterContent { get; set; } = null!;

    public decimal? ChapterPrice { get; set; }

    public bool? Status { get; set; }

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual ICollection<Report> Reports { get; set; } = new List<Report>();

    public virtual Story Story { get; set; } = null!;

    public virtual Volume Volume { get; set; } = null!;

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
