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

    public virtual DbSet<Comment> Comments { get; set; }

    public virtual DbSet<CommentResponse> CommentResponses { get; set; }

    public virtual DbSet<Report> Reports { get; set; }

    public virtual DbSet<Story> Stories { get; set; }

    public virtual DbSet<StoryFollowLike> StoryFollowLikes { get; set; }

    public virtual DbSet<StoryInteraction> StoryInteractions { get; set; }

    public virtual DbSet<StoryIssue> StoryIssues { get; set; }

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
            entity.Property(e => e.CategoryName)
                .HasMaxLength(100)
                .HasColumnName("category_name");

            entity.HasMany(d => d.Stories).WithMany(p => p.Categories)
                .UsingEntity<Dictionary<string, object>>(
                    "StoryCategory",
                    r => r.HasOne<Story>().WithMany()
                        .HasForeignKey("StoryId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Story_Cat__story__4AB81AF0"),
                    l => l.HasOne<Category>().WithMany()
                        .HasForeignKey("CategoryId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Story_Cat__categ__4BAC3F29"),
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
            entity.Property(e => e.ChapterContent)
                .HasColumnType("ntext")
                .HasColumnName("chapter_content");
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
                .HasConstraintName("FK__Chapter__story_i__4E88ABD4");

            entity.HasOne(d => d.Volume).WithMany(p => p.Chapters)
                .HasForeignKey(d => d.VolumeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Chapter__volume___4F7CD00D");
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
                .HasColumnType("date")
                .HasColumnName("comment_date");
            entity.Property(e => e.IssueId).HasColumnName("issue_id");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Chapter).WithMany(p => p.Comments)
                .HasForeignKey(d => d.ChapterId)
                .HasConstraintName("FK__Comment__chapter__5629CD9C");

            entity.HasOne(d => d.Issue).WithMany(p => p.Comments)
                .HasForeignKey(d => d.IssueId)
                .HasConstraintName("FK__Comment__issue_i__571DF1D5");

            entity.HasOne(d => d.Story).WithMany(p => p.Comments)
                .HasForeignKey(d => d.StoryId)
                .HasConstraintName("FK__Comment__story_i__5535A963");

            entity.HasOne(d => d.User).WithMany(p => p.Comments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Comment__user_id__5441852A");
        });

        modelBuilder.Entity<CommentResponse>(entity =>
        {
            entity.HasKey(e => e.CommentResponseId).HasName("PK_commentresponse");

            entity.ToTable("CommentResponse");

            entity.Property(e => e.CommentResponseId).HasColumnName("comment_response_id");
            entity.Property(e => e.CommentContent)
                .HasMaxLength(2000)
                .HasColumnName("comment_content");
            entity.Property(e => e.CommentDate)
                .HasColumnType("date")
                .HasColumnName("comment_date");
            entity.Property(e => e.CommentId).HasColumnName("comment_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Comment).WithMany(p => p.CommentResponses)
                .HasForeignKey(d => d.CommentId)
                .HasConstraintName("FK__CommentRe__comme__59063A47");

            entity.HasOne(d => d.User).WithMany(p => p.CommentResponses)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CommentRe__user___5812160E");
        });

        modelBuilder.Entity<Report>(entity =>
        {
            entity.HasKey(e => e.ReportId).HasName("PK_report");

            entity.ToTable("Report");

            entity.Property(e => e.ReportId).HasColumnName("report_id");
            entity.Property(e => e.ChapterId).HasColumnName("chapter_id");
            entity.Property(e => e.CommentId).HasColumnName("comment_id");
            entity.Property(e => e.IssueId).HasColumnName("issue_id");
            entity.Property(e => e.ReportContent)
                .HasMaxLength(2000)
                .HasColumnName("report_content");
            entity.Property(e => e.ReportDate)
                .HasColumnType("date")
                .HasColumnName("report_date");
            entity.Property(e => e.ReportTitle)
                .HasMaxLength(100)
                .HasColumnName("report_title");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.TransactionId).HasColumnName("transaction_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Chapter).WithMany(p => p.Reports)
                .HasForeignKey(d => d.ChapterId)
                .HasConstraintName("FK__Report__chapter___5BE2A6F2");

            entity.HasOne(d => d.Comment).WithMany(p => p.Reports)
                .HasForeignKey(d => d.CommentId)
                .HasConstraintName("FK__Report__comment___5EBF139D");

            entity.HasOne(d => d.Issue).WithMany(p => p.Reports)
                .HasForeignKey(d => d.IssueId)
                .HasConstraintName("FK__Report__issue_id__5CD6CB2B");

            entity.HasOne(d => d.Story).WithMany(p => p.Reports)
                .HasForeignKey(d => d.StoryId)
                .HasConstraintName("FK__Report__story_id__5AEE82B9");

            entity.HasOne(d => d.Transaction).WithMany(p => p.Reports)
                .HasForeignKey(d => d.TransactionId)
                .HasConstraintName("FK__Report__transact__5DCAEF64");

            entity.HasOne(d => d.User).WithMany(p => p.Reports)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Report__user_id__59FA5E80");
        });

        modelBuilder.Entity<Story>(entity =>
        {
            entity.HasKey(e => e.StoryId).HasName("PK_story");

            entity.ToTable("Story");

            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.AuthorId).HasColumnName("author_id");
            entity.Property(e => e.CreateTime)
                .HasColumnType("datetime")
                .HasColumnName("create_time");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.StoryDescription)
                .HasMaxLength(4000)
                .HasColumnName("story_description");
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
                .HasConstraintName("FK__Story__author_id__49C3F6B7");
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
                .HasConstraintName("FK__Story_Fol__story__45F365D3");

            entity.HasOne(d => d.User).WithMany(p => p.StoryFollowLikes)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Story_Fol__user___46E78A0C");
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
                .HasConstraintName("FK__Story_Int__story__4CA06362");
        });

        modelBuilder.Entity<StoryIssue>(entity =>
        {
            entity.HasKey(e => e.IssueId).HasName("PK_story_issue");

            entity.ToTable("Story_Issue");

            entity.Property(e => e.IssueId).HasColumnName("issue_id");
            entity.Property(e => e.IssueContent)
                .HasMaxLength(500)
                .HasColumnName("issue_content");
            entity.Property(e => e.IssueDate)
                .HasColumnType("date")
                .HasColumnName("issue_date");
            entity.Property(e => e.IssueTitle)
                .HasMaxLength(100)
                .HasColumnName("issue_title");
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Story).WithMany(p => p.StoryIssues)
                .HasForeignKey(d => d.StoryId)
                .HasConstraintName("FK__Story_Iss__story__534D60F1");

            entity.HasOne(d => d.User).WithMany(p => p.StoryIssues)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Story_Iss__user___52593CB8");
        });

        modelBuilder.Entity<Transaction>(entity =>
        {
            entity.ToTable("Transaction");

            entity.Property(e => e.TransactionId).HasColumnName("transaction_id");
            entity.Property(e => e.Amount)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("amount");
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
            entity.Property(e => e.Status)
                .HasComment("0 mean Fail, 1 mean Pending, 2 mean Successful")
                .HasColumnName("status");
            entity.Property(e => e.TransactionTime)
                .HasColumnType("datetime")
                .HasColumnName("transaction_time");
            entity.Property(e => e.WalletId).HasColumnName("wallet_id");

            entity.HasOne(d => d.Wallet).WithMany(p => p.Transactions)
                .HasForeignKey(d => d.WalletId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Transacti__walle__44FF419A");
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

            entity.HasMany(d => d.Chapters).WithMany(p => p.Users)
                .UsingEntity<Dictionary<string, object>>(
                    "ChapterOwned",
                    r => r.HasOne<Chapter>().WithMany()
                        .HasForeignKey("ChapterId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Chapter_O__chapt__5165187F"),
                    l => l.HasOne<User>().WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Chapter_O__user___5070F446"),
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
                        .HasConstraintName("FK__Story_Own__story__47DBAE45"),
                    l => l.HasOne<User>().WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Story_Own__user___48CFD27E"),
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
            entity.Property(e => e.StoryId).HasColumnName("story_id");
            entity.Property(e => e.VolumeTitle)
                .HasMaxLength(100)
                .HasColumnName("volume_title");

            entity.HasOne(d => d.Story).WithMany(p => p.Volumes)
                .HasForeignKey(d => d.StoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Volume__story_id__4D94879B");
        });

        modelBuilder.Entity<Wallet>(entity =>
        {
            entity.HasKey(e => e.WalletId).HasName("PK_wallet");

            entity.ToTable("Wallet");

            entity.Property(e => e.WalletId).HasColumnName("wallet_id");
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
                .HasConstraintName("FK__Wallet__user_id__440B1D61");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
