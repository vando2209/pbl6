// src/data/products.ts
export interface Product {
  id: string;
  name: string;
  price: number;
  original_price?: number | null;
  category_id: "men" | "women" | "kids";
  subcategory_id: number;
  description: string;
  images: string[] | string;  // có thể là JSON string từ MySQL
  colors: string[] | string;
  sizes: (string|number)[] | string;
  features: string[] | string;
  is_new: 0 | 1;
  is_sale: 0 | 1;
  rating?: number | null;
  review_count?: number | null;
}

export interface ProductVariant {
  id: number;
  color: string;
  size: string;
  sku: string;
  stock_qty: number;
  price?: number | null;
  original_price?: number | null;
}
