using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SHOPii.Models;

namespace SHOPii.Controllers.API
{
    [Route("api/[controller]")]
    [ApiController]
    public class ShopAccountsController : ControllerBase
    {
        private readonly SHOPIIContext _context;

        public ShopAccountsController(SHOPIIContext context)
        {
            _context = context;
        }

        // GET: api/ShopAccounts
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ShopAccount>>> GetShopAccount()
        {
            return await _context.ShopAccount.ToListAsync();
        }

        // GET: api/ShopAccounts/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ShopAccount>> GetShopAccount(string id)
        {
            var shopAccount = await _context.ShopAccount.FindAsync(id);

            if (shopAccount == null)
            {
                return NotFound();
            }

            return shopAccount;
        }

        // PUT: api/ShopAccounts/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutShopAccount(string id, ShopAccount shopAccount)
        {
            if (id != shopAccount.Username)
            {
                return BadRequest();
            }

            _context.Entry(shopAccount).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ShopAccountExists(id))
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

        // POST: api/ShopAccounts
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<ShopAccount>> PostShopAccount(ShopAccount shopAccount)
        {
            _context.ShopAccount.Add(shopAccount);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (ShopAccountExists(shopAccount.Username))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetShopAccount", new { id = shopAccount.Username }, shopAccount);
        }

        // DELETE: api/ShopAccounts/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<ShopAccount>> DeleteShopAccount(string id)
        {
            var shopAccount = await _context.ShopAccount.FindAsync(id);
            if (shopAccount == null)
            {
                return NotFound();
            }

            _context.ShopAccount.Remove(shopAccount);
            await _context.SaveChangesAsync();

            return shopAccount;
        }

        private bool ShopAccountExists(string id)
        {
            return _context.ShopAccount.Any(e => e.Username == id);
        }
    }
}
