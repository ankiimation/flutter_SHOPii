using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace SHOPii.Models
{
    public partial class SHOPIIContext : DbContext
    {
        public SHOPIIContext()
        {
        }

        public SHOPIIContext(DbContextOptions<SHOPIIContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Account> Account { get; set; }
        public virtual DbSet<Category> Category { get; set; }
        public virtual DbSet<DeliveryAddress> DeliveryAddress { get; set; }
        public virtual DbSet<Favorite> Favorite { get; set; }
        public virtual DbSet<Ordering> Ordering { get; set; }
        public virtual DbSet<OrderingDetail> OrderingDetail { get; set; }
        public virtual DbSet<Product> Product { get; set; }
        public virtual DbSet<ProductImage> ProductImage { get; set; }
        public virtual DbSet<ShopAccount> ShopAccount { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseSqlServer("Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=SHOPII;Integrated Security=True");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Account>(entity =>
            {
                entity.HasKey(e => e.Username)
                    .HasName("PK__ACCOUNT__B15BE12F28AFB08A");

                entity.ToTable("ACCOUNT");

                entity.Property(e => e.Username)
                    .HasColumnName("USERNAME")
                    .HasMaxLength(32)
                    .IsUnicode(false);

                entity.Property(e => e.Address).HasColumnName("ADDRESS");

                entity.Property(e => e.DefaultDeliveryId)
                    .HasColumnName("DEFAULT_DELIVERY_ID")
                    .HasDefaultValueSql("((-1))");

                entity.Property(e => e.Fullname).HasColumnName("FULLNAME");

                entity.Property(e => e.Image).HasColumnName("IMAGE");

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasColumnName("PASSWORD")
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.PhoneNumber)
                    .HasColumnName("PHONE_NUMBER")
                    .HasMaxLength(15)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Category>(entity =>
            {
                entity.ToTable("CATEGORY");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasColumnName("DESCRIPTION")
                    .HasDefaultValueSql("('')");

                entity.Property(e => e.Image)
                    .IsRequired()
                    .HasColumnName("IMAGE");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasColumnName("NAME");
            });

            modelBuilder.Entity<DeliveryAddress>(entity =>
            {
                entity.ToTable("DELIVERY_ADDRESS");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Address)
                    .IsRequired()
                    .HasColumnName("ADDRESS");

                entity.Property(e => e.Fullname)
                    .IsRequired()
                    .HasColumnName("FULLNAME");

                entity.Property(e => e.Latitude)
                    .IsRequired()
                    .HasColumnName("LATITUDE")
                    .IsUnicode(false)
                    .HasDefaultValueSql("('')");

                entity.Property(e => e.Longitude)
                    .IsRequired()
                    .HasColumnName("LONGITUDE")
                    .IsUnicode(false)
                    .HasDefaultValueSql("('')");

                entity.Property(e => e.PhoneNumber)
                    .IsRequired()
                    .HasColumnName("PHONE_NUMBER")
                    .HasMaxLength(15)
                    .IsUnicode(false);

                entity.Property(e => e.Username)
                    .IsRequired()
                    .HasColumnName("USERNAME")
                    .HasMaxLength(32)
                    .IsUnicode(false);

                entity.HasOne(d => d.UsernameNavigation)
                    .WithMany(p => p.DeliveryAddress)
                    .HasForeignKey(d => d.Username)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__DELIVERY___USERN__440B1D61");
            });

            modelBuilder.Entity<Favorite>(entity =>
            {
                entity.ToTable("FAVORITE");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Isfavorite)
                    .IsRequired()
                    .HasColumnName("ISFAVORITE")
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.ProductId).HasColumnName("PRODUCT_ID");

                entity.Property(e => e.Username)
                    .IsRequired()
                    .HasColumnName("USERNAME")
                    .HasMaxLength(32)
                    .IsUnicode(false);

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.Favorite)
                    .HasForeignKey(d => d.ProductId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__FAVORITE__PRODUC__5DCAEF64");

                entity.HasOne(d => d.UsernameNavigation)
                    .WithMany(p => p.Favorite)
                    .HasForeignKey(d => d.Username)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__FAVORITE__USERNA__5CD6CB2B");
            });

            modelBuilder.Entity<Ordering>(entity =>
            {
                entity.ToTable("ORDERING");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.CreatedDate)
                    .HasColumnName("CREATED_DATE")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.DeliveryId)
                    .HasColumnName("DELIVERY_ID")
                    .HasDefaultValueSql("((-1))");

                entity.Property(e => e.ShopUsername)
                    .IsRequired()
                    .HasColumnName("SHOP_USERNAME")
                    .HasMaxLength(32)
                    .IsUnicode(false);

                entity.Property(e => e.Status).HasColumnName("STATUS");

                entity.Property(e => e.Username)
                    .IsRequired()
                    .HasColumnName("USERNAME")
                    .HasMaxLength(32)
                    .IsUnicode(false);

                entity.HasOne(d => d.ShopUsernameNavigation)
                    .WithMany(p => p.Ordering)
                    .HasForeignKey(d => d.ShopUsername)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ORDERING__shop_u__531856C7");

                entity.HasOne(d => d.UsernameNavigation)
                    .WithMany(p => p.Ordering)
                    .HasForeignKey(d => d.Username)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ORDERING__USERNA__02084FDA");
            });

            modelBuilder.Entity<OrderingDetail>(entity =>
            {
                entity.ToTable("ORDERING_DETAIL");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Count).HasColumnName("COUNT");

                entity.Property(e => e.OrderingId).HasColumnName("ORDERING_ID");

                entity.Property(e => e.ProductId).HasColumnName("PRODUCT_ID");

                entity.HasOne(d => d.Ordering)
                    .WithMany(p => p.OrderingDetail)
                    .HasForeignKey(d => d.OrderingId)
                    .HasConstraintName("FK__ORDERING___ORDER__05D8E0BE");

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.OrderingDetail)
                    .HasForeignKey(d => d.ProductId)
                    .HasConstraintName("FK__ORDERING___PRODU__06CD04F7");
            });

            modelBuilder.Entity<Product>(entity =>
            {
                entity.ToTable("PRODUCT");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.CategoryId).HasColumnName("CATEGORY_ID");

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasColumnName("DESCRIPTION")
                    .HasDefaultValueSql("('')");

                entity.Property(e => e.Image)
                    .IsRequired()
                    .HasColumnName("IMAGE");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasColumnName("NAME");

                entity.Property(e => e.Price).HasColumnName("PRICE");

                entity.Property(e => e.ShopUsername)
                    .IsRequired()
                    .HasColumnName("SHOP_USERNAME")
                    .HasMaxLength(32)
                    .IsUnicode(false);

                entity.HasOne(d => d.Category)
                    .WithMany(p => p.Product)
                    .HasForeignKey(d => d.CategoryId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PRODUCT__CATEGOR__2A4B4B5E");
            });

            modelBuilder.Entity<ProductImage>(entity =>
            {
                entity.ToTable("PRODUCT_IMAGE");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Image)
                    .IsRequired()
                    .HasColumnName("IMAGE");

                entity.Property(e => e.ProductId).HasColumnName("PRODUCT_ID");

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.ProductImage)
                    .HasForeignKey(d => d.ProductId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PRODUCT_I__PRODU__300424B4");
            });

            modelBuilder.Entity<ShopAccount>(entity =>
            {
                entity.HasKey(e => e.Username)
                    .HasName("PK__SHOP_ACC__B15BE12FB7F1BC99");

                entity.ToTable("SHOP_ACCOUNT");

                entity.Property(e => e.Username)
                    .HasColumnName("USERNAME")
                    .HasMaxLength(32)
                    .IsUnicode(false);

                entity.Property(e => e.Address)
                    .IsRequired()
                    .HasColumnName("ADDRESS");

                entity.Property(e => e.CoverImage).HasColumnName("COVER_IMAGE");

                entity.Property(e => e.Image)
                    .IsRequired()
                    .HasColumnName("IMAGE");

                entity.Property(e => e.Latitude)
                    .HasColumnName("LATITUDE")
                    .IsUnicode(false);

                entity.Property(e => e.Longitude)
                    .HasColumnName("LONGITUDE")
                    .IsUnicode(false);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasColumnName("NAME");

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasColumnName("PASSWORD")
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.PhoneNumber)
                    .IsRequired()
                    .HasColumnName("PHONE_NUMBER")
                    .HasMaxLength(15)
                    .IsUnicode(false);
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
