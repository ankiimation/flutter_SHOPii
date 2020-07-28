using System;
using System.Collections.Generic;

namespace SHOPii.Models
{
    public partial class DeliveryAddress
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string PhoneNumber { get; set; }
        public string Fullname { get; set; }
        public string Address { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }

        public virtual Account UsernameNavigation { get; set; }
    }
}
