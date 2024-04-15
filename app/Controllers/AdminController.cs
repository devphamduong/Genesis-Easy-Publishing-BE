using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    public class AdminController : Controller
    {

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

        [AllowAnonymous]
        public IActionResult Login()
        {
            return View();
        }
        public IActionResult User()
        {
            if (GetUserId() == 0) return RedirectToAction("Login");
            return View();
        }
        public IActionResult Dashboard()
        {
            if (GetUserId() == 0) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Report()
        {
            if (GetUserId() == 0) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Story()
        {
            if (GetUserId() == 0) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Transaction()
        {
            if (GetUserId() == 0) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Category()
        {
            if (GetUserId() == 0) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Ticket()
        {
            if (GetUserId() == 0) return RedirectToAction("Login");
            return View();
        }

        public IActionResult Review()
        {
            if (GetUserId() == 0) return RedirectToAction("Login");
            return View();
        }
    }
}
