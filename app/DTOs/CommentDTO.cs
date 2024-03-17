namespace app.DTOs
{
    public class CommentDTO
    {
        public int? StoryId { get; set; }

        public long? ChapterId { get; set; }

        public string CommentContent { get; set; } = null!;

    }
}
