import React from 'react';
import { Link } from 'react-router-dom';
import { Heart, ShoppingBag, Star } from 'lucide-react';
import { Product, parseMaybeJson } from '../api';
import { useCart } from '../contexts/CartContext';

interface ProductCardProps {
  product: Product;
}

const ProductCard: React.FC<ProductCardProps> = ({ product }) => {
  const { addItem } = useCart();

  // Normalize các trường JSON vì MySQL có thể trả về string
  const images = Array.isArray(product.images)
    ? product.images
    : parseMaybeJson<string[]>(product.images);

  const colors = Array.isArray(product.colors)
    ? product.colors
    : parseMaybeJson<string[]>(product.colors);

  const sizes = Array.isArray(product.sizes)
    ? product.sizes
    : parseMaybeJson<string[]>(product.sizes);

  const features = Array.isArray(product.features)
    ? product.features
    : parseMaybeJson<string[]>(product.features);

  const handleQuickAdd = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    // Add với màu/size đầu tiên nếu có
    if (colors?.length > 0 && sizes?.length > 0) {
      addItem(product, colors[0], sizes[0], 1);
    }
  };

  const formatPrice = (price: number) =>
    new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price);

  const cover = images?.[0];
  const isNew = product.is_new === 1;
  const isSale = product.is_sale === 1;
  const originalPrice = product.original_price ?? null;
  const rating = product.rating ?? 0;
  const reviewCount = product.review_count ?? 0;

  const colorSwatch = (color: string) =>
    color === 'Trắng' ? '#ffffff' :
    color === 'Đen'   ? '#000000' :
    color === 'Xanh'  ? '#3b82f6' :
    color === 'Đỏ'    ? '#ef4444' :
    color === 'Xám'   ? '#6b7280' :
    color === 'Hồng'  ? '#ec4899' :
    color === 'Vàng'  ? '#eab308' :
    color === 'Be'    ? '#d2b48c' : '#94a3b8';

  return (
    <Link to={`/product/${product.id}`} className="group block">
      <div className="bg-white rounded-lg shadow-sm hover:shadow-lg transition-shadow duration-300 overflow-hidden">
        {/* Image Container */}
        <div className="relative overflow-hidden">
          {cover ? (
            <img
              src={cover}
              alt={product.name}
              className="w-full h-64 object-cover group-hover:scale-105 transition-transform duration-300"
              loading="lazy"
            />
          ) : (
            <div className="w-full h-64 bg-gray-100 flex items-center justify-center text-gray-400">
              No image
            </div>
          )}

          {/* Badges */}
          <div className="absolute top-3 left-3 flex flex-col space-y-1">
            {isNew && (
              <span className="bg-green-500 text-white text-xs px-2 py-1 rounded">
                MỚI
              </span>
            )}
            {isSale && (
              <span className="bg-red-600 text-white text-xs px-2 py-1 rounded">
                GIẢM GIÁ
              </span>
            )}
          </div>

          {/* Hover Actions */}
          <div className="absolute top-3 right-3 flex flex-col space-y-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
            <button className="p-2 bg-white rounded-full shadow-md hover:bg-gray-50 transition-colors">
              <Heart size={16} className="text-gray-600" />
            </button>
            <button
              onClick={handleQuickAdd}
              className="p-2 bg-red-600 rounded-full shadow-md hover:bg-red-700 transition-colors"
            >
              <ShoppingBag size={16} className="text-white" />
            </button>
          </div>

          {/* Color Options */}
          {colors?.length ? (
            <div className="absolute bottom-3 left-3 flex space-x-1 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
              {colors.slice(0, 4).map((color, index) => (
                <div
                  key={index}
                  className="w-4 h-4 rounded-full border-2 border-white shadow-sm"
                  style={{ backgroundColor: colorSwatch(color) }}
                  title={color}
                />
              ))}
              {colors.length > 4 && (
                <span className="text-xs text-white bg-black bg-opacity-50 px-1 rounded">
                  +{colors.length - 4}
                </span>
              )}
            </div>
          ) : null}
        </div>

        {/* Product Info */}
        <div className="p-4">
          <h3 className="font-medium text-gray-900 mb-2 line-clamp-2 group-hover:text-red-600 transition-colors">
            {product.name}
          </h3>

          <div className="flex items-center space-x-2 mb-2">
            <span className="text-lg font-bold text-red-600">
              {formatPrice(product.price)}
            </span>
            {originalPrice && originalPrice > product.price && (
              <span className="text-sm text-gray-500 line-through">
                {formatPrice(originalPrice)}
              </span>
            )}
          </div>

          {product.description && (
            <p className="text-sm text-gray-600 mb-3 line-clamp-2">
              {product.description}
            </p>
          )}

          {/* Rating */}
          {rating ? (
            <div className="flex items-center space-x-1 mb-3">
              <div className="flex text-yellow-400">
                {[...Array(5)].map((_, i) => (
                  <Star
                    key={i}
                    size={12}
                    fill={i < Math.floor(rating) ? "currentColor" : "none"}
                    className={i < Math.floor(rating) ? "text-yellow-400" : "text-gray-300"}
                  />
                ))}
              </div>
              <span className="text-xs text-gray-600">
                {rating} ({reviewCount})
              </span>
            </div>
          ) : null}

          {/* Features */}
          {!!features?.length && (
            <div className="flex flex-wrap gap-1">
              {features.slice(0, 2).map((feature, index) => (
                <span
                  key={index}
                  className="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded"
                >
                  {feature}
                </span>
              ))}
            </div>
          )}
        </div>
      </div>
    </Link>
  );
};

export default ProductCard;
