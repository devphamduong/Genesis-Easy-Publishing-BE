using Microsoft.AspNetCore.Mvc;

namespace app.Controllers
{
    public class AdminController : Controller
    {
        public IActionResult User()
        {
            return View();
        }

        public IActionResult Report()
        {
            return View();
        }

        public IActionResult Story()
        {
            return View();
        }

        public IActionResult Transaction()
        {
            return View();
        }

        public IActionResult Category()
        {
            return View();
        }


    }
}
