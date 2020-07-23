using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SHOPii.Models;

namespace SHOPii.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class DeliveryAddressesController : ControllerBase
    {
        private readonly SHOPIIContext _context;

        public DeliveryAddressesController(SHOPIIContext context)
        {
            _context = context;
        }

        // GET: api/DeliveryAddresses
        [HttpGet]
        public async Task<ActionResult<IEnumerable<DeliveryAddress>>> GetDeliveryAddress()
        {
            var username = User.Identity.Name;
            return await _context.DeliveryAddress.Where(d => d.Username.Equals(username)).ToListAsync();
        }

        // GET: api/DeliveryAddresses/5
        [HttpGet("{id}")]
        public async Task<ActionResult<DeliveryAddress>> GetDeliveryAddress(int id)
        {
            var username = User.Identity.Name;
            var deliveryAddress = await _context.DeliveryAddress.Where(d => d.Username.Equals(username)).FirstOrDefaultAsync(d => d.Id == id);

            if (deliveryAddress == null)
            {
                return NotFound();
            }

            return deliveryAddress;
        }

        // PUT: api/DeliveryAddresses/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutDeliveryAddress(int id, DeliveryAddress deliveryAddress)
        {
            if (id != deliveryAddress.Id)
            {
                return BadRequest();
            }

            _context.Entry(deliveryAddress).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DeliveryAddressExists(id))
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

        // POST: api/DeliveryAddresses
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<DeliveryAddress>> PostDeliveryAddress(DeliveryAddress deliveryAddress)
        {
            var username = User.Identity.Name;
            deliveryAddress.Username = username;
            _context.DeliveryAddress.Add(deliveryAddress);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetDeliveryAddress", new { id = deliveryAddress.Id }, deliveryAddress);
        }

        // DELETE: api/DeliveryAddresses/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<DeliveryAddress>> DeleteDeliveryAddress(int id)
        {
            var deliveryAddress = await _context.DeliveryAddress.FindAsync(id);
            if (deliveryAddress == null)
            {
                return NotFound();
            }

            _context.DeliveryAddress.Remove(deliveryAddress);
            await _context.SaveChangesAsync();

            return deliveryAddress;
        }

        private bool DeliveryAddressExists(int id)
        {
            return _context.DeliveryAddress.Any(e => e.Id == id);
        }
    }
}
