using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Review
{
    public int ReviewId { get; set; }

    public int UserId { get; set; }

    public int StoryId { get; set; }

    public DateTime ReviewDate { get; set; }

    public bool SpellingError { get; set; }

    public bool LengthError { get; set; }

    public bool PoliticalContentError { get; set; }

    public bool DistortHistoryError { get; set; }

    public bool SecretContentError { get; set; }

    public bool OffensiveContentError { get; set; }

    public bool UnhealthyContentError { get; set; }

    public string? ReviewContent { get; set; }

    public virtual Story Story { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
