﻿using app.Models;
using app.Service;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
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
        private HashService hashService = new HashService();
        private MailService mailService = new MailService();

        public AuthController(EasyPublishingContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }


        public class LoginForm
        {
            public string username { get; set; }
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

            public string? Dob { get; set; }

            public string? Phone { get; set; }

            public string? UserImage { get; set; }

            public int? Status { get; set; }
            //public string? Role { get; set; }
        }

        public class RegisterForm
        {
            public string email { get; set; }
            public string password { get; set; }
            public string username { get; set; }
            public string fullName { get; set; }
        }
        public class ResetPasswordForm
        {
            public string token { get; set; }
            public string password { get; set; }
            public string confirmPassword { get; set; }
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginForm data)
        {
            if (string.IsNullOrEmpty(data.username) || string.IsNullOrEmpty(data.password))
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Missing parameters",
                });
            }
            var user = _context.Users.Where(u => u.Username.Equals(data.username)).Select(u => new
            {
                id = u.UserId,
                email = u.Email,
                username = u.Username,
                password = u.Password,
                fullName = u.UserFullname,
                gender = u.Gender == true ? "Male" : "Female",
                dob = u.Dob,
                address = u.Address,
                phone = u.Phone,
                status = u.Status == true ? 1 : 0,
                userImage = u.UserImage
            }).FirstOrDefault();
            if (user == null || !hashService.Verify(user.password, data.password))
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Wrong username or password",
                });
            }
            UserDTO userDTO = new UserDTO
            {
                Id = user.id,
                Email = user.email,
                Username = user.username,
                FullName = user.fullName,
                Gender = user.gender,
                Dob = user.dob.ToString(),
                Address = user.address,
                Phone = user.phone,
                Status = user.status,
                UserImage = user.userImage
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
        public IActionResult Register([FromBody] RegisterForm data)
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
            user = _context.Users.Where(u => u.Username.Equals(data.username)).FirstOrDefault();
            if (user != null)
            {
                return new JsonResult(new
                {
                    EC = 3,
                    EM = "This username is already in use by another account",
                });
            }
            string passwordHash = hashService.Hash(data.password);
            _context.Users.Add(new User
            {
                Email = data.email,
                Password = passwordHash,
                Username = data.username,
                UserFullname = !string.IsNullOrEmpty(data.fullName) ? data.fullName : null,
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
                new Claim("dob", !string.IsNullOrEmpty(user.Dob) ? user.Dob : ""),
                new Claim("address", !string.IsNullOrEmpty(user.Address) ? user.Address : ""),
                new Claim("phone", !string.IsNullOrEmpty(user.Phone) ? user.Phone : ""),
                new Claim("status", user.Status.ToString()),
                new Claim("userImage", !string.IsNullOrEmpty(user.UserImage) ? user.UserImage : ""),
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

        private string CreateForgotPasswordToken(string email)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                new Claim("email", email)
                }),
                Issuer = _configuration.GetSection("JWTConfig:Issuer").Value!,
                Audience = _configuration.GetSection("JWTConfig:Audience").Value!,
                Expires = DateTime.UtcNow.AddHours(6),
                SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration.GetSection("JWTConfig:Key").Value!)),
                    SecurityAlgorithms.HmacSha256)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);

            string jwt = tokenHandler.WriteToken(token);
            return jwt;
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

        [HttpGet("account")]
        public IActionResult GetAccount()
        {
            var jwtSecurityToken = new JwtSecurityToken();
            UserDTO userDTO = null;
            try
            {
                jwtSecurityToken = VerifyToken();
                userDTO = new UserDTO
                {
                    Id = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "id").Value),
                    Email = jwtSecurityToken.Claims.First(c => c.Type == "email").Value,
                    Username = jwtSecurityToken.Claims.First(c => c.Type == "userName").Value,
                    FullName = jwtSecurityToken.Claims.First(c => c.Type == "fullName").Value,
                    Gender = jwtSecurityToken.Claims.First(c => c.Type == "gender").Value,
                    Dob = jwtSecurityToken.Claims.First(c => c.Type == "dob").Value,
                    Address = jwtSecurityToken.Claims.First(c => c.Type == "address").Value,
                    Phone = jwtSecurityToken.Claims.First(c => c.Type == "phone").Value,
                    Status = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "status").Value),
                    UserImage = jwtSecurityToken.Claims.First(c => c.Type == "userImage").Value,
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
                    jwt = jwtSecurityToken
                },
            });
        }

        [HttpPost("forgot_password")]
        public IActionResult SendMailConfirm(string email)
        {
            var user = _context.Users.Where(u => u.Email.Equals(email)).FirstOrDefault();
            if (user == null)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "This email is not registered",
                });
            }
            try
            {
                string token = CreateForgotPasswordToken(email);
                mailService.Send(email, "Easy Publishing: Reset password", "<p>Click on the link below to reset your password:</p>\r\n<a href=\"https://genesis-easy-publishing.vercel.app/reset-password/" + token +"\">Reset password</a>");
            }
            catch (Exception ex)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Error: " + ex.Message,
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "We have sent an email to your registered email address, Please follow the instructions to reset your password",
            });
        }
        [HttpPost("reset_password")]
        public IActionResult ResetPassword([FromBody] ResetPasswordForm data)
        {
            var handler = new JwtSecurityTokenHandler();
            try
            {
                var token = handler.ReadJwtToken(data.token);
                string email = token.Claims.First(c => c.Type == "email").Value;
                var user = _context.Users.FirstOrDefault(u => u.Email.Equals(email));
                if (user == null)
                {
                    return new JsonResult(new
                    {
                        EC = 1,
                        EM = "User does not exist"
                    });
                }
                if (!data.password.Equals(data.confirmPassword))
                {
                    return new JsonResult(new
                    {
                        EC = 2,
                        EM = "Confirm password must match password"
                    });
                }
                user.Password = hashService.Hash(data.password);
                _context.SaveChanges();
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
                EM = "Reset password successfully",
            });
        }
    }
}
