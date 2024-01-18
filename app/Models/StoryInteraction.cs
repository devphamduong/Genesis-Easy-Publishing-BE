using System;
using System.Collections.Generic;

namespace app.Models;

public partial class StoryInteraction
{
    public int StoryId { get; set; }

    public int Like { get; set; }

    public int Follow { get; set; }

    public int View { get; set; }

    public int Read { get; set; }

    public virtual Story Story { get; set; } = null!;
}
