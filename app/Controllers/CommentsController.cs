using app.DTOs;
using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualBasic;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    [Route("api/v1/comments")]
    [ApiController]
    public class CommentsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        //private int pageSize = 10;
        public CommentsController(EasyPublishingContext context)
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

        private int GetUserId()
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }
            return userId;
        }

        [HttpGet("story_detail")]
        public async Task<ActionResult> GetStoryComments(int storyId, int page, int pageSize)
        {
            int userId = GetUserId();

            var comments = await _context.Comments.Where(c => c.StoryId == storyId)
                .Include(c => c.User)
                .Select(c => new
                {
                    UserComment = new { c.User.UserId, c.User.UserFullname, c.User.UserImage },
                    CommentId = c.CommentId,
                    CommentContent = c.CommentContent,
                    CommentDate = c.CommentDate,
                    CommentWriter = userId == c.UserId ? true : false
                })
                .OrderByDescending(c => c.CommentId)
                .ToListAsync();
            pageSize = pageSize == null ? 10 : pageSize;
            return _msgService.MsgPagingReturn("Bình luận của truyện",
                comments.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, comments.Count);
        }

        [HttpGet("chapter_content")]
        public async Task<ActionResult> GetChapterComments(int chapterId, int page, int pageSize)
        {
            int userId = GetUserId();

            var comments = await _context.Comments.Where(c => c.StoryId == chapterId)
                .Include(c => c.User)
                .Select(c => new
                {
                    UserComment = new { c.User.UserId, c.User.UserFullname, c.User.UserImage },
                    CommentId = c.CommentId,
                    CommentContent = c.CommentContent,
                    CommentDate = c.CommentDate,
                    CommentWriter = userId == c.UserId ? true : false
                })
                .OrderByDescending(c => c.CommentId)
                .ToListAsync();
            pageSize = pageSize == null ? 10 : pageSize;
            return _msgService.MsgPagingReturn("Bình luận của chương",
                comments.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, comments.Count);
        }


        [HttpPost("send")]
        public async Task<ActionResult> SendComment(CommentDTO commentDTO)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            if (!ModelState.IsValid) return _msgService.MsgActionReturn(-1, "Thiếu điều kiện");
            try
            {
                Comment cmt = new Comment()
                {
                    UserId = userId,
                    StoryId = commentDTO.StoryId,
                    ChapterId = commentDTO.ChapterId,
                    CommentContent = commentDTO.CommentContent,
                    CommentDate = DateTime.Now,
                };
                _context.Comments.Add(cmt);
                await _context.SaveChangesAsync();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
            return _msgService.MsgActionReturn(0, "Bình luận thành công");
        }

        public class CommentUpdateModel
        {
            public string CommentContent { get; set; }
        }

        [HttpPost("edit")]
        public async Task<ActionResult> EditComment(int commentId, [FromBody] CommentUpdateModel cmtUpdate)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            Comment cmt = await _context.Comments.FirstOrDefaultAsync(c => c.UserId == userId && c.CommentId == commentId);
            if (cmt == null) return _msgService.MsgActionReturn(-1, "Không có comment");

            try
            {
                if (String.IsNullOrEmpty(cmtUpdate.CommentContent)) _context.Comments.Remove(cmt);
                else
                {
                    cmt.CommentContent = cmtUpdate.CommentContent;
                    _context.Entry(cmt).State = EntityState.Modified;
                }

                await _context.SaveChangesAsync();

            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
            return _msgService.MsgActionReturn(0, "Bình luận thành công");
        }
    }
}
