using System;
using System.Collections.Generic;

namespace SHOPii.Models
{
    public partial class Product
    {
        public Product()
        {
            Favorite = new HashSet<Favorite>();
            OrderingDetail = new HashSet<OrderingDetail>();
            ProductImage = new HashSet<ProductImage>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Image { get; set; }
        public long Price { get; set; }
        public int CategoryId { get; set; }

        public virtual Category Category { get; set; }
        public virtual ICollection<Favorite> Favorite { get; set; }
        public virtual ICollection<OrderingDetail> OrderingDetail { get; set; }
        public virtual ICollection<ProductImage> ProductImage { get; set; }
    }
}
