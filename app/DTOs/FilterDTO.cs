using app.Models;

namespace app.DTOs
{
    public partial class FilterDTO
    {

        public string? StoryTitle { get; set; } = null!;

        public Purchase? Purchase { get; set; } = null!;
        public bool? OrderPriceAscend { get; set; }
        public virtual ICollection<int>? Categories { get; set; } = new List<int>();

        public int? page { get; set; } = 0;
    }

    public class Purchase
    {
        public decimal? UpLimit { get; set; }
        public decimal? DownLimit { get; set; }
    }
}
