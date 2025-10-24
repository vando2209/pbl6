import React from "react";
import { Link } from "react-router-dom";
import { ArrowRight, Truck, Shield, RefreshCw, Headphones, Camera, Sparkles } from "lucide-react";
import ProductCard from "../components/ProductCard";
import ImageSearch from "../components/ImageSearch";
import { fetchProducts, parseMaybeJson, type Product } from "../api";

const norm = (data: Product[]) =>
  data.map((p) => ({
    ...p,
    images: parseMaybeJson<string[]>(p.images),
    colors: parseMaybeJson<string[]>(p.colors),
    sizes: parseMaybeJson<string[]>(p.sizes),
    features: parseMaybeJson<string[]>(p.features),
  }));

const Home: React.FC = () => {
  const [isImageSearchOpen, setIsImageSearchOpen] = React.useState(false);

  const [featuredProducts, setFeaturedProducts] = React.useState<Product[]>([]);
  const [newProducts, setNewProducts] = React.useState<Product[]>([]);
  const [saleProducts, setSaleProducts] = React.useState<Product[]>([]);
  const [menProducts, setMenProducts] = React.useState<Product[]>([]);
  const [womenProducts, setWomenProducts] = React.useState<Product[]>([]);
  const [kidsProducts, setKidsProducts] = React.useState<Product[]>([]);
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    (async () => {
      try {
        const settled = await Promise.allSettled([
          fetchProducts({ page: 1, pageSize: 50 }),
          fetchProducts({ is_new: 1, page: 1, pageSize: 8 }),
          fetchProducts({ is_sale: 1, page: 1, pageSize: 8 }),
          fetchProducts({ category: "men", page: 1, pageSize: 4 }),
          fetchProducts({ category: "women", page: 1, pageSize: 4 }),
          fetchProducts({ category: "kids", page: 1, pageSize: 4 }),
        ]);

        const pick = <T,>(i: number) =>
          settled[i].status === "fulfilled" ? settled[i].value.data as T[] : [];

        const all = norm(pick<Product>(0));
        const featured = all.filter((p) => (p.rating ?? 0) >= 4.5).slice(0, 8);

        setFeaturedProducts(featured);
        setNewProducts(norm(pick<Product>(1)));
        setSaleProducts(norm(pick<Product>(2)));
        setMenProducts(norm(pick<Product>(3)));
        setWomenProducts(norm(pick<Product>(4)));
        setKidsProducts(norm(pick<Product>(5)));
      } finally {
        setLoading(false);
      }
    })();
  }, []);


  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative h-[600px] bg-gradient-to-r from-gray-900 to-gray-700 flex items-center justify-center text-white">
        <div
          className="absolute inset-0 bg-cover bg-center bg-no-repeat opacity-50"
          style={{
            backgroundImage:
              "url(https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg)",
          }}
        />
        <div className="relative z-10 text-center max-w-4xl mx-auto px-4">
          <h1 className="text-5xl md:text-6xl font-bold mb-6">LIFEWEAR FOR EVERYONE</h1>
          <p className="text-xl md:text-2xl mb-8 opacity-90">
            Thời trang chất lượng cao với thiết kế đơn giản, phù hợp cho cuộc sống hằng ngày
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link
              to="/men"
              className="bg-red-600 hover:bg-red-700 text-white px-8 py-3 rounded-full font-medium transition-colors duration-300 inline-flex items-center justify-center"
            >
              Mua sắm Nam <ArrowRight className="ml-2" size={20} />
            </Link>
            <Link
              to="/women"
              className="bg-white hover:bg-gray-100 text-gray-900 px-8 py-3 rounded-full font-medium transition-colors duration-300 inline-flex items-center justify-center"
            >
              Mua sắm Nữ <ArrowRight className="ml-2" size={20} />
            </Link>
            <button
              onClick={() => setIsImageSearchOpen(true)}
              className="bg-purple-600 hover:bg-purple-700 text-white px-8 py-3 rounded-full font-medium transition-colors duration-300 inline-flex items-center justify-center"
            >
              <Sparkles className="mr-2" size={20} />
              Tìm bằng AI
            </button>
          </div>
        </div>
      </section>

      {/* Categories Section */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center mb-12">Danh mục sản phẩm</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              {
                title: "Nam",
                image: "https://images.pexels.com/photos/1183266/pexels-photo-1183266.jpeg",
                link: "/men",
                description: "Phong cách lịch lãm, hiện đại",
                subcategories: ["T-shirt", "Áo Polo", "Áo Sơ Mi", "Quần Jean"],
              },
              {
                title: "Nữ",
                image: "https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg",
                link: "/women",
                description: "Thanh lịch, nữ tính và tinh tế",
                subcategories: ["Áo Blouse", "T-shirt", "Váy", "Cardigan"],
              },
              {
                title: "Trẻ em",
                image: "https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg",
                link: "/kids",
                description: "An toàn, thoải mái cho bé yêu",
                subcategories: ["T-shirt", "Váy", "Quần Jean", "Áo Khoác"],
              },
            ].map((category, index) => (
              <Link
                key={index}
                to={category.link}
                className="group relative overflow-hidden rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300"
              >
                <div className="aspect-w-16 aspect-h-12">
                  <img
                    src={category.image}
                    alt={category.title}
                    className="w-full h-80 object-cover group-hover:scale-105 transition-transform duration-300"
                  />
                </div>
                <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent flex items-end">
                  <div className="p-6 text-white">
                    <h3 className="text-2xl font-bold mb-2">{category.title}</h3>
                    <p className="opacity-90 mb-3">{category.description}</p>
                    <div className="mb-3">
                      <div className="flex flex-wrap gap-2">
                        {category.subcategories.map((subcat, idx) => (
                          <span key={idx} className="text-xs bg-white/20 px-2 py-1 rounded">
                            {subcat}
                          </span>
                        ))}
                      </div>
                    </div>
                    <div className="flex items-center text-sm font-medium">
                      Khám phá ngay <ArrowRight className="ml-1" size={16} />
                    </div>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* New Products Section */}
      {!loading && newProducts.length > 0 && (
        <section className="py-16 bg-gray-50">
          <div className="container mx-auto px-4">
            <div className="flex justify-between items-center mb-12">
              <h2 className="text-3xl font-bold">Sản phẩm mới</h2>
              <Link to="/men" className="text-red-600 hover:text-red-700 font-medium flex items-center">
                Xem tất cả <ArrowRight className="ml-1" size={16} />
              </Link>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {newProducts.map((product) => (
                <ProductCard key={product.id} product={product} />
              ))}
            </div>
          </div>
        </section>
      )}

      {/* Sale Products Section */}
      {!loading && saleProducts.length > 0 && (
        <section className="py-16 bg-white">
          <div className="container mx-auto px-4">
            <div className="flex justify-between items-center mb-12">
              <h2 className="text-3xl font-bold">Sản phẩm khuyến mãi</h2>
              <Link to="/women" className="text-red-600 hover:text-red-700 font-medium flex items-center">
                Xem tất cả <ArrowRight className="ml-1" size={16} />
              </Link>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {saleProducts.map((product) => (
                <ProductCard key={product.id} product={product} />
              ))}
            </div>
          </div>
        </section>
      )}

      {/* Featured Products Section */}
      <section className="py-16 bg-gray-50">
        <div className="container mx-auto px-4">
          <div className="flex justify-between items-center mb-12">
            <h2 className="text-3xl font-bold">Sản phẩm được đánh giá cao</h2>
          </div>
          {loading ? (
            <div>Loading...</div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {featuredProducts.map((product) => (
                <ProductCard key={product.id} product={product} />
              ))}
            </div>
          )}
        </div>
      </section>

      {/* Category Showcase */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center mb-12">Khám phá theo danh mục</h2>

          {/* Men's Section */}
          <div className="mb-12">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-2xl font-semibold">Thời trang Nam</h3>
              <Link to="/men" className="text-red-600 hover:text-red-700 font-medium flex items-center">
                Xem tất cả <ArrowRight className="ml-1" size={16} />
              </Link>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {loading ? (
                <div>Loading...</div>
              ) : (
                menProducts.map((product) => <ProductCard key={product.id} product={product} />)
              )}
            </div>
          </div>

          {/* Women's Section */}
          <div className="mb-12">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-2xl font-semibold">Thời trang Nữ</h3>
              <Link to="/women" className="text-red-600 hover:text-red-700 font-medium flex items-center">
                Xem tất cả <ArrowRight className="ml-1" size={16} />
              </Link>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {loading ? (
                <div>Loading...</div>
              ) : (
                womenProducts.map((product) => <ProductCard key={product.id} product={product} />)
              )}
            </div>
          </div>

          {/* Kids Section */}
          <div>
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-2xl font-semibold">Thời trang Trẻ em</h3>
              <Link to="/kids" className="text-red-600 hover:text-red-700 font-medium flex items-center">
                Xem tất cả <ArrowRight className="ml-1" size={16} />
              </Link>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {loading ? (
                <div>Loading...</div>
              ) : (
                kidsProducts.map((product) => <ProductCard key={product.id} product={product} />)
              )}
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {[
              { icon: <Truck size={40} />, title: "Miễn phí giao hàng", description: "Cho đơn hàng từ 500.000đ" },
              { icon: <Shield size={40} />, title: "Chất lượng đảm bảo", description: "Sản phẩm chính hãng 100%" },
              { icon: <RefreshCw size={40} />, title: "Đổi trả dễ dàng", description: "Trong vòng 30 ngày" },
              { icon: <Camera size={40} />, title: "Tìm kiếm AI", description: "Tìm sản phẩm bằng hình ảnh" },
            ].map((feature, index) => (
              <div
                key={index}
                className={`text-center ${
                  index === 3 ? "cursor-pointer hover:bg-purple-50 p-4 rounded-lg transition-colors" : ""
                }`}
                onClick={index === 3 ? () => setIsImageSearchOpen(true) : undefined}
              >
                <div className={`${index === 3 ? "text-purple-600" : "text-red-600"} mb-4 flex justify-center`}>
                  {feature.icon}
                </div>
                <h3 className="text-lg font-semibold mb-2">{feature.title}</h3>
                <p className="text-gray-600">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Newsletter Section */}
      <section className="py-16 bg-gray-900 text-white">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl font-bold mb-4">Đăng ký nhận tin từ UNIQLO</h2>
          <p className="text-gray-300 mb-8 max-w-2xl mx-auto">
            Nhận thông tin về sản phẩm mới, khuyến mãi đặc biệt và các bộ sưu tập độc quyền
          </p>
          <div className="max-w-md mx-auto flex">
            <input
              type="email"
              placeholder="Nhập email của bạn"
              className="flex-1 px-4 py-3 rounded-l-full text-gray-900 focus:outline-none focus:ring-2 focus:ring-red-600"
            />
            <button className="px-6 py-3 bg-red-600 hover:bg-red-700 rounded-r-full font-medium transition-colors">
              Đăng ký
            </button>
          </div>
        </div>
      </section>

      {/* Image Search Modal */}
      <ImageSearch isOpen={isImageSearchOpen} onClose={() => setIsImageSearchOpen(false)} />
    </div>
  );
};

export default Home;
