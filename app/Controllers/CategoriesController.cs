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
                    c.CategoryDescription,
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
                    c.CategoryName,
                    c.CategoryDescription,
                    c.CategoryBanner
                })
                .ToListAsync();
            if (cate == null) return _msgService.MsgReturn(-1, "Không có loại đó", null);
            return _msgService.MsgReturn(0, "Chi tiết thể loại", cate);
        }
        [HttpGet("{id}")]
        public async Task<ActionResult<Category>> GetUser(int id)
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
                    EM = "Id Categories  is null"
                });
            }
            if (category.CategoryName == "" || category.CategoryName == null)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Categories  is null"
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
                    EM = "Can't update category"
                });
            }

            return new JsonResult(new
            {
                EC = 0,
                EM = "Update category successfully"
            });
        }

        [HttpPost]
        public async Task<ActionResult<Category>> PostCategory(Category category)
        {
            if (category.CategoryName == "" || category.CategoryName == null || _context.Categories == null)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Categories  is null"
                });
            }
            if ((_context.Categories?.Any(e => e.CategoryName == category.CategoryName)).GetValueOrDefault())
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Categories already exist"
                });
            }
            try
            {
                _context.Categories.Add(category);
                await _context.SaveChangesAsync();

            }
            catch
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Can't save category"
                });
            }


            return new JsonResult(new
            {
                EC = 0,
                EM = "Save category successfully"
            });
        }

        //// GET: api/Categories/5
        //[HttpGet("{id}")]
        //public async Task<ActionResult<Category>> GetCategory(int id)
        //{
        //    if (_context.Categories == null)
        //    {
        //        return NotFound();
        //    }
        //    var category = await _context.Categories.FindAsync(id);

        //    if (category == null)
        //    {
        //        return NotFound();
        //    }

        //    return category;
        //}

        //// PUT: api/Categories/5
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPut("{id}")]
        //public async Task<IActionResult> PutCategory(int id, Category category)
        //{
        //    if (id != category.CategoryId)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(category).State = EntityState.Modified;

        //    try
        //    {
        //        await _context.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!CategoryExists(id))
        //        {
        //            return NotFound();
        //        }
        //        else
        //        {
        //            throw;
        //        }
        //    }

        //    return NoContent();
        //}

        //// POST: api/Categories
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPost]
        //public async Task<ActionResult<Category>> PostCategory(Category category)
        //{
        //    if (_context.Categories == null)
        //    {
        //        return Problem("Entity set 'EasyPublishingContext.Categories'  is null.");
        //    }
        //    _context.Categories.Add(category);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("GetCategory", new { id = category.CategoryId }, category);
        //}

        //// DELETE: api/Categories/5
        //[HttpDelete("{id}")]
        //public async Task<IActionResult> DeleteCategory(int id)
        //{
        //    if (_context.Categories == null)
        //    {
        //        return NotFound();
        //    }
        //    var category = await _context.Categories.FindAsync(id);
        //    if (category == null)
        //    {
        //        return NotFound();
        //    }

        //    _context.Categories.Remove(category);
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}

        //private bool CategoryExists(int id)
        //{
        //    return (_context.Categories?.Any(e => e.CategoryId == id)).GetValueOrDefault();
        //}
    }
}
