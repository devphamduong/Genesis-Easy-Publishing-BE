﻿using app.DTOs;
using app.Models;
using app.Service;
using Azure.Core;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
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
            public string EmailOrUsername { get; set; }
            public string Password { get; set; }
            public bool Remember { get; set; }
        }

        public class RegisterForm
        {
            public string Email { get; set; }
            public string Username { get; set; }
            public string Password { get; set; }
            public string ConfirmPassword { get; set; }
        }

        public class ForgotPasswordForm
        {
            public string Email { get; set; }
        }

        public class ResetPasswordForm
        {
            public string Token { get; set; }
            public string Password { get; set; }
            public string ConfirmPassword { get; set; }
        }

        public class ChangePasswordForm
        {
            public string OldPassword { get; set; }
            public string Password { get; set; }
            public string ConfirmPassword { get; set; }
        }

        public class UserProfileForm
        {
            public string? UserFullname { get; set; }
            public string? Gender { get; set; }
            public DateTime? Dob { get; set; }
            public string? Phone { get; set; }
            public string? Address { get; set; }
            public string? DescriptionMarkdown { get; set; }
            public string? DescriptionHTML { get; set; }
        }

        public class AvatarForm
        {
            public IFormFile image { get; set; }
        }

        public class VerifyTokenForm
        {
            public string Token { get; set; }
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginForm data)
        {
            if (string.IsNullOrEmpty(data.EmailOrUsername) || string.IsNullOrEmpty(data.Password))
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Missing parameters",
                });
            }
            var user = _context.Users.Where(u => u.Username.Equals(data.EmailOrUsername) || u.Email.Equals(data.EmailOrUsername)).FirstOrDefault();
            if (user == null)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Wrong username or password",
                });
            };
            string password = user.Password;
            var userResponse = _context.Users.Where(u => u.Username.Equals(data.EmailOrUsername) || u.Email.Equals(data.EmailOrUsername)).Select(u => new
            {
                UserId = u.UserId,
                Email = u.Email,
                Username = u.Username,
                UserFullname = u.UserFullname,
                Gender = u.Gender == true ? "Male" : "Female",
                Dob = u.Dob,
                Address = u.Address,
                Phone = u.Phone,
                Status = u.Status == true ? "Active" : "Inactive",
                UserImage = u.UserImage,
                DescriptionMarkdown = u.DescriptionMarkdown,
                DescriptionHTML = u.DescriptionHtml
            }).FirstOrDefault();
            if (!hashService.Verify(password, data.Password))
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Wrong username or password",
                });
            }
            UserDTO userDTO = new UserDTO
            {
                Id = userResponse.UserId,
                Email = userResponse.Email,
                Username = userResponse.Username,
            };
            var accessToken = CreateToken(userDTO);
            var cookieOptions = new CookieOptions();
            cookieOptions.Expires = DateTime.Now.AddDays(1);
            cookieOptions.HttpOnly = true;
            Response.Cookies.Append("access_token", accessToken, cookieOptions);
            if (data.Remember)
            {
                var rememberToken = CreateRememberLoginToken(data.EmailOrUsername, data.Password);
                cookieOptions.Expires = DateTime.Now.AddDays(30);
                Response.Cookies.Append("remember_token", rememberToken, cookieOptions);
            }
            else
            {
                Response.Cookies.Delete("remember_token");
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Login successfully",
                DT = new
                {
                    user = userResponse,
                    access_token = accessToken,
                },
            });
        }

        [HttpPost("register")]
        public IActionResult Register([FromBody] RegisterForm data)
        {
            if (string.IsNullOrEmpty(data.Email) || string.IsNullOrEmpty(data.Password) || string.IsNullOrEmpty(data.Username))
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Missing required fields",
                });
            }
            var user = _context.Users.Where(u => u.Email.Equals(data.Email)).FirstOrDefault();
            if (user != null)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "This email is already in use by another account",
                });
            }
            user = _context.Users.Where(u => u.Username.Equals(data.Username)).FirstOrDefault();
            if (user != null)
            {
                return new JsonResult(new
                {
                    EC = 3,
                    EM = "This username is already in use by another account",
                });
            }
            if (!data.Password.Equals(data.ConfirmPassword))
            {
                return new JsonResult(new
                {
                    EC = 4,
                    EM = "Confirm password must match password"
                });
            }
            string passwordHash = hashService.Hash(data.Password);
            _context.Users.Add(new User
            {
                Email = data.Email,
                Password = passwordHash,
                Username = data.Username,
                Gender = true
            });
            _context.SaveChanges();
            _context.Wallets.Add(new Wallet
            {
                UserId = _context.Users.FirstOrDefault(u => u.Username.Equals(data.Username)).UserId,
                Fund = 0,
                Refund = 0
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
                new Claim("userId", user.Id.ToString()),
                new Claim("email", user.Email),
                new Claim("username", user.Username),
                }),
                Issuer = _configuration.GetSection("JWTConfig:Issuer").Value!,
                Audience = _configuration.GetSection("JWTConfig:Audience").Value!,
                Expires = DateTime.UtcNow.AddDays(Int32.Parse(_configuration.GetSection("JWTConfig:Time").Value!)),
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
                Expires = DateTime.UtcNow.AddHours(24),
                SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration.GetSection("JWTConfig:Key").Value!)),
                    SecurityAlgorithms.HmacSha256)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);

            string jwt = tokenHandler.WriteToken(token);
            return jwt;
        }

        private string CreateRememberLoginToken(string emailOrUsername, string password)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                new Claim("emailOrUsername", emailOrUsername),
                new Claim("password", password)
                }),
                Issuer = _configuration.GetSection("JWTConfig:Issuer").Value!,
                Audience = _configuration.GetSection("JWTConfig:Audience").Value!,
                Expires = DateTime.UtcNow.AddDays(30),
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
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var user = _context.Users.Where(u => u.UserId == userId)
                    .Select(u => new
                    {
                        UserId = u.UserId,
                        Email = u.Email,
                        Username = u.Username,
                        UserFullname = u.UserFullname,
                        Gender = u.Gender == true ? "Male" : "Female",
                        Dob = u.Dob,
                        Address = u.Address,
                        Phone = u.Phone,
                        Status = u.Status == true ? "Active" : "Inactive",
                        UserImage = u.UserImage,
                        DescriptionMarkdown = u.DescriptionMarkdown,
                        DescriptionHTML = u.DescriptionHtml
                    }).FirstOrDefault();
                return new JsonResult(new
                {
                    EC = 0,
                    EM = "Get account successfully",
                    DT = new
                    {
                        user = user
                    },
                });
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Not authenticated"
                });
            }
        }

        [HttpPost("forgot_password")]
        public IActionResult SendMailConfirm([FromBody] ForgotPasswordForm data)
        {
            var user = _context.Users.Where(u => u.Email.Equals(data.Email)).FirstOrDefault();
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
                string token = CreateForgotPasswordToken(data.Email);
                mailService.Send(data.Email,
                        "Easy Publishing: Reset password",
                        "<b>Hi " + user.Username + ",</b>" +
                        "<p>There was a request to reset your password! </p> " +
                        "<p>If you did not make this request then please ignore this email.</p> " +
                        "<p>Otherwise, please click this link to reset your password:</p> " +
                        "<a href =\"http://localhost:3000/auth/reset-password?token=" + token + "\">Reset password</a>");
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
            string email;
            var handler = new JwtSecurityTokenHandler();
            try
            {
                var token = handler.ReadJwtToken(data.Token);
                email = token.Claims.First(c => c.Type == "email").Value;
                var user = _context.Users.FirstOrDefault(u => u.Email.Equals(email));
                if (user == null)
                {
                    return new JsonResult(new
                    {
                        EC = 1,
                        EM = "User does not exist"
                    });
                }
                if (!data.Password.Equals(data.ConfirmPassword))
                {
                    return new JsonResult(new
                    {
                        EC = 2,
                        EM = "Confirm password must match password"
                    });
                }
                user.Password = hashService.Hash(data.Password);

                try
                {
                    mailService.Send(email,
                        "Easy Publishing: Reset password",
                        "<b>Hi " + user.Username + ",</b>" +
                        "<p>Your password has been reset successfully!</p> " +
                        "<p>Your new password is: <b>" + data.Password + "</b></p>");
                }
                catch (Exception ex)
                {
                    return new JsonResult(new
                    {
                        EC = 3,
                        EM = "Error: " + ex.Message,
                    });
                }
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
                DT = new
                {
                    email = email
                }
            });
        }

        [HttpPost("change_password")]
        public IActionResult ChangePassword([FromBody] ChangePasswordForm data)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            UserDTO userDTO = null;
            try
            {
                jwtSecurityToken = VerifyToken();
                string userId = jwtSecurityToken.Claims.First(c => c.Type == "userId").Value;
                var user = _context.Users.FirstOrDefault(u => u.UserId == int.Parse(userId));
                if (!hashService.Verify(user.Password, data.OldPassword))
                {
                    return new JsonResult(new
                    {
                        EC = 1,
                        EM = "Wrong password"
                    });
                }
                if (!data.Password.Equals(data.ConfirmPassword))
                {
                    return new JsonResult(new
                    {
                        EC = 2,
                        EM = "Confirm password must match password"
                    });
                }
                user.Password = hashService.Hash(data.Password);
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
                EM = "Change password successfully",
            });
        }

        [HttpPut("update_profile")]
        public IActionResult EditProfile([FromBody] UserProfileForm data)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            string accessToken = null;
            try
            {
                jwtSecurityToken = VerifyToken();
                string userId = jwtSecurityToken.Claims.First(c => c.Type == "userId").Value;
                var user = _context.Users.FirstOrDefault(u => u.UserId == int.Parse(userId));
                user.UserFullname = data.UserFullname;
                user.Address = data.Address;
                user.Phone = data.Phone;
                user.Dob = data.Dob;
                if (data.Gender.ToLower().Equals("male"))
                {
                    user.Gender = true;
                }
                else
                {
                    user.Gender = false;
                }
                user.DescriptionMarkdown = data.DescriptionMarkdown;
                user.DescriptionHtml = data.DescriptionHTML;
                _context.SaveChanges();

                UserDTO userDTO = new UserDTO
                {
                    Id = user.UserId,
                    Email = user.Email,
                    Username = user.Username,
                };
                accessToken = CreateToken(userDTO);
                var cookieOptions = new CookieOptions();
                cookieOptions.Expires = DateTime.Now.AddDays(1);
                cookieOptions.HttpOnly = true;
                Response.Cookies.Append("access_token", accessToken, cookieOptions);
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
                EM = "Save profile successfully",
                DT = new
                {
                    access_token = accessToken
                }
            });
        }

        [HttpPut("update_avatar")]
        public IActionResult ChangeAvatar([FromForm] AvatarForm data)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                string userId = jwtSecurityToken.Claims.First(c => c.Type == "userId").Value;
                var user = _context.Users.FirstOrDefault(u => u.UserId == int.Parse(userId));
                if (data.image.Length > 0)
                {
                    string relativePath = "Assets/images/avatar/";
                    string path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/Assets/images/avatar");
                    if (!Directory.Exists(path))
                        Directory.CreateDirectory(path);
                    string fileName = Path.GetFileName(data.image.FileName);
                    string filePath = Path.Combine(path, fileName);
                    using (FileStream stream = new FileStream(filePath, FileMode.Create))
                    {
                        data.image.CopyTo(stream);
                    }
                    user.UserImage = Path.Combine(relativePath, fileName); ;
                    _context.SaveChanges();
                }
                else
                {
                    return new JsonResult(new
                    {
                        EC = 1,
                        EM = "File not found"
                    });
                }
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
                EM = "Save avatar successfully"
            });
        }

        [HttpPost("verify_token")]
        public IActionResult VerifyToken([FromBody] VerifyTokenForm data)
        {
            string token = data.Token;
            if (string.IsNullOrEmpty(token))
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "The token is invalid"
                });
            }
            var tokenHandler = new JwtSecurityTokenHandler();
            var jwtToken = tokenHandler.ReadJwtToken(token);
            DateTime expirationDate = jwtToken.ValidTo;
            if (DateTime.UtcNow < expirationDate)
            {
                return new JsonResult(new
                {
                    EC = 0,
                    EM = "The token is valid",
                });
            }
            else
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "The token has expired",
                });
            }
        }
    }
}