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
    public class FavoritesController : ControllerBase
    {
        private readonly SHOPIIContext _context;

        public FavoritesController(SHOPIIContext context)
        {
            _context = context;
        }

        // GET: api/Favorites
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Favorite>>> GetFavorite(String username)
        {
            return await _context.Favorite.Where(f => f.Username.Equals(username)).ToListAsync();
        }

        // GET: api/Favorites/5
        [HttpGet("{productID}")]
        public async Task<ActionResult<Favorite>> GetFavorite(String username, int productID)
        {
            var favorite = await _context.Favorite.Where(f => f.Username.Equals(username) && f.ProductId == productID).FirstOrDefaultAsync();

            if (favorite == null)
            {
                return NotFound();
            }

            return favorite;
        }

        // PUT: api/Favorites/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutFavorite(int id, Favorite favorite)
        {
            if (id != favorite.Id)
            {
                return BadRequest();
            }

            _context.Entry(favorite).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FavoriteExists(id))
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

        // POST: api/Favorites
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        //[HttpPost]
        //public async Task<ActionResult<Favorite>> PostFavorite(Favorite favorite)
        //{
        //    _context.Favorite.Add(favorite);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("GetFavorite", new { id = favorite.Id }, favorite);
        //}

        public class ProductFavorite
        {
            public String username;
            public int productID;

            public ProductFavorite(string username, int productID)
            {
                this.username = username;
                this.productID = productID;
            }
        }

        [HttpPost]
        public async Task<ActionResult<Favorite>> PostFavorite(ProductFavorite productFavorite)
        {
            //CHECK EXIST
            var currentFavorite = await _context.Favorite.Where(f => f.Username.Equals(productFavorite.username) && f.ProductId == productFavorite.productID).FirstOrDefaultAsync();

            if (currentFavorite == null)
            {
                Favorite temp = new Favorite();
                temp.ProductId = productFavorite.productID;
                temp.Username = productFavorite.username;

                _context.Favorite.Add(temp);
                await _context.SaveChangesAsync();

                return CreatedAtAction("GetFavorite", new { id = temp.Id }, temp);
            }
            else
            {
                _context.Favorite.Remove(currentFavorite);
                return Ok(currentFavorite);
            }
        }








        // DELETE: api/Favorites/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Favorite>> DeleteFavorite(int id)
        {
            var favorite = await _context.Favorite.FindAsync(id);
            if (favorite == null)
            {
                return NotFound();
            }

            _context.Favorite.Remove(favorite);
            await _context.SaveChangesAsync();

            return favorite;
        }

        private bool FavoriteExists(int id)
        {
            return _context.Favorite.Any(e => e.Id == id);
        }
    }


}
