using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace app.Models;

public partial class EasyPublishingContext : DbContext
{
    public EasyPublishingContext()
    {
    }

    public EasyPublishingContext(DbContextOptions<EasyPublishingContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Category> Categories { get; set; }

    public virtual DbSet<Chapter> Chapters { get; set; }

    public virtual DbSet<ChapterLiked> ChapterLikeds { get; set; }

    public virtual DbSet<Comment> Comments { get; set; }

    public virtual DbSet<RefundRequest> RefundRequests { get; set; }

    public virtual DbSet<ReportContent> ReportContents { get; set; }

    public virtual DbSet<ReportType> ReportTypes { get; set; }

    public virtual DbSet<Review> Reviews { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Story> Stories { get; set; }

    public virtual DbSet<StoryFollowLike> StoryFollowLikes { get; set; }

    public virtual DbSet<StoryInteraction> StoryInteractions { get; set; }

    public virtual DbSet<StoryRead> StoryReads { get; set; }

    public virtual DbSet<Ticket> Tickets { get; set; }

    public virtual DbSet<Transaction> Transactions { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<Volume> Volumes { get; set; }

    public virtual DbSet<Wallet> Wallets { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            var conf = new ConfigurationBuilder()
              .SetBasePath(Directory.GetCurrentDirectory())
              .AddJsonFile("appsettings.json").Build();
            optionsBuilder.UseSqlServer(conf.GetConnectionString("MyCnn"));
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Category>(entity =>
        {
            entity.HasKey(e => e.CategoryId).HasName("PK_category");

            entity.ToTable("Category");

            entity.Property(e => e.CategoryId).HasColumnName("category_id");
            entity.Property(e => e.CategoryBanner)
                .HasMaxLength(3000)
                .HasColumnName("category_banner");
            entity.Property(e => e.CategoryDescription)
                .HasMaxLength(500)
                .HasColumnName("category_description");
            entity.Property(e => e.CategoryName)
                .HasMaxLength(100)
                .HasColumnName("category_name");

            entity.HasMany(d => d.Stories).WithMany(p => p.Categories)
                .UsingEntity<Dictionary<string, object>>(
                    "StoryCategory",
                    r => r.HasOne<Story>().WithMany()
                        .HasForeignKey("StoryId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Story_Cat__story__5AEE82B9"),
                    l => l.HasOne<Category>().WithMany()
                        .HasForeignKey("CategoryId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Story_Cat__categ__5BE2A6F2"),
                    j =>
                    {
                        j.HasKey("CategoryId", "StoryId").HasName("PK_story_category");
                        j.ToTable("Story_Category");
                        j.IndexerProperty<int>("CategoryId").HasColumnName("category_id");
                        j.IndexerProperty<int>("StoryId").HasColumnName("story_id");
                    });
        });

        modelBuilder.Entity<Chapter>(entity =>
        {
            entity.HasKey(e => e.ChapterId).HasName("PK_chapter");

            entity.ToTable("Chapter");

            entity.Property(e => e.ChapterId).HasColumnName("chapter_id");
            entity.Property(e => e.ChapterContentHtml)
                .HasColumnType("ntext")
                .HasColumnName("chapter_content_html");
            entity.Property(e => e.ChapterContentMarkdown)
                .HasColumnType("ntext")
                .HasColumnName("chapter_content_markdown");
            entity.Property(e => e.ChapterNumber).HasColumnName("chapter_number");
            entity.Property(e => e.ChapterPrice)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("chapter_price");
            entity.Property(e => e.ChapterTitle)
                .HasMaxLength(100)
                .HasColumnName("chapter_title");
            entity.Property(e => e.CreateTime)
                .HasColumnType("datetime")
                .HasColumnName("create_time");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.UpdateTime)
                .HasColumnType("datetime")
                .HasColumnName("update_time");
            entity.Property(e => e.VolumeId).HasColumnName("volume_id");

            entity.HasOne(d => d.Story).WithMany(p => p.Chapters)
                .HasForeignKey(d => d.StoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Chapter__story_i__5DCAEF64");

            entity.HasOne(d => d.Volume).WithMany(p => p.Chapters)
                .HasForeignKey(d => d.VolumeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Chapter__volume___5EBF139D");
        });

        modelBuilder.Entity<ChapterLiked>(entity =>
        {
            entity.HasKey(e => new { e.UserId, e.ChapterId }).HasName("PK_chapter_liked");

            entity.ToTable("Chapter_Liked");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.ChapterId).HasColumnName("chapter_id");
            entity.Property(e => e.Status).HasColumnName("status");

            entity.HasOne(d => d.Chapter).WithMany(p => p.ChapterLikeds)
                .HasForeignKey(d => d.ChapterId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Chapter_L__chapt__628FA481");

            entity.HasOne(d => d.User).WithMany(p => p.ChapterLikeds)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Chapter_L__user___619B8048");
        });

        modelBuilder.Entity<Comment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK_comment");

            entity.ToTable("Comment");

            entity.Property(e => e.CommentId).HasColumnName("comment_id");
            entity.Property(e => e.ChapterId).HasColumnName("chapter_id");
            entity.Property(e => e.CommentContent)
                .HasMaxLength(2000)
                .HasColumnName("comment_content");
            entity.Property(e => e.CommentDate)
                .HasColumnType("datetime")
                .HasColumnName("comment_date");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Chapter).WithMany(p => p.Comments)
                .HasForeignKey(d => d.ChapterId)
                .HasConstraintName("FK__Comment__chapter__656C112C");

            entity.HasOne(d => d.Story).WithMany(p => p.Comments)
                .HasForeignKey(d => d.StoryId)
                .HasConstraintName("FK__Comment__story_i__6477ECF3");

            entity.HasOne(d => d.User).WithMany(p => p.Comments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Comment__user_id__6383C8BA");
        });

        modelBuilder.Entity<RefundRequest>(entity =>
        {
            entity.HasKey(e => e.RequestId).HasName("PK_refund");

            entity.ToTable("Refund_Request");

            entity.Property(e => e.RequestId).HasColumnName("request_id");
            entity.Property(e => e.Amount)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("amount");
            entity.Property(e => e.RequestTime)
                .HasColumnType("datetime")
                .HasColumnName("request_time");
            entity.Property(e => e.ResponseTime)
                .HasColumnType("datetime")
                .HasColumnName("response_time");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.WalletId).HasColumnName("wallet_id");

            entity.HasOne(d => d.Wallet).WithMany(p => p.RefundRequests)
                .HasForeignKey(d => d.WalletId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Refund_Re__walle__4D94879B");
        });

        modelBuilder.Entity<ReportContent>(entity =>
        {
            entity.HasKey(e => e.ReportId).HasName("PK_reportcontent");

            entity.ToTable("ReportContent");

            entity.Property(e => e.ReportId).HasColumnName("report_id");
            entity.Property(e => e.ChapterId).HasColumnName("chapter_id");
            entity.Property(e => e.CommentId).HasColumnName("comment_id");
            entity.Property(e => e.ReportContent1)
                .HasMaxLength(2000)
                .HasColumnName("report_content");
            entity.Property(e => e.ReportDate)
                .HasColumnType("date")
                .HasColumnName("report_date");
            entity.Property(e => e.ReportTypeId).HasColumnName("report_type_id");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Chapter).WithMany(p => p.ReportContents)
                .HasForeignKey(d => d.ChapterId)
                .HasConstraintName("FK__ReportCon__chapt__693CA210");

            entity.HasOne(d => d.Comment).WithMany(p => p.ReportContents)
                .HasForeignKey(d => d.CommentId)
                .HasConstraintName("FK__ReportCon__comme__6A30C649");

            entity.HasOne(d => d.ReportType).WithMany(p => p.ReportContents)
                .HasForeignKey(d => d.ReportTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ReportCon__repor__6754599E");

            entity.HasOne(d => d.Story).WithMany(p => p.ReportContents)
                .HasForeignKey(d => d.StoryId)
                .HasConstraintName("FK__ReportCon__story__68487DD7");

            entity.HasOne(d => d.User).WithMany(p => p.ReportContents)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ReportCon__user___66603565");
        });

        modelBuilder.Entity<ReportType>(entity =>
        {
            entity.HasKey(e => e.ReportTypeId).HasName("PK_reporttype");

            entity.ToTable("ReportType");

            entity.Property(e => e.ReportTypeId).HasColumnName("report_type_id");
            entity.Property(e => e.ReportTypeContent)
                .HasMaxLength(100)
                .HasColumnName("report_type_content");
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.HasKey(e => e.ReviewId).HasName("PK_review");

            entity.ToTable("Review");

            entity.Property(e => e.ReviewId).HasColumnName("review_id");
            entity.Property(e => e.ChapterId).HasColumnName("chapter_id");
            entity.Property(e => e.DistortHistoryError).HasColumnName("distort history_error");
            entity.Property(e => e.LengthError).HasColumnName("length_error");
            entity.Property(e => e.OffensiveContentError).HasColumnName("offensive_content_error");
            entity.Property(e => e.PoliticalContentError).HasColumnName("political_content_error");
            entity.Property(e => e.ReviewContent)
                .HasMaxLength(2000)
                .HasColumnName("review_content");
            entity.Property(e => e.ReviewDate)
                .HasColumnType("datetime")
                .HasColumnName("review_date");
            entity.Property(e => e.SecretContentError).HasColumnName("secret_content_error");
            entity.Property(e => e.SpellingError).HasColumnName("spelling_error");
            entity.Property(e => e.UnhealthyContentError).HasColumnName("unhealthy_content_error");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Chapter).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.ChapterId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Review__chapter___6D0D32F4");

            entity.HasOne(d => d.User).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Review__user_id__6C190EBB");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Role__760965CC379A69D3");

            entity.ToTable("Role");

            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.RoleName)
                .HasMaxLength(50)
                .HasColumnName("role_name");
        });

