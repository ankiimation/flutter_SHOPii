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
    public class OrderingDetailsController : ControllerBase
    {
        private readonly SHOPIIContext _context;

        public OrderingDetailsController(SHOPIIContext context)
        {
            _context = context;
        }

        // GET: api/OrderingDetails
        [HttpGet]
        public async Task<ActionResult<IEnumerable<OrderingDetail>>> GetOrderingDetail()
        {
            return await _context.OrderingDetail.Include(od=>od.Product).ToListAsync();
        }

        // GET: api/OrderingDetails/5
        [HttpGet("{id}")]
        public async Task<ActionResult<OrderingDetail>> GetOrderingDetail(int id)
        {
            var orderingDetail = await _context.OrderingDetail.FindAsync(id);

            if (orderingDetail == null)
            {
                return NotFound();
            }

            return orderingDetail;
        }

        // PUT: api/OrderingDetails/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutOrderingDetail(int id, OrderingDetail orderingDetail)
        {
            if (id != orderingDetail.Id)
            {
                return BadRequest();
            }

            _context.Entry(orderingDetail).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!OrderingDetailExists(id))
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

        // POST: api/OrderingDetails
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<OrderingDetail>> PostOrderingDetail(OrderingDetail orderingDetail)
        {
            _context.OrderingDetail.Add(orderingDetail);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetOrderingDetail", new { id = orderingDetail.Id }, orderingDetail);
        }

        // DELETE: api/OrderingDetails/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<OrderingDetail>> DeleteOrderingDetail(int id)
        {
            var orderingDetail = await _context.OrderingDetail.FindAsync(id);
            if (orderingDetail == null)
            {
                return NotFound();
            }

            _context.OrderingDetail.Remove(orderingDetail);
            await _context.SaveChangesAsync();

            return orderingDetail;
        }

        private bool OrderingDetailExists(int id)
        {
            return _context.OrderingDetail.Any(e => e.Id == id);
        }
    }
}
