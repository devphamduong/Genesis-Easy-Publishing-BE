using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Story
{
    public int StoryId { get; set; }

    public string StoryTitle { get; set; } = null!;

    public int AuthorId { get; set; }

    public decimal StoryPrice { get; set; }

    public decimal? StorySale { get; set; }

    public string? StoryImage { get; set; }

    public string? StoryDescription { get; set; }

    public string? StoryDescriptionMarkdown { get; set; }

    public string? StoryDescriptionHtml { get; set; }

    public DateTime CreateTime { get; set; }

    public DateTime? UpdateTime { get; set; }

    public int Status { get; set; }

    public virtual User Author { get; set; } = null!;

    public virtual ICollection<Chapter> Chapters { get; set; } = new List<Chapter>();

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual ICollection<ReportContent> ReportContents { get; set; } = new List<ReportContent>();

    public virtual ICollection<StoryFollowLike> StoryFollowLikes { get; set; } = new List<StoryFollowLike>();

    public virtual StoryInteraction? StoryInteraction { get; set; }

    public virtual ICollection<StoryRead> StoryReads { get; set; } = new List<StoryRead>();

    public virtual ICollection<Volume> Volumes { get; set; } = new List<Volume>();

    public virtual ICollection<Category> Categories { get; set; } = new List<Category>();

    public virtual ICollection<User> Users { get; set; } = new List<User>();

    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
}
