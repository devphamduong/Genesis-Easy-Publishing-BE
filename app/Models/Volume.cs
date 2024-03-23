using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Volume
{
    public int VolumeId { get; set; }

    public int VolumeNumber { get; set; }
    public int StoryId { get; set; }

    public string VolumeTitle { get; set; } = null!;
    public DateTime CreateTime { get; set; }
    public DateTime? UpdateTime { get; set; }

    public virtual ICollection<Chapter> Chapters { get; set; } = new List<Chapter>();

    public virtual Story Story { get; set; } = null!;
}
