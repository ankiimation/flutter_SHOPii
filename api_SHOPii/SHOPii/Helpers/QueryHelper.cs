using Microsoft.EntityFrameworkCore;
using SHOPii.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SHOPii.Helpers
{
    public class QueryHelper<E>
    {
        private IQueryable<E> queryable;
        public QueryHelper(IQueryable<E> queryable)
        {
            this.queryable = queryable;
        }
        public IQueryable<E> pagingQuery(int? from, int? limit)
        {
            var takeFrom = from ?? 0;
            var takeLimit = limit ?? -1;
            if (takeLimit < 0)
            {
                return queryable.Skip(takeFrom);
            }
            return queryable.Skip(takeFrom).Take(takeLimit);
        }

    }
}
