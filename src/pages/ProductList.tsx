import React, { useState, useMemo, useEffect } from 'react';
import { useParams, Link, useSearchParams } from 'react-router-dom';
import { Filter, SlidersHorizontal, ChevronRight } from 'lucide-react';
import ProductCard from '../components/ProductCard';
import { fetchProducts, parseMaybeJson, type Product } from '../api';

// ====== META nội bộ cho UI (không lấy từ data tĩnh) ======
const CATEGORY_META = [
  { id: 'men', name: 'Nam',   path: '/men',   subcategories: ['T-shirt', 'Áo Polo', 'Áo Sơ Mi', 'Quần Jean', 'Áo Khoác'] },
  { id: 'women', name: 'Nữ',  path: '/women', subcategories: ['Áo Blouse', 'T-shirt', 'Váy', 'Cardigan', 'Áo Khoác'] },
  { id: 'kids', name: 'Trẻ em', path: '/kids', subcategories: ['T-shirt', 'Váy', 'Quần Jean', 'Áo Khoác'] },
] as const;
type CatId = (typeof CATEGORY_META)[number]['id'];

const ProductList: React.FC = () => {
  const params = useParams<{ category: CatId }>();
  const category = (params.category as CatId) || (window.location.pathname.split('/')[1] as CatId);
  const [searchParams] = useSearchParams();
  const subcategoryFromUrl = searchParams.get('subcategory');

  const [selectedSubcategory, setSelectedSubcategory] = useState<string>(subcategoryFromUrl || 'all');
  const [sortBy, setSortBy] = useState<string>('default');
  const [priceMax, setPriceMax] = useState<number>(2_000_000);
  const [showFilters, setShowFilters] = useState(false);
  const [saleOnly, setSaleOnly] = useState(false);

  // dữ liệu từ API
  const [items, setItems] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  // Cập nhật subcategory khi URL đổi
  useEffect(() => {
    setSelectedSubcategory(subcategoryFromUrl || 'all');
  }, [subcategoryFromUrl]);

  // Reset filter khi đổi category
  useEffect(() => {
    setSelectedSubcategory('all');
    setSortBy('default');
    setPriceMax(2_000_000);
    setSaleOnly(false);
  }, [category]);

  const currentCategory = CATEGORY_META.find(cat => cat.id === category);
  const categorySubcategories = currentCategory?.subcategories ?? [];

  // === GỌI API mỗi khi category / saleOnly đổi ===
  useEffect(() => {
    let aborted = false;
    (async () => {
      setLoading(true);
      try {
        const { data } = await fetchProducts({
          page: 1,
          pageSize: 500,         // đủ lớn cho dataset hiện tại
          category_id: category, // đúng tên tham số backend: category_id
          // KHÔNG gửi subcategory (backend cần subcategory_id dạng số)
          is_sale: saleOnly ? 1 : undefined,
        });
        if (aborted) return;

        const normalized = data.map(p => ({
          ...p,
          images: parseMaybeJson<string[]>(p.images),
          colors: parseMaybeJson<string[]>(p.colors),
          sizes: parseMaybeJson<string[]>(p.sizes),
          features: parseMaybeJson<string[]>(p.features),
        }));
        setItems(normalized);
      } finally {
        if (!aborted) setLoading(false);
      }
    })();
    return () => { aborted = true; };
  }, [category, saleOnly]);

  // === Lọc theo subcategory + giá & sort ở client ===
  const filteredProducts = useMemo(() => {
    let result = items;

    // Lọc theo subcategory: match theo tên / mô tả (vì chưa có subcategory_id -> name map)
    if (selectedSubcategory !== 'all') {
      const key = selectedSubcategory.toLowerCase();
      result = result.filter(p =>
        p.name.toLowerCase().includes(key) ||
        (typeof p.description === 'string' && p.description.toLowerCase().includes(key))
      );
    }

    // Lọc theo giá (<= priceMax)
    result = result.filter(p => p.price <= priceMax);

    // Sort
    switch (sortBy) {
      case 'price-low':
        result = [...result].sort((a, b) => a.price - b.price);
        break;
      case 'price-high':
        result = [...result].sort((a, b) => b.price - a.price);
        break;
      case 'name':
        result = [...result].sort((a, b) => a.name.localeCompare(b.name));
        break;
      case 'newest':
        result = [...result].sort((a, b) => (Number(b.is_new) || 0) - (Number(a.is_new) || 0));
        break;
      case 'rating':
        result = [...result].sort((a, b) => (b.rating || 0) - (a.rating || 0));
        break;
      default:
        break;
    }

    return result;
  }, [items, selectedSubcategory, priceMax, sortBy]);

  if (!currentCategory) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Danh mục không tồn tại
          </h2>
          <Link
            to="/"
            className="inline-block px-6 py-3 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
          >
            Về trang chủ
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
            <Link to={currentCategory.path} className="text-gray-600 hover:text-red-600">
              {currentCategory.name}
            </Link>
            {selectedSubcategory !== 'all' && (
              <>
                <ChevronRight size={16} className="text-gray-400" />
                <span className="text-gray-900 font-medium">{selectedSubcategory}</span>
              </>
            )}
          </nav>
        </div>
      </div>

      {/* Header */}
      <div className="bg-white shadow-sm">
        <div className="container mx-auto px-4 py-8">
          <div className="flex flex-col md:flex-row justify-between items-start md:items-center">
            <div>
              <h1 className="text-3xl font-bold text-gray-900 mb-2">
                {selectedSubcategory !== 'all' ? selectedSubcategory : currentCategory.name}
              </h1>
              <p className="text-gray-600">
                {loading ? 'Đang tải…' : `${filteredProducts.length} sản phẩm`}
              </p>
            </div>

            <div className="flex items-center space-x-4 mt-4 md:mt-0">
              <button
                onClick={() => setShowFilters(!showFilters)}
                className="lg:hidden flex items-center space-x-2 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
              >
                <Filter size={16} />
                <span>Bộ lọc</span>
              </button>

              <div className="flex items-center space-x-2">
                <SlidersHorizontal size={16} className="text-gray-600" />
                <select
                  value={sortBy}
                  onChange={(e) => setSortBy(e.target.value)}
                  className="border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-red-600"
                >
                  <option value="default">Mặc định</option>
                  <option value="newest">Mới nhất</option>
                  <option value="price-low">Giá thấp đến cao</option>
                  <option value="price-high">Giá cao đến thấp</option>
                  <option value="name">Tên A-Z</option>
                  <option value="rating">Đánh giá cao nhất</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="container mx-auto px-4 py-8">
        <div className="flex flex-col lg:flex-row gap-8">
          {/* Sidebar Filters */}
          <div className={`lg:w-64 lg:flex-shrink-0 ${showFilters ? 'block' : 'hidden lg:block'}`}>
            <div className="bg-white rounded-lg shadow-sm p-6 sticky top-24">
              <h3 className="text-lg font-semibold mb-4">Bộ lọc</h3>

              {/* Subcategory Filter */}
              <div className="mb-6">
                <h4 className="font-medium mb-3">Danh mục</h4>
                <div className="space-y-2">
                  <label className="flex items-center">
                    <input
                      type="radio"
                      name="subcategory"
                      value="all"
                      checked={selectedSubcategory === 'all'}
                      onChange={(e) => setSelectedSubcategory(e.target.value)}
                      className="mr-2 text-red-600"
                    />
                    Tất cả {currentCategory.name}
                  </label>
                  {categorySubcategories.map((subcat) => (
                    <label key={subcat} className="flex items-center">
                      <input
                        type="radio"
                        name="subcategory"
                        value={subcat}
                        checked={selectedSubcategory === subcat}
                        onChange={(e) => setSelectedSubcategory(e.target.value)}
                        className="mr-2 text-red-600"
                      />
                      {subcat}
                    </label>
                  ))}
                </div>
              </div>

              {/* Price Range Filter */}
              <div className="mb-6">
                <h4 className="font-medium mb-3">Khoảng giá</h4>
                <div className="space-y-3">
                  <input
                    type="range"
                    min="0"
                    max="2000000"
                    step="50000"
                    value={priceMax}
                    onChange={(e) => setPriceMax(parseInt(e.target.value))}
                    className="w-full"
                  />
                  <div className="flex justify-between text-sm text-gray-600">
                    <span>0đ</span>
                    <span>{priceMax.toLocaleString('vi-VN')}đ</span>
                  </div>
                </div>
              </div>

              {/* Quick Filters */}
              <div className="mb-6">
                <h4 className="font-medium mb-3">Lọc nhanh</h4>
                <div className="space-y-2">
                  <button
                    onClick={() => {
                      setSelectedSubcategory('all');
                      setSortBy('newest');
                      setSaleOnly(false);
                    }}
                    className="w-full text-left px-3 py-2 text-sm bg-gray-50 hover:bg-gray-100 rounded"
                  >
                    Sản phẩm mới
                  </button>
                  <button
                    onClick={() => {
                      setSelectedSubcategory('all');
                      setSortBy('default');
                      setSaleOnly(true); // bật lọc khuyến mãi -> gọi lại API
                    }}
                    className="w-full text-left px-3 py-2 text-sm bg-gray-50 hover:bg-gray-100 rounded"
                  >
                    Khuyến mãi
                  </button>
                  <button
                    onClick={() => setSortBy('rating')}
                    className="w-full text-left px-3 py-2 text-sm bg-gray-50 hover:bg-gray-100 rounded"
                  >
                    Bán chạy nhất
                  </button>
                </div>
                {saleOnly && (
                  <button
                    onClick={() => setSaleOnly(false)}
                    className="mt-2 w-full text-left px-3 py-2 text-sm bg-white border hover:bg-gray-50 rounded"
                  >
                    Bỏ lọc khuyến mãi
                  </button>
                )}
              </div>
            </div>
          </div>

          {/* Product Grid */}
          <div className="flex-1">
            {loading ? (
              <div className="bg-white rounded-lg shadow-sm p-12 text-center">
                Đang tải sản phẩm…
              </div>
            ) : filteredProducts.length > 0 ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                {filteredProducts.map((product) => (
                  <ProductCard key={product.id} product={product as any} />
                ))}
              </div>
            ) : (
              <div className="bg-white rounded-lg shadow-sm p-12 text-center">
                <div className="text-gray-400 mb-4">
                  <Filter size={48} className="mx-auto" />
                </div>
                <h3 className="text-lg font-medium text-gray-900 mb-2">
                  Không tìm thấy sản phẩm
                </h3>
                <p className="text-gray-600 mb-4">
                  Thử thay đổi bộ lọc để xem thêm sản phẩm khác
                </p>
                <button
                  onClick={() => {
                    setSelectedSubcategory('all');
                    setPriceMax(2_000_000);
                    setSortBy('default');
                    setSaleOnly(false);
                  }}
                  className="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
                >
                  Xóa bộ lọc
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProductList;
