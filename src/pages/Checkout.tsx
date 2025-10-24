import React, { useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import { ChevronRight, CreditCard, Truck, MapPin } from 'lucide-react';
import { useCart } from '../contexts/CartContext';

type FormState = {
  // Shipping
  fullName: string;
  email: string;
  phone: string;
  address: string;
  city: string;
  district: string;
  ward: string;
  // Payment
  paymentMethod: 'cod' | 'card';
  cardNumber: string;
  cardName: string;
  expiryDate: string; // MM/YY
  cvv: string;
  // Notes
  notes: string;
};

const Checkout: React.FC = () => {
  const { items, total, itemCount, clearCart } = useCart();
  const [step, setStep] = useState<1 | 2 | 3>(1);
  const [submitting, setSubmitting] = useState(false);
  const [touched, setTouched] = useState<Record<string, boolean>>({});

  const [formData, setFormData] = useState<FormState>({
    // Shipping Info
    fullName: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    district: '',
    ward: '',
    // Payment Info
    paymentMethod: 'cod',
    cardNumber: '',
    cardName: '',
    expiryDate: '',
    cvv: '',
    // Order Notes
    notes: ''
  });

  const formatPrice = (price: number) =>
    new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price);

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>
  ) => {
    const { name, value } = e.target;
    setFormData(s => ({ ...s, [name]: value as any }));
    setTouched(t => ({ ...t, [name]: true }));
  };

  // ===== Simple validations per step =====
  const errors = useMemo(() => {
    const err: Partial<Record<keyof FormState, string>> = {};

    if (step === 1) {
      if (!formData.fullName.trim()) err.fullName = 'Vui lòng nhập họ và tên';
      if (!formData.phone.trim()) err.phone = 'Vui lòng nhập số điện thoại';
      if (!formData.email.trim() || !/^\S+@\S+\.\S+$/.test(formData.email)) err.email = 'Email chưa hợp lệ';
      if (!formData.address.trim()) err.address = 'Vui lòng nhập địa chỉ';
      if (!formData.city) err.city = 'Vui lòng chọn Tỉnh/Thành phố';
      if (!formData.district) err.district = 'Vui lòng chọn Quận/Huyện';
      if (!formData.ward) err.ward = 'Vui lòng chọn Phường/Xã';
    }

    if (step === 2 && formData.paymentMethod === 'card') {
      if (!/^\d{12,19}$/.test(formData.cardNumber.replace(/\s+/g, '')))
        err.cardNumber = 'Số thẻ không hợp lệ';
      if (!formData.cardName.trim()) err.cardName = 'Vui lòng nhập tên trên thẻ';
      if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(formData.expiryDate))
        err.expiryDate = 'Định dạng MM/YY';
      if (!/^\d{3,4}$/.test(formData.cvv)) err.cvv = 'CVV không hợp lệ';
    }

    return err;
  }, [formData, step]);

  const stepValid = useMemo(() => Object.keys(errors).length === 0, [errors]);

  const requireTouchAll = (keys: (keyof FormState)[]) => {
    setTouched(prev => {
      const next = { ...prev };
      keys.forEach(k => (next[k] = true));
      return next;
    });
  };

  const handleNext = async () => {
    if (step === 1) {
      requireTouchAll(['fullName', 'phone', 'email', 'address', 'city', 'district', 'ward']);
      if (!stepValid) return;
      setStep(2);
      return;
    }
    if (step === 2) {
      if (formData.paymentMethod === 'card') {
        requireTouchAll(['cardNumber', 'cardName', 'expiryDate', 'cvv']);
        if (!stepValid) return;
      }
      setStep(3);
      return;
    }
    if (step === 3) {
      // Submit order
      setSubmitting(true);
      try {
        // TODO: Gọi API tạo đơn hàng tại đây
        // await createOrder({ items, formData, total })
        alert('Đặt hàng thành công! Cảm ơn bạn đã mua sắm.');
        clearCart?.();
      } finally {
        setSubmitting(false);
      }
    }
  };

  if (items.length === 0) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Giỏ hàng trống</h2>
          <p className="text-gray-600 mb-6">Bạn cần thêm sản phẩm vào giỏ hàng trước khi thanh toán</p>
          <Link
            to="/"
            className="inline-block px-6 py-3 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
          >
            Tiếp tục mua sắm
          </Link>
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
            <Link to="/cart" className="text-gray-600 hover:text-red-600">Giỏ hàng</Link>
            <ChevronRight size={16} className="text-gray-400" />
            <span className="text-gray-900 font-medium">Thanh toán</span>
          </nav>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        {/* Steps */}
        <div className="mb-8">
          <div className="flex items-center justify-center space-x-8">
            {[
              { idx: 1, title: 'Thông tin giao hàng', icon: MapPin },
              { idx: 2, title: 'Phương thức thanh toán', icon: CreditCard },
              { idx: 3, title: 'Xác nhận đơn hàng', icon: Truck },
            ].map(s => (
              <div key={s.idx} className="flex items-center">
                <div
                  className={`flex items-center justify-center w-10 h-10 rounded-full ${
                    step >= (s.idx as 1 | 2 | 3) ? 'bg-red-600 text-white' : 'bg-gray-200 text-gray-600'
                  }`}
                >
                  <s.icon size={20} />
                </div>
                <span
                  className={`ml-2 font-medium ${
                    step >= (s.idx as 1 | 2 | 3) ? 'text-red-600' : 'text-gray-600'
                  }`}
                >
                  {s.title}
                </span>
              </div>
            ))}
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-lg shadow-sm p-6">
              {/* Step 1: Shipping */}
              {step === 1 && (
                <div>
                  <h2 className="text-xl font-semibold mb-6">Thông tin giao hàng</h2>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Họ và tên *</label>
                      <input
                        type="text"
                        name="fullName"
                        value={formData.fullName}
                        onChange={handleInputChange}
                        className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                          touched.fullName && !formData.fullName ? 'border-red-500' : 'border-gray-300'
                        }`}
                      />
                      {touched.fullName && !formData.fullName && (
                        <p className="text-xs text-red-600 mt-1">Vui lòng nhập họ và tên</p>
                      )}
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Số điện thoại *</label>
                      <input
                        type="tel"
                        name="phone"
                        value={formData.phone}
                        onChange={handleInputChange}
                        className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                          touched.phone && !formData.phone ? 'border-red-500' : 'border-gray-300'
                        }`}
                      />
                      {touched.phone && !formData.phone && (
                        <p className="text-xs text-red-600 mt-1">Vui lòng nhập số điện thoại</p>
                      )}
                    </div>
                  </div>

                  <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700 mb-1">Email *</label>
                    <input
                      type="email"
                      name="email"
                      value={formData.email}
                      onChange={handleInputChange}
                      className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                        touched.email && (!formData.email || !/^\S+@\S+\.\S+$/.test(formData.email))
                          ? 'border-red-500'
                          : 'border-gray-300'
                      }`}
                    />
                    {touched.email && (!formData.email || !/^\S+@\S+\.\S+$/.test(formData.email)) && (
                      <p className="text-xs text-red-600 mt-1">Email chưa hợp lệ</p>
                    )}
                  </div>

                  <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700 mb-1">Địa chỉ *</label>
                    <input
                      type="text"
                      name="address"
                      value={formData.address}
                      onChange={handleInputChange}
                      placeholder="Số nhà, tên đường"
                      className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                        touched.address && !formData.address ? 'border-red-500' : 'border-gray-300'
                      }`}
                    />
                    {touched.address && !formData.address && (
                      <p className="text-xs text-red-600 mt-1">Vui lòng nhập địa chỉ</p>
                    )}
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Tỉnh/Thành phố *</label>
                      <select
                        name="city"
                        value={formData.city}
                        onChange={handleInputChange}
                        className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                          touched.city && !formData.city ? 'border-red-500' : 'border-gray-300'
                        }`}
                      >
                        <option value="">Chọn tỉnh/thành</option>
                        <option value="ho-chi-minh">TP. Hồ Chí Minh</option>
                        <option value="ha-noi">Hà Nội</option>
                        <option value="da-nang">Đà Nẵng</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Quận/Huyện *</label>
                      <select
                        name="district"
                        value={formData.district}
                        onChange={handleInputChange}
                        className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                          touched.district && !formData.district ? 'border-red-500' : 'border-gray-300'
                        }`}
                      >
                        <option value="">Chọn quận/huyện</option>
                        <option value="quan-1">Quận 1</option>
                        <option value="quan-2">Quận 2</option>
                        <option value="quan-3">Quận 3</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Phường/Xã *</label>
                      <select
                        name="ward"
                        value={formData.ward}
                        onChange={handleInputChange}
                        className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                          touched.ward && !formData.ward ? 'border-red-500' : 'border-gray-300'
                        }`}
                      >
                        <option value="">Chọn phường/xã</option>
                        <option value="phuong-1">Phường 1</option>
                        <option value="phuong-2">Phường 2</option>
                        <option value="phuong-3">Phường 3</option>
                      </select>
                    </div>
                  </div>
                </div>
              )}

              {/* Step 2: Payment */}
              {step === 2 && (
                <div>
                  <h2 className="text-xl font-semibold mb-6">Phương thức thanh toán</h2>

                  <div className="space-y-4 mb-6">
                    <label className="flex items-center p-4 border border-gray-300 rounded-lg cursor-pointer hover:bg-gray-50">
                      <input
                        type="radio"
                        name="paymentMethod"
                        value="cod"
                        checked={formData.paymentMethod === 'cod'}
                        onChange={handleInputChange}
                        className="mr-3"
                      />
                      <div className="flex items-center">
                        <Truck className="mr-3 text-red-600" size={24} />
                        <div>
                          <div className="font-medium">Thanh toán khi nhận hàng (COD)</div>
                          <div className="text-sm text-gray-600">Tiền mặt khi nhận hàng</div>
                        </div>
                      </div>
                    </label>

                    <label className="flex items-center p-4 border border-gray-300 rounded-lg cursor-pointer hover:bg-gray-50">
                      <input
                        type="radio"
                        name="paymentMethod"
                        value="card"
                        checked={formData.paymentMethod === 'card'}
                        onChange={handleInputChange}
                        className="mr-3"
                      />
                      <div className="flex items-center">
                        <CreditCard className="mr-3 text-red-600" size={24} />
                        <div>
                          <div className="font-medium">Thẻ tín dụng/ghi nợ</div>
                          <div className="text-sm text-gray-600">Visa, Mastercard, JCB</div>
                        </div>
                      </div>
                    </label>
                  </div>

                  {formData.paymentMethod === 'card' && (
                    <div className="space-y-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Số thẻ *</label>
                        <input
                          type="text"
                          name="cardNumber"
                          value={formData.cardNumber}
                          onChange={handleInputChange}
                          placeholder="1234123412341234"
                          inputMode="numeric"
                          className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                            touched.cardNumber && errors.cardNumber ? 'border-red-500' : 'border-gray-300'
                          }`}
                        />
                        {touched.cardNumber && errors.cardNumber && (
                          <p className="text-xs text-red-600 mt-1">{errors.cardNumber}</p>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Tên trên thẻ *</label>
                        <input
                          type="text"
                          name="cardName"
                          value={formData.cardName}
                          onChange={handleInputChange}
                          className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                            touched.cardName && errors.cardName ? 'border-red-500' : 'border-gray-300'
                          }`}
                        />
                        {touched.cardName && errors.cardName && (
                          <p className="text-xs text-red-600 mt-1">{errors.cardName}</p>
                        )}
                      </div>
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-1">Ngày hết hạn *</label>
                          <input
                            type="text"
                            name="expiryDate"
                            value={formData.expiryDate}
                            onChange={handleInputChange}
                            placeholder="MM/YY"
                            className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                              touched.expiryDate && errors.expiryDate ? 'border-red-500' : 'border-gray-300'
                            }`}
                          />
                          {touched.expiryDate && errors.expiryDate && (
                            <p className="text-xs text-red-600 mt-1">{errors.expiryDate}</p>
                          )}
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-1">CVV *</label>
                          <input
                            type="text"
                            name="cvv"
                            value={formData.cvv}
                            onChange={handleInputChange}
                            placeholder="123"
                            inputMode="numeric"
                            className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600 ${
                              touched.cvv && errors.cvv ? 'border-red-500' : 'border-gray-300'
                            }`}
                          />
                          {touched.cvv && errors.cvv && (
                            <p className="text-xs text-red-600 mt-1">{errors.cvv}</p>
                          )}
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              )}

              {/* Step 3: Confirm */}
              {step === 3 && (
                <div>
                  <h2 className="text-xl font-semibold mb-6">Xác nhận đơn hàng</h2>

                  <div className="space-y-6">
                    {/* Shipping Info */}
                    <div className="p-4 bg-gray-50 rounded-lg">
                      <h3 className="font-medium mb-2">Thông tin giao hàng</h3>
                      <p className="text-sm text-gray-600">
                        {formData.fullName}
                        <br />
                        {formData.phone}
                        <br />
                        {formData.email}
                        <br />
                        {formData.address}
                        {formData.ward ? `, ${formData.ward}` : ''}
                        {formData.district ? `, ${formData.district}` : ''}
                        {formData.city ? `, ${formData.city}` : ''}
                      </p>
                    </div>

                    {/* Payment Info */}
                    <div className="p-4 bg-gray-50 rounded-lg">
                      <h3 className="font-medium mb-2">Phương thức thanh toán</h3>
                      <p className="text-sm text-gray-600">
                        {formData.paymentMethod === 'cod'
                          ? 'Thanh toán khi nhận hàng (COD)'
                          : 'Thẻ tín dụng/ghi nợ'}
                      </p>
                    </div>

                    {/* Notes */}
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Ghi chú đơn hàng</label>
                      <textarea
                        name="notes"
                        value={formData.notes}
                        onChange={handleInputChange}
                        rows={3}
                        placeholder="Ghi chú thêm cho đơn hàng (tùy chọn)"
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-600"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Nav Buttons */}
              <div className="flex justify-between mt-8">
                {step > 1 && (
                  <button
                    type="button"
                    onClick={() => setStep((s) => (s === 2 ? 1 : 2))}
                    className="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                  >
                    Quay lại
                  </button>
                )}

                <button
                  type="button"
                  onClick={handleNext}
                  disabled={submitting}
                  className="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors ml-auto disabled:opacity-60"
                >
                  {step === 3 ? (submitting ? 'Đang đặt hàng...' : 'Đặt hàng') : 'Tiếp tục'}
                </button>
              </div>
            </div>
          </div>

          {/* Order Summary */}
          <div className="lg:col-span-1">
            <div className="bg-white rounded-lg shadow-sm p-6 sticky top-24">
              <h3 className="text-lg font-semibold mb-4">Tóm tắt đơn hàng</h3>

              <div className="space-y-3 mb-4">
                {items.map((item) => {
                  const key = `${item.id}-${item.selectedColor}-${item.selectedSize}`;
                  const cover =
                    Array.isArray(item.images) && item.images.length > 0 ? item.images[0] : undefined;

                  return (
                    <div key={key} className="flex items-center space-x-3">
                      {cover ? (
                        <img src={cover} alt={item.name} className="w-12 h-12 object-cover rounded" />
                      ) : (
                        <div className="w-12 h-12 rounded bg-gray-100" />
                      )}
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium text-gray-900 truncate">{item.name}</p>
                        <p className="text-xs text-gray-600">
                          {item.selectedColor} - {item.selectedSize} ×{item.quantity}
                        </p>
                      </div>
                      <p className="text-sm font-medium text-red-600">
                        {formatPrice(item.unitPrice * item.quantity)}
                      </p>
                    </div>
                  );
                })}
              </div>

              <div className="border-t pt-4 space-y-2">
                <div className="flex justify-between text-sm">
                  <span>Tạm tính ({itemCount} sản phẩm)</span>
                  <span>{formatPrice(total)}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span>Phí vận chuyển</span>
                  <span className="text-green-600">Miễn phí</span>
                </div>
                <div className="flex justify-between text-lg font-semibold text-red-600 border-t pt-2">
                  <span>Tổng cộng</span>
                  <span>{formatPrice(total)}</span>
                </div>
              </div>

              <div className="mt-4 text-xs text-gray-500">
                * Giá đã bao gồm VAT (nếu có)
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Checkout;
