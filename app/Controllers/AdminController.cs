using app.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    public class AdminController : Controller
    {
        private readonly EasyPublishingContext _context;
        public AdminController(EasyPublishingContext context)
        {
            _context = context;
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

        private JwtSecurityToken VerifyToken()
        {
            var tokenCookie = Request.Cookies["access_token"];
            var tokenBearer = extractToken();
            var handler = new JwtSecurityTokenHandler();
            var jwtSecurityToken = handler.ReadJwtToken(!String.IsNullOrEmpty(tokenBearer) ? tokenBearer : tokenCookie);
            return jwtSecurityToken;
        }

        private bool CheckAdmin()
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }
            if(userId == 0)
            {
                return false;
            }
            var user = _context.Users.FirstOrDefault(u => u.UserId == userId);
            if (user.RoleId != 1) return false;
            return true;
        }

        [AllowAnonymous]
        public IActionResult Login()
        {
            return View();
        }
        public IActionResult User()
        {
            if (!CheckAdmin()) return RedirectToAction("Login");
            return View();
        }
        public IActionResult Dashboard()
        {
            if (!CheckAdmin()) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Report()
        {
            if (!CheckAdmin()) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Story()
        {
            if (!CheckAdmin()) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Transaction()
        {
            if (!CheckAdmin()) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Category()
        {
            if (!CheckAdmin()) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Ticket()
        {
            if (!CheckAdmin()) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Review()
        {
            if (!CheckAdmin()) return RedirectToAction("Login");
            return View();
        }
    }
}