        modelBuilder.Entity<Story>(entity =>
        {
            entity.HasKey(e => e.StoryId).HasName("PK_story");

            entity.ToTable("Story", tb => tb.HasTrigger("trg_InsertStoryInteraction"));

            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.AuthorId).HasColumnName("author_id");
            entity.Property(e => e.CreateTime)
                .HasColumnType("datetime")
                .HasColumnName("create_time");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.StoryDescription)
                .HasColumnType("ntext")
                .HasColumnName("story_description");
            entity.Property(e => e.StoryDescriptionHtml)
                .HasColumnType("ntext")
                .HasColumnName("story_description_html");
            entity.Property(e => e.StoryDescriptionMarkdown)
                .HasColumnType("ntext")
                .HasColumnName("story_description_markdown");
            entity.Property(e => e.StoryImage)
                .HasMaxLength(4000)
                .IsUnicode(false)
                .HasColumnName("story_image");
            entity.Property(e => e.StoryPrice)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("story_price");
            entity.Property(e => e.StorySale)
                .HasColumnType("decimal(18, 0)")
                .HasColumnName("story_sale");
            entity.Property(e => e.StoryTitle)
                .HasMaxLength(100)
                .HasColumnName("story_title");
            entity.Property(e => e.UpdateTime)
                .HasColumnType("datetime")
                .HasColumnName("update_time");

