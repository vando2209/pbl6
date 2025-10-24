import React, { useState, useRef, useCallback } from 'react';
import { Camera, Upload, X, Search, Loader, Sparkles } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { fetchProducts, parseMaybeJson, type Product } from '../api';

interface ImageSearchProps {
  isOpen: boolean;
  onClose: () => void;
}

interface SearchResult {
  product: Product;
  confidence: number;
  similarity: number;
}

const ImageSearch: React.FC<ImageSearchProps> = ({ isOpen, onClose }) => {
  const [selectedImage, setSelectedImage] = useState<string | null>(null);
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [searchResults, setSearchResults] = useState<SearchResult[]>([]);
  const [dragActive, setDragActive] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const cameraInputRef = useRef<HTMLInputElement>(null);
  const navigate = useNavigate();

  // Demo "AI": gọi API lấy danh sách sản phẩm (newest) rồi gán điểm giả lập
  const analyzeImage = useCallback(async (_imageFile: File): Promise<SearchResult[]> => {
    // gọi API lấy khoảng 12 sp mới nhất (tuỳ bạn muốn lọc theo category sau)
    const { data } = await fetchProducts({ page: 1, pageSize: 12 });

    // đảm bảo các field JSON đã được parse
    const normalized = data.map(p => ({
      ...p,
      images: parseMaybeJson<string[]>(p.images),
      colors: parseMaybeJson<string[]>(p.colors),
      sizes: parseMaybeJson<string[]>(p.sizes),
      features: parseMaybeJson<string[]>(p.features),
    }));

    // gán điểm confidence/similarity giả lập theo vị trí
    const results: SearchResult[] = normalized.map((p, i) => ({
      product: p,
      confidence: Math.max(0.65, 0.95 - i * 0.03),
      similarity: Math.max(0.6, 0.92 - i * 0.025),
    }));

    return results.sort((a, b) => b.confidence - a.confidence);
  }, []);

  const handleImageUpload = useCallback(async (file: File) => {
    if (!file.type.startsWith('image/')) {
      alert('Vui lòng chọn file hình ảnh');
      return;
    }

    const reader = new FileReader();
    reader.onload = async (e) => {
      const imageUrl = e.target?.result as string;
      setSelectedImage(imageUrl);
      setIsAnalyzing(true);
      setSearchResults([]);

      try {
        // giả lập trễ một chút cho UX
        await new Promise(r => setTimeout(r, 600));
        const results = await analyzeImage(file);
        setSearchResults(results);
      } catch (error) {
        console.error('Error analyzing image:', error);
        alert('Có lỗi xảy ra khi phân tích hình ảnh');
      } finally {
        setIsAnalyzing(false);
      }
    };
    reader.readAsDataURL(file);
  }, [analyzeImage]);

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      handleImageUpload(file);
    }
  };

  const handleDrag = (e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (e.type === 'dragenter' || e.type === 'dragover') {
      setDragActive(true);
    } else if (e.type === 'dragleave') {
      setDragActive(false);
    }
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    setDragActive(false);

    const file = e.dataTransfer.files?.[0];
    if (file) {
      handleImageUpload(file);
    }
  };

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(price);
  };

  const getConfidenceColor = (confidence: number) => {
    if (confidence >= 0.9) return 'text-green-600 bg-green-100';
    if (confidence >= 0.8) return 'text-blue-600 bg-blue-100';
    if (confidence >= 0.7) return 'text-orange-600 bg-orange-100';
    return 'text-gray-600 bg-gray-100';
  };

  const handleProductClick = (productId: string) => {
    navigate(`/product/${productId}`);
    onClose();
  };

  const resetSearch = () => {
    setSelectedImage(null);
    setSearchResults([]);
    setIsAnalyzing(false);
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-purple-100 rounded-lg">
              <Sparkles size={24} className="text-purple-600" />
            </div>
            <div>
              <h2 className="text-xl font-bold text-gray-900">Tìm kiếm bằng AI</h2>
              <p className="text-sm text-gray-600">Upload hình ảnh để tìm sản phẩm tương tự</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X size={24} className="text-gray-600" />
          </button>
        </div>

        <div className="p-6 max-h-[calc(90vh-80px)] overflow-y-auto">
          {!selectedImage ? (
            /* Upload Area */
            <div
              className={`border-2 border-dashed rounded-lg p-12 text-center transition-colors ${
                dragActive
                  ? 'border-purple-500 bg-purple-50'
                  : 'border-gray-300 hover:border-purple-400 hover:bg-purple-50'
              }`}
              onDragEnter={handleDrag}
              onDragLeave={handleDrag}
              onDragOver={handleDrag}
              onDrop={handleDrop}
            >
              <div className="space-y-4">
                <div className="flex justify-center">
                  <div className="p-4 bg-purple-100 rounded-full">
                    <Upload size={48} className="text-purple-600" />
                  </div>
                </div>

                <div>
                  <h3 className="text-lg font-semibold text-gray-900 mb-2">
                    Tải lên hình ảnh sản phẩm
                  </h3>
                  <p className="text-gray-600 mb-4">
                    Kéo thả hình ảnh vào đây hoặc click để chọn file
                  </p>
                </div>

                <div className="flex flex-col sm:flex-row gap-4 justify-center">
                  <button
                    onClick={() => fileInputRef.current?.click()}
                    className="flex items-center justify-center space-x-2 px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
                  >
                    <Upload size={20} />
                    <span>Chọn từ máy tính</span>
                  </button>

                  <button
                    onClick={() => cameraInputRef.current?.click()}
                    className="flex items-center justify-center space-x-2 px-6 py-3 border border-purple-600 text-purple-600 rounded-lg hover:bg-purple-50 transition-colors"
                  >
                    <Camera size={20} />
                    <span>Chụp ảnh</span>
                  </button>
                </div>

                <div className="text-sm text-gray-500">
                  Hỗ trợ: JPG, PNG, GIF (tối đa 10MB)
                </div>
              </div>

              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                onChange={handleFileSelect}
                className="hidden"
              />

              <input
                ref={cameraInputRef}
                type="file"
                accept="image/*"
                capture="environment"
                onChange={handleFileSelect}
                className="hidden"
              />
            </div>
          ) : (
            /* Results Area */
            <div className="space-y-6">
              {/* Uploaded Image */}
              <div className="flex flex-col lg:flex-row gap-6">
                <div className="lg:w-1/3">
                  <div className="bg-gray-50 rounded-lg p-4">
                    <div className="flex items-center justify-between mb-3">
                      <h3 className="font-semibold text-gray-900">Hình ảnh đã tải lên</h3>
                      <button
                        onClick={resetSearch}
                        className="text-sm text-purple-600 hover:text-purple-700"
                      >
                        Tải ảnh khác
                      </button>
                    </div>
                    <img
                      src={selectedImage}
                      alt="Uploaded"
                      className="w-full h-48 object-cover rounded-lg"
                    />
                  </div>
                </div>

                {/* Analysis Status */}
                <div className="lg:w-2/3">
                  {isAnalyzing ? (
                    <div className="bg-purple-50 rounded-lg p-6 text-center">
                      <div className="flex justify-center mb-4">
                        <Loader size={48} className="text-purple-600 animate-spin" />
                      </div>
                      <h3 className="text-lg font-semibold text-purple-900 mb-2">
                        AI đang phân tích hình ảnh...
                      </h3>
                      <p className="text-purple-700">
                        Vui lòng đợi trong giây lát để chúng tôi tìm sản phẩm tương tự
                      </p>
                      <div className="mt-4 bg-purple-200 rounded-full h-2">
                        <div className="bg-purple-600 h-2 rounded-full animate-pulse" style={{width: '60%'}}></div>
                      </div>
                    </div>
                  ) : searchResults.length > 0 ? (
                    <div>
                      <div className="flex items-center space-x-2 mb-4">
                        <Search size={20} className="text-green-600" />
                        <h3 className="text-lg font-semibold text-gray-900">
                          Tìm thấy {searchResults.length} sản phẩm tương tự
                        </h3>
                      </div>
                      <p className="text-gray-600 mb-4">
                        Kết quả được sắp xếp theo độ chính xác từ cao đến thấp
                      </p>
                    </div>
                  ) : null}
                </div>
              </div>

              {/* Search Results */}
              {searchResults.length > 0 && !isAnalyzing && (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  {searchResults.map((result) => {
                    const imgs = Array.isArray(result.product.images)
                      ? result.product.images
                      : parseMaybeJson<string[]>(result.product.images);
                    const cover = imgs?.[0];
                    const cat =
                      result.product.category_id === 'men'
                        ? 'Nam'
                        : result.product.category_id === 'women'
                        ? 'Nữ'
                        : 'Trẻ em';

                    return (
                      <div
                        key={result.product.id}
                        className="border rounded-lg p-4 hover:shadow-md transition-shadow cursor-pointer"
                        onClick={() => handleProductClick(result.product.id)}
                      >
                        <div className="flex space-x-4">
                          {cover ? (
                            <img
                              src={cover}
                              alt={result.product.name}
                              className="w-20 h-20 object-cover rounded-lg"
                            />
                          ) : (
                            <div className="w-20 h-20 bg-gray-100 rounded-lg" />
                          )}
                          <div className="flex-1">
                            <div className="flex items-start justify-between mb-2">
                              <h4 className="font-medium text-gray-900 line-clamp-2">
                                {result.product.name}
                              </h4>
                              <span
                                className={`px-2 py-1 rounded-full text-xs font-medium ${getConfidenceColor(
                                  result.confidence
                                )}`}
                              >
                                {Math.round(result.confidence * 100)}%
                              </span>
                            </div>

                            <p className="text-sm text-gray-600 mb-2">
                              Mục {result.product.subcategory_id} • {cat}
                            </p>

                            <div className="flex items-center justify-between">
                              <div className="flex items-center space-x-2">
                                <span className="font-semibold text-red-600">
                                  {formatPrice(result.product.price)}
                                </span>
                                {result.product.original_price ? (
                                  <span className="text-sm text-gray-500 line-through">
                                    {formatPrice(result.product.original_price)}
                                  </span>
                                ) : null}
                              </div>
                              <div className="text-xs text-gray-500">
                                Độ tương tự: {Math.round(result.similarity * 100)}%
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}

              {/* AI Training Note */}
              <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                <div className="flex items-start space-x-3">
                  <Sparkles size={20} className="text-blue-600 mt-0.5" />
                  <div>
                    <h4 className="font-medium text-blue-900 mb-1">
                      Tính năng AI đang được phát triển
                    </h4>
                    <p className="text-sm text-blue-800">
                      Hiện tại đây là demo với kết quả mẫu từ dữ liệu trong database. Sau này,
                      hệ thống AI sẽ phân tích ảnh (màu sắc, kiểu dáng, chất liệu) và đề xuất
                      sản phẩm tương tự với độ chính xác cao.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ImageSearch;
