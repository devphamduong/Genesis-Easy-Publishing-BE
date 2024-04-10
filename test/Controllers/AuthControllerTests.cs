using app.Controllers;
using app.Models;
using app.Service;
using FakeItEasy;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static app.Controllers.AuthController;

namespace Genesis_Easy_Publishing_BE.Tests.Controllers
{

    public class AuthControllerTests 
    {
        private readonly EasyPublishingContext _context;
        private readonly IConfiguration _configuration;

        public AuthControllerTests()
        {
            _context = new  EasyPublishingContext();
            _configuration = A.Fake<IConfiguration>();
        }
      


    }
}
