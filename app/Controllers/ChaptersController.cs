using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualBasic;
using System.Drawing.Printing;
using System.IdentityModel.Tokens.Jwt;
using System.Xml.Linq;

namespace app.Controllers
{
    [Route("api/v1/chapters")]
    [ApiController]
    public class ChaptersController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private int pagesize = 10;
        public ChaptersController(EasyPublishingContext context)
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

        [HttpGet("story_detail")]
        public async Task<ActionResult> GetStoryChapters(int storyId, int page, int pageSize)
        {
            var chapters = await _context.Chapters.Where(c => c.StoryId == storyId && c.Status > 0)
                .Include(c => c.Comments)
                .Include(c => c.Users)
                .Select(c => new
                {
                    ChapterId = c.ChapterId,
                    ChapterNumber = c.ChapterNumber,
                    ChapterTitle = c.ChapterTitle,
                    ChapterPrice = c.ChapterPrice,
                    CreateTime = c.CreateTime,
                    Comment = c.Comments.Count,
                    UserPurchaseChapter = c.Users.Count,
                })
                .OrderBy(c => c.ChapterNumber)
                .ToListAsync();
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return _msgService.MsgPagingReturn("Danh sách chương",
                chapters.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, chapters.Count);
        }

        //[HttpGet("chapter_detail")]
        //public async Task<ActionResult> GetChapter(int chapterid)
        //{
        //    var chapters = await _context.Chapters.Where(c => c.ChapterId == chapterid && c.Status > 0)
        //        .Include(c => c.Story)
        //        .Include(c => c.Comments)
        //        .Select(c => new
        //        {
        //            Story = new { c.StoryId, c.Story.StoryTitle },
        //            ChapterId = c.ChapterId,
        //            ChapterNumber = c.ChapterNumber,
        //            ChapterTitle = c.ChapterTitle,
        //            ChapterPrice = c.ChapterPrice,
        //            CreateTime = c.CreateTime,
        //            UpdateTime = c.UpdateTime,
        //            Comment = c.Comments.Count,
        //            UserPurchaseChapter = c.Users.Count,
        //        })
        //        .ToListAsync();
        //    return _msgService.MsgReturn(0, "Story Chapter Detail", chapters.FirstOrDefault());
        //}

        //[HttpGet("chapter_detail/taskbar")]
        //public async Task<ActionResult> GetChapterRelated(int chapterid, int storyid)
        //{
        //    var chapters = await _context.Chapters.Where(c => c.ChapterId != chapterid && c.Status > 0 && c.StoryId == storyid)
        //        .Select(c => new
        //        {
        //            ChapterId = c.ChapterId,
        //            ChapterTitle = c.ChapterTitle,
        //        })
        //        .OrderBy(c => c.ChapterId).Take(2)
        //        .ToListAsync();
        //    return _msgService.MsgReturn(0, "Story Chapter Relate", chapters);
        //}

