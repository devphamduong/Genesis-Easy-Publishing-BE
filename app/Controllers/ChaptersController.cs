using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
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

        public class AddVolumeForm
        {
            public int StoryId { get; set; }
            public string VolumeTitle { get; set; } = null!;
        }
        [HttpPost("add_volume")]
        public async Task<ActionResult> AddVolume(AddVolumeForm volume)
        {
            if (volume.VolumeTitle.IsNullOrEmpty())
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Thêm tập thất bại!"
                });
            }
            int volumeNumber = _context.Volumes.Where(v => v.StoryId == volume.StoryId).Select(v => v.VolumeNumber).ToList().DefaultIfEmpty(0).Max() + 1;
            if (volumeNumber >= 2)
            {
                var h = _context.Volumes.Where(v => v.VolumeNumber == (volumeNumber - 1) && v.StoryId == volume.StoryId).Include(v => v.Chapters).Select(v => new
                {
                    numberChapter = v.Chapters.Count()
                }).FirstOrDefault();
                if (h == null || h.numberChapter < 2)
                {
                    return new JsonResult(new
                    {
                        EC = -1,
                        EM = "Không thể tạo thêm tập mới"
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
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Thêm tập mới thành công"
            });
        }

        public class UpdateVolumeForm
        {
            public int VolumeId { get; set; }
            public string VolumeTitle { get; set; } = null!;
        }

        [HttpPut("update_volume")]
        public async Task<ActionResult> UpdateVolume(UpdateVolumeForm volume)
        {
            if (volume.VolumeTitle.IsNullOrEmpty())
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Cập nhật thất bại!"
                });
            }
            var currentVolume = _context.Volumes.FirstOrDefault(v => v.VolumeId == volume.VolumeId);
            try
            {
                if (currentVolume != null)
                {
                    currentVolume.VolumeTitle = volume.VolumeTitle;
                    currentVolume.UpdateTime = DateTime.Now;
                }
                else
                {
                    return new JsonResult(new
                    {
                        EC = -1,
                        EM = "Tập không tồn tại"
                    });
                }
                _context.Entry<Volume>(currentVolume).State = EntityState.Modified;
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
            return new JsonResult(new
            {
                EC = 0,
                EM = "Cập nhật thành công"
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
            return _msgService.MsgReturn(0, "Danh sách tập", volumes);
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
                    Chapters = v.Chapters.Where(c => c.Status >= 0).Select(c => new
                    {
                        c.ChapterId,
                        c.ChapterNumber,
                        c.ChapterTitle,
                        c.ChapterPrice,
                        c.CreateTime,
                        c.Status
                    }).OrderBy(c => c.ChapterNumber).ToList()
                }).OrderBy(v => v.volumeNumber)
                .ToListAsync();
            return _msgService.MsgReturn(0, "Danh sách tập cụ thể", volumes);
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
            if (chapter.ChapterContentHtml.IsNullOrEmpty() || chapter.ChapterContentMarkdown.IsNullOrEmpty())
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Không được để trống nội dung!"
                });
            }
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
            c.Status = 0;
            try
            {
                long nextChapterNum = _context.Chapters.Where(c => c.StoryId == chapter.StoryId && c.VolumeId == chapter.VolumeId && c.Status == 1).Select(c => c.ChapterNumber).ToList().DefaultIfEmpty(0).Max() + 1;
                c.ChapterNumber = nextChapterNum;
                await _context.Chapters.AddAsync(c);
                _context.SaveChanges();
                // renumber chapter number
                var chapters = _context.Chapters.Where(c => c.StoryId == chapter.StoryId && c.Status == 1).OrderBy(c => c.Volume.VolumeNumber).ThenBy(c => c.ChapterNumber).ToList();
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
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Thêm chương mới thành công"
            });
        }

        [HttpGet("chapter_information")]
        public async Task<ActionResult> GetChapterInfor(int chapterId)
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

            var chapter = _context.Chapters.Where(c => c.ChapterId == chapterId).Select(c => new
            {
                chapterId = c.ChapterId,
                storyId = c.Story.StoryId,
                storyTitle = c.Story.StoryTitle,
                ChapterTitle = c.ChapterTitle,
                chapterContentHtml = c.ChapterContentHtml,
                ChapterContentMarkdown = c.ChapterContentMarkdown,
                ChapterNumber = c.ChapterNumber,
                volumeId = c.VolumeId,
                chapterPrice = c.ChapterPrice,

            }).FirstOrDefault();
            if (chapter == null)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Chương không tồn tại"
                });
            }
            if (user == null)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Bạn phải đăng nhập trước"
                });
            }
            if (!user.Stories.Any(s => s.StoryId == chapter.storyId))
            {
                if (!user.Chapters.Any(c => c.ChapterId == chapterId))
                {
                    return new JsonResult(new
                    {
                        EC = -1,
                        EM = "Bạn không được quyền vào trang này"
                    });
                }
            }



            return _msgService.MsgReturn(0, "Thông tin chương", chapter);
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
            if (chapter.ChapterContentHtml.IsNullOrEmpty() || chapter.ChapterContentMarkdown.IsNullOrEmpty())
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Không được để trống nội dung chương!"
                });
            }
            var currentChapter = _context.Chapters.FirstOrDefault(c => c.ChapterId == chapter.ChapterId);
            try
            {
                if (currentChapter != null)
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
                        EM = "Cập nhật thất bại!"
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
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Cập nhật thành công!"
            });
        }

        [HttpPut("delete_chapter")]
        public async Task<ActionResult> DeleteChapter(int chapterId)
        {
            var currentChapter = _context.Chapters.FirstOrDefault(c => c.ChapterId == chapterId);
            int storyId = currentChapter.StoryId;
            try
            {
                if (currentChapter == null)
                {
                    return new JsonResult(new
                    {
                        EC = -1,
                        EM = "Chương không tồn tại"
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
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Xóa chương thành công!"
            });
        }


        private bool checkPurchase(int? userid, long chapterNum, int storyid)
        {
            if (userid == null)
            {
                return false;
            }
            var user = _context.Users.Where(u => u.UserId == userid).Select(u => new
            {
                UserId = u.UserId,
                Stories = u.StoriesNavigation.Select(sn => new { StoryId = sn.StoryId }).ToList(),
                Chapters = u.Chapters.Select(c => new { chapterId = c.ChapterId, ChapterNumber = c.ChapterNumber, StoryId = c.StoryId }).ToList()
            }).FirstOrDefault();
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
            long prevChapterNum = PreviousChapter(chapterNumber, storyid);

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
                    PreviousChapterNumber = prevChapterNum,
                    NextChapterNumber = nextChapterNum,
                    Owned = (checkPurchase(userId, chapterNumber, storyid) || c.ChapterPrice == 0 || c.ChapterPrice == null || userId == c.Story.Author.UserId),
                    UserLike = c.ChapterLikeds.Any(c => c.UserId == userId && c.ChapterId == c.ChapterId),
                }).FirstOrDefault();

            if (chapter == null)
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Chương không tồn tại"
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

            return _msgService.MsgReturn(0, "Nội dung chương", chapter);

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

        private long PreviousChapter(long currentChapterNumber, int storyid)
        {
            var nextChapter = _context.Chapters.Where(c => c.StoryId == storyid && c.ChapterNumber < currentChapterNumber && c.Status > 0)
                              .OrderByDescending(c => c.ChapterNumber)
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
