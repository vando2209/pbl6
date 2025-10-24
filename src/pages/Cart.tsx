import React from 'react';
import { Link } from 'react-router-dom';
import { ChevronRight, Plus, Minus, Trash2, ShoppingBag } from 'lucide-react';
import { useCart } from '../contexts/CartContext';

const Cart: React.FC = () => {
  const { items, total, itemCount, removeItem, updateQuantity } = useCart();

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(price);
  };

  const handleQuantityChange = (
    id: string,
    color: string,
    size: string,
    newQuantity: number
  ) => {
    if (newQuantity <= 0) {
      removeItem(id, color, size);
    } else {
      updateQuantity(id, color, size, newQuantity);
    }
  };

  if (items.length === 0) {
    return (
      <div className="min-h-screen bg-gray-50">
        {/* Breadcrumb */}
        <div className="bg-white border-b">
          <div className="container mx-auto px-4 py-4">
            <nav className="flex items-center space-x-2 text-sm">
              <Link to="/" className="text-gray-600 hover:text-red-600">Trang chủ</Link>
              <ChevronRight size={16} className="text-gray-400" />
              <span className="text-gray-900 font-medium">Giỏ hàng</span>
            </nav>
          </div>
        </div>

        <div className="container mx-auto px-4 py-16">
          <div className="max-w-md mx-auto text-center">
            <div className="bg-gray-100 rounded-full w-24 h-24 flex items-center justify-center mx-auto mb-6">
              <ShoppingBag size={48} className="text-gray-400" />
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-4">
              Giỏ hàng trống
            </h2>
            <p className="text-gray-600 mb-8">
              Bạn chưa có sản phẩm nào trong giỏ hàng
            </p>
            <Link
              to="/"
              className="inline-flex items-center justify-center px-6 py-3 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
            >
              Tiếp tục mua sắm
            </Link>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Breadcrumb */}
      <div className="bg-white border-b">
        <div className="container mx-auto px-4 py-4">
          <nav className="flex items-center space-x-2 text-sm">
            <Link to="/" className="text-gray-600 hover:text-red-600">Trang chủ</Link>
            <ChevronRight size={16} className="text-gray-400" />
            <span className="text-gray-900 font-medium">Giỏ hàng</span>
          </nav>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">
          Giỏ hàng ({itemCount} sản phẩm)
        </h1>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Cart Items */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-lg shadow-sm">
              {items.map((item) => {
                const key = `${item.id}-${item.selectedColor}-${item.selectedSize}`;
                const cover =
                  Array.isArray(item.images) && item.images.length > 0
                    ? item.images[0]
                    : undefined;

                return (
                  <div key={key} className="p-6 border-b border-gray-200 last:border-b-0">
                    <div className="flex items-start space-x-4">
                      <div className="flex-shrink-0">
                        {cover ? (
                          <img
                            src={cover}
                            alt={item.name}
                            className="w-20 h-20 object-cover rounded-lg"
                          />
                        ) : (
                          <div className="w-20 h-20 bg-gray-100 rounded-lg" />
                        )}
                      </div>

                      <div className="flex-1 min-w-0">
                        <h3 className="text-lg font-medium text-gray-900 mb-1">
                          {item.name}
                        </h3>
                        <div className="text-sm text-gray-600 mb-2">
                          <span>Màu: {item.selectedColor}</span>
                          <span className="mx-2">|</span>
                          <span>Size: {item.selectedSize}</span>
                          {item.sku && (
                            <>
                              <span className="mx-2">|</span>
                              <span>SKU: {item.sku}</span>
                            </>
                          )}
                        </div>

                        {/* Giá mỗi đơn vị (ưu tiên unitPrice từ variant) */}
                        <div className="text-lg font-semibold text-red-600">
                          {formatPrice(item.unitPrice)}
                        </div>

                        {/* (Tuỳ chọn) hiển thị tạm tính của dòng */}
                        <div className="text-sm text-gray-500">
                          Tạm tính: {formatPrice(item.unitPrice * item.quantity)}
                        </div>
                      </div>

                      <div className="flex items-center space-x-3">
                        {/* Quantity Controls */}
                        <div className="flex items-center border border-gray-300 rounded-lg">
                          <button
                            onClick={() =>
                              handleQuantityChange(
                                item.id,
                                item.selectedColor,
                                item.selectedSize,
                                item.quantity - 1
                              )
                            }
                            className="p-2 hover:bg-gray-50 transition-colors"
                          >
                            <Minus size={16} />
                          </button>
                          <span className="px-4 py-2 font-medium min-w-[3rem] text-center">
                            {item.quantity}
                          </span>
                          <button
                            onClick={() =>
                              handleQuantityChange(
                                item.id,
                                item.selectedColor,
                                item.selectedSize,
                                item.quantity + 1
                              )
                            }
                            className="p-2 hover:bg-gray-50 transition-colors"
                          >
                            <Plus size={16} />
                          </button>
                        </div>

                        {/* Remove Button */}
                        <button
                          onClick={() => removeItem(item.id, item.selectedColor, item.selectedSize)}
                          className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                          aria-label="Xoá sản phẩm"
                          title="Xoá sản phẩm"
                        >
                          <Trash2 size={18} />
                        </button>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Order Summary */}
          <div className="lg:col-span-1">
            <div className="bg-white rounded-lg shadow-sm p-6 sticky top-24">
              <h2 className="text-xl font-semibold text-gray-900 mb-6">
                Tổng đơn hàng
              </h2>

              <div className="space-y-4">
                <div className="flex justify-between text-gray-600">
                  <span>Tạm tính ({itemCount} sản phẩm)</span>
                  <span>{formatPrice(total)}</span>
                </div>

                <div className="flex justify-between text-gray-600">
                  <span>Phí vận chuyển</span>
                  <span className="text-green-600">Miễn phí</span>
                </div>

                <hr />

                <div className="flex justify-between text-lg font-semibold text-gray-900">
                  <span>Tổng cộng</span>
                  <span className="text-red-600">{formatPrice(total)}</span>
                </div>
              </div>

              {/* Dùng Link để điều hướng, áp style cho Link thay vì bọc Link trong button */}
              <Link
                to="/checkout"
                className="mt-6 block w-full text-center bg-red-600 hover:bg-red-700 text-white py-3 px-6 rounded-lg font-medium transition-colors"
              >
                Tiến hành thanh toán
              </Link>

              <div className="mt-4 text-center">
                <Link
                  to="/"
                  className="text-red-600 hover:text-red-700 font-medium"
                >
                  ← Tiếp tục mua sắm
                </Link>
              </div>

              {/* Promo Code (UI) */}
              <div className="mt-6 p-4 bg-gray-50 rounded-lg">
                <h3 className="font-medium text-gray-900 mb-3">Mã giảm giá</h3>
                <div className="flex">
                  <input
                    type="text"
                    placeholder="Nhập mã giảm giá"
                    className="flex-1 px-3 py-2 border border-gray-300 rounded-l-lg focus:outline-none focus:ring-2 focus:ring-red-600"
                  />
                  <button className="px-4 py-2 bg-gray-600 text-white rounded-r-lg hover:bg-gray-700 transition-colors">
                    Áp dụng
                  </button>
                </div>
              </div>

              {/* Security Note */}
              <div className="mt-6 text-sm text-gray-600 text-center">
                <p>🔒 Thanh toán bảo mật SSL</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Cart;
