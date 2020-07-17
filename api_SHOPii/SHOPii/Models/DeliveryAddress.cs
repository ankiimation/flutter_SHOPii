using System;
using System.Collections.Generic;

namespace SHOPii.Models
{
    public partial class DeliveryAddress
    {
        public DeliveryAddress()
        {
            Ordering = new HashSet<Ordering>();
        }

        public int Id { get; set; }
        public string Username { get; set; }
        public string PhoneNumber { get; set; }
        public string Fullname { get; set; }
        public string Address { get; set; }

        public virtual Account UsernameNavigation { get; set; }
        public virtual ICollection<Ordering> Ordering { get; set; }
    }
}