        public class AddVolumeForm
        {
            public int StoryId { get; set; }
            public string VolumeTitle { get; set; } = null!;
        }
        [HttpPost("add_volume")]
        public async Task<ActionResult> AddVolume(AddVolumeForm volume)
        {
            int volumeNumber = _context.Volumes.Where(v => v.StoryId == volume.StoryId).Select(v => v.VolumeNumber).ToList().DefaultIfEmpty(0).Max() + 1;
            if (volumeNumber >= 2)
            {
                var h = _context.Volumes.Where(v => v.VolumeNumber == (volumeNumber-1) && v.StoryId == volume.StoryId).Include(v=> v.Chapters).Select(v => new
                {
                    numberChapter = v.Chapters.Count()
                }).FirstOrDefault();
                if(h == null || h.numberChapter < 2)
                {
                    return new JsonResult(new
                    {
                        EC = -1,
                        EM = "Can't add more volume"
                    });
                }
            }
            Volume v = new Volume()
            {
                StoryId = volume.StoryId,
                VolumeTitle = volume.VolumeTitle,
                VolumeNumber = volumeNumber,
                CreateTime = DateTime.Now
            };
            try
            {
                await _context.Volumes.AddAsync(v);
                _context.SaveChanges();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Can't add volume"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Add volume successfully"
            });
        }

        [HttpGet("volume_list")]
        public async Task<ActionResult> GetVolumeName(int storyid)
        {
            var volumes = await _context.Volumes.Where(v => v.StoryId == storyid)
                .Select(v => new
                {
                    volumeId = v.VolumeId,
                    volumeNumber = v.VolumeNumber,
                    VolumeTitle = v.VolumeTitle
                })
                .ToListAsync();
            return _msgService.MsgReturn(0, "List volume", volumes);
        }

        [HttpGet("story_volume")]
        public async Task<ActionResult> GetVolume(int storyid)
        {
            var volumes = await _context.Volumes.Where(v => v.StoryId == storyid)
                .Include(v => v.Chapters)
                .Select(v => new
                {
                    volumeId = v.VolumeId,
                    volumeNumber = v.VolumeNumber,
                    VolumeTitle = v.VolumeTitle,
                    StoryId = v.StoryId,
                    CreateTime = v.CreateTime,
                    Chapters = v.Chapters.Where(c => c.Status > 0).Select(c => new
                    {
                        c.ChapterId,
                        c.ChapterNumber,
                        c.ChapterTitle,
                        c.ChapterPrice,
                        c.CreateTime
                    }).OrderBy(c => c.ChapterNumber).ToList()
                }).OrderBy(v => v.volumeNumber)
                .ToListAsync();
            return _msgService.MsgReturn(0, "List volume", volumes);
        }

        public class addChapterForm
        {
            public int StoryId { get; set; }
            public int VolumeId { get; set; }
            public string ChapterTitle { get; set; } = null!;
            public string? ChapterContentMarkdown { get; set; }
            public string? ChapterContentHtml { get; set; }
            public decimal? ChapterPrice { get; set; }
        }

        [HttpPost("add_chapter")]
        public async Task<ActionResult> AddChapter(addChapterForm chapter)
        {
            Chapter c = new Chapter()
            {
                ChapterContentHtml = chapter.ChapterContentHtml,
                ChapterContentMarkdown = chapter.ChapterContentMarkdown,
                StoryId = chapter.StoryId,
                VolumeId = chapter.VolumeId,
                ChapterTitle = chapter.ChapterTitle,
                ChapterPrice = chapter.ChapterPrice
            };
            c.CreateTime = DateTime.Now;
            c.Status = 1;
            try
            {
                long nextChapterNum = _context.Chapters.Where(c => c.StoryId == chapter.StoryId && c.VolumeId == chapter.VolumeId && c.Status ==1).Select(c => c.ChapterNumber).ToList().DefaultIfEmpty(0).Max() + 1;
                c.ChapterNumber = nextChapterNum;
                await _context.Chapters.AddAsync(c);
                _context.SaveChanges();
                // renumber chapter number
                var chapters = _context.Chapters.Where(c => c.StoryId == chapter.StoryId && c.Status == 1).OrderBy(c => c.Volume.VolumeNumber).ThenBy(c => c.ChapterNumber).ToList();
                for(int i =0; i < chapters.Count; i++)
                {
                    chapters[i].ChapterNumber = i + 1;
                }
                await _context.SaveChangesAsync();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Can't add chapter"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Add chapter successfully"
            });
        }

        [HttpGet("Chapter_information")]
        public async Task<ActionResult> GetStoryInfor(int chapterId)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }
            var user = _context.Users.Include(u => u.Chapters).Include(u => u.Stories).FirstOrDefault(u => u.UserId == userId);
            if (user == null || !user.Chapters.Any(c => c.ChapterId == chapterId))
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "You can't access this page"
                });
            }


            var chapter = _context.Chapters.Where(c => c.ChapterId == chapterId).Select(c => new
            {
                chapterId = c.ChapterId,
                chapterContentHtml = c.ChapterContentHtml,
                ChapterContentMarkdown = c.ChapterContentMarkdown,
                ChapterNumber = c.ChapterNumber
            }).FirstOrDefault();
            if (chapter == null)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "You can't save story"
                });
            }
            return _msgService.MsgReturn(0, "Story Detail", chapter);
        }
        public class UpdateChapterForm
        {
            public long ChapterId { get; set; }

            public string ChapterTitle { get; set; } = null!;

            public string? ChapterContentMarkdown { get; set; }

            public string? ChapterContentHtml { get; set; }

            public decimal? ChapterPrice { get; set; }
        }


        [HttpPut("update_chapter")]
        public async Task<ActionResult> EditChapter(UpdateChapterForm chapter)
        {
            var currentChapter = _context.Chapters.FirstOrDefault(c => c.ChapterId == chapter.ChapterId);
            try
            {
                if(currentChapter != null)
                {
                    currentChapter.ChapterTitle = chapter.ChapterTitle;
                    currentChapter.ChapterContentHtml = chapter.ChapterContentHtml;
                    currentChapter.ChapterContentMarkdown = chapter.ChapterContentMarkdown;
                    currentChapter.ChapterPrice = chapter.ChapterPrice;
                    currentChapter.UpdateTime = DateTime.Now;
                }
                else
                {
                    return new JsonResult(new
                    {
                        EC = -1,
                        EM = "Update Fail"
                    });
                }
                _context.Entry<Chapter>(currentChapter).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.SaveChanges();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Edit Fail"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Save chapter successfully"
            });
        }

        [HttpPut("delete_chapter")]
        public async Task<ActionResult> DeleteChapter(int chapterId)
        {
            var currentChapter = _context.Chapters.FirstOrDefault(c => c.ChapterId == chapterId);
            int storyId = currentChapter.StoryId;
            try
            {
                if(currentChapter == null)
                {
                    return new JsonResult(new
                    {
                        EC = -1,
                        EM = "Delete Fail"
                    });
                }
                currentChapter.Status = 0;
                _context.Entry<Chapter>(currentChapter).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.SaveChanges();

                var chapters = _context.Chapters.Where(c => c.StoryId == storyId && c.Status == 1).OrderBy(c => c.Volume.VolumeNumber).ThenBy(c => c.ChapterNumber).ToList();
                for (int i = 0; i < chapters.Count; i++)
                {
                    chapters[i].ChapterNumber = i + 1;
                }
                await _context.SaveChangesAsync();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Delete Fail"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Delete chapter successfully"
            });
        }
        private bool checkPurchase(int? userid, long chapterNum, int storyid)
        {
            if (userid == null)
            {
                return false;
            }
            var user = _context.Users.Include(u => u.Chapters).Include(u => u.Stories).FirstOrDefault(u => u.UserId == userid);
            if (user == null)
            {
                return false;
            }
            if (user.Chapters.Any(c => c.ChapterNumber == chapterNum && c.StoryId == storyid) || user.Stories.Any(s => s.StoryId == storyid))
            {
                return true;
            }
            return false;
        }

        [HttpGet("chapter_content/{storyid}/{chapterNumber}")]
        public async Task<ActionResult> GetChapterContent(long chapterNumber, int storyid)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }

            long nextChapterNum = NextChapter(chapterNumber, storyid);

            var chapter = _context.Chapters
                .Where(c => c.StoryId == storyid && c.ChapterNumber == chapterNumber && c.Status > 0)
                .Include(c => c.Story)
                .Include(c => c.Comments)
                .Include(c => c.ChapterLikeds)
                .Select(c => new
                {
                    Story = new { c.StoryId, c.Story.StoryTitle, c.Story.StoryPrice },
                    Author = new { c.Story.Author.UserId, c.Story.Author.UserFullname },
                    Content = (checkPurchase(userId, chapterNumber, storyid) || c.ChapterPrice == 0 || c.ChapterPrice == null || userId == c.Story.Author.UserId) ? c.ChapterContentHtml : null,
                    ChapterId = c.ChapterId,
                    ChapterNumber = c.ChapterNumber,
                    ChapterTitle = c.ChapterTitle,
                    ChapterPrice = c.ChapterPrice,
                    CreateTime = c.CreateTime,
                    UpdateTime = c.UpdateTime,
                    Comment = c.Comments.Count,
                    UserPurchaseChapter = c.Users.Count,
                    NextChapterNumber = nextChapterNum,
                    Owned = (checkPurchase(userId, chapterNumber, storyid) || c.ChapterPrice == 0 || c.ChapterPrice == null || userId == c.Story.Author.UserId),
                    UserLike = c.ChapterLikeds.Any(c => c.UserId == userId && c.ChapterId == c.ChapterId),
                }).FirstOrDefault();

            if (chapter == null)
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Chapter is not available"
                });
            if (chapter.Owned == true)
            {
                var story_interaction = await _context.StoryInteractions.FirstOrDefaultAsync(c => c.StoryId == storyid);
                story_interaction.Read += 1;
                _context.Entry(story_interaction).State = EntityState.Modified;

                var story_read = await _context.StoryReads.FirstOrDefaultAsync(c => c.UserId == userId && c.StoryId == storyid);
                if (story_read != null)
                {
                    story_read.ChapterId = chapter.ChapterId;
                    story_read.ReadTime = DateTime.Now;
                    _context.Entry(story_read).State = EntityState.Modified;
                }
                else _context.StoryReads.Add(new StoryRead
                {
                    StoryId = chapter.Story.StoryId,
                    UserId = userId,
                    ChapterId = chapter.ChapterId,
                    ReadTime = DateTime.Now
                });
                await _context.SaveChangesAsync();
            }

            return _msgService.MsgReturn(0, "Chapter content", chapter);

        }

        private long NextChapter(long currentChapterNumber, int storyid)
        {
            var nextChapter = _context.Chapters.Where(c => c.StoryId == storyid && c.ChapterNumber > currentChapterNumber && c.Status > 0)
                              .OrderBy(c => c.ChapterNumber)
                                .Select(c => new
                                {
                                    ChapterNumber = c.ChapterNumber
                                })
                              .FirstOrDefault();

            if (nextChapter == null)
            {
                return -1;
            }
            return nextChapter.ChapterNumber;
        }
    }
}
