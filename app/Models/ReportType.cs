using System;
using System.Collections.Generic;

namespace app.Models;

public partial class ReportType
{
    public int ReportTypeId { get; set; }

    public string ReportTypeContent { get; set; } = null!;

    public virtual ICollection<ReportContent> ReportContents { get; set; } = new List<ReportContent>();
}
