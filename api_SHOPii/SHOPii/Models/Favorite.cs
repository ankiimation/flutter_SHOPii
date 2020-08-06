using System;
using System.Collections.Generic;

namespace SHOPii.Models
{
    public partial class Favorite
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public int ProductId { get; set; }
        public bool Isfavorite { get; set; }

        public virtual Product Product { get; set; }
        public virtual Account UsernameNavigation { get; set; }
    }
}
