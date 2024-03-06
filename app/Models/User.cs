using System;
using System.Collections.Generic;

namespace app.Models;

public partial class User
{
    public int UserId { get; set; }

    public string? UserFullname { get; set; }

    public bool? Gender { get; set; }

    public DateTime? Dob { get; set; }

    public string Email { get; set; } = null!;

    public string? Phone { get; set; }

    public string? Address { get; set; }

    public string Username { get; set; } = null!;

    public string Password { get; set; } = null!;

    public string? UserImage { get; set; }

    public bool? Status { get; set; }

    public string? DescriptionMarkdown { get; set; }

    public string? DescriptionHtml { get; set; }

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual ICollection<ReportContent> ReportContents { get; set; } = new List<ReportContent>();

    public virtual ICollection<Story> Stories { get; set; } = new List<Story>();

    public virtual ICollection<StoryFollowLike> StoryFollowLikes { get; set; } = new List<StoryFollowLike>();

    public virtual ICollection<StoryRead> StoryReads { get; set; } = new List<StoryRead>();

    public virtual ICollection<Wallet> Wallets { get; set; } = new List<Wallet>();

    public virtual ICollection<Chapter> Chapters { get; set; } = new List<Chapter>();

    public virtual ICollection<Story> StoriesNavigation { get; set; } = new List<Story>();
}
