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
            var username = User.Identity.Name;
            var orders = await _context.Ordering.Include(o => o.OrderingDetail).Where(o => o.Username.Equals(username)).ToListAsync();
         
            return Ok(orders);
        }

        // GET: api/Orderings/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Ordering>> GetOrdering(int id)
        {
            var username = User.Identity.Name;
            var ordering = await _context.Ordering.Include(o => o.OrderingDetail).ThenInclude(od => od.Product).FirstOrDefaultAsync(o => o.Username.Equals(username) && o.Id == id);

            if (ordering == null)
            {
                return NotFound();
            }

            return ordering;
        }

        [HttpGet("cart")]
        public async Task<ActionResult<Ordering>> GetCurrentCart()
        {
            var username = User.Identity.Name;
            var cart = await _context.Ordering.Include(o => o.OrderingDetail).ThenInclude(od => od.Product).Where(o => o.Username.Equals(username) && o.Status == 0).FirstOrDefaultAsync();
            if (cart == null)
            {
                cart = new Ordering();
                cart.Username = username;
                cart.Status = 0;
                _context.Ordering.Add(cart);
                await _context.SaveChangesAsync();

            }
            return cart;
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

        //public async Task<ActionResult<Ordering>> PostOrdering(Ordering ordering)
        //{
        //    _context.Ordering.Add(ordering);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("GetOrdering", new { id = ordering.Id }, ordering);
        //}
        public class DoOrderModel
        {
            public int productID;
            public int count;

            public DoOrderModel(int productID, int count)
            {
                this.productID = productID;
                this.count = count;
            }
        }

        public class CheckOutHelperModel
        {
            public int orderingId;
            public int? deliveryId;
            public int status;

            public CheckOutHelperModel(int orderingId, int? deliveryId, int status)
            {
                this.orderingId = orderingId;
                this.deliveryId = deliveryId;
                this.status = status;
            }
        }

        [HttpPost("checkout")]
        public async Task<ActionResult<Ordering>> checkOut(CheckOutHelperModel checkOutHelper)
        {
            var ordering = await _context.Ordering.FirstOrDefaultAsync(o => o.Id == checkOutHelper.orderingId);
            if (ordering != null)
            {

                ordering.DeliveryId = checkOutHelper.deliveryId ?? -1;
                ordering.Status = checkOutHelper.status;


                _context.Ordering.Update(ordering);
                await _context.SaveChangesAsync();
                return Ok(ordering);

            }
            return NotFound();
        }


        [HttpPost("cart")]
        public async Task<ActionResult<Ordering>> addToCart(DoOrderModel doOrderModel)
        {
            String username = User.Identity.Name;
            var currentOrdering = await _context.Ordering.Include(o => o.OrderingDetail).ThenInclude(od => od.Product).FirstOrDefaultAsync(o => o.Username.Equals(username) && o.Status == 0);
            if (currentOrdering != null)
            {
                //get ordering detail via ordering id && product id
                var currentOrderingDetail = await _context.OrderingDetail.Include(od => od.Product).FirstOrDefaultAsync(od => od.OrderingId == currentOrdering.Id && od.ProductId == doOrderModel.productID);
                if (currentOrderingDetail != null)
                {
                    currentOrderingDetail.Count += doOrderModel.count;
                    if (currentOrderingDetail.Count < 0)
                    {
                        currentOrderingDetail.Count = 0;
                    }
                    _context.OrderingDetail.Update(currentOrderingDetail);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    OrderingDetail detailTemp = new OrderingDetail();
                    detailTemp.OrderingId = currentOrdering.Id;
                    detailTemp.ProductId = doOrderModel.productID;
                    detailTemp.Product = await _context.Product.Include(p => p.ProductImage).FirstOrDefaultAsync(p => p.Id == doOrderModel.productID);
                    detailTemp.Count = doOrderModel.count;
                    if (detailTemp.Count < 0)
                    {
                        detailTemp.Count = 0;
                    }
                    _context.OrderingDetail.Add(detailTemp);
                    await _context.SaveChangesAsync();
                }
                return Ok(currentOrdering);
            }
            else
            {
                //ADD ORDER
                Ordering orderingTemp = new Ordering();
                orderingTemp.Username = username;
                _context.Ordering.Add(orderingTemp);
                await _context.SaveChangesAsync();
                //ADD ORDER  DETAIL
                OrderingDetail detailTemp = new OrderingDetail();
                detailTemp.OrderingId = orderingTemp.Id;
                detailTemp.ProductId = doOrderModel.productID;
                detailTemp.Product = await _context.Product.FirstOrDefaultAsync(p => p.Id == doOrderModel.productID);
                detailTemp.Count = doOrderModel.count;
                if (detailTemp.Count < 0)
                {
                    detailTemp.Count = 0;
                }
                _context.OrderingDetail.Add(detailTemp);

                await _context.SaveChangesAsync();
                orderingTemp = await _context.Ordering.Include(o => o.OrderingDetail).ThenInclude(od => od.Product).FirstOrDefaultAsync(o => o.Id == orderingTemp.Id);


                return Ok(orderingTemp);
            }




            //Ordering orderingTemp = new Ordering();
            //orderingTemp.Username = username;


            //_context.Ordering.Add(ordering);
            //await _context.SaveChangesAsync();

            //return CreatedAtAction("GetOrdering", new { id = ordering.Id }, ordering);
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
