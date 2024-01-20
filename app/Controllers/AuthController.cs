using app.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace app.Controllers
{
    [Route("api/v1/auth")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private readonly IConfiguration _configuration;

        public AuthController(EasyPublishingContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

      
        public class LoginModal
        {
            public string email { get; set; }
            public string password { get; set; }
        }

        public class UserDTO
        {
            public int Id { get; set; }

            public string? Email { get; set; }

            public string? Username { get; set; }

            public string? FullName { get; set; }

            public string? Gender { get; set; }

            public string? Address { get; set; }

            public DateTime? Dob { get; set; }

            public string? Role { get; set; }
        }

        public class RegisterModal
        {
            public string email { get; set; }
            public string password { get; set; }
            public string username { get; set; }
            public string fullName { get; set; }
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginModal data)
        {
            if (string.IsNullOrEmpty(data.email) || string.IsNullOrEmpty(data.password))
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Missing parameters",
                });
            }
            var user = _context.Users.Where(u => u.Email.Equals(data.email) && u.Password.Equals(data.password)).Select(u => new
            {
                //id = u.Id,
                //email = u.Email,
                //username = u.Username,
                //fullName = u.FullName,
                //gender = u.Gender == true ? "Male" : "Female",
                //dob = u.Dob,
                //address = u.Address,
                //role = u.Role.Name,
            }).FirstOrDefault();
            if (user == null)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Wrong email or password",
                });
            }
            UserDTO userDTO = new UserDTO
            {
                //Id = user.id,
                //Email = user.email,
                //Username = user.username,
                //FullName = user.fullName,
                //Gender = user.gender,
                //Dob = user.dob,
                //Address = user.address,
                //Role = user.role,
            };
            var token = CreateToken(userDTO);
            var cookieOptions = new CookieOptions();
            cookieOptions.Expires = DateTime.Now.AddDays(1);
            cookieOptions.HttpOnly = true;
            Response.Cookies.Append("access_token", token, cookieOptions);
            return new JsonResult(new
            {
                EC = 0,
                EM = "Login successfully",
                DT = new
                {
                    user,
                    access_token = token,
                },
            });
        }

        [HttpPost("register")]
        public IActionResult Register([FromBody] RegisterModal data)
        {
            if (string.IsNullOrEmpty(data.email) || string.IsNullOrEmpty(data.password) || string.IsNullOrEmpty(data.username))
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Missing parameters",
                });
            }
            var user = _context.Users.Where(u => u.Email.Equals(data.email)).FirstOrDefault();
            if (user != null)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "This email is already in use by another account",
                });
            }
            _context.Users.Add(new User
            {
                Email = data.email,
                Password = data.password,
                UserName = data.username,
                //FullName = !string.IsNullOrEmpty(data.fullName) ? data.fullName : null,
                //RoleId = 1,
                Gender = true
            });
            _context.SaveChanges();
            return new JsonResult(new
            {
                EC = 0,
                EM = "Register successfully",
            });
        }

        [HttpPost("logout")]
        public IActionResult Logout()
        {
            Response.Cookies.Delete("access_token");
            return new JsonResult(new
            {
                EC = 0,
                EM = "Logout successfully"
            });
        }

        private string CreateToken(UserDTO user)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                new Claim("id", user.Id.ToString()),
                new Claim("email", user.Email),
                new Claim("fullName", user.FullName),
                new Claim("userName", user.Username),
                new Claim("gender", user.Gender),
                new Claim("dob", user.Dob.ToString()),
                new Claim("address", user.Address),
                new Claim("role", user.Role),
    }),
                Issuer = _configuration.GetSection("JWTConfig:Issuer").Value!,
                Audience = _configuration.GetSection("JWTConfig:Audience").Value!,
                Expires = DateTime.UtcNow.AddHours(Int32.Parse(_configuration.GetSection("JWTConfig:Time").Value!)),
                SigningCredentials = new SigningCredentials(
    new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration.GetSection("JWTConfig:Key").Value!)),
    SecurityAlgorithms.HmacSha256)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);

            // Serialize token to string
            string jwt = tokenHandler.WriteToken(token);
            return jwt;
        }

        private string extractToken()
        {
            if (!String.IsNullOrEmpty(Request.Headers.Authorization) && Request.Headers.Authorization.ToString().Split(' ')[0] == "Bearer" && !String.IsNullOrEmpty(Request.Headers.Authorization.ToString().Split(' ')[1]))
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

        [HttpGet("account")]
        public IActionResult GetAccount()
        {
            UserDTO userDTO = null;
            try
            {
                var jwtSecurityToken = VerifyToken();
                userDTO = new UserDTO
                {
                    Id = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "id").Value),
                    Email = jwtSecurityToken.Claims.First(c => c.Type == "email").Value,
                    Username = jwtSecurityToken.Claims.First(c => c.Type == "userName").Value,
                    FullName = jwtSecurityToken.Claims.First(c => c.Type == "fullName").Value,
                    Gender = jwtSecurityToken.Claims.First(c => c.Type == "gender").Value,
                    Dob = DateTime.Parse(jwtSecurityToken.Claims.First(c => c.Type == "dob").Value),
                    Address = jwtSecurityToken.Claims.First(c => c.Type == "address").Value,
                    Role = jwtSecurityToken.Claims.First(c => c.Type == "role").Value,
                };
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Not authenticated"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Get account successfully",
                DT = new
                {
                    user = userDTO,
                    access_token = Request.Cookies["access_token"],
                },
            });
        }
    }
}
