using System;
using System.Collections.Generic;

namespace app.Models;

public partial class StoryRead
{
    public int UserId { get; set; }

    public int StoryId { get; set; }

    public long ChapterId { get; set; }

    public DateTime ReadTime { get; set; }

    public virtual Chapter Chapter { get; set; } = null!;

    public virtual Story Story { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
