using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Review
{
    public int ReviewId { get; set; }

    public int StoryId { get; set; }

    public bool SpellingError { get; set; }

    public bool LengthError { get; set; }

    public int? ReportTypeId { get; set; }

    public string? ReviewContent { get; set; }

    public virtual ReportType? ReportType { get; set; }

    public virtual Story Story { get; set; } = null!;
}
