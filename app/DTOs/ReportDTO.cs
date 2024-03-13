namespace app.DTOs
{
    public class ReportDTO
    {
        public int ReportTypeId { get; set; }

        public int? StoryId { get; set; }

        public long? ChapterId { get; set; }

        public int? CommentId { get; set; }

        public string ReportContent { get; set; } = null!;

    }
}
