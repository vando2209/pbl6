import React, { useState } from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { Search, ShoppingBag, User, Menu, X, Heart, Camera } from 'lucide-react';
import { useCart } from '../contexts/CartContext';
import { useAuth } from '../contexts/AuthContext';

const Header: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const { itemCount } = useCart();
  const { isAuthenticated, user, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      navigate(`/search?q=${encodeURIComponent(searchQuery.trim())}`);
      setSearchQuery('');
    }
  };

  const isActive = (path: string) => {
    return location.pathname === path;
  };

  return (
    <header className="bg-white shadow-sm sticky top-0 z-40">
      {/* Top Bar */}
      <div className="bg-gray-900 text-white text-sm">
        <div className="container mx-auto px-4 py-2">
          <div className="flex justify-between items-center">
            <div className="flex space-x-4">
              <Link to="/about" className="hover:text-gray-300">Về chúng tôi</Link>
              <Link to="/contact" className="hover:text-gray-300">Liên hệ</Link>
              <Link to="/size-guide" className="hover:text-gray-300">Bảng size</Link>
            </div>
            <div className="flex space-x-4">
              <span>Miễn phí giao hàng cho đơn từ 500.000đ</span>
              <span>|</span>
              <span>Hotline: 1900 1000</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Header */}
      <div className="container mx-auto px-4 py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <Link to="/" className="flex items-center space-x-2">
            <div className="w-10 h-10 bg-red-600 rounded-full flex items-center justify-center">
              <span className="text-white font-bold text-xl">U</span>
            </div>
            <span className="text-2xl font-bold text-gray-900">UNIQLO</span>
          </Link>

          {/* Navigation - Desktop */}
          <nav className="hidden lg:flex space-x-8">
            <Link 
              to="/men" 
              className={`font-medium transition-colors ${
                isActive('/men') ? 'text-red-600' : 'text-gray-700 hover:text-red-600'
              }`}
            >
              Nam
            </Link>
            <Link 
              to="/women" 
              className={`font-medium transition-colors ${
                isActive('/women') ? 'text-red-600' : 'text-gray-700 hover:text-red-600'
              }`}
            >
              Nữ
            </Link>
            <Link 
              to="/kids" 
              className={`font-medium transition-colors ${
                isActive('/kids') ? 'text-red-600' : 'text-gray-700 hover:text-red-600'
              }`}
            >
              Trẻ em
            </Link>
          </nav>

          {/* Search Bar - Desktop */}
          <form onSubmit={handleSearch} className="hidden md:flex items-center flex-1 max-w-md mx-8">
            <div className="relative w-full">
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Tìm kiếm sản phẩm..."
                className="w-full pl-4 pr-10 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-red-600 focus:border-transparent"
              />
              <button
                type="submit"
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-red-600"
              >
                <Search size={20} />
              </button>
            </div>
          </form>

          {/* Action Buttons */}
          <div className="flex items-center space-x-4">
            {/* Search - Mobile */}
            <button className="md:hidden p-2 text-gray-600 hover:text-red-600">
              <Search size={20} />
            </button>

            {/* AI Search */}
            <button className="hidden sm:flex items-center space-x-1 px-3 py-2 bg-purple-100 text-purple-600 rounded-full hover:bg-purple-200 transition-colors">
              <Camera size={16} />
              <span className="text-sm font-medium">AI</span>
            </button>

            {/* Wishlist */}
            <button className="p-2 text-gray-600 hover:text-red-600 relative">
              <Heart size={20} />
              <span className="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                0
              </span>
            </button>

            {/* Cart */}
            <Link to="/cart" className="p-2 text-gray-600 hover:text-red-600 relative">
              <ShoppingBag size={20} />
              {itemCount > 0 && (
                <span className="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                  {itemCount}
                </span>
              )}
            </Link>

            {/* User Account */}
            {isAuthenticated ? (
              <div className="relative group">
                <button className="flex items-center space-x-2 p-2 text-gray-600 hover:text-red-600">
                  <User size={20} />
                  <span className="hidden sm:block text-sm">{user?.name}</span>
                </button>
                <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                  <div className="py-2">
                    <Link
                      to={user?.role === 'admin' ? '/admin' : '/customer'}
                      className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    >
                      Tài khoản của tôi
                    </Link>
                    <Link
                      to="/customer"
                      className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    >
                      Đơn hàng
                    </Link>
                    <button
                      onClick={logout}
                      className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    >
                      Đăng xuất
                    </button>
                  </div>
                </div>
              </div>
            ) : (
              <Link to="/account" className="p-2 text-gray-600 hover:text-red-600">
                <User size={20} />
              </Link>
            )}

            {/* Mobile Menu Button */}
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="lg:hidden p-2 text-gray-600 hover:text-red-600"
            >
              {isMenuOpen ? <X size={20} /> : <Menu size={20} />}
            </button>
          </div>
        </div>

        {/* Mobile Search */}
        <form onSubmit={handleSearch} className="md:hidden mt-4">
          <div className="relative">
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Tìm kiếm sản phẩm..."
              className="w-full pl-4 pr-10 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-red-600 focus:border-transparent"
            />
            <button
              type="submit"
              className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-red-600"
            >
              <Search size={20} />
            </button>
          </div>
        </form>
      </div>

      {/* Mobile Menu */}
      {isMenuOpen && (
        <div className="lg:hidden bg-white border-t">
          <div className="container mx-auto px-4 py-4">
            <nav className="space-y-4">
              <Link
                to="/men"
                className="block py-2 text-gray-700 hover:text-red-600 font-medium"
                onClick={() => setIsMenuOpen(false)}
              >
                Nam
              </Link>
              <Link
                to="/women"
                className="block py-2 text-gray-700 hover:text-red-600 font-medium"
                onClick={() => setIsMenuOpen(false)}
              >
                Nữ
              </Link>
              <Link
                to="/kids"
                className="block py-2 text-gray-700 hover:text-red-600 font-medium"
                onClick={() => setIsMenuOpen(false)}
              >
                Trẻ em
              </Link>
              <hr />
              <Link
                to="/about"
                className="block py-2 text-gray-600 hover:text-red-600"
                onClick={() => setIsMenuOpen(false)}
              >
                Về chúng tôi
              </Link>
              <Link
                to="/contact"
                className="block py-2 text-gray-600 hover:text-red-600"
                onClick={() => setIsMenuOpen(false)}
              >
                Liên hệ
              </Link>
              <Link
                to="/size-guide"
                className="block py-2 text-gray-600 hover:text-red-600"
                onClick={() => setIsMenuOpen(false)}
              >
                Bảng size
              </Link>
            </nav>
          </div>
        </div>
      )}
    </header>
  );
};

export default Header;