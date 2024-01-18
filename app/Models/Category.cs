﻿using System;
using System.Collections.Generic;

namespace app.Models;

public partial class Category
{
    public int CategoryId { get; set; }

    public string? CategoryName { get; set; }

    public virtual ICollection<Story> Stories { get; set; } = new List<Story>();
}