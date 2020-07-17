using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using SHOPii.Models;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using static SHOPii.Services.IUserService;

namespace SHOPii.Services
{
    public interface IUserService
    {
        public UserEntities AuthUser(string username, string password);
        public IEnumerable<UserEntities> getAll();
        public UserEntities getUser(string username);

        public class UserEntities
        {
            public Account account;
            public String Role;
            public string Token { set; get; }

            public UserEntities(Account account)
            {
                this.account = account;
            }

            public UserEntities withOutPassword()
            {
                UserEntities temp = this;
                temp.account.Password = null;
                return temp;
            }
        }
     
    }

    public class UserService : IUserService
    {
        public static string KEY = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build().GetSection("SecurityKey")["SymmetricSecurityKey"];
        SHOPIIContext context = new SHOPIIContext();
        

        public UserEntities AuthUser(string username, string password)
        {
            List<UserEntities> LIST_USERS = context.Account.Include(a=>a.Favorite).Include(a=>a.DeliveryAddress).Select(u => new UserEntities(u)).ToList();
            var user = LIST_USERS.FirstOrDefault(u => u.account.Username.Equals(username) && u.account.Password.Equals(password));
            if (user == null)
            {
                return null;
            }
            user.Role = "test";


            List<Claim> lstClaim = new List<Claim>(); //CLAIM USER INFO
            lstClaim.Add(new Claim(ClaimTypes.Name, user.account.Username));
            lstClaim.Add(new Claim(ClaimTypes.Role, user.Role));


            //CREATE JWT TOKEN
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(KEY);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(lstClaim.ToArray()),
                Expires = DateTime.UtcNow.AddHours(1),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)

            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            user.Token = tokenHandler.WriteToken(token);

            return user.withOutPassword();
        }

        public List<Account> getAllAccounts()
        {
            return  context.Account.ToList();
        }

        public IEnumerable<UserEntities> getAll()
        {
            throw new NotImplementedException();
        }

        public UserEntities getUser(string username)
        {
            throw new NotImplementedException();
        }
    }
}
