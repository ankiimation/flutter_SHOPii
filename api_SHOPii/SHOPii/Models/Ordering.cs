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
        public int Status { get; set; }
        public string Username { get; set; }
        public int DeliveryId { get; set; }
        public DateTime CreatedDate { get; set; }
        public string ShopUsername { get; set; }

        public virtual ShopAccount ShopUsernameNavigation { get; set; }
        public virtual Account UsernameNavigation { get; set; }
        public virtual ICollection<OrderingDetail> OrderingDetail { get; set; }
    }
}
