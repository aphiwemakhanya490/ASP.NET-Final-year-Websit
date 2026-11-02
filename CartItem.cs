using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace M4Website
{
    public class CartItem
    {
        // For both meal and product
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public string ItemType { get; set; } // "Meal" or "Product"

        // Meal specific
        public int MealId { get; set; }
        public string Description { get; set; }
        public byte[] Picture { get; set; }

        // Product specific
        public string Category { get; set; }
        public string PicturePath { get; set; } // Added for product images

        public decimal TotalPrice
        {
            get { return Price * Quantity; }
        }
    }
}