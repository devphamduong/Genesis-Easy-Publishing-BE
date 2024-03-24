using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using app.Models;
using app.Service;

namespace app.Controllers
{
    [Route("api/v1/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private int pageSize = 10;

        public UsersController(EasyPublishingContext context)
        {
            _context = context;
        }

        [HttpPut("SwitchStatus")]
        public async Task<ActionResult> SwitchStatus(string email)
        {
            var user = await _context.Users.FirstOrDefaultAsync(x => x.Email == email);
            try
            {
                user.Status = !user.Status;
                _context.Entry(user).State = EntityState.Modified;
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            return Ok(user);
        }

        [HttpGet("getAllUser")]
        public async Task<ActionResult> GetAllUsers()
        {
            var users = await _context.Users.Where(u => u.UserId > 0)
               .Include(u => u.Wallets)
               .Include(u => u.Stories)
               .Select(u => new
               {
                   UserId = u.UserId,
                   UserFullName = u.UserFullname,
                   Email = u.Email,
                   Phone = u.Phone,
                   UserName = u.Username,
                   PassWord = u.Password,
                   DoB = u.Dob.ToString(),
                   UserImage = u.UserImage,
                   Status = u.Status,
                   Address = u.Address,
                   Wallets = u.Wallets.ToList(),
               })
               .OrderBy(s => s.UserId) // top famous compare
               .ToListAsync();
            return _msgService.MsgReturn(0, "success", users);
        }

        // GET: api/Users
        [HttpGet]
        public async Task<ActionResult> GetUsers(int page)
        {
            var users = await _context.Users.Where(u => u.UserId > 0)
               .Include(u => u.Wallets)
               .Include(u => u.Stories)
               .Select(u => new
               {
                   UserId = u.UserId,
                   UserFullName = u.UserFullname,
                   Email = u.Email,
                   Phone = u.Phone,
                   UserName = u.Username,
                   PassWord = u.Password,
                   DoB = u.Dob.ToString(),
                   UserImage = u.UserImage,
                   Status = u.Status,
                   Address = u.Address,
                   Wallets = u.Wallets.ToList(),

               })
               .OrderBy(s => s.UserId) // top famous compare
               .ToListAsync();
            return _msgService.MsgPagingReturn("Get All Users successfully",
                users.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, users.Count);
        }


        // GET: api/Users/5
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            if (_context.Users == null)
            {
                return NotFound();
            }
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

        // PUT: api/Users/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(int id, User user)
        {
            if (id != user.UserId)
            {
                return BadRequest();
            }

            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Users
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<User>> PostUser(User user)
        {
            if (_context.Users == null)
            {
                return Problem("Entity set 'EasyPublishingContext.Users'  is null.");
            }
            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUser", new { id = user.UserId }, user);
        }

        // DELETE: api/Users/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            if (_context.Users == null)
            {
                return NotFound();
            }
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UserExists(int id)
        {
            return (_context.Users?.Any(e => e.UserId == id)).GetValueOrDefault();
        }
    }
}
