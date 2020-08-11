using Microsoft.EntityFrameworkCore;
using SHOPii.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
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


        public static String removeAccents(String input)
        {
            var normalizedString = input.Normalize(NormalizationForm.FormD);
            var stringBuilder = new StringBuilder();

            foreach (var c in normalizedString)
            {
                var unicodeCategory = CharUnicodeInfo.GetUnicodeCategory(c);
                if (unicodeCategory != UnicodeCategory.NonSpacingMark)
                {
                    stringBuilder.Append(c);
                }
            }

            return stringBuilder.ToString().Normalize(NormalizationForm.FormC);
        }

    }
}
