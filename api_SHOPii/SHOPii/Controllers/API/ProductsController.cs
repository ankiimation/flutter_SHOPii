using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http.OData;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using SHOPii.Helpers;
using SHOPii.Models;

namespace SHOPii.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly SHOPIIContext _context;

        public ProductsController(SHOPIIContext context)
        {
            _context = context;
        }

        // GET: api/Products
        [EnableQuery]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Product>>> GetProductsAsync(int? categoryID, int? from, int? limit)
        {


            if (categoryID == null)
            {
                return await new QueryHelper<Product>(_context.Product.Include(p => p.ProductImage).Include(p => p.Category)).pagingQuery(from, limit).ToListAsync();
            }
            else
            {
                return await new QueryHelper<Product>(_context.Product.Include(p => p.ProductImage).Include(p => p.Category).Where(p => p.CategoryId == categoryID)).pagingQuery(from, limit).ToListAsync();
            }
        }

        // GET: api/Products/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Product>> GetProduct(int id)
        {
            var product = await _context.Product.Include(p => p.Category.Product).FirstOrDefaultAsync(p => p.Id == id);

            if (product == null)
            {
                return NotFound();
            }

            return product;
        }

        [HttpGet("forYou")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<Product>>> GetProductsForYou()
        {
            String username = User.Identity.Name;
            List<Product> listResult = new List<Product>();
            var listProducts = await getBuyedProduct(username);
            HashSet<int> setCategoryId = listProducts.Select(p => p.CategoryId).ToList().ToHashSet();
            foreach (int id in setCategoryId)
            {
                var listRandomProduct = await getRandomProductFromCategoryId(id, 5);
                foreach (var product in listRandomProduct)
                {
                    product.OrderingDetail = null;
                    listResult.Add(product);
                }
            }
            return listResult;


        }




        private async Task<List<Product>> getRandomProductFromCategoryId(int categoryId, int limit)
        {
            var allProduct = await _context.Product.Where(p => p.CategoryId == categoryId).ToListAsync();
            allProduct = allProduct.OrderBy(x => Guid.NewGuid()).ToList();
            List<Product> listProducts = allProduct.Take(limit).ToList();
            return listProducts;
        }

        private async Task<List<Product>> getBuyedProduct(String username)
        {
            List<Product> listProducts = new List<Product>();
            var listOrdering = await _context.Ordering.Include(o => o.OrderingDetail).Where(o => o.Username.Equals(username)).ToListAsync();
            foreach (var ordering in listOrdering)
            {
                foreach (var od in ordering.OrderingDetail)
                {
                    var product = await _context.Product.FirstOrDefaultAsync(p => p.Id == od.ProductId);
                    listProducts.Add(product);
                }
            }
            return listProducts;
        }

        //[HttpGet("categories/{id}")]
        //public async Task<ActionResult<IEnumerable<Product>>> GetProductViaCategoryID([FromQuery] int categoryID)
        //{
        //    var product =await _context.Product.Where(p => p.CategoryId == categoryID).ToListAsync();

        //    if (product == null)
        //    {
        //        return NotFound();
        //    }

        //    return product;
        //}

        // PUT: api/Products/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProduct(int id, Product product)
        {
            if (id != product.Id)
            {
                return BadRequest();
            }

            _context.Entry(product).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductExists(id))
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

        // POST: api/Products
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Product>> PostProduct(Product product)
        {
            _context.Product.Add(product);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProduct", new { id = product.Id }, product);
        }

        [HttpPost("search")]
        public async Task<ActionResult<IEnumerable<Product>>> SearchProduct(String keyword, int? from, int? limit)
        {
            var query = "select * from Product " +
            " where  name COLLATE Latin1_General_CI_AI  like @name";
            var results = _context.Product
                                   .FromSqlRaw(query, new SqlParameter("@name", "%"+keyword+"%"));
            return await new QueryHelper<Product>(results).pagingQuery(from, limit).ToListAsync();

            //return Ok(QueryHelper<Product>.removeAccents(keyword));


        }

        // DELETE: api/Products/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Product>> DeleteProduct(int id)
        {
            var product = await _context.Product.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }

            _context.Product.Remove(product);
            await _context.SaveChangesAsync();

            return product;
        }

        private bool ProductExists(int id)
        {
            return _context.Product.Any(e => e.Id == id);
        }
    }
}
