import React, { useEffect, useMemo, useState } from "react";
import { useParams, Link } from "react-router-dom";
import {
  ChevronRight,
  Heart,
  Share2,
  Plus,
  Minus,
  ShoppingBag,
  Star,
  Truck,
  Shield,
} from "lucide-react";
import { useCart } from "../contexts/CartContext";
import ProductCard from "../components/ProductCard";
import {
  fetchProductById,
  fetchProducts,
  parseMaybeJson,
  type Product,
  type ProductVariant,
} from "../api";

type FullProduct = Product & {
  variants?: ProductVariant[];
  reviews?: Array<{
    id: string | number;
    author: string;
    rating: number; // 1..5
    comment: string;
    created_at?: string;
  }>;
};

const ProductDetail: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const { addItem } = useCart();

  const [product, setProduct] = useState<FullProduct | null>(null);
  const [relatedProducts, setRelatedProducts] = useState<Product[]>([]);
  const [selectedImageIndex, setSelectedImageIndex] = useState(0);
  const [selectedColor, setSelectedColor] = useState("");
  const [selectedSize, setSelectedSize] = useState("");
  const [quantity, setQuantity] = useState(1);
  const [loading, setLoading] = useState(true);

  // Load product detail
  useEffect(() => {
    if (!id) return;
    let ignore = false;

    (async () => {
      setLoading(true);
      try {
        const p = await fetchProductById(id);

        const normalized: FullProduct = {
          ...p,
          images: parseMaybeJson<string[]>(p.images),
          colors: parseMaybeJson<string[]>(p.colors),
          sizes: parseMaybeJson<string[]>(p.sizes),
          features: parseMaybeJson<string[]>(p.features),
          // reviews / variants nếu API có dạng JSON string thì parse tương tự:
          reviews: (p as any).reviews ? parseMaybeJson<any[]>((p as any).reviews) : [],
          variants: (p as any).variants ? parseMaybeJson<any[]>((p as any).variants) : [],
        };

        if (ignore) return;
        setProduct(normalized);

        // init selections
        setSelectedColor((normalized.colors as string[] | undefined)?.[0] ?? "");
        setSelectedSize((normalized.sizes as string[] | undefined)?.[0] ?? "");

        // load related by category (cùng category_id, khác id hiện tại)
        const { data: rel } = await fetchProducts({
          category_id: normalized.category_id,
          page: 1,
          pageSize: 12,
        });

        if (ignore) return;

        const relNorm = rel
          .map((r) => ({
            ...r,
            images: parseMaybeJson<string[]>(r.images),
            colors: parseMaybeJson<string[]>(r.colors),
            sizes: parseMaybeJson<string[]>(r.sizes),
            features: parseMaybeJson<string[]>(r.features),
          }))
          .filter((r) => r.id !== normalized.id)
          .slice(0, 4);

        setRelatedProducts(relNorm);
      } finally {
        if (!ignore) setLoading(false);
      }
    })();

    return () => {
      ignore = true;
    };
  }, [id]);

  const images = useMemo(() => (product?.images ?? []) as string[], [product]);

  const handleAddToCart = () => {
    if (!product) return;
    if (!selectedColor || !selectedSize) return;

    // Giữ API addItem(product, color, size, qty)
    // Nếu CartContext dùng unitPrice, đảm bảo product.price có sẵn (hoặc map sang unitPrice tại reducer)
    addItem(product as any, selectedColor, selectedSize, quantity);
  };

  const formatPrice = (price: number) =>
    new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(price);

  const renderStars = (ratingNumber?: number) => {
    const r = Math.max(0, Math.min(5, Math.round(ratingNumber ?? 0)));
    return (
      <div className="flex">
        {[...Array(5)].map((_, i) => (
          <Star
            key={i}
            size={16}
            className={i < r ? "text-yellow-400" : "text-gray-300"}
            fill={i < r ? "currentColor" : "none"}
          />
        ))}
      </div>
    );
  };

  if (loading) return <div className="p-6">Loading...</div>;
  if (!product) return <div className="p-6">Product not found</div>;

  const cover = images?.[selectedImageIndex];

  return (
    <div className="min-h-screen bg-white">
      {/* Breadcrumb */}
      <div className="border-b">
        <div className="container mx-auto px-4 py-4">
          <nav className="flex items-center space-x-2 text-sm">
            <Link to="/" className="text-gray-600 hover:text-red-600">
              Trang chủ
            </Link>
            <ChevronRight size={16} className="text-gray-400" />
            <Link
              to={`/${product.category_id}`}
              className="text-gray-600 hover:text-red-600"
            >
              {product.category_id === "men"
                ? "Nam"
                : product.category_id === "women"
                ? "Nữ"
                : "Trẻ em"}
            </Link>
            <ChevronRight size={16} className="text-gray-400" />
            <span className="text-gray-900">{product.name}</span>
          </nav>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
          {/* Product Images */}
          <div className="space-y-4">
            <div className="aspect-square overflow-hidden rounded-lg bg-gray-100">
              {cover ? (
                <img
                  src={cover}
                  alt={product.name}
                  className="w-full h-full object-cover"
                />
              ) : (
                <div className="w-full h-full bg-gray-100" />
              )}
            </div>

            {images.length > 1 && (
              <div className="grid grid-cols-4 gap-4">
                {images.map((image, index) => (
                  <button
                    key={index}
                    onClick={() => setSelectedImageIndex(index)}
                    className={`aspect-square overflow-hidden rounded-lg border-2 ${
                      selectedImageIndex === index
                        ? "border-red-600"
                        : "border-gray-200"
                    }`}
                  >
                    {image ? (
                      <img
                        src={image}
                        alt={`${product.name} ${index + 1}`}
                        className="w-full h-full object-cover"
                      />
                    ) : (
                      <div className="w-full h-full bg-gray-100" />
                    )}
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Product Info */}
          <div className="space-y-6">
            {/* Badges */}
            <div className="flex flex-wrap gap-2">
              {!!product.is_new && (
                <span className="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full">
                  SẢN PHẨM MỚI
                </span>
              )}
              {!!product.is_sale && (
                <span className="bg-red-100 text-red-800 text-sm font-medium px-3 py-1 rounded-full">
                  KHUYẾN MÃI
                </span>
              )}
            </div>

            {/* Title & Price */}
            <div>
              <h1 className="text-3xl font-bold text-gray-900 mb-4">
                {product.name}
              </h1>
              <div className="flex items-center flex-wrap gap-3 mb-3">
                <span className="text-3xl font-bold text-red-600">
                  {formatPrice(product.price)}
                </span>
                {product.original_price ? (
                  <span className="text-xl text-gray-500 line-through">
                    {formatPrice(product.original_price)}
                  </span>
                ) : null}
              </div>

              {/* Rating */}
              <div className="flex items-center gap-2">
                {renderStars(product.rating)}
                <span className="text-sm text-gray-600">
                  {product.rating ? product.rating.toFixed(1) : "0.0"} / 5
                </span>
                <span className="text-sm text-gray-600">
                  ({product.review_count ?? 0} đánh giá)
                </span>
              </div>
            </div>

            {/* Description */}
            {product.description ? (
              <div>
                <p className="text-gray-700">{product.description}</p>
              </div>
            ) : null}

            {/* Features */}
            {!!(product.features as string[] | undefined)?.length && (
              <div>
                <h3 className="font-semibold mb-2">Tính năng:</h3>
                <ul className="space-y-1">
                  {(product.features as string[]).map((feature, index) => (
                    <li key={index} className="text-gray-700 flex items-center">
                      <div className="w-1.5 h-1.5 bg-red-600 rounded-full mr-2" />
                      {feature}
                    </li>
                  ))}
                </ul>
              </div>
            )}

            {/* Color Selection */}
            {!!(product.colors as string[] | undefined)?.length && (
              <div>
                <h3 className="font-semibold mb-3">Màu sắc: {selectedColor}</h3>
                <div className="flex flex-wrap gap-2">
                  {(product.colors as string[]).map((color) => (
                    <button
                      key={color}
                      onClick={() => setSelectedColor(color)}
                      className={`px-4 py-2 border rounded-lg text-sm font-medium transition-colors ${
                        selectedColor === color
                          ? "border-red-600 bg-red-50 text-red-600"
                          : "border-gray-300 text-gray-700 hover:border-gray-400"
                      }`}
                    >
                      {color}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {/* Size Selection */}
            {!!(product.sizes as string[] | undefined)?.length && (
              <div>
                <h3 className="font-semibold mb-3">Kích thước: {selectedSize}</h3>
                <div className="flex flex-wrap gap-2">
                  {(product.sizes as string[]).map((size) => (
                    <button
                      key={size}
                      onClick={() => setSelectedSize(size)}
                      className={`px-4 py-2 border rounded-lg text-sm font-medium transition-colors ${
                        selectedSize === size
                          ? "border-red-600 bg-red-50 text-red-600"
                          : "border-gray-300 text-gray-700 hover:border-gray-400"
                      }`}
                    >
                      {size}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {/* Quantity */}
            <div>
              <h3 className="font-semibold mb-3">Số lượng:</h3>
              <div className="flex items-center space-x-3">
                <div className="flex items-center border border-gray-300 rounded-lg">
                  <button
                    onClick={() => setQuantity((q) => Math.max(1, q - 1))}
                    className="p-2 hover:bg-gray-50"
                  >
                    <Minus size={16} />
                  </button>
                  <span className="px-4 py-2 font-medium">{quantity}</span>
                  <button
                    onClick={() => setQuantity((q) => q + 1)}
                    className="p-2 hover:bg-gray-50"
                  >
                    <Plus size={16} />
                  </button>
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="space-y-4">
              <button
                onClick={handleAddToCart}
                disabled={!selectedColor || !selectedSize}
                className="w-full bg-red-600 hover:bg-red-700 disabled:bg-gray-300 text-white py-3 px-6 rounded-lg font-medium transition-colors flex items-center justify-center space-x-2"
              >
                <ShoppingBag size={20} />
                <span>Thêm vào giỏ hàng</span>
              </button>

              <div className="flex space-x-3">
                <button className="flex-1 border border-gray-300 hover:bg-gray-50 py-3 px-6 rounded-lg font-medium transition-colors flex items-center justify-center space-x-2">
                  <Heart size={20} />
                  <span>Yêu thích</span>
                </button>
                <button className="flex-1 border border-gray-300 hover:bg-gray-50 py-3 px-6 rounded-lg font-medium transition-colors flex items-center justify-center space-x-2">
                  <Share2 size={20} />
                  <span>Chia sẻ</span>
                </button>
              </div>
            </div>

            {/* Shipping Info */}
            <div className="border-t pt-6 space-y-3">
              <div className="flex items-center space-x-3 text-sm text-gray-600">
                <Truck size={16} className="text-red-600" />
                <span>Miễn phí giao hàng cho đơn từ 500.000đ</span>
              </div>
              <div className="flex items-center space-x-3 text-sm text-gray-600">
                <Shield size={16} className="text-red-600" />
                <span>Đổi trả trong 30 ngày</span>
              </div>
            </div>
          </div>
        </div>

        {/* Reviews (tuỳ chọn hiển thị nếu API có) */}
        {!!product.reviews?.length && (
          <div className="mt-16">
            <h2 className="text-2xl font-bold mb-6">Đánh giá từ khách hàng</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {product.reviews!.slice(0, 4).map((rv) => (
                <div key={rv.id} className="border rounded-lg p-4 bg-white">
                  <div className="flex items-center justify-between mb-2">
                    <div className="font-semibold text-gray-900">{rv.author}</div>
                    <div className="flex">{renderStars(rv.rating)}</div>
                  </div>
                  <p className="text-gray-700 text-sm">{rv.comment}</p>
                  {rv.created_at && (
                    <div className="text-xs text-gray-500 mt-2">{rv.created_at}</div>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Related Products */}
        {relatedProducts.length > 0 && (
          <div className="mt-16">
            <h2 className="text-2xl font-bold mb-8">Sản phẩm liên quan</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {relatedProducts.map((rp) => (
                <ProductCard key={rp.id} product={rp as any} />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default ProductDetail;
