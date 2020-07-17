using System;
using System.Collections.Generic;

namespace SHOPii.Models
{
    public partial class Ordering
    {
        public Ordering()
        {
            OrderingDetail = new HashSet<OrderingDetail>();
        }

        public int Id { get; set; }
        public int DeliveryId { get; set; }
        public int Status { get; set; }

        public virtual DeliveryAddress Delivery { get; set; }
        public virtual ICollection<OrderingDetail> OrderingDetail { get; set; }
    }
}
