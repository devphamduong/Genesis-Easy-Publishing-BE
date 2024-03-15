using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Printing;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    [Route("api/v1/interaction")]
    [ApiController]
    public class InteractionsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();

        public InteractionsController(EasyPublishingContext context)
        {
            _context = context;
        }
        private JwtSecurityToken VerifyToken()
        {
            var tokenCookie = Request.Cookies["access_token"];
            var tokenBearer = extractToken();
            var handler = new JwtSecurityTokenHandler();
            var jwtSecurityToken = handler.ReadJwtToken(!String.IsNullOrEmpty(tokenBearer) ? tokenBearer : tokenCookie);
            return jwtSecurityToken;
        }

        private string extractToken()
        {
            if (!String.IsNullOrEmpty(Request.Headers.Authorization) &&
                Request.Headers.Authorization.ToString().Split(' ')[0] == "Bearer" &&
                !String.IsNullOrEmpty(Request.Headers.Authorization.ToString().Split(' ')[1]))
            {
                return Request.Headers.Authorization.ToString().Split(' ')[1];
            }
            return null;
        }

        [HttpPut("story_like")]
        public async Task<ActionResult> LikeStory(int storyid)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Login first");

            var interaction = await _context.StoryFollowLikes.FirstOrDefaultAsync(c => c.StoryId == storyid && c.UserId == userId);
            var story_interaction = await _context.StoryInteractions.FirstOrDefaultAsync(c => c.StoryId == storyid);

            if (interaction != null)
            {
                story_interaction.Like = interaction.Like == true ? story_interaction.Like - 1 : story_interaction.Like + 1;
                interaction.Like = !interaction.Like;
                _context.Entry(interaction).State = EntityState.Modified;

            }
            else
            {
                story_interaction.Like += 1;
                StoryFollowLike storyFollowLike = new StoryFollowLike { UserId = userId, StoryId = storyid, Follow = false, Like = true };
                _context.StoryFollowLikes.Add(storyFollowLike);

            }

            _context.Entry(story_interaction).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return _msgService.MsgActionReturn(0, "");
        }


        [HttpPut("story_follow")]
        public async Task<ActionResult> FollowStory(int storyid)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            var interaction = await _context.StoryFollowLikes.FirstOrDefaultAsync(c => c.StoryId == storyid && c.UserId == userId);
            var story_interaction = await _context.StoryInteractions.FirstOrDefaultAsync(c => c.StoryId == storyid);

            if (interaction != null)
            {
                story_interaction.Follow = interaction.Follow == true ? story_interaction.Follow - 1 : story_interaction.Follow + 1;
                interaction.Follow = !interaction.Follow;
                _context.Entry(interaction).State = EntityState.Modified;
            }
            else
            {
                story_interaction.Follow += 1;
                StoryFollowLike storyFollowLike = new StoryFollowLike { UserId = userId, StoryId = storyid, Follow = true, Like = false };
                _context.StoryFollowLikes.Add(storyFollowLike);
            }
            _context.Entry(story_interaction).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return _msgService.MsgActionReturn(0, "");
        }

        [HttpGet("author_manage/story")]
        public async Task<ActionResult> GetStoryData(int storyid)
        {

            var interaction = await _context.Stories.Where(c => c.StoryId == storyid)
               .Include(c => c.Users).Include(c => c.StoryInteraction)
               .Include(c => c.Chapters).ThenInclude(c => c.Users)
               .Include(c => c.ReportContents)
               .Select(s => new
               {
                   s.StoryId,
                   s.StoryTitle,
                   s.StoryInteraction.Like,
                   s.StoryInteraction.Follow,
                   s.StoryInteraction.View,
                   s.StoryInteraction.Read,
                   PurchaseStory = s.Users.Count,
                   PurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                   ReportStory = s.ReportContents.Count,
               }).ToListAsync();

            return _msgService.MsgReturn(0, "Truyện của tác giả", interaction.FirstOrDefault());
        }

        [HttpGet("author_manage/chapter")]
        public async Task<ActionResult> GetStoryChaptersData(int storyid)
        {

            var interaction = await _context.Chapters.Where(c => c.StoryId == storyid)
               .Include(c => c.Users)
               .Include(c => c.ReportContents)
               .Select(s => new
               {
                   s.ChapterId,
                   s.ChapterNumber,
                   s.ChapterTitle,
                   PurchaseChapter = s.Users.Count,
                   ReportChapter = s.ReportContents.Count,
               }).ToListAsync();

            return _msgService.MsgReturn(0, "Truyện của tác giả", interaction);
        }
    }
}
