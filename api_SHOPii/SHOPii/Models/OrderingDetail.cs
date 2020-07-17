using System;
using System.Collections.Generic;

namespace SHOPii.Models
{
    public partial class OrderingDetail
    {
        public int Id { get; set; }
        public int OrderingId { get; set; }
        public int ProductId { get; set; }

        public virtual Ordering Ordering { get; set; }
        public virtual Product Product { get; set; }
    }
}
