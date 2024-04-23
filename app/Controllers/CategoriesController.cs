using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using app.Models;
using NuGet.Common;
using app.Service;
using System.Drawing.Printing;

namespace app.Controllers
{
    [Route("api/v1/category")]
    [ApiController]
    public class CategoriesController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        public CategoriesController(EasyPublishingContext context)
        {
            _context = context;
        }

        // GET: api/Categories
        [HttpGet]
        public async Task<ActionResult> GetCategories()
        {
            var cate = await _context.Categories
                .Include(c => c.Stories)
                .Select(c => new
                {
                    c.CategoryId,
                    c.CategoryName,
                    categoryDescription = c.CategoryDescription.Substring(0,50)+"...",
                    c.CategoryBanner,
                    StoriesNumber = c.Stories.Count,
                })
                .ToListAsync();
            return _msgService.MsgReturn(0, "Các thể loại truyện", cate);
        }

        // GET: api/Categories
        [HttpGet("cate_shelves_detail")]
        public async Task<ActionResult> GetCategoriy(int cateId)
        {
            var cate = await _context.Categories.Where(c => c.CategoryId == cateId)
                .Select(c => new
                {
                    c.CategoryId,
                    CategoryName = c.CategoryName.Replace("Truyện ", ""),
                    c.CategoryDescription,
                    c.CategoryBanner,
                    StoriesNumber = c.Stories.Count(),
                })
                .ToListAsync();
            if (cate == null) return _msgService.MsgActionReturn(-1, "Không có loại đó");
            return _msgService.MsgReturn(0, "Chi tiết thể loại", cate.FirstOrDefault());
        }
        [HttpGet("{id}")]
        public async Task<ActionResult<Category>> GetCategory(int id)
        {
            if (_context.Categories == null)
            {
                return NotFound();
            }
            var category = await _context.Categories.FindAsync(id);
            if (category == null)
            {
                return NotFound();
            }
            return category;
        }
        // GET: api/filter
        [HttpGet("options")]
        public async Task<ActionResult> GetOptionFilter()
        {
            var cate = await _context.Categories
                .Include(c => c.Stories)
                .Select(c => new
                {
                    c.CategoryId,
                    c.CategoryName,
                    c.CategoryDescription
                })
                .ToListAsync();
            var stories = await _context.Stories.Select(s => new { s.StoryPrice, }).OrderByDescending(s => s.StoryPrice).ToListAsync();
            var to = stories.Max(c => c.StoryPrice);
            var from = stories.Min(c => c.StoryPrice);
            var status = new List<object>
                {
                    new { Name = "Hoàn thành", Value = 2 },
                    new { Name = "Chưa hoàn thành", Value = 1 }
                };

            return _msgService.MsgReturn(0, "Trường tìm kiếm", new { cate, to, from, status });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutCategory(int id, Category category)
        {
            if (id != category.CategoryId)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Không tìm thấy thể loại!"
                });
            }
            if (category.CategoryName == "" || category.CategoryName == null)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Tên thể loại không được để trống!"
                });
            }

            _context.Entry(category).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch
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
                EM = "Cập nhật thể loại thành công!"
            });
        }

        public class addCategoryForm
        {
            public string? CategoryName { get; set; }

            public string? CategoryBanner { get; set; }

            public string? CategoryDescription { get; set; }
        }

        [HttpPost("addCategory")]
        public async Task<ActionResult> addCategory(addCategoryForm category)
        {
            if (category.CategoryName == "" || category.CategoryName == null )
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Tên thể loại không được để trống"
                });
            }
            if ((_context.Categories?.Any(e => e.CategoryName == category.CategoryName)).GetValueOrDefault())
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Thể loại đã tồn tại"
                });
            }
            try
            {
                Category c = new Category()
                {
                    CategoryName = category.CategoryName,
                    CategoryBanner = category.CategoryBanner,
                    CategoryDescription = category.CategoryDescription,
                };
                _context.Categories.Add(c);
                await _context.SaveChangesAsync();

            }
            catch
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
                EM = "Thêm thể loại thành công"
            });
        }

    }
}
