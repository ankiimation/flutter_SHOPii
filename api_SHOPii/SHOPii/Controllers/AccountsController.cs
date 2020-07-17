using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SHOPii.Models;
using SHOPii.Services;

namespace SHOPii.Controllers
{
    [Route("api")]

    [ApiController]
    [Authorize]
    public class AccountsController : ControllerBase
    {
        private IUserService userService;
        private static SHOPIIContext _context = new SHOPIIContext();

        public AccountsController(IUserService userService)
        {
            this.userService = userService;
        }


        public class LoginInputModel
        {
            public String username;
            public String password;

            public LoginInputModel(string username, string password)
            {
                this.username = username;
                this.password = password;
            }
        }
        [AllowAnonymous]
        [HttpPost("login")]
        public IActionResult login([FromBody] LoginInputModel loginModel)
        {

            var userTemp = userService.AuthUser(loginModel.username, loginModel.password);

            if (userTemp == null)
                return BadRequest(new { message = "Sai thông tin đăng cmn nhập" });
            return Ok(userTemp);

        }
        //[AllowAnonymous]
        //public  IActionResult getAllAccount() 
        //{
        //    return Ok((new UserService()).getAllAccounts());
        //}

    }
}
