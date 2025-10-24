// src/api.ts
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
  sizes: string[] | string;
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
  sku: string | null;               // cho an toàn nếu DB có NULL
  stock_qty: number;
  price: number | null;
  original_price: number | null;
}

export interface Pagination {
  page: number;
  pageSize: number;
  total: number;
}

type FetchOpts = { signal?: AbortSignal };

function buildQuery(params?: Record<string, string | number | 0 | 1 | undefined | null>) {
  const qs = new URLSearchParams();
  if (!params) return "";
  Object.entries(params).forEach(([k, v]) => {
    if (v !== undefined && v !== null && v !== "") qs.set(k, String(v));
  });
  return qs.toString();
}

// Parse helper: nếu driver trả JSON dạng string, chuyển về array
// src/api.ts
export function parseMaybeJson<T>(v: unknown): T | unknown {
  if (Array.isArray(v) || (v && typeof v === 'object')) return v as any;
  if (typeof v === 'string') { try { return JSON.parse(v) as T; } catch { return v; } }
  return v;
}

function normalizeProduct(p: Product): Product {
  return {
    ...p,
    images: parseMaybeJson<string[]>(p.images) as string[],
    colors: parseMaybeJson<string[]>(p.colors) as string[],
    sizes: parseMaybeJson<string[]>(p.sizes) as string[],
    features: parseMaybeJson<string[]>(p.features) as string[],
  };
}


// Chuẩn hoá chi tiết (kèm variants/reviews)
export function normalizeDetail(p: Product & { variants: ProductVariant[]; reviews: any[] }) {
  const base = normalizeProduct(p);
  return {
    ...base,
    variants: (p.variants ?? []).map(v => ({
      ...v,
      // đảm bảo số: phòng trường hợp driver trả string
      id: Number(v.id),
      stock_qty: Number(v.stock_qty),
      price: v.price === null ? null : Number(v.price),
      original_price: v.original_price === null ? null : Number(v.original_price),
      sku: v.sku ?? null,
    })),
    reviews: p.reviews ?? [],
  };
}

export async function fetchProducts(
  params?: {
    page?: number; pageSize?: number; category_id?: string; subcategory_id?: number | string;
    is_new?: 0|1; is_sale?: 0|1; q?: string;
  },
  opts?: FetchOpts
): Promise<{ data: Product[]; pagination: Pagination }> {
  const qs = buildQuery(params);
  const res = await fetch(`/api/products?${qs}`, { signal: opts?.signal });
  if (!res.ok) throw new Error(`Failed to load products (${res.status})`);
  const json = await res.json() as { data: Product[]; pagination: Pagination };
  return {
    data: (json.data ?? []).map(normalizeProduct),
    pagination: json.pagination,
  };
}

export async function fetchProductById(id: string, opts?: FetchOpts) {
  const res = await fetch(`/api/products/${id}`, { signal: opts?.signal });
  if (!res.ok) throw new Error(res.status === 404 ? "Not found" : `Failed (${res.status})`);
  const json = await res.json() as Product & { variants: ProductVariant[]; reviews: any[] };
  return normalizeDetail(json);
}
