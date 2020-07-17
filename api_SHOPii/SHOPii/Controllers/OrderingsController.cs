using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SHOPii.Models;

namespace SHOPii.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderingsController : ControllerBase
    {
        private readonly SHOPIIContext _context;

        public OrderingsController(SHOPIIContext context)
        {
            _context = context;
        }

        // GET: api/Orderings
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Ordering>>> GetOrdering()
        {
            return await _context.Ordering.Include(o=>o.OrderingDetail).Include(o=>o.Delivery).ToListAsync();
        }

        // GET: api/Orderings/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Ordering>> GetOrdering(int id)
        {
            var ordering = await _context.Ordering.FindAsync(id);

            if (ordering == null)
            {
                return NotFound();
            }

            return ordering;
        }

        // PUT: api/Orderings/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutOrdering(int id, Ordering ordering)
        {
            if (id != ordering.Id)
            {
                return BadRequest();
            }

            _context.Entry(ordering).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!OrderingExists(id))
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

        // POST: api/Orderings
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Ordering>> PostOrdering(Ordering ordering)
        {
            _context.Ordering.Add(ordering);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetOrdering", new { id = ordering.Id }, ordering);
        }

        // DELETE: api/Orderings/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Ordering>> DeleteOrdering(int id)
        {
            var ordering = await _context.Ordering.FindAsync(id);
            if (ordering == null)
            {
                return NotFound();
            }

            _context.Ordering.Remove(ordering);
            await _context.SaveChangesAsync();

            return ordering;
        }

        private bool OrderingExists(int id)
        {
            return _context.Ordering.Any(e => e.Id == id);
        }
    }
}
