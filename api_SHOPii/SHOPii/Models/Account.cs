using System;
using System.Collections.Generic;

namespace SHOPii.Models
{
    public partial class Account
    {
        public Account()
        {
            DeliveryAddress = new HashSet<DeliveryAddress>();
            Favorite = new HashSet<Favorite>();
            Ordering = new HashSet<Ordering>();
        }

        public string Username { get; set; }
        public string Password { get; set; }
        public string PhoneNumber { get; set; }
        public string Fullname { get; set; }
        public string Address { get; set; }
        public string Image { get; set; }
        public int DefaultDeliveryId { get; set; }

        public virtual ICollection<DeliveryAddress> DeliveryAddress { get; set; }
        public virtual ICollection<Favorite> Favorite { get; set; }
        public virtual ICollection<Ordering> Ordering { get; set; }
    }
}