            entity.HasOne(d => d.Author).WithMany(p => p.Stories)
                .HasForeignKey(d => d.AuthorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Story__author_id__59063A47");
        });

        modelBuilder.Entity<StoryFollowLike>(entity =>
        {
            entity.HasKey(e => new { e.UserId, e.StoryId }).HasName("PK_story_follow");

            entity.ToTable("Story_Follow_Like");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.Follow).HasColumnName("follow");
            entity.Property(e => e.Like).HasColumnName("like");

            entity.HasOne(d => d.Story).WithMany(p => p.StoryFollowLikes)
                .HasForeignKey(d => d.StoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Story_Fol__story__5535A963");

            entity.HasOne(d => d.User).WithMany(p => p.StoryFollowLikes)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Story_Fol__user___5629CD9C");
        });

        modelBuilder.Entity<StoryInteraction>(entity =>
        {
            entity.HasKey(e => e.StoryId).HasName("PK_story_interaction");

            entity.ToTable("Story_Interaction");

            entity.Property(e => e.StoryId)
                .ValueGeneratedNever()
                .HasColumnName("story_id");
            entity.Property(e => e.Follow).HasColumnName("follow");
            entity.Property(e => e.Like).HasColumnName("like");
            entity.Property(e => e.Read).HasColumnName("read");
            entity.Property(e => e.View).HasColumnName("view");

            entity.HasOne(d => d.Story).WithOne(p => p.StoryInteraction)
                .HasForeignKey<StoryInteraction>(d => d.StoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Story_Int__story__59FA5E80");
        });

        modelBuilder.Entity<StoryRead>(entity =>
        {
            entity.HasKey(e => new { e.UserId, e.StoryId }).HasName("PK_story_read");

            entity.ToTable("Story_Read");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.ChapterId).HasColumnName("chapter_id");
            entity.Property(e => e.ReadTime)
                .HasColumnType("date")
                .HasColumnName("read_time");

            entity.HasOne(d => d.Chapter).WithMany(p => p.StoryReads)
                .HasForeignKey(d => d.ChapterId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Story_Rea__chapt__5441852A");

            entity.HasOne(d => d.Story).WithMany(p => p.StoryReads)
                .HasForeignKey(d => d.StoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Story_Rea__story__534D60F1");

            entity.HasOne(d => d.User).WithMany(p => p.StoryReads)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Story_Rea__user___52593CB8");
        });

        modelBuilder.Entity<Ticket>(entity =>
        {
            entity.HasKey(e => e.TicketId).HasName("PK_ticket");

            entity.ToTable("Ticket");

            entity.Property(e => e.TicketId).HasColumnName("ticket_id");
            entity.Property(e => e.Seen).HasColumnName("seen");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.TicketDate)
                .HasColumnType("datetime")
                .HasColumnName("ticket_date");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ticket__user_id__6E01572D");
        });

        modelBuilder.Entity<Transaction>(entity =>
        {
            entity.ToTable("Transaction");

            entity.Property(e => e.TransactionId).HasColumnName("transaction_id");
            entity.Property(e => e.Amount)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("amount");
            entity.Property(e => e.ChapterId).HasColumnName("chapter_id");
            entity.Property(e => e.Description)
                .HasMaxLength(500)
                .HasColumnName("description");
            entity.Property(e => e.FundAfter)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("fund_after");
            entity.Property(e => e.FundBefore)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("fund_before");
            entity.Property(e => e.RefundAfter)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("refund_after");
            entity.Property(e => e.RefundBefore)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("refund_before");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.TransactionTime)
                .HasColumnType("datetime")
                .HasColumnName("transaction_time");
            entity.Property(e => e.WalletId).HasColumnName("wallet_id");

            entity.HasOne(d => d.Chapter).WithMany(p => p.Transactions)
                .HasForeignKey(d => d.ChapterId)
                .HasConstraintName("FK__Transacti__chapt__5165187F");

            entity.HasOne(d => d.Story).WithMany(p => p.Transactions)
                .HasForeignKey(d => d.StoryId)
                .HasConstraintName("FK__Transacti__story__5070F446");

            entity.HasOne(d => d.Wallet).WithMany(p => p.Transactions)
                .HasForeignKey(d => d.WalletId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Transacti__walle__4F7CD00D");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK_user");

            entity.ToTable("User");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.Address)
                .HasMaxLength(200)
                .HasColumnName("address");
            entity.Property(e => e.DescriptionHtml)
                .HasColumnType("ntext")
                .HasColumnName("description_html");
            entity.Property(e => e.DescriptionMarkdown)
                .HasColumnType("ntext")
                .HasColumnName("description_markdown");
            entity.Property(e => e.Dob)
                .HasColumnType("date")
                .HasColumnName("dob");
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.Gender).HasColumnName("gender");
            entity.Property(e => e.Password)
                .HasMaxLength(4000)
                .HasColumnName("password");
            entity.Property(e => e.Phone)
                .HasMaxLength(11)
                .IsUnicode(false)
                .HasColumnName("phone");
            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.Status)
                .HasDefaultValueSql("((1))")
                .HasColumnName("status");
            entity.Property(e => e.UserFullname)
                .HasMaxLength(50)
                .HasColumnName("user_fullname");
            entity.Property(e => e.UserImage)
                .HasMaxLength(4000)
                .HasColumnName("user_image");
            entity.Property(e => e.Username)
                .HasMaxLength(50)
                .HasColumnName("username");

            entity.HasOne(d => d.Role).WithMany(p => p.Users)
                .HasForeignKey(d => d.RoleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__User__role_id__6B24EA82");

            entity.HasMany(d => d.Chapters).WithMany(p => p.Users)
                .UsingEntity<Dictionary<string, object>>(
                    "ChapterOwned",
                    r => r.HasOne<Chapter>().WithMany()
                        .HasForeignKey("ChapterId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Chapter_O__chapt__60A75C0F"),
                    l => l.HasOne<User>().WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Chapter_O__user___5FB337D6"),
                    j =>
                    {
                        j.HasKey("UserId", "ChapterId").HasName("PK_chapter_owned");
                        j.ToTable("Chapter_Owned");
                        j.IndexerProperty<int>("UserId").HasColumnName("user_id");
                        j.IndexerProperty<long>("ChapterId").HasColumnName("chapter_id");
                    });

            entity.HasMany(d => d.StoriesNavigation).WithMany(p => p.Users)
                .UsingEntity<Dictionary<string, object>>(
                    "StoryOwned",
                    r => r.HasOne<Story>().WithMany()
                        .HasForeignKey("StoryId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Story_Own__story__571DF1D5"),
                    l => l.HasOne<User>().WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Story_Own__user___5812160E"),
                    j =>
                    {
                        j.HasKey("UserId", "StoryId").HasName("PK_story_owned");
                        j.ToTable("Story_Owned");
                        j.IndexerProperty<int>("UserId").HasColumnName("user_id");
                        j.IndexerProperty<int>("StoryId").HasColumnName("story_id");
                    });
        });

        modelBuilder.Entity<Volume>(entity =>
        {
            entity.HasKey(e => e.VolumeId).HasName("PK_volume");

            entity.ToTable("Volume");

            entity.Property(e => e.VolumeId).HasColumnName("volume_id");
            entity.Property(e => e.CreateTime)
                .HasColumnType("datetime")
                .HasColumnName("create_time");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.UpdateTime)
                .HasColumnType("datetime")
                .HasColumnName("update_time");
            entity.Property(e => e.VolumeNumber).HasColumnName("volume_number");
            entity.Property(e => e.VolumeTitle)
                .HasMaxLength(100)
                .HasColumnName("volume_title");

            entity.HasOne(d => d.Story).WithMany(p => p.Volumes)
                .HasForeignKey(d => d.StoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Volume__story_id__5CD6CB2B");
        });

        modelBuilder.Entity<Wallet>(entity =>
        {
            entity.HasKey(e => e.WalletId).HasName("PK_wallet");

            entity.ToTable("Wallet");

            entity.Property(e => e.WalletId).HasColumnName("wallet_id");
            entity.Property(e => e.BankAccount)
                .HasMaxLength(50)
                .HasColumnName("bank_account");
            entity.Property(e => e.BankId)
                .HasMaxLength(50)
                .HasColumnName("bank_id");
            entity.Property(e => e.Fund)
                .HasDefaultValueSql("('0.00')")
                .HasColumnType("decimal(18, 0)")
                .HasColumnName("fund");
            entity.Property(e => e.Refund)
                .HasDefaultValueSql("('0.00')")
                .HasColumnType("decimal(18, 0)")
                .HasColumnName("refund");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.Wallets)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Wallet__user_id__4E88ABD4");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
