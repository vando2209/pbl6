-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 13, 2025 at 04:36 PM
-- Server version: 9.1.0
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shop_db`
--
CREATE DATABASE IF NOT EXISTS `shop_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `shop_db`;

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `line1` varchar(255) NOT NULL,
  `line2` varchar(255) DEFAULT NULL,
  `city` varchar(120) NOT NULL,
  `district` varchar(120) DEFAULT NULL,
  `ward` varchar(120) DEFAULT NULL,
  `country` varchar(80) NOT NULL DEFAULT 'VN',
  `postcode` varchar(20) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `user_id`, `full_name`, `phone`, `line1`, `line2`, `city`, `district`, `ward`, `country`, `postcode`, `is_default`) VALUES
(1, 2, 'Nguyen Van A', '0912345678', '123 Đường A', NULL, 'TP.HCM', 'Quận 1', 'Phường Bến Nghé', 'VN', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `admin_customers`
--

DROP TABLE IF EXISTS `admin_customers`;
CREATE TABLE `admin_customers` (
  `id` varchar(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(32) DEFAULT NULL,
  `total_orders` int DEFAULT '0',
  `total_spent` int DEFAULT '0',
  `join_date` date DEFAULT NULL,
  `status` enum('VIP','Regular') DEFAULT 'Regular'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin_customers`
--

INSERT INTO `admin_customers` (`id`, `name`, `email`, `phone`, `total_orders`, `total_spent`, `join_date`, `status`) VALUES
('CUST001', 'Nguyễn Văn A', 'nguyenvana@email.com', '0901234567', 5, 2450000, '2023-08-15', 'VIP'),
('CUST002', 'Trần Thị B', 'tranthib@email.com', '0907654321', 3, 1890000, '2023-10-20', 'Regular'),
('CUST003', 'Lê Văn C', 'levanc@email.com', '0912345678', 8, 3200000, '2023-06-10', 'VIP');

-- --------------------------------------------------------

--
-- Table structure for table `admin_orders`
--

DROP TABLE IF EXISTS `admin_orders`;
CREATE TABLE `admin_orders` (
  `id` varchar(20) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_email` varchar(255) DEFAULT NULL,
  `total` int NOT NULL,
  `status` enum('Đã giao','Đang giao','Đã xác nhận','Đang chuẩn bị','Chờ xử lý') NOT NULL,
  `order_date` date NOT NULL,
  `items` int NOT NULL,
  `payment_method` enum('COD','Card') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin_orders`
--

INSERT INTO `admin_orders` (`id`, `customer_name`, `customer_email`, `total`, `status`, `order_date`, `items`, `payment_method`) VALUES
('ORD001', 'Nguyễn Văn A', 'nguyenvana@email.com', 890000, 'Đã giao', '2024-01-15', 2, 'COD'),
('ORD002', 'Trần Thị B', 'tranthib@email.com', 1290000, 'Đang giao', '2024-01-20', 3, 'Card'),
('ORD003', 'Lê Văn C', 'levanc@email.com', 650000, 'Chờ xử lý', '2024-01-22', 1, 'COD'),
('ORD004', 'Phạm Thị D', 'phamthid@email.com', 1450000, 'Đã xác nhận', '2024-01-23', 4, 'Card'),
('ORD005', 'Hoàng Văn E', 'hoangvane@email.com', 780000, 'Đang chuẩn bị', '2024-01-24', 2, 'COD');

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 2, '2025-09-12 19:12:56', '2025-09-12 19:12:56');

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
CREATE TABLE `cart_items` (
  `id` bigint NOT NULL,
  `cart_id` bigint NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `variant_id` bigint DEFAULT NULL,
  `qty` int NOT NULL,
  `unit_price` int NOT NULL
) ;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `product_id`, `variant_id`, `qty`, `unit_price`) VALUES
(1, 1, 'men-tshirt-1', 2, 2, 290000),
(2, 1, 'women-dress-1', 322, 1, 690000),
(3, 1, 'kids-boy-tshirt-2', 478, 3, 220000);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` varchar(32) NOT NULL,
  `name` varchar(100) NOT NULL,
  `path` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `path`) VALUES
('kids', 'Trẻ em', '/kids'),
('men', 'Nam', '/men'),
('women', 'Nữ', '/women');

-- --------------------------------------------------------

--
-- Table structure for table `coupons`
--

DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons` (
  `id` bigint NOT NULL,
  `code` varchar(32) NOT NULL,
  `type` enum('percent','fixed') NOT NULL,
  `value` int NOT NULL,
  `min_subtotal` int DEFAULT '0',
  `max_discount` int DEFAULT NULL,
  `starts_at` datetime DEFAULT NULL,
  `ends_at` datetime DEFAULT NULL,
  `usage_limit` int DEFAULT NULL,
  `used_count` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `coupons`
--

INSERT INTO `coupons` (`id`, `code`, `type`, `value`, `min_subtotal`, `max_discount`, `starts_at`, `ends_at`, `usage_limit`, `used_count`, `is_active`) VALUES
(1, 'GIAM10', 'percent', 10, 500000, NULL, '2025-09-13 02:12:56', '2025-10-13 02:12:56', 100, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` bigint NOT NULL,
  `order_code` varchar(24) NOT NULL,
  `user_id` bigint NOT NULL,
  `status` enum('pending','paid','packing','shipped','completed','cancelled','refunded') NOT NULL DEFAULT 'pending',
  `subtotal` int NOT NULL,
  `discount_total` int NOT NULL DEFAULT '0',
  `shipping_fee` int NOT NULL DEFAULT '0',
  `grand_total` int NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'VND',
  `shipping_name` varchar(150) NOT NULL,
  `shipping_phone` varchar(30) NOT NULL,
  `shipping_addr1` varchar(255) NOT NULL,
  `shipping_addr2` varchar(255) DEFAULT NULL,
  `shipping_city` varchar(120) NOT NULL,
  `shipping_district` varchar(120) DEFAULT NULL,
  `shipping_ward` varchar(120) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_code`, `user_id`, `status`, `subtotal`, `discount_total`, `shipping_fee`, `grand_total`, `currency`, `shipping_name`, `shipping_phone`, `shipping_addr1`, `shipping_addr2`, `shipping_city`, `shipping_district`, `shipping_ward`, `note`, `created_at`, `updated_at`) VALUES
(1, 'ORD-20250913-0001', 2, 'paid', 1930000, 0, 30000, 1960000, 'VND', 'Nguyen Van A', '0912345678', '123 Đường A', NULL, 'TP.HCM', 'Quận 1', 'Phường Bến Nghé', 'Giao giờ hành chính', '2025-09-12 19:12:56', '2025-09-12 19:12:56'),
(2, 'ORD001', 3, 'paid', 890000, 0, 0, 890000, 'VND', 'Nguyễn Văn A', '0901234567', '123 Đường A', NULL, 'TP.HCM', NULL, NULL, NULL, '2025-10-13 15:48:30', '2025-10-13 15:48:30'),
(3, 'ORD002', 4, 'paid', 1290000, 0, 0, 1290000, 'VND', 'Trần Thị B', '0907654321', '456 Đường B', NULL, 'TP.HCM', NULL, NULL, NULL, '2025-10-13 15:48:30', '2025-10-13 15:48:30'),
(4, 'ORD003', 5, 'paid', 650000, 0, 0, 650000, 'VND', 'Lê Văn C', '0912345678', '789 Đường C', NULL, 'Hà Nội', NULL, NULL, NULL, '2025-10-13 15:48:30', '2025-10-13 15:48:30'),
(5, 'ORD004', 3, 'paid', 1450000, 0, 0, 1450000, 'VND', 'Nguyễn Văn A', '0901234567', '123 Đường A', NULL, 'TP.HCM', NULL, NULL, NULL, '2025-10-13 15:48:30', '2025-10-13 15:48:30'),
(6, 'ORD005', 4, 'paid', 780000, 0, 0, 780000, 'VND', 'Trần Thị B', '0907654321', '456 Đường B', NULL, 'TP.HCM', NULL, NULL, NULL, '2025-10-13 15:48:30', '2025-10-13 15:48:30');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` bigint NOT NULL,
  `order_id` bigint NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `variant_id` bigint DEFAULT NULL,
  `name_snapshot` varchar(255) NOT NULL,
  `color_snapshot` varchar(64) DEFAULT NULL,
  `size_snapshot` varchar(32) DEFAULT NULL,
  `unit_price` int NOT NULL,
  `qty` int NOT NULL,
  `line_total` int NOT NULL
) ;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `variant_id`, `name_snapshot`, `color_snapshot`, `size_snapshot`, `unit_price`, `qty`, `line_total`) VALUES
(1, 1, 'men-tshirt-1', 2, 'Áo T-shirt Nam Cotton Premium', 'Trắng', 'M', 290000, 2, 580000),
(2, 1, 'women-dress-1', 322, 'Váy Midi Nữ A-Line', 'Đen', 'M', 690000, 1, 690000),
(3, 1, 'kids-boy-tshirt-2', 478, 'Áo T-shirt Bé Trai Dinosaur', 'Xanh lá', 'M', 220000, 3, 660000),
(4, 2, 'men-tshirt-1', NULL, 'Áo T-shirt Nam Cotton Premium', 'Trắng', 'M', 290000, 1, 290000),
(5, 3, 'men-tshirt-1', NULL, 'Áo T-shirt Nam Cotton Premium', 'Trắng', 'M', 290000, 1, 290000),
(6, 4, 'men-tshirt-1', NULL, 'Áo T-shirt Nam Cotton Premium', 'Trắng', 'M', 290000, 1, 290000),
(7, 5, 'men-tshirt-1', NULL, 'Áo T-shirt Nam Cotton Premium', 'Trắng', 'M', 290000, 1, 290000),
(8, 6, 'men-tshirt-1', NULL, 'Áo T-shirt Nam Cotton Premium', 'Trắng', 'M', 290000, 1, 290000);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` bigint NOT NULL,
  `order_id` bigint NOT NULL,
  `provider` enum('cod','vnpay','momo','stripe','paypal') NOT NULL,
  `amount` int NOT NULL,
  `status` enum('pending','authorized','captured','failed','refunded') NOT NULL DEFAULT 'pending',
  `txn_id` varchar(64) DEFAULT NULL,
  `payload` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `provider`, `amount`, `status`, `txn_id`, `payload`, `created_at`, `updated_at`) VALUES
(1, 1, 'cod', 1960000, 'captured', 'COD-20250913-01', NULL, '2025-09-12 19:12:56', '2025-09-12 19:12:56');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` int NOT NULL,
  `original_price` int DEFAULT NULL,
  `category_id` varchar(32) NOT NULL,
  `subcategory_id` bigint NOT NULL,
  `description` text NOT NULL,
  `images` json NOT NULL,
  `colors` json NOT NULL,
  `sizes` json NOT NULL,
  `features` json NOT NULL,
  `is_new` tinyint(1) NOT NULL DEFAULT '0',
  `is_sale` tinyint(1) NOT NULL DEFAULT '0',
  `rating` decimal(2,1) DEFAULT NULL,
  `review_count` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `original_price`, `category_id`, `subcategory_id`, `description`, `images`, `colors`, `sizes`, `features`, `is_new`, `is_sale`, `rating`, `review_count`, `created_at`, `updated_at`) VALUES
('kids-boy-tshirt-1', 'Áo T-shirt Bé Trai Graphic', 190000, NULL, 'kids', 14, 'Áo t-shirt bé trai họa tiết graphic vui tươi, chất liệu cotton an toàn', '[\"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\", \"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\"]', '[\"Xanh\", \"Đỏ\", \"Vàng\", \"Trắng\"]', '[\"100\", \"110\", \"120\", \"130\", \"140\"]', '[\"100% Cotton organic\", \"Không độc hại\", \"Mềm mại\", \"In chắc chắn\"]', 0, 0, '4.7', 89, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('kids-boy-tshirt-2', 'Áo T-shirt Bé Trai Dinosaur', 220000, NULL, 'kids', 14, 'Áo t-shirt bé trai họa tiết khủng long, thu hút các bé', '[\"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\", \"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\"]', '[\"Xanh lá\", \"Xám\", \"Đen\"]', '[\"100\", \"110\", \"120\", \"130\", \"140\", \"150\"]', '[\"Cotton organic\", \"In 3D\", \"Màu sắc bền\", \"An toàn cho da\"]', 1, 0, '4.8', 67, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('kids-girl-dress-1', 'Váy Bé Gái Cotton Hoa', 290000, NULL, 'kids', 15, 'Váy bé gái họa tiết hoa dễ thương, phù hợp cho các bé từ 2-8 tuổi', '[\"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\", \"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\"]', '[\"Hồng\", \"Xanh nhạt\", \"Vàng\", \"Trắng\"]', '[\"100\", \"110\", \"120\", \"130\"]', '[\"Cotton organic\", \"Màu không phai\", \"Dáng A-line\", \"Thoải mái vận động\"]', 1, 0, '4.6', 112, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('kids-girl-dress-2', 'Đầm Bé Gái Princess', 350000, NULL, 'kids', 15, 'Đầm công chúa cho bé gái, thiết kế lộng lẫy cho các dịp đặc biệt', '[\"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\", \"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\"]', '[\"Hồng\", \"Tím\", \"Xanh\"]', '[\"100\", \"110\", \"120\", \"130\", \"140\"]', '[\"Chiffon mềm\", \"Lót cotton\", \"Thiết kế công chúa\", \"Phụ kiện đi kèm\"]', 0, 0, '4.5', 78, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('kids-jacket-1', 'Áo Khoác Bé Trai', 590000, NULL, 'kids', 18, 'Áo khoác bé trai chống gió, giữ ấm tốt', '[\"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\", \"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\"]', '[\"Xanh Navy\", \"Đen\", \"Xám\"]', '[\"100\", \"110\", \"120\", \"130\", \"140\", \"150\"]', '[\"Chống gió\", \"Giữ ấm\", \"Nhẹ nhàng\", \"Túi zip\"]', 0, 0, '4.5', 89, '2025-09-12 19:12:56', '2025-09-12 19:12:56'),
('kids-jacket-2', 'Áo Khoác Bé Gái', 590000, NULL, 'kids', 18, 'Áo khoác bé gái với mũ trùm đầu dễ thương', '[\"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\", \"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\"]', '[\"Hồng\", \"Tím\", \"Trắng\"]', '[\"100\", \"110\", \"120\", \"130\", \"140\"]', '[\"Có mũ trùm\", \"Giữ ấm\", \"Thiết kế dễ thương\", \"Chất liệu mềm\"]', 1, 0, '4.6', 72, '2025-09-12 19:12:56', '2025-09-12 19:12:56'),
('kids-jean-1', 'Quần Jean Bé Trai', 390000, NULL, 'kids', 16, 'Quần jean bé trai bền chắc, phù hợp cho các hoạt động vui chơi', '[\"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\", \"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\"]', '[\"Xanh đậm\", \"Xanh nhạt\", \"Đen\"]', '[\"100\", \"110\", \"120\", \"130\", \"140\", \"150\"]', '[\"Cotton denim\", \"Bền chắc\", \"Co giãn nhẹ\", \"An toàn\"]', 0, 0, '4.4', 95, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('kids-jean-2', 'Quần Jean Bé Gái', 390000, NULL, 'kids', 16, 'Quần jean bé gái thiết kế dễ thương với chi tiết thêu hoa', '[\"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\", \"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\"]', '[\"Xanh đậm\", \"Xanh nhạt\", \"Hồng nhạt\"]', '[\"100\", \"110\", \"120\", \"130\", \"140\"]', '[\"Cotton denim\", \"Chi tiết thêu\", \"Form skinny nhẹ\", \"Thoải mái\"]', 0, 0, '4.5', 87, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('kids-short-1', 'Quần Short Bé Trai', 250000, NULL, 'kids', 17, 'Quần short bé trai cotton thoải mái, phù hợp mùa hè', '[\"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\", \"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\"]', '[\"Be\", \"Xanh Navy\", \"Xám\", \"Đen\"]', '[\"100\", \"110\", \"120\", \"130\", \"140\"]', '[\"100% Cotton\", \"Thoáng mát\", \"Túi tiện lợi\", \"Dây rút\"]', 0, 0, '4.3', 76, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('kids-short-2', 'Quần Short Bé Gái', 250000, NULL, 'kids', 17, 'Quần short bé gái với chi tiết bèo nhún dễ thương', '[\"https://images.pexels.com/photos/1682699/pexels-photo-1682699.jpeg\", \"https://images.pexels.com/photos/1619779/pexels-photo-1619779.jpeg\"]', '[\"Hồng\", \"Trắng\", \"Xanh nhạt\", \"Vàng\"]', '[\"100\", \"110\", \"120\", \"130\", \"140\"]', '[\"Cotton mềm\", \"Chi tiết bèo\", \"Thoải mái\", \"Dễ giặt\"]', 0, 0, '4.4', 68, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-chino-1', 'Quần Kaki Nam Chino', 650000, NULL, 'men', 5, 'Quần kaki nam chino cao cấp, phù hợp đi làm và dạo phố', '[\"https://images.pexels.com/photos/1598508/pexels-photo-1598508.jpeg\", \"https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg\"]', '[\"Be\", \"Xanh Navy\", \"Xám\", \"Đen\"]', '[\"29\", \"30\", \"31\", \"32\", \"33\", \"34\", \"36\"]', '[\"Cotton Twill\", \"Chống nhăn\", \"Form slim\", \"Túi ẩn\"]', 0, 0, '4.5', 134, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-chino-2', 'Quần Kaki Nam Stretch', 690000, NULL, 'men', 5, 'Quần kaki co giãn thoải mái, phù hợp vận động', '[\"https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg\", \"https://images.pexels.com/photos/1598508/pexels-photo-1598508.jpeg\"]', '[\"Be\", \"Xám\", \"Xanh Navy\"]', '[\"30\", \"31\", \"32\", \"33\", \"34\", \"36\"]', '[\"Cotton pha Elastane\", \"Co giãn 4 chiều\", \"Thoải mái\"]', 1, 0, '4.7', 76, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-jacket-1', 'Áo Khoác Bomber Nam', 1290000, 1590000, 'men', 6, 'Áo khoác bomber phong cách streetwear, chất liệu polyester cao cấp', '[\"https://images.pexels.com/photos/1598508/pexels-photo-1598508.jpeg\", \"https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg\"]', '[\"Đen\", \"Xanh Navy\", \"Xám\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Chống gió\", \"Lót lưới thoáng khí\", \"Túi zip an toàn\", \"Form regular\"]', 0, 1, '4.3', 89, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-jacket-2', 'Áo Khoác Denim Nam', 890000, NULL, 'men', 6, 'Áo khoác denim classic, phong cách vintage không bao giờ lỗi thời', '[\"https://images.pexels.com/photos/1040945/pexels-photo-1040945.jpeg\", \"https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg\"]', '[\"Xanh đậm\", \"Xanh nhạt\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"100% Cotton Denim\", \"Bền chắc\", \"Classic fit\", \"Vintage style\"]', 0, 0, '4.4', 112, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-jean-1', 'Quần Jean Nam Slim Fit', 790000, NULL, 'men', 4, 'Quần jean nam form slim fit phù hợp với vóc dáng châu Á', '[\"https://images.pexels.com/photos/1598508/pexels-photo-1598508.jpeg\", \"https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg\"]', '[\"Xanh đậm\", \"Xanh nhạt\", \"Đen\"]', '[\"29\", \"30\", \"31\", \"32\", \"33\", \"34\", \"36\"]', '[\"Cotton pha Spandex\", \"Co giãn tốt\", \"Bền màu\", \"Form slim\"]', 0, 0, '4.6', 203, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-jean-2', 'Quần Jean Nam Regular Fit', 750000, NULL, 'men', 4, 'Quần jean nam form regular thoải mái, phù hợp mọi dáng người', '[\"https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg\", \"https://images.pexels.com/photos/1598508/pexels-photo-1598508.jpeg\"]', '[\"Xanh đậm\", \"Đen\", \"Xám\"]', '[\"29\", \"30\", \"31\", \"32\", \"33\", \"34\", \"36\", \"38\"]', '[\"100% Cotton\", \"Form regular\", \"Bền chắc\", \"Classic style\"]', 0, 0, '4.4', 167, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-polo-1', 'Áo Polo Nam Cotton Pique', 390000, 490000, 'men', 2, 'Áo polo nam chất liệu cotton pique cao cấp, thoáng mát và thoải mái', '[\"https://images.pexels.com/photos/1040945/pexels-photo-1040945.jpeg\", \"https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg\"]', '[\"Trắng\", \"Đen\", \"Xanh Navy\", \"Xám\", \"Đỏ\"]', '[\"S\", \"M\", \"L\", \"XL\", \"XXL\"]', '[\"100% Cotton Pique\", \"Chống nhăn\", \"Dễ giặt\", \"Form regular\"]', 0, 1, '4.6', 142, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-polo-2', 'Áo Polo Nam Dry Pique', 450000, NULL, 'men', 2, 'Áo polo công nghệ Dry Pique, thấm hút mồ hôi tốt', '[\"https://images.pexels.com/photos/1183266/pexels-photo-1183266.jpeg\", \"https://images.pexels.com/photos/1040945/pexels-photo-1040945.jpeg\"]', '[\"Xanh Navy\", \"Trắng\", \"Xám\", \"Đen\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Dry Technology\", \"UV Protection\", \"Quick Dry\"]', 1, 0, '4.8', 89, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-shirt-1', 'Áo Sơ Mi Nam Oxford', 690000, NULL, 'men', 3, 'Áo sơ mi nam chất liệu Oxford cao cấp, phù hợp đi làm và dự tiệc', '[\"https://images.pexels.com/photos/1040945/pexels-photo-1040945.jpeg\", \"https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg\"]', '[\"Trắng\", \"Xanh nhạt\", \"Hồng nhạt\", \"Xám\"]', '[\"S\", \"M\", \"L\", \"XL\", \"XXL\"]', '[\"Cotton Oxford\", \"Chống nhăn\", \"Form slim fit\", \"Dễ ủi\"]', 0, 0, '4.4', 156, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-shirt-2', 'Áo Sơ Mi Nam Easy Care', 590000, NULL, 'men', 3, 'Áo sơ mi Easy Care không cần ủi, tiện lợi cho công việc', '[\"https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg\", \"https://images.pexels.com/photos/1040945/pexels-photo-1040945.jpeg\"]', '[\"Trắng\", \"Xanh Navy\", \"Xám nhạt\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Easy Care\", \"Không cần ủi\", \"Chống nhăn\", \"Form regular\"]', 1, 0, '4.5', 98, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-short-1', 'Quần Short Nam Cotton', 450000, NULL, 'men', 7, 'Quần short nam cotton thoải mái, phù hợp mùa hè', '[\"https://images.pexels.com/photos/1598508/pexels-photo-1598508.jpeg\", \"https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg\"]', '[\"Be\", \"Xanh Navy\", \"Xám\", \"Đen\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"100% Cotton\", \"Thoáng mát\", \"Túi tiện lợi\", \"Form regular\"]', 0, 0, '4.2', 87, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-tshirt-1', 'Áo T-shirt Nam Cotton Premium', 290000, NULL, 'men', 1, 'Áo t-shirt nam chất liệu cotton cao cấp, form regular fit thoải mái', '[\"https://images.pexels.com/photos/1183266/pexels-photo-1183266.jpeg\", \"https://images.pexels.com/photos/1040945/pexels-photo-1040945.jpeg\"]', '[\"Trắng\", \"Đen\", \"Xanh Navy\", \"Xám\"]', '[\"S\", \"M\", \"L\", \"XL\", \"XXL\"]', '[\"100% Cotton\", \"Chống co rút\", \"Dễ giặt\", \"Form regular\"]', 1, 0, '4.5', 128, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-tshirt-2', 'Áo T-shirt Nam Dry Technology', 350000, NULL, 'men', 1, 'Áo t-shirt công nghệ Dry thấm hút mồ hôi tốt, phù hợp thể thao', '[\"https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg\", \"https://images.pexels.com/photos/1183266/pexels-photo-1183266.jpeg\"]', '[\"Trắng\", \"Đen\", \"Xanh\", \"Đỏ\", \"Vàng\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Công nghệ Dry\", \"Kháng khuẩn\", \"Co giãn 4 chiều\", \"Nhanh khô\"]', 0, 0, '4.7', 95, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('men-tshirt-3', 'Áo T-shirt Nam Graphic Print', 320000, 420000, 'men', 1, 'Áo t-shirt nam họa tiết graphic hiện đại, phong cách streetwear', '[\"https://images.pexels.com/photos/1598508/pexels-photo-1598508.jpeg\", \"https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg\"]', '[\"Đen\", \"Trắng\", \"Xám\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Cotton pha\", \"In chắc chắn\", \"Thiết kế độc đáo\"]', 0, 1, '4.3', 67, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-blouse-1', 'Áo Blouse Nữ Linen', 590000, NULL, 'women', 8, 'Áo blouse nữ chất liệu linen cao cấp, phong cách thanh lịch', '[\"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\", \"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\"]', '[\"Trắng\", \"Xanh nhạt\", \"Hồng\", \"Be\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"100% Linen\", \"Thoáng mát\", \"Thấm hút tốt\", \"Dáng loose fit\"]', 1, 0, '4.6', 145, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-blouse-2', 'Áo Blouse Nữ Silk Touch', 690000, NULL, 'women', 8, 'Áo blouse cảm giác như lụa, mềm mại và sang trọng', '[\"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\", \"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\"]', '[\"Trắng\", \"Đen\", \"Hồng nhạt\", \"Xanh Navy\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Silk Touch\", \"Mềm mại\", \"Không nhăn\", \"Dáng regular\"]', 0, 0, '4.7', 98, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-cardigan-1', 'Áo Cardigan Nữ Cotton', 790000, NULL, 'women', 11, 'Áo cardigan cotton mềm mại, layer hoàn hảo cho mọi outfit', '[\"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\", \"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\"]', '[\"Be\", \"Xám\", \"Hồng nhạt\", \"Xanh\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Cotton pha modal\", \"Mềm mại\", \"Không xù lông\", \"Form regular\"]', 0, 0, '4.4', 156, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-cardigan-2', 'Áo Cardigan Nữ Cashmere Touch', 990000, NULL, 'women', 11, 'Áo cardigan cảm giác như cashmere, sang trọng và ấm áp', '[\"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\", \"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\"]', '[\"Be\", \"Xám nhạt\", \"Hồng\", \"Đen\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Cashmere Touch\", \"Siêu mềm\", \"Giữ ấm tốt\", \"Không xù lông\"]', 1, 0, '4.8', 67, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-dress-1', 'Váy Midi Nữ A-Line', 690000, 890000, 'women', 10, 'Váy midi dáng A-line thanh lịch, phù hợp đi làm và dự tiệc', '[\"https://images.pexels.com/photos/1162983/pexels-photo-1162983.jpeg\", \"https://images.pexels.com/photos/1853079/pexels-photo-1853079.jpeg\"]', '[\"Đen\", \"Xanh Navy\", \"Đỏ\", \"Be\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Polyester cao cấp\", \"Không nhăn\", \"Dáng A-line\", \"Dễ mix đồ\"]', 0, 1, '4.5', 134, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-dress-2', 'Đầm Maxi Nữ Hoa', 890000, NULL, 'women', 10, 'Đầm maxi họa tiết hoa nữ tính, phù hợp dạo phố và du lịch', '[\"https://images.pexels.com/photos/1162983/pexels-photo-1162983.jpeg\", \"https://images.pexels.com/photos/1853079/pexels-photo-1853079.jpeg\"]', '[\"Hoa đỏ\", \"Hoa xanh\", \"Hoa vàng\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Chiffon mềm mại\", \"Lót trong\", \"Dây điều chỉnh\", \"Dáng xòe\"]', 1, 0, '4.6', 112, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-dress-3', 'Váy Ngắn Nữ Denim', 550000, NULL, 'women', 10, 'Váy ngắn denim trẻ trung, phong cách casual', '[\"https://images.pexels.com/photos/1853079/pexels-photo-1853079.jpeg\", \"https://images.pexels.com/photos/1162983/pexels-photo-1162983.jpeg\"]', '[\"Xanh đậm\", \"Xanh nhạt\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Cotton Denim\", \"Bền chắc\", \"Phong cách trẻ trung\", \"Dễ phối đồ\"]', 0, 0, '4.3', 78, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-jacket-1', 'Áo Khoác Blazer Nữ', 1290000, NULL, 'women', 13, 'Áo blazer nữ thanh lịch, phù hợp công sở và dự tiệc', '[\"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\", \"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\"]', '[\"Đen\", \"Xanh Navy\", \"Be\", \"Xám\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Polyester cao cấp\", \"Không nhăn\", \"Form fitted\", \"Lót trong\"]', 0, 0, '4.6', 98, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-jacket-2', 'Áo Khoác Denim Nữ', 790000, NULL, 'women', 13, 'Áo khoác denim nữ phong cách casual, dễ phối đồ', '[\"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\", \"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\"]', '[\"Xanh đậm\", \"Xanh nhạt\", \"Trắng\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Cotton Denim\", \"Bền chắc\", \"Phong cách casual\", \"Oversized fit\"]', 0, 0, '4.3', 123, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-jean-1', 'Quần Jean Nữ Skinny', 790000, NULL, 'women', 12, 'Quần jean nữ form skinny ôm dáng, tôn lên đường cong cơ thể', '[\"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\", \"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\"]', '[\"Xanh đậm\", \"Xanh nhạt\", \"Đen\"]', '[\"25\", \"26\", \"27\", \"28\", \"29\", \"30\"]', '[\"Cotton pha Elastane\", \"Co giãn 4 chiều\", \"Bền màu\", \"Form skinny\"]', 0, 0, '4.5', 189, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-jean-2', 'Quần Jean Nữ Straight', 750000, NULL, 'women', 12, 'Quần jean nữ form straight classic, phù hợp mọi dáng người', '[\"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\", \"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\"]', '[\"Xanh đậm\", \"Đen\", \"Xanh nhạt\"]', '[\"25\", \"26\", \"27\", \"28\", \"29\", \"30\", \"32\"]', '[\"100% Cotton\", \"Form straight\", \"Vintage style\", \"Bền chắc\"]', 0, 0, '4.4', 145, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-tshirt-1', 'Áo T-shirt Nữ Cotton', 290000, NULL, 'women', 9, 'Áo t-shirt nữ cotton basic, dễ phối đồ', '[\"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\", \"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\"]', '[\"Trắng\", \"Đen\", \"Hồng\", \"Xanh\", \"Vàng\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"100% Cotton\", \"Form fitted\", \"Dễ giặt\", \"Màu bền\"]', 0, 0, '4.4', 167, '2025-09-12 19:12:55', '2025-09-12 19:12:55'),
('women-tshirt-2', 'Áo T-shirt Nữ Dry', 350000, NULL, 'women', 9, 'Áo t-shirt công nghệ Dry cho nữ, thích hợp tập thể thao', '[\"https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg\", \"https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg\"]', '[\"Trắng\", \"Đen\", \"Xám\", \"Hồng\"]', '[\"S\", \"M\", \"L\", \"XL\"]', '[\"Dry Technology\", \"Thấm hút mồ hôi\", \"Nhanh khô\", \"UV Protection\"]', 1, 0, '4.5', 89, '2025-09-12 19:12:55', '2025-09-12 19:12:55');

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_rating_agg`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `product_rating_agg`;
CREATE TABLE `product_rating_agg` (
`product_id` varchar(64)
,`avg_rating` decimal(5,1)
,`total_reviews` bigint
);

-- --------------------------------------------------------

--
-- Table structure for table `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
CREATE TABLE `product_variants` (
  `id` bigint NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `color` varchar(64) NOT NULL,
  `size` varchar(32) NOT NULL,
  `sku` varchar(64) DEFAULT NULL,
  `stock_qty` int NOT NULL DEFAULT '0',
  `price` int DEFAULT NULL,
  `original_price` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `product_variants`
--

INSERT INTO `product_variants` (`id`, `product_id`, `color`, `size`, `sku`, `stock_qty`, `price`, `original_price`, `is_active`) VALUES
(1, 'men-tshirt-1', 'Trắng', 'S', 'SKU-men-tshirt-1-1-1', 20, NULL, NULL, 1),
(2, 'men-tshirt-1', 'Trắng', 'M', 'SKU-men-tshirt-1-1-2', 20, NULL, NULL, 1),
(3, 'men-tshirt-1', 'Trắng', 'L', 'SKU-men-tshirt-1-1-3', 20, NULL, NULL, 1),
(4, 'men-tshirt-1', 'Trắng', 'XL', 'SKU-men-tshirt-1-1-4', 20, NULL, NULL, 1),
(5, 'men-tshirt-1', 'Trắng', 'XXL', 'SKU-men-tshirt-1-1-5', 20, NULL, NULL, 1),
(6, 'men-tshirt-1', 'Đen', 'S', 'SKU-men-tshirt-1-2-1', 20, NULL, NULL, 1),
(7, 'men-tshirt-1', 'Đen', 'M', 'SKU-men-tshirt-1-2-2', 20, NULL, NULL, 1),
(8, 'men-tshirt-1', 'Đen', 'L', 'SKU-men-tshirt-1-2-3', 20, NULL, NULL, 1),
(9, 'men-tshirt-1', 'Đen', 'XL', 'SKU-men-tshirt-1-2-4', 20, NULL, NULL, 1),
(10, 'men-tshirt-1', 'Đen', 'XXL', 'SKU-men-tshirt-1-2-5', 20, NULL, NULL, 1),
(11, 'men-tshirt-1', 'Xanh Navy', 'S', 'SKU-men-tshirt-1-3-1', 20, NULL, NULL, 1),
(12, 'men-tshirt-1', 'Xanh Navy', 'M', 'SKU-men-tshirt-1-3-2', 20, NULL, NULL, 1),
(13, 'men-tshirt-1', 'Xanh Navy', 'L', 'SKU-men-tshirt-1-3-3', 20, NULL, NULL, 1),
(14, 'men-tshirt-1', 'Xanh Navy', 'XL', 'SKU-men-tshirt-1-3-4', 20, NULL, NULL, 1),
(15, 'men-tshirt-1', 'Xanh Navy', 'XXL', 'SKU-men-tshirt-1-3-5', 20, NULL, NULL, 1),
(16, 'men-tshirt-1', 'Xám', 'S', 'SKU-men-tshirt-1-4-1', 20, NULL, NULL, 1),
(17, 'men-tshirt-1', 'Xám', 'M', 'SKU-men-tshirt-1-4-2', 20, NULL, NULL, 1),
(18, 'men-tshirt-1', 'Xám', 'L', 'SKU-men-tshirt-1-4-3', 20, NULL, NULL, 1),
(19, 'men-tshirt-1', 'Xám', 'XL', 'SKU-men-tshirt-1-4-4', 20, NULL, NULL, 1),
(20, 'men-tshirt-1', 'Xám', 'XXL', 'SKU-men-tshirt-1-4-5', 20, NULL, NULL, 1),
(21, 'men-tshirt-2', 'Trắng', 'S', 'SKU-men-tshirt-2-1-1', 20, NULL, NULL, 1),
(22, 'men-tshirt-2', 'Trắng', 'M', 'SKU-men-tshirt-2-1-2', 20, NULL, NULL, 1),
(23, 'men-tshirt-2', 'Trắng', 'L', 'SKU-men-tshirt-2-1-3', 20, NULL, NULL, 1),
(24, 'men-tshirt-2', 'Trắng', 'XL', 'SKU-men-tshirt-2-1-4', 20, NULL, NULL, 1),
(25, 'men-tshirt-2', 'Đen', 'S', 'SKU-men-tshirt-2-2-1', 20, NULL, NULL, 1),
(26, 'men-tshirt-2', 'Đen', 'M', 'SKU-men-tshirt-2-2-2', 20, NULL, NULL, 1),
(27, 'men-tshirt-2', 'Đen', 'L', 'SKU-men-tshirt-2-2-3', 20, NULL, NULL, 1),
(28, 'men-tshirt-2', 'Đen', 'XL', 'SKU-men-tshirt-2-2-4', 20, NULL, NULL, 1),
(29, 'men-tshirt-2', 'Xanh', 'S', 'SKU-men-tshirt-2-3-1', 20, NULL, NULL, 1),
(30, 'men-tshirt-2', 'Xanh', 'M', 'SKU-men-tshirt-2-3-2', 20, NULL, NULL, 1),
(31, 'men-tshirt-2', 'Xanh', 'L', 'SKU-men-tshirt-2-3-3', 20, NULL, NULL, 1),
(32, 'men-tshirt-2', 'Xanh', 'XL', 'SKU-men-tshirt-2-3-4', 20, NULL, NULL, 1),
(33, 'men-tshirt-2', 'Đỏ', 'S', 'SKU-men-tshirt-2-4-1', 20, NULL, NULL, 1),
(34, 'men-tshirt-2', 'Đỏ', 'M', 'SKU-men-tshirt-2-4-2', 20, NULL, NULL, 1),
(35, 'men-tshirt-2', 'Đỏ', 'L', 'SKU-men-tshirt-2-4-3', 20, NULL, NULL, 1),
(36, 'men-tshirt-2', 'Đỏ', 'XL', 'SKU-men-tshirt-2-4-4', 20, NULL, NULL, 1),
(37, 'men-tshirt-2', 'Vàng', 'S', 'SKU-men-tshirt-2-5-1', 20, NULL, NULL, 1),
(38, 'men-tshirt-2', 'Vàng', 'M', 'SKU-men-tshirt-2-5-2', 20, NULL, NULL, 1),
(39, 'men-tshirt-2', 'Vàng', 'L', 'SKU-men-tshirt-2-5-3', 20, NULL, NULL, 1),
(40, 'men-tshirt-2', 'Vàng', 'XL', 'SKU-men-tshirt-2-5-4', 20, NULL, NULL, 1),
(41, 'men-tshirt-3', 'Đen', 'S', 'SKU-men-tshirt-3-1-1', 20, NULL, NULL, 1),
(42, 'men-tshirt-3', 'Đen', 'M', 'SKU-men-tshirt-3-1-2', 20, NULL, NULL, 1),
(43, 'men-tshirt-3', 'Đen', 'L', 'SKU-men-tshirt-3-1-3', 20, NULL, NULL, 1),
(44, 'men-tshirt-3', 'Đen', 'XL', 'SKU-men-tshirt-3-1-4', 20, NULL, NULL, 1),
(45, 'men-tshirt-3', 'Trắng', 'S', 'SKU-men-tshirt-3-2-1', 20, NULL, NULL, 1),
(46, 'men-tshirt-3', 'Trắng', 'M', 'SKU-men-tshirt-3-2-2', 20, NULL, NULL, 1),
(47, 'men-tshirt-3', 'Trắng', 'L', 'SKU-men-tshirt-3-2-3', 20, NULL, NULL, 1),
(48, 'men-tshirt-3', 'Trắng', 'XL', 'SKU-men-tshirt-3-2-4', 20, NULL, NULL, 1),
(49, 'men-tshirt-3', 'Xám', 'S', 'SKU-men-tshirt-3-3-1', 20, NULL, NULL, 1),
(50, 'men-tshirt-3', 'Xám', 'M', 'SKU-men-tshirt-3-3-2', 20, NULL, NULL, 1),
(51, 'men-tshirt-3', 'Xám', 'L', 'SKU-men-tshirt-3-3-3', 20, NULL, NULL, 1),
(52, 'men-tshirt-3', 'Xám', 'XL', 'SKU-men-tshirt-3-3-4', 20, NULL, NULL, 1),
(53, 'men-polo-1', 'Trắng', 'S', 'SKU-men-polo-1-1-1', 20, NULL, NULL, 1),
(54, 'men-polo-1', 'Trắng', 'M', 'SKU-men-polo-1-1-2', 20, NULL, NULL, 1),
(55, 'men-polo-1', 'Trắng', 'L', 'SKU-men-polo-1-1-3', 20, NULL, NULL, 1),
(56, 'men-polo-1', 'Trắng', 'XL', 'SKU-men-polo-1-1-4', 20, NULL, NULL, 1),
(57, 'men-polo-1', 'Trắng', 'XXL', 'SKU-men-polo-1-1-5', 20, NULL, NULL, 1),
(58, 'men-polo-1', 'Đen', 'S', 'SKU-men-polo-1-2-1', 20, NULL, NULL, 1),
(59, 'men-polo-1', 'Đen', 'M', 'SKU-men-polo-1-2-2', 20, NULL, NULL, 1),
(60, 'men-polo-1', 'Đen', 'L', 'SKU-men-polo-1-2-3', 20, NULL, NULL, 1),
(61, 'men-polo-1', 'Đen', 'XL', 'SKU-men-polo-1-2-4', 20, NULL, NULL, 1),
(62, 'men-polo-1', 'Đen', 'XXL', 'SKU-men-polo-1-2-5', 20, NULL, NULL, 1),
(63, 'men-polo-1', 'Xanh Navy', 'S', 'SKU-men-polo-1-3-1', 20, NULL, NULL, 1),
(64, 'men-polo-1', 'Xanh Navy', 'M', 'SKU-men-polo-1-3-2', 20, NULL, NULL, 1),
(65, 'men-polo-1', 'Xanh Navy', 'L', 'SKU-men-polo-1-3-3', 20, NULL, NULL, 1),
(66, 'men-polo-1', 'Xanh Navy', 'XL', 'SKU-men-polo-1-3-4', 20, NULL, NULL, 1),
(67, 'men-polo-1', 'Xanh Navy', 'XXL', 'SKU-men-polo-1-3-5', 20, NULL, NULL, 1),
(68, 'men-polo-1', 'Xám', 'S', 'SKU-men-polo-1-4-1', 20, NULL, NULL, 1),
(69, 'men-polo-1', 'Xám', 'M', 'SKU-men-polo-1-4-2', 20, NULL, NULL, 1),
(70, 'men-polo-1', 'Xám', 'L', 'SKU-men-polo-1-4-3', 20, NULL, NULL, 1),
(71, 'men-polo-1', 'Xám', 'XL', 'SKU-men-polo-1-4-4', 20, NULL, NULL, 1),
(72, 'men-polo-1', 'Xám', 'XXL', 'SKU-men-polo-1-4-5', 20, NULL, NULL, 1),
(73, 'men-polo-1', 'Đỏ', 'S', 'SKU-men-polo-1-5-1', 20, NULL, NULL, 1),
(74, 'men-polo-1', 'Đỏ', 'M', 'SKU-men-polo-1-5-2', 20, NULL, NULL, 1),
(75, 'men-polo-1', 'Đỏ', 'L', 'SKU-men-polo-1-5-3', 20, NULL, NULL, 1),
(76, 'men-polo-1', 'Đỏ', 'XL', 'SKU-men-polo-1-5-4', 20, NULL, NULL, 1),
(77, 'men-polo-1', 'Đỏ', 'XXL', 'SKU-men-polo-1-5-5', 20, NULL, NULL, 1),
(78, 'men-polo-2', 'Xanh Navy', 'S', 'SKU-men-polo-2-1-1', 20, NULL, NULL, 1),
(79, 'men-polo-2', 'Xanh Navy', 'M', 'SKU-men-polo-2-1-2', 20, NULL, NULL, 1),
(80, 'men-polo-2', 'Xanh Navy', 'L', 'SKU-men-polo-2-1-3', 20, NULL, NULL, 1),
(81, 'men-polo-2', 'Xanh Navy', 'XL', 'SKU-men-polo-2-1-4', 20, NULL, NULL, 1),
(82, 'men-polo-2', 'Trắng', 'S', 'SKU-men-polo-2-2-1', 20, NULL, NULL, 1),
(83, 'men-polo-2', 'Trắng', 'M', 'SKU-men-polo-2-2-2', 20, NULL, NULL, 1),
(84, 'men-polo-2', 'Trắng', 'L', 'SKU-men-polo-2-2-3', 20, NULL, NULL, 1),
(85, 'men-polo-2', 'Trắng', 'XL', 'SKU-men-polo-2-2-4', 20, NULL, NULL, 1),
(86, 'men-polo-2', 'Xám', 'S', 'SKU-men-polo-2-3-1', 20, NULL, NULL, 1),
(87, 'men-polo-2', 'Xám', 'M', 'SKU-men-polo-2-3-2', 20, NULL, NULL, 1),
(88, 'men-polo-2', 'Xám', 'L', 'SKU-men-polo-2-3-3', 20, NULL, NULL, 1),
(89, 'men-polo-2', 'Xám', 'XL', 'SKU-men-polo-2-3-4', 20, NULL, NULL, 1),
(90, 'men-polo-2', 'Đen', 'S', 'SKU-men-polo-2-4-1', 20, NULL, NULL, 1),
(91, 'men-polo-2', 'Đen', 'M', 'SKU-men-polo-2-4-2', 20, NULL, NULL, 1),
(92, 'men-polo-2', 'Đen', 'L', 'SKU-men-polo-2-4-3', 20, NULL, NULL, 1),
(93, 'men-polo-2', 'Đen', 'XL', 'SKU-men-polo-2-4-4', 20, NULL, NULL, 1),
(94, 'men-shirt-1', 'Trắng', 'S', 'SKU-men-shirt-1-1-1', 20, NULL, NULL, 1),
(95, 'men-shirt-1', 'Trắng', 'M', 'SKU-men-shirt-1-1-2', 20, NULL, NULL, 1),
(96, 'men-shirt-1', 'Trắng', 'L', 'SKU-men-shirt-1-1-3', 20, NULL, NULL, 1),
(97, 'men-shirt-1', 'Trắng', 'XL', 'SKU-men-shirt-1-1-4', 20, NULL, NULL, 1),
(98, 'men-shirt-1', 'Trắng', 'XXL', 'SKU-men-shirt-1-1-5', 20, NULL, NULL, 1),
(99, 'men-shirt-1', 'Xanh nhạt', 'S', 'SKU-men-shirt-1-2-1', 20, NULL, NULL, 1),
(100, 'men-shirt-1', 'Xanh nhạt', 'M', 'SKU-men-shirt-1-2-2', 20, NULL, NULL, 1),
(101, 'men-shirt-1', 'Xanh nhạt', 'L', 'SKU-men-shirt-1-2-3', 20, NULL, NULL, 1),
(102, 'men-shirt-1', 'Xanh nhạt', 'XL', 'SKU-men-shirt-1-2-4', 20, NULL, NULL, 1),
(103, 'men-shirt-1', 'Xanh nhạt', 'XXL', 'SKU-men-shirt-1-2-5', 20, NULL, NULL, 1),
(104, 'men-shirt-1', 'Hồng nhạt', 'S', 'SKU-men-shirt-1-3-1', 20, NULL, NULL, 1),
(105, 'men-shirt-1', 'Hồng nhạt', 'M', 'SKU-men-shirt-1-3-2', 20, NULL, NULL, 1),
(106, 'men-shirt-1', 'Hồng nhạt', 'L', 'SKU-men-shirt-1-3-3', 20, NULL, NULL, 1),
(107, 'men-shirt-1', 'Hồng nhạt', 'XL', 'SKU-men-shirt-1-3-4', 20, NULL, NULL, 1),
(108, 'men-shirt-1', 'Hồng nhạt', 'XXL', 'SKU-men-shirt-1-3-5', 20, NULL, NULL, 1),
(109, 'men-shirt-1', 'Xám', 'S', 'SKU-men-shirt-1-4-1', 20, NULL, NULL, 1),
(110, 'men-shirt-1', 'Xám', 'M', 'SKU-men-shirt-1-4-2', 20, NULL, NULL, 1),
(111, 'men-shirt-1', 'Xám', 'L', 'SKU-men-shirt-1-4-3', 20, NULL, NULL, 1),
(112, 'men-shirt-1', 'Xám', 'XL', 'SKU-men-shirt-1-4-4', 20, NULL, NULL, 1),
(113, 'men-shirt-1', 'Xám', 'XXL', 'SKU-men-shirt-1-4-5', 20, NULL, NULL, 1),
(114, 'men-shirt-2', 'Trắng', 'S', 'SKU-men-shirt-2-1-1', 20, NULL, NULL, 1),
(115, 'men-shirt-2', 'Trắng', 'M', 'SKU-men-shirt-2-1-2', 20, NULL, NULL, 1),
(116, 'men-shirt-2', 'Trắng', 'L', 'SKU-men-shirt-2-1-3', 20, NULL, NULL, 1),
(117, 'men-shirt-2', 'Trắng', 'XL', 'SKU-men-shirt-2-1-4', 20, NULL, NULL, 1),
(118, 'men-shirt-2', 'Xanh Navy', 'S', 'SKU-men-shirt-2-2-1', 20, NULL, NULL, 1),
(119, 'men-shirt-2', 'Xanh Navy', 'M', 'SKU-men-shirt-2-2-2', 20, NULL, NULL, 1),
(120, 'men-shirt-2', 'Xanh Navy', 'L', 'SKU-men-shirt-2-2-3', 20, NULL, NULL, 1),
(121, 'men-shirt-2', 'Xanh Navy', 'XL', 'SKU-men-shirt-2-2-4', 20, NULL, NULL, 1),
(122, 'men-shirt-2', 'Xám nhạt', 'S', 'SKU-men-shirt-2-3-1', 20, NULL, NULL, 1),
(123, 'men-shirt-2', 'Xám nhạt', 'M', 'SKU-men-shirt-2-3-2', 20, NULL, NULL, 1),
(124, 'men-shirt-2', 'Xám nhạt', 'L', 'SKU-men-shirt-2-3-3', 20, NULL, NULL, 1),
(125, 'men-shirt-2', 'Xám nhạt', 'XL', 'SKU-men-shirt-2-3-4', 20, NULL, NULL, 1),
(126, 'men-jean-1', 'Xanh đậm', '29', 'SKU-men-jean-1-1-1', 20, NULL, NULL, 1),
(127, 'men-jean-1', 'Xanh đậm', '30', 'SKU-men-jean-1-1-2', 20, NULL, NULL, 1),
(128, 'men-jean-1', 'Xanh đậm', '31', 'SKU-men-jean-1-1-3', 20, NULL, NULL, 1),
(129, 'men-jean-1', 'Xanh đậm', '32', 'SKU-men-jean-1-1-4', 20, NULL, NULL, 1),
(130, 'men-jean-1', 'Xanh đậm', '33', 'SKU-men-jean-1-1-5', 20, NULL, NULL, 1),
(131, 'men-jean-1', 'Xanh đậm', '34', 'SKU-men-jean-1-1-6', 20, NULL, NULL, 1),
(132, 'men-jean-1', 'Xanh đậm', '36', 'SKU-men-jean-1-1-7', 20, NULL, NULL, 1),
(133, 'men-jean-1', 'Xanh nhạt', '29', 'SKU-men-jean-1-2-1', 20, NULL, NULL, 1),
(134, 'men-jean-1', 'Xanh nhạt', '30', 'SKU-men-jean-1-2-2', 20, NULL, NULL, 1),
(135, 'men-jean-1', 'Xanh nhạt', '31', 'SKU-men-jean-1-2-3', 20, NULL, NULL, 1),
(136, 'men-jean-1', 'Xanh nhạt', '32', 'SKU-men-jean-1-2-4', 20, NULL, NULL, 1),
(137, 'men-jean-1', 'Xanh nhạt', '33', 'SKU-men-jean-1-2-5', 20, NULL, NULL, 1),
(138, 'men-jean-1', 'Xanh nhạt', '34', 'SKU-men-jean-1-2-6', 20, NULL, NULL, 1),
(139, 'men-jean-1', 'Xanh nhạt', '36', 'SKU-men-jean-1-2-7', 20, NULL, NULL, 1),
(140, 'men-jean-1', 'Đen', '29', 'SKU-men-jean-1-3-1', 20, NULL, NULL, 1),
(141, 'men-jean-1', 'Đen', '30', 'SKU-men-jean-1-3-2', 20, NULL, NULL, 1),
(142, 'men-jean-1', 'Đen', '31', 'SKU-men-jean-1-3-3', 20, NULL, NULL, 1),
(143, 'men-jean-1', 'Đen', '32', 'SKU-men-jean-1-3-4', 20, NULL, NULL, 1),
(144, 'men-jean-1', 'Đen', '33', 'SKU-men-jean-1-3-5', 20, NULL, NULL, 1),
(145, 'men-jean-1', 'Đen', '34', 'SKU-men-jean-1-3-6', 20, NULL, NULL, 1),
(146, 'men-jean-1', 'Đen', '36', 'SKU-men-jean-1-3-7', 20, NULL, NULL, 1),
(147, 'men-jean-2', 'Xanh đậm', '29', 'SKU-men-jean-2-1-1', 20, NULL, NULL, 1),
(148, 'men-jean-2', 'Xanh đậm', '30', 'SKU-men-jean-2-1-2', 20, NULL, NULL, 1),
(149, 'men-jean-2', 'Xanh đậm', '31', 'SKU-men-jean-2-1-3', 20, NULL, NULL, 1),
(150, 'men-jean-2', 'Xanh đậm', '32', 'SKU-men-jean-2-1-4', 20, NULL, NULL, 1),
(151, 'men-jean-2', 'Xanh đậm', '33', 'SKU-men-jean-2-1-5', 20, NULL, NULL, 1),
(152, 'men-jean-2', 'Xanh đậm', '34', 'SKU-men-jean-2-1-6', 20, NULL, NULL, 1),
(153, 'men-jean-2', 'Xanh đậm', '36', 'SKU-men-jean-2-1-7', 20, NULL, NULL, 1),
(154, 'men-jean-2', 'Xanh đậm', '38', 'SKU-men-jean-2-1-8', 20, NULL, NULL, 1),
(155, 'men-jean-2', 'Đen', '29', 'SKU-men-jean-2-2-1', 20, NULL, NULL, 1),
(156, 'men-jean-2', 'Đen', '30', 'SKU-men-jean-2-2-2', 20, NULL, NULL, 1),
(157, 'men-jean-2', 'Đen', '31', 'SKU-men-jean-2-2-3', 20, NULL, NULL, 1),
(158, 'men-jean-2', 'Đen', '32', 'SKU-men-jean-2-2-4', 20, NULL, NULL, 1),
(159, 'men-jean-2', 'Đen', '33', 'SKU-men-jean-2-2-5', 20, NULL, NULL, 1),
(160, 'men-jean-2', 'Đen', '34', 'SKU-men-jean-2-2-6', 20, NULL, NULL, 1),
(161, 'men-jean-2', 'Đen', '36', 'SKU-men-jean-2-2-7', 20, NULL, NULL, 1),
(162, 'men-jean-2', 'Đen', '38', 'SKU-men-jean-2-2-8', 20, NULL, NULL, 1),
(163, 'men-jean-2', 'Xám', '29', 'SKU-men-jean-2-3-1', 20, NULL, NULL, 1),
(164, 'men-jean-2', 'Xám', '30', 'SKU-men-jean-2-3-2', 20, NULL, NULL, 1),
(165, 'men-jean-2', 'Xám', '31', 'SKU-men-jean-2-3-3', 20, NULL, NULL, 1),
(166, 'men-jean-2', 'Xám', '32', 'SKU-men-jean-2-3-4', 20, NULL, NULL, 1),
(167, 'men-jean-2', 'Xám', '33', 'SKU-men-jean-2-3-5', 20, NULL, NULL, 1),
(168, 'men-jean-2', 'Xám', '34', 'SKU-men-jean-2-3-6', 20, NULL, NULL, 1),
(169, 'men-jean-2', 'Xám', '36', 'SKU-men-jean-2-3-7', 20, NULL, NULL, 1),
(170, 'men-jean-2', 'Xám', '38', 'SKU-men-jean-2-3-8', 20, NULL, NULL, 1),
(171, 'men-chino-1', 'Be', '29', 'SKU-men-chino-1-1-1', 20, NULL, NULL, 1),
(172, 'men-chino-1', 'Be', '30', 'SKU-men-chino-1-1-2', 20, NULL, NULL, 1),
(173, 'men-chino-1', 'Be', '31', 'SKU-men-chino-1-1-3', 20, NULL, NULL, 1),
(174, 'men-chino-1', 'Be', '32', 'SKU-men-chino-1-1-4', 20, NULL, NULL, 1),
(175, 'men-chino-1', 'Be', '33', 'SKU-men-chino-1-1-5', 20, NULL, NULL, 1),
(176, 'men-chino-1', 'Be', '34', 'SKU-men-chino-1-1-6', 20, NULL, NULL, 1),
(177, 'men-chino-1', 'Be', '36', 'SKU-men-chino-1-1-7', 20, NULL, NULL, 1),
(178, 'men-chino-1', 'Xanh Navy', '29', 'SKU-men-chino-1-2-1', 20, NULL, NULL, 1),
(179, 'men-chino-1', 'Xanh Navy', '30', 'SKU-men-chino-1-2-2', 20, NULL, NULL, 1),
(180, 'men-chino-1', 'Xanh Navy', '31', 'SKU-men-chino-1-2-3', 20, NULL, NULL, 1),
(181, 'men-chino-1', 'Xanh Navy', '32', 'SKU-men-chino-1-2-4', 20, NULL, NULL, 1),
(182, 'men-chino-1', 'Xanh Navy', '33', 'SKU-men-chino-1-2-5', 20, NULL, NULL, 1),
(183, 'men-chino-1', 'Xanh Navy', '34', 'SKU-men-chino-1-2-6', 20, NULL, NULL, 1),
(184, 'men-chino-1', 'Xanh Navy', '36', 'SKU-men-chino-1-2-7', 20, NULL, NULL, 1),
(185, 'men-chino-1', 'Xám', '29', 'SKU-men-chino-1-3-1', 20, NULL, NULL, 1),
(186, 'men-chino-1', 'Xám', '30', 'SKU-men-chino-1-3-2', 20, NULL, NULL, 1),
(187, 'men-chino-1', 'Xám', '31', 'SKU-men-chino-1-3-3', 20, NULL, NULL, 1),
(188, 'men-chino-1', 'Xám', '32', 'SKU-men-chino-1-3-4', 20, NULL, NULL, 1),
(189, 'men-chino-1', 'Xám', '33', 'SKU-men-chino-1-3-5', 20, NULL, NULL, 1),
(190, 'men-chino-1', 'Xám', '34', 'SKU-men-chino-1-3-6', 20, NULL, NULL, 1),
(191, 'men-chino-1', 'Xám', '36', 'SKU-men-chino-1-3-7', 20, NULL, NULL, 1),
(192, 'men-chino-1', 'Đen', '29', 'SKU-men-chino-1-4-1', 20, NULL, NULL, 1),
(193, 'men-chino-1', 'Đen', '30', 'SKU-men-chino-1-4-2', 20, NULL, NULL, 1),
(194, 'men-chino-1', 'Đen', '31', 'SKU-men-chino-1-4-3', 20, NULL, NULL, 1),
(195, 'men-chino-1', 'Đen', '32', 'SKU-men-chino-1-4-4', 20, NULL, NULL, 1),
(196, 'men-chino-1', 'Đen', '33', 'SKU-men-chino-1-4-5', 20, NULL, NULL, 1),
(197, 'men-chino-1', 'Đen', '34', 'SKU-men-chino-1-4-6', 20, NULL, NULL, 1),
(198, 'men-chino-1', 'Đen', '36', 'SKU-men-chino-1-4-7', 20, NULL, NULL, 1),
(199, 'men-chino-2', 'Be', '30', 'SKU-men-chino-2-1-1', 20, NULL, NULL, 1),
(200, 'men-chino-2', 'Be', '31', 'SKU-men-chino-2-1-2', 20, NULL, NULL, 1),
(201, 'men-chino-2', 'Be', '32', 'SKU-men-chino-2-1-3', 20, NULL, NULL, 1),
(202, 'men-chino-2', 'Be', '33', 'SKU-men-chino-2-1-4', 20, NULL, NULL, 1),
(203, 'men-chino-2', 'Be', '34', 'SKU-men-chino-2-1-5', 20, NULL, NULL, 1),
(204, 'men-chino-2', 'Be', '36', 'SKU-men-chino-2-1-6', 20, NULL, NULL, 1),
(205, 'men-chino-2', 'Xám', '30', 'SKU-men-chino-2-2-1', 20, NULL, NULL, 1),
(206, 'men-chino-2', 'Xám', '31', 'SKU-men-chino-2-2-2', 20, NULL, NULL, 1),
(207, 'men-chino-2', 'Xám', '32', 'SKU-men-chino-2-2-3', 20, NULL, NULL, 1),
(208, 'men-chino-2', 'Xám', '33', 'SKU-men-chino-2-2-4', 20, NULL, NULL, 1),
(209, 'men-chino-2', 'Xám', '34', 'SKU-men-chino-2-2-5', 20, NULL, NULL, 1),
(210, 'men-chino-2', 'Xám', '36', 'SKU-men-chino-2-2-6', 20, NULL, NULL, 1),
(211, 'men-chino-2', 'Xanh Navy', '30', 'SKU-men-chino-2-3-1', 20, NULL, NULL, 1),
(212, 'men-chino-2', 'Xanh Navy', '31', 'SKU-men-chino-2-3-2', 20, NULL, NULL, 1),
(213, 'men-chino-2', 'Xanh Navy', '32', 'SKU-men-chino-2-3-3', 20, NULL, NULL, 1),
(214, 'men-chino-2', 'Xanh Navy', '33', 'SKU-men-chino-2-3-4', 20, NULL, NULL, 1),
(215, 'men-chino-2', 'Xanh Navy', '34', 'SKU-men-chino-2-3-5', 20, NULL, NULL, 1),
(216, 'men-chino-2', 'Xanh Navy', '36', 'SKU-men-chino-2-3-6', 20, NULL, NULL, 1),
(217, 'men-jacket-1', 'Đen', 'S', 'SKU-men-jacket-1-1-1', 20, NULL, NULL, 1),
(218, 'men-jacket-1', 'Đen', 'M', 'SKU-men-jacket-1-1-2', 20, NULL, NULL, 1),
(219, 'men-jacket-1', 'Đen', 'L', 'SKU-men-jacket-1-1-3', 20, NULL, NULL, 1),
(220, 'men-jacket-1', 'Đen', 'XL', 'SKU-men-jacket-1-1-4', 20, NULL, NULL, 1),
(221, 'men-jacket-1', 'Xanh Navy', 'S', 'SKU-men-jacket-1-2-1', 20, NULL, NULL, 1),
(222, 'men-jacket-1', 'Xanh Navy', 'M', 'SKU-men-jacket-1-2-2', 20, NULL, NULL, 1),
(223, 'men-jacket-1', 'Xanh Navy', 'L', 'SKU-men-jacket-1-2-3', 20, NULL, NULL, 1),
(224, 'men-jacket-1', 'Xanh Navy', 'XL', 'SKU-men-jacket-1-2-4', 20, NULL, NULL, 1),
(225, 'men-jacket-1', 'Xám', 'S', 'SKU-men-jacket-1-3-1', 20, NULL, NULL, 1),
(226, 'men-jacket-1', 'Xám', 'M', 'SKU-men-jacket-1-3-2', 20, NULL, NULL, 1),
(227, 'men-jacket-1', 'Xám', 'L', 'SKU-men-jacket-1-3-3', 20, NULL, NULL, 1),
(228, 'men-jacket-1', 'Xám', 'XL', 'SKU-men-jacket-1-3-4', 20, NULL, NULL, 1),
(229, 'men-jacket-2', 'Xanh đậm', 'S', 'SKU-men-jacket-2-1-1', 20, NULL, NULL, 1),
(230, 'men-jacket-2', 'Xanh đậm', 'M', 'SKU-men-jacket-2-1-2', 20, NULL, NULL, 1),
(231, 'men-jacket-2', 'Xanh đậm', 'L', 'SKU-men-jacket-2-1-3', 20, NULL, NULL, 1),
(232, 'men-jacket-2', 'Xanh đậm', 'XL', 'SKU-men-jacket-2-1-4', 20, NULL, NULL, 1),
(233, 'men-jacket-2', 'Xanh nhạt', 'S', 'SKU-men-jacket-2-2-1', 20, NULL, NULL, 1),
(234, 'men-jacket-2', 'Xanh nhạt', 'M', 'SKU-men-jacket-2-2-2', 20, NULL, NULL, 1),
(235, 'men-jacket-2', 'Xanh nhạt', 'L', 'SKU-men-jacket-2-2-3', 20, NULL, NULL, 1),
(236, 'men-jacket-2', 'Xanh nhạt', 'XL', 'SKU-men-jacket-2-2-4', 20, NULL, NULL, 1),
(237, 'men-short-1', 'Be', 'S', 'SKU-men-short-1-1-1', 20, NULL, NULL, 1),
(238, 'men-short-1', 'Be', 'M', 'SKU-men-short-1-1-2', 20, NULL, NULL, 1),
(239, 'men-short-1', 'Be', 'L', 'SKU-men-short-1-1-3', 20, NULL, NULL, 1),
(240, 'men-short-1', 'Be', 'XL', 'SKU-men-short-1-1-4', 20, NULL, NULL, 1),
(241, 'men-short-1', 'Xanh Navy', 'S', 'SKU-men-short-1-2-1', 20, NULL, NULL, 1),
(242, 'men-short-1', 'Xanh Navy', 'M', 'SKU-men-short-1-2-2', 20, NULL, NULL, 1),
(243, 'men-short-1', 'Xanh Navy', 'L', 'SKU-men-short-1-2-3', 20, NULL, NULL, 1),
(244, 'men-short-1', 'Xanh Navy', 'XL', 'SKU-men-short-1-2-4', 20, NULL, NULL, 1),
(245, 'men-short-1', 'Xám', 'S', 'SKU-men-short-1-3-1', 20, NULL, NULL, 1),
(246, 'men-short-1', 'Xám', 'M', 'SKU-men-short-1-3-2', 20, NULL, NULL, 1),
(247, 'men-short-1', 'Xám', 'L', 'SKU-men-short-1-3-3', 20, NULL, NULL, 1),
(248, 'men-short-1', 'Xám', 'XL', 'SKU-men-short-1-3-4', 20, NULL, NULL, 1),
(249, 'men-short-1', 'Đen', 'S', 'SKU-men-short-1-4-1', 20, NULL, NULL, 1),
(250, 'men-short-1', 'Đen', 'M', 'SKU-men-short-1-4-2', 20, NULL, NULL, 1),
(251, 'men-short-1', 'Đen', 'L', 'SKU-men-short-1-4-3', 20, NULL, NULL, 1),
(252, 'men-short-1', 'Đen', 'XL', 'SKU-men-short-1-4-4', 20, NULL, NULL, 1),
(253, 'women-blouse-1', 'Trắng', 'S', 'SKU-women-blouse-1-1-1', 20, NULL, NULL, 1),
(254, 'women-blouse-1', 'Trắng', 'M', 'SKU-women-blouse-1-1-2', 20, NULL, NULL, 1),
(255, 'women-blouse-1', 'Trắng', 'L', 'SKU-women-blouse-1-1-3', 20, NULL, NULL, 1),
(256, 'women-blouse-1', 'Trắng', 'XL', 'SKU-women-blouse-1-1-4', 20, NULL, NULL, 1),
(257, 'women-blouse-1', 'Xanh nhạt', 'S', 'SKU-women-blouse-1-2-1', 20, NULL, NULL, 1),
(258, 'women-blouse-1', 'Xanh nhạt', 'M', 'SKU-women-blouse-1-2-2', 20, NULL, NULL, 1),
(259, 'women-blouse-1', 'Xanh nhạt', 'L', 'SKU-women-blouse-1-2-3', 20, NULL, NULL, 1),
(260, 'women-blouse-1', 'Xanh nhạt', 'XL', 'SKU-women-blouse-1-2-4', 20, NULL, NULL, 1),
(261, 'women-blouse-1', 'Hồng', 'S', 'SKU-women-blouse-1-3-1', 20, NULL, NULL, 1),
(262, 'women-blouse-1', 'Hồng', 'M', 'SKU-women-blouse-1-3-2', 20, NULL, NULL, 1),
(263, 'women-blouse-1', 'Hồng', 'L', 'SKU-women-blouse-1-3-3', 20, NULL, NULL, 1),
(264, 'women-blouse-1', 'Hồng', 'XL', 'SKU-women-blouse-1-3-4', 20, NULL, NULL, 1),
(265, 'women-blouse-1', 'Be', 'S', 'SKU-women-blouse-1-4-1', 20, NULL, NULL, 1),
(266, 'women-blouse-1', 'Be', 'M', 'SKU-women-blouse-1-4-2', 20, NULL, NULL, 1),
(267, 'women-blouse-1', 'Be', 'L', 'SKU-women-blouse-1-4-3', 20, NULL, NULL, 1),
(268, 'women-blouse-1', 'Be', 'XL', 'SKU-women-blouse-1-4-4', 20, NULL, NULL, 1),
(269, 'women-blouse-2', 'Trắng', 'S', 'SKU-women-blouse-2-1-1', 20, NULL, NULL, 1),
(270, 'women-blouse-2', 'Trắng', 'M', 'SKU-women-blouse-2-1-2', 20, NULL, NULL, 1),
(271, 'women-blouse-2', 'Trắng', 'L', 'SKU-women-blouse-2-1-3', 20, NULL, NULL, 1),
(272, 'women-blouse-2', 'Trắng', 'XL', 'SKU-women-blouse-2-1-4', 20, NULL, NULL, 1),
(273, 'women-blouse-2', 'Đen', 'S', 'SKU-women-blouse-2-2-1', 20, NULL, NULL, 1),
(274, 'women-blouse-2', 'Đen', 'M', 'SKU-women-blouse-2-2-2', 20, NULL, NULL, 1),
(275, 'women-blouse-2', 'Đen', 'L', 'SKU-women-blouse-2-2-3', 20, NULL, NULL, 1),
(276, 'women-blouse-2', 'Đen', 'XL', 'SKU-women-blouse-2-2-4', 20, NULL, NULL, 1),
(277, 'women-blouse-2', 'Hồng nhạt', 'S', 'SKU-women-blouse-2-3-1', 20, NULL, NULL, 1),
(278, 'women-blouse-2', 'Hồng nhạt', 'M', 'SKU-women-blouse-2-3-2', 20, NULL, NULL, 1),
(279, 'women-blouse-2', 'Hồng nhạt', 'L', 'SKU-women-blouse-2-3-3', 20, NULL, NULL, 1),
(280, 'women-blouse-2', 'Hồng nhạt', 'XL', 'SKU-women-blouse-2-3-4', 20, NULL, NULL, 1),
(281, 'women-blouse-2', 'Xanh Navy', 'S', 'SKU-women-blouse-2-4-1', 20, NULL, NULL, 1),
(282, 'women-blouse-2', 'Xanh Navy', 'M', 'SKU-women-blouse-2-4-2', 20, NULL, NULL, 1),
(283, 'women-blouse-2', 'Xanh Navy', 'L', 'SKU-women-blouse-2-4-3', 20, NULL, NULL, 1),
(284, 'women-blouse-2', 'Xanh Navy', 'XL', 'SKU-women-blouse-2-4-4', 20, NULL, NULL, 1),
(285, 'women-tshirt-1', 'Trắng', 'S', 'SKU-women-tshirt-1-1-1', 20, NULL, NULL, 1),
(286, 'women-tshirt-1', 'Trắng', 'M', 'SKU-women-tshirt-1-1-2', 20, NULL, NULL, 1),
(287, 'women-tshirt-1', 'Trắng', 'L', 'SKU-women-tshirt-1-1-3', 20, NULL, NULL, 1),
(288, 'women-tshirt-1', 'Trắng', 'XL', 'SKU-women-tshirt-1-1-4', 20, NULL, NULL, 1),
(289, 'women-tshirt-1', 'Đen', 'S', 'SKU-women-tshirt-1-2-1', 20, NULL, NULL, 1),
(290, 'women-tshirt-1', 'Đen', 'M', 'SKU-women-tshirt-1-2-2', 20, NULL, NULL, 1),
(291, 'women-tshirt-1', 'Đen', 'L', 'SKU-women-tshirt-1-2-3', 20, NULL, NULL, 1),
(292, 'women-tshirt-1', 'Đen', 'XL', 'SKU-women-tshirt-1-2-4', 20, NULL, NULL, 1),
(293, 'women-tshirt-1', 'Hồng', 'S', 'SKU-women-tshirt-1-3-1', 20, NULL, NULL, 1),
(294, 'women-tshirt-1', 'Hồng', 'M', 'SKU-women-tshirt-1-3-2', 20, NULL, NULL, 1),
(295, 'women-tshirt-1', 'Hồng', 'L', 'SKU-women-tshirt-1-3-3', 20, NULL, NULL, 1),
(296, 'women-tshirt-1', 'Hồng', 'XL', 'SKU-women-tshirt-1-3-4', 20, NULL, NULL, 1),
(297, 'women-tshirt-1', 'Xanh', 'S', 'SKU-women-tshirt-1-4-1', 20, NULL, NULL, 1),
(298, 'women-tshirt-1', 'Xanh', 'M', 'SKU-women-tshirt-1-4-2', 20, NULL, NULL, 1),
(299, 'women-tshirt-1', 'Xanh', 'L', 'SKU-women-tshirt-1-4-3', 20, NULL, NULL, 1),
(300, 'women-tshirt-1', 'Xanh', 'XL', 'SKU-women-tshirt-1-4-4', 20, NULL, NULL, 1),
(301, 'women-tshirt-1', 'Vàng', 'S', 'SKU-women-tshirt-1-5-1', 20, NULL, NULL, 1),
(302, 'women-tshirt-1', 'Vàng', 'M', 'SKU-women-tshirt-1-5-2', 20, NULL, NULL, 1),
(303, 'women-tshirt-1', 'Vàng', 'L', 'SKU-women-tshirt-1-5-3', 20, NULL, NULL, 1),
(304, 'women-tshirt-1', 'Vàng', 'XL', 'SKU-women-tshirt-1-5-4', 20, NULL, NULL, 1),
(305, 'women-tshirt-2', 'Trắng', 'S', 'SKU-women-tshirt-2-1-1', 20, NULL, NULL, 1),
(306, 'women-tshirt-2', 'Trắng', 'M', 'SKU-women-tshirt-2-1-2', 20, NULL, NULL, 1),
(307, 'women-tshirt-2', 'Trắng', 'L', 'SKU-women-tshirt-2-1-3', 20, NULL, NULL, 1),
(308, 'women-tshirt-2', 'Trắng', 'XL', 'SKU-women-tshirt-2-1-4', 20, NULL, NULL, 1),
(309, 'women-tshirt-2', 'Đen', 'S', 'SKU-women-tshirt-2-2-1', 20, NULL, NULL, 1),
(310, 'women-tshirt-2', 'Đen', 'M', 'SKU-women-tshirt-2-2-2', 20, NULL, NULL, 1),
(311, 'women-tshirt-2', 'Đen', 'L', 'SKU-women-tshirt-2-2-3', 20, NULL, NULL, 1),
(312, 'women-tshirt-2', 'Đen', 'XL', 'SKU-women-tshirt-2-2-4', 20, NULL, NULL, 1),
(313, 'women-tshirt-2', 'Xám', 'S', 'SKU-women-tshirt-2-3-1', 20, NULL, NULL, 1),
(314, 'women-tshirt-2', 'Xám', 'M', 'SKU-women-tshirt-2-3-2', 20, NULL, NULL, 1),
(315, 'women-tshirt-2', 'Xám', 'L', 'SKU-women-tshirt-2-3-3', 20, NULL, NULL, 1),
(316, 'women-tshirt-2', 'Xám', 'XL', 'SKU-women-tshirt-2-3-4', 20, NULL, NULL, 1),
(317, 'women-tshirt-2', 'Hồng', 'S', 'SKU-women-tshirt-2-4-1', 20, NULL, NULL, 1),
(318, 'women-tshirt-2', 'Hồng', 'M', 'SKU-women-tshirt-2-4-2', 20, NULL, NULL, 1),
(319, 'women-tshirt-2', 'Hồng', 'L', 'SKU-women-tshirt-2-4-3', 20, NULL, NULL, 1),
(320, 'women-tshirt-2', 'Hồng', 'XL', 'SKU-women-tshirt-2-4-4', 20, NULL, NULL, 1),
(321, 'women-dress-1', 'Đen', 'S', 'SKU-women-dress-1-1-1', 20, NULL, NULL, 1),
(322, 'women-dress-1', 'Đen', 'M', 'SKU-women-dress-1-1-2', 20, NULL, NULL, 1),
(323, 'women-dress-1', 'Đen', 'L', 'SKU-women-dress-1-1-3', 20, NULL, NULL, 1),
(324, 'women-dress-1', 'Đen', 'XL', 'SKU-women-dress-1-1-4', 20, NULL, NULL, 1),
(325, 'women-dress-1', 'Xanh Navy', 'S', 'SKU-women-dress-1-2-1', 20, NULL, NULL, 1),
(326, 'women-dress-1', 'Xanh Navy', 'M', 'SKU-women-dress-1-2-2', 20, NULL, NULL, 1),
(327, 'women-dress-1', 'Xanh Navy', 'L', 'SKU-women-dress-1-2-3', 20, NULL, NULL, 1),
(328, 'women-dress-1', 'Xanh Navy', 'XL', 'SKU-women-dress-1-2-4', 20, NULL, NULL, 1),
(329, 'women-dress-1', 'Đỏ', 'S', 'SKU-women-dress-1-3-1', 20, NULL, NULL, 1),
(330, 'women-dress-1', 'Đỏ', 'M', 'SKU-women-dress-1-3-2', 20, NULL, NULL, 1),
(331, 'women-dress-1', 'Đỏ', 'L', 'SKU-women-dress-1-3-3', 20, NULL, NULL, 1),
(332, 'women-dress-1', 'Đỏ', 'XL', 'SKU-women-dress-1-3-4', 20, NULL, NULL, 1),
(333, 'women-dress-1', 'Be', 'S', 'SKU-women-dress-1-4-1', 20, NULL, NULL, 1),
(334, 'women-dress-1', 'Be', 'M', 'SKU-women-dress-1-4-2', 20, NULL, NULL, 1),
(335, 'women-dress-1', 'Be', 'L', 'SKU-women-dress-1-4-3', 20, NULL, NULL, 1),
(336, 'women-dress-1', 'Be', 'XL', 'SKU-women-dress-1-4-4', 20, NULL, NULL, 1),
(337, 'women-dress-2', 'Hoa đỏ', 'S', 'SKU-women-dress-2-1-1', 20, NULL, NULL, 1),
(338, 'women-dress-2', 'Hoa đỏ', 'M', 'SKU-women-dress-2-1-2', 20, NULL, NULL, 1),
(339, 'women-dress-2', 'Hoa đỏ', 'L', 'SKU-women-dress-2-1-3', 20, NULL, NULL, 1),
(340, 'women-dress-2', 'Hoa đỏ', 'XL', 'SKU-women-dress-2-1-4', 20, NULL, NULL, 1),
(341, 'women-dress-2', 'Hoa xanh', 'S', 'SKU-women-dress-2-2-1', 20, NULL, NULL, 1),
(342, 'women-dress-2', 'Hoa xanh', 'M', 'SKU-women-dress-2-2-2', 20, NULL, NULL, 1),
(343, 'women-dress-2', 'Hoa xanh', 'L', 'SKU-women-dress-2-2-3', 20, NULL, NULL, 1),
(344, 'women-dress-2', 'Hoa xanh', 'XL', 'SKU-women-dress-2-2-4', 20, NULL, NULL, 1),
(345, 'women-dress-2', 'Hoa vàng', 'S', 'SKU-women-dress-2-3-1', 20, NULL, NULL, 1),
(346, 'women-dress-2', 'Hoa vàng', 'M', 'SKU-women-dress-2-3-2', 20, NULL, NULL, 1),
(347, 'women-dress-2', 'Hoa vàng', 'L', 'SKU-women-dress-2-3-3', 20, NULL, NULL, 1),
(348, 'women-dress-2', 'Hoa vàng', 'XL', 'SKU-women-dress-2-3-4', 20, NULL, NULL, 1),
(349, 'women-dress-3', 'Xanh đậm', 'S', 'SKU-women-dress-3-1-1', 20, NULL, NULL, 1),
(350, 'women-dress-3', 'Xanh đậm', 'M', 'SKU-women-dress-3-1-2', 20, NULL, NULL, 1),
(351, 'women-dress-3', 'Xanh đậm', 'L', 'SKU-women-dress-3-1-3', 20, NULL, NULL, 1),
(352, 'women-dress-3', 'Xanh đậm', 'XL', 'SKU-women-dress-3-1-4', 20, NULL, NULL, 1),
(353, 'women-dress-3', 'Xanh nhạt', 'S', 'SKU-women-dress-3-2-1', 20, NULL, NULL, 1),
(354, 'women-dress-3', 'Xanh nhạt', 'M', 'SKU-women-dress-3-2-2', 20, NULL, NULL, 1),
(355, 'women-dress-3', 'Xanh nhạt', 'L', 'SKU-women-dress-3-2-3', 20, NULL, NULL, 1),
(356, 'women-dress-3', 'Xanh nhạt', 'XL', 'SKU-women-dress-3-2-4', 20, NULL, NULL, 1),
(357, 'women-cardigan-1', 'Be', 'S', 'SKU-women-cardigan-1-1-1', 20, NULL, NULL, 1),
(358, 'women-cardigan-1', 'Be', 'M', 'SKU-women-cardigan-1-1-2', 20, NULL, NULL, 1),
(359, 'women-cardigan-1', 'Be', 'L', 'SKU-women-cardigan-1-1-3', 20, NULL, NULL, 1),
(360, 'women-cardigan-1', 'Be', 'XL', 'SKU-women-cardigan-1-1-4', 20, NULL, NULL, 1),
(361, 'women-cardigan-1', 'Xám', 'S', 'SKU-women-cardigan-1-2-1', 20, NULL, NULL, 1),
(362, 'women-cardigan-1', 'Xám', 'M', 'SKU-women-cardigan-1-2-2', 20, NULL, NULL, 1),
(363, 'women-cardigan-1', 'Xám', 'L', 'SKU-women-cardigan-1-2-3', 20, NULL, NULL, 1),
(364, 'women-cardigan-1', 'Xám', 'XL', 'SKU-women-cardigan-1-2-4', 20, NULL, NULL, 1),
(365, 'women-cardigan-1', 'Hồng nhạt', 'S', 'SKU-women-cardigan-1-3-1', 20, NULL, NULL, 1),
(366, 'women-cardigan-1', 'Hồng nhạt', 'M', 'SKU-women-cardigan-1-3-2', 20, NULL, NULL, 1),
(367, 'women-cardigan-1', 'Hồng nhạt', 'L', 'SKU-women-cardigan-1-3-3', 20, NULL, NULL, 1),
(368, 'women-cardigan-1', 'Hồng nhạt', 'XL', 'SKU-women-cardigan-1-3-4', 20, NULL, NULL, 1),
(369, 'women-cardigan-1', 'Xanh', 'S', 'SKU-women-cardigan-1-4-1', 20, NULL, NULL, 1),
(370, 'women-cardigan-1', 'Xanh', 'M', 'SKU-women-cardigan-1-4-2', 20, NULL, NULL, 1),
(371, 'women-cardigan-1', 'Xanh', 'L', 'SKU-women-cardigan-1-4-3', 20, NULL, NULL, 1),
(372, 'women-cardigan-1', 'Xanh', 'XL', 'SKU-women-cardigan-1-4-4', 20, NULL, NULL, 1),
(373, 'women-cardigan-2', 'Be', 'S', 'SKU-women-cardigan-2-1-1', 20, NULL, NULL, 1),
(374, 'women-cardigan-2', 'Be', 'M', 'SKU-women-cardigan-2-1-2', 20, NULL, NULL, 1),
(375, 'women-cardigan-2', 'Be', 'L', 'SKU-women-cardigan-2-1-3', 20, NULL, NULL, 1),
(376, 'women-cardigan-2', 'Be', 'XL', 'SKU-women-cardigan-2-1-4', 20, NULL, NULL, 1),
(377, 'women-cardigan-2', 'Xám nhạt', 'S', 'SKU-women-cardigan-2-2-1', 20, NULL, NULL, 1),
(378, 'women-cardigan-2', 'Xám nhạt', 'M', 'SKU-women-cardigan-2-2-2', 20, NULL, NULL, 1),
(379, 'women-cardigan-2', 'Xám nhạt', 'L', 'SKU-women-cardigan-2-2-3', 20, NULL, NULL, 1),
(380, 'women-cardigan-2', 'Xám nhạt', 'XL', 'SKU-women-cardigan-2-2-4', 20, NULL, NULL, 1),
(381, 'women-cardigan-2', 'Hồng', 'S', 'SKU-women-cardigan-2-3-1', 20, NULL, NULL, 1),
(382, 'women-cardigan-2', 'Hồng', 'M', 'SKU-women-cardigan-2-3-2', 20, NULL, NULL, 1),
(383, 'women-cardigan-2', 'Hồng', 'L', 'SKU-women-cardigan-2-3-3', 20, NULL, NULL, 1),
(384, 'women-cardigan-2', 'Hồng', 'XL', 'SKU-women-cardigan-2-3-4', 20, NULL, NULL, 1),
(385, 'women-cardigan-2', 'Đen', 'S', 'SKU-women-cardigan-2-4-1', 20, NULL, NULL, 1),
(386, 'women-cardigan-2', 'Đen', 'M', 'SKU-women-cardigan-2-4-2', 20, NULL, NULL, 1),
(387, 'women-cardigan-2', 'Đen', 'L', 'SKU-women-cardigan-2-4-3', 20, NULL, NULL, 1),
(388, 'women-cardigan-2', 'Đen', 'XL', 'SKU-women-cardigan-2-4-4', 20, NULL, NULL, 1),
(389, 'women-jean-1', 'Xanh đậm', '25', 'SKU-women-jean-1-1-1', 20, NULL, NULL, 1),
(390, 'women-jean-1', 'Xanh đậm', '26', 'SKU-women-jean-1-1-2', 20, NULL, NULL, 1),
(391, 'women-jean-1', 'Xanh đậm', '27', 'SKU-women-jean-1-1-3', 20, NULL, NULL, 1),
(392, 'women-jean-1', 'Xanh đậm', '28', 'SKU-women-jean-1-1-4', 20, NULL, NULL, 1),
(393, 'women-jean-1', 'Xanh đậm', '29', 'SKU-women-jean-1-1-5', 20, NULL, NULL, 1),
(394, 'women-jean-1', 'Xanh đậm', '30', 'SKU-women-jean-1-1-6', 20, NULL, NULL, 1),
(395, 'women-jean-1', 'Xanh nhạt', '25', 'SKU-women-jean-1-2-1', 20, NULL, NULL, 1),
(396, 'women-jean-1', 'Xanh nhạt', '26', 'SKU-women-jean-1-2-2', 20, NULL, NULL, 1),
(397, 'women-jean-1', 'Xanh nhạt', '27', 'SKU-women-jean-1-2-3', 20, NULL, NULL, 1),
(398, 'women-jean-1', 'Xanh nhạt', '28', 'SKU-women-jean-1-2-4', 20, NULL, NULL, 1),
(399, 'women-jean-1', 'Xanh nhạt', '29', 'SKU-women-jean-1-2-5', 20, NULL, NULL, 1),
(400, 'women-jean-1', 'Xanh nhạt', '30', 'SKU-women-jean-1-2-6', 20, NULL, NULL, 1),
(401, 'women-jean-1', 'Đen', '25', 'SKU-women-jean-1-3-1', 20, NULL, NULL, 1),
(402, 'women-jean-1', 'Đen', '26', 'SKU-women-jean-1-3-2', 20, NULL, NULL, 1),
(403, 'women-jean-1', 'Đen', '27', 'SKU-women-jean-1-3-3', 20, NULL, NULL, 1),
(404, 'women-jean-1', 'Đen', '28', 'SKU-women-jean-1-3-4', 20, NULL, NULL, 1),
(405, 'women-jean-1', 'Đen', '29', 'SKU-women-jean-1-3-5', 20, NULL, NULL, 1),
(406, 'women-jean-1', 'Đen', '30', 'SKU-women-jean-1-3-6', 20, NULL, NULL, 1),
(407, 'women-jean-2', 'Xanh đậm', '25', 'SKU-women-jean-2-1-1', 20, NULL, NULL, 1),
(408, 'women-jean-2', 'Xanh đậm', '26', 'SKU-women-jean-2-1-2', 20, NULL, NULL, 1),
(409, 'women-jean-2', 'Xanh đậm', '27', 'SKU-women-jean-2-1-3', 20, NULL, NULL, 1),
(410, 'women-jean-2', 'Xanh đậm', '28', 'SKU-women-jean-2-1-4', 20, NULL, NULL, 1),
(411, 'women-jean-2', 'Xanh đậm', '29', 'SKU-women-jean-2-1-5', 20, NULL, NULL, 1),
(412, 'women-jean-2', 'Xanh đậm', '30', 'SKU-women-jean-2-1-6', 20, NULL, NULL, 1),
(413, 'women-jean-2', 'Xanh đậm', '32', 'SKU-women-jean-2-1-7', 20, NULL, NULL, 1),
(414, 'women-jean-2', 'Đen', '25', 'SKU-women-jean-2-2-1', 20, NULL, NULL, 1),
(415, 'women-jean-2', 'Đen', '26', 'SKU-women-jean-2-2-2', 20, NULL, NULL, 1),
(416, 'women-jean-2', 'Đen', '27', 'SKU-women-jean-2-2-3', 20, NULL, NULL, 1),
(417, 'women-jean-2', 'Đen', '28', 'SKU-women-jean-2-2-4', 20, NULL, NULL, 1),
(418, 'women-jean-2', 'Đen', '29', 'SKU-women-jean-2-2-5', 20, NULL, NULL, 1),
(419, 'women-jean-2', 'Đen', '30', 'SKU-women-jean-2-2-6', 20, NULL, NULL, 1),
(420, 'women-jean-2', 'Đen', '32', 'SKU-women-jean-2-2-7', 20, NULL, NULL, 1),
(421, 'women-jean-2', 'Xanh nhạt', '25', 'SKU-women-jean-2-3-1', 20, NULL, NULL, 1),
(422, 'women-jean-2', 'Xanh nhạt', '26', 'SKU-women-jean-2-3-2', 20, NULL, NULL, 1),
(423, 'women-jean-2', 'Xanh nhạt', '27', 'SKU-women-jean-2-3-3', 20, NULL, NULL, 1),
(424, 'women-jean-2', 'Xanh nhạt', '28', 'SKU-women-jean-2-3-4', 20, NULL, NULL, 1),
(425, 'women-jean-2', 'Xanh nhạt', '29', 'SKU-women-jean-2-3-5', 20, NULL, NULL, 1),
(426, 'women-jean-2', 'Xanh nhạt', '30', 'SKU-women-jean-2-3-6', 20, NULL, NULL, 1),
(427, 'women-jean-2', 'Xanh nhạt', '32', 'SKU-women-jean-2-3-7', 20, NULL, NULL, 1),
(428, 'women-jacket-1', 'Đen', 'S', 'SKU-women-jacket-1-1-1', 20, NULL, NULL, 1),
(429, 'women-jacket-1', 'Đen', 'M', 'SKU-women-jacket-1-1-2', 20, NULL, NULL, 1),
(430, 'women-jacket-1', 'Đen', 'L', 'SKU-women-jacket-1-1-3', 20, NULL, NULL, 1),
(431, 'women-jacket-1', 'Đen', 'XL', 'SKU-women-jacket-1-1-4', 20, NULL, NULL, 1),
(432, 'women-jacket-1', 'Xanh Navy', 'S', 'SKU-women-jacket-1-2-1', 20, NULL, NULL, 1),
(433, 'women-jacket-1', 'Xanh Navy', 'M', 'SKU-women-jacket-1-2-2', 20, NULL, NULL, 1),
(434, 'women-jacket-1', 'Xanh Navy', 'L', 'SKU-women-jacket-1-2-3', 20, NULL, NULL, 1),
(435, 'women-jacket-1', 'Xanh Navy', 'XL', 'SKU-women-jacket-1-2-4', 20, NULL, NULL, 1),
(436, 'women-jacket-1', 'Be', 'S', 'SKU-women-jacket-1-3-1', 20, NULL, NULL, 1),
(437, 'women-jacket-1', 'Be', 'M', 'SKU-women-jacket-1-3-2', 20, NULL, NULL, 1),
(438, 'women-jacket-1', 'Be', 'L', 'SKU-women-jacket-1-3-3', 20, NULL, NULL, 1),
(439, 'women-jacket-1', 'Be', 'XL', 'SKU-women-jacket-1-3-4', 20, NULL, NULL, 1),
(440, 'women-jacket-1', 'Xám', 'S', 'SKU-women-jacket-1-4-1', 20, NULL, NULL, 1),
(441, 'women-jacket-1', 'Xám', 'M', 'SKU-women-jacket-1-4-2', 20, NULL, NULL, 1),
(442, 'women-jacket-1', 'Xám', 'L', 'SKU-women-jacket-1-4-3', 20, NULL, NULL, 1),
(443, 'women-jacket-1', 'Xám', 'XL', 'SKU-women-jacket-1-4-4', 20, NULL, NULL, 1),
(444, 'women-jacket-2', 'Xanh đậm', 'S', 'SKU-women-jacket-2-1-1', 20, NULL, NULL, 1),
(445, 'women-jacket-2', 'Xanh đậm', 'M', 'SKU-women-jacket-2-1-2', 20, NULL, NULL, 1),
(446, 'women-jacket-2', 'Xanh đậm', 'L', 'SKU-women-jacket-2-1-3', 20, NULL, NULL, 1),
(447, 'women-jacket-2', 'Xanh đậm', 'XL', 'SKU-women-jacket-2-1-4', 20, NULL, NULL, 1),
(448, 'women-jacket-2', 'Xanh nhạt', 'S', 'SKU-women-jacket-2-2-1', 20, NULL, NULL, 1),
(449, 'women-jacket-2', 'Xanh nhạt', 'M', 'SKU-women-jacket-2-2-2', 20, NULL, NULL, 1),
(450, 'women-jacket-2', 'Xanh nhạt', 'L', 'SKU-women-jacket-2-2-3', 20, NULL, NULL, 1),
(451, 'women-jacket-2', 'Xanh nhạt', 'XL', 'SKU-women-jacket-2-2-4', 20, NULL, NULL, 1),
(452, 'women-jacket-2', 'Trắng', 'S', 'SKU-women-jacket-2-3-1', 20, NULL, NULL, 1),
(453, 'women-jacket-2', 'Trắng', 'M', 'SKU-women-jacket-2-3-2', 20, NULL, NULL, 1),
(454, 'women-jacket-2', 'Trắng', 'L', 'SKU-women-jacket-2-3-3', 20, NULL, NULL, 1),
(455, 'women-jacket-2', 'Trắng', 'XL', 'SKU-women-jacket-2-3-4', 20, NULL, NULL, 1),
(456, 'kids-boy-tshirt-1', 'Xanh', '100', 'SKU-kids-boy-tshirt-1-1-1', 20, NULL, NULL, 1),
(457, 'kids-boy-tshirt-1', 'Xanh', '110', 'SKU-kids-boy-tshirt-1-1-2', 20, NULL, NULL, 1),
(458, 'kids-boy-tshirt-1', 'Xanh', '120', 'SKU-kids-boy-tshirt-1-1-3', 20, NULL, NULL, 1),
(459, 'kids-boy-tshirt-1', 'Xanh', '130', 'SKU-kids-boy-tshirt-1-1-4', 20, NULL, NULL, 1),
(460, 'kids-boy-tshirt-1', 'Xanh', '140', 'SKU-kids-boy-tshirt-1-1-5', 20, NULL, NULL, 1),
(461, 'kids-boy-tshirt-1', 'Đỏ', '100', 'SKU-kids-boy-tshirt-1-2-1', 20, NULL, NULL, 1),
(462, 'kids-boy-tshirt-1', 'Đỏ', '110', 'SKU-kids-boy-tshirt-1-2-2', 20, NULL, NULL, 1),
(463, 'kids-boy-tshirt-1', 'Đỏ', '120', 'SKU-kids-boy-tshirt-1-2-3', 20, NULL, NULL, 1),
(464, 'kids-boy-tshirt-1', 'Đỏ', '130', 'SKU-kids-boy-tshirt-1-2-4', 20, NULL, NULL, 1),
(465, 'kids-boy-tshirt-1', 'Đỏ', '140', 'SKU-kids-boy-tshirt-1-2-5', 20, NULL, NULL, 1),
(466, 'kids-boy-tshirt-1', 'Vàng', '100', 'SKU-kids-boy-tshirt-1-3-1', 20, NULL, NULL, 1),
(467, 'kids-boy-tshirt-1', 'Vàng', '110', 'SKU-kids-boy-tshirt-1-3-2', 20, NULL, NULL, 1),
(468, 'kids-boy-tshirt-1', 'Vàng', '120', 'SKU-kids-boy-tshirt-1-3-3', 20, NULL, NULL, 1),
(469, 'kids-boy-tshirt-1', 'Vàng', '130', 'SKU-kids-boy-tshirt-1-3-4', 20, NULL, NULL, 1),
(470, 'kids-boy-tshirt-1', 'Vàng', '140', 'SKU-kids-boy-tshirt-1-3-5', 20, NULL, NULL, 1),
(471, 'kids-boy-tshirt-1', 'Trắng', '100', 'SKU-kids-boy-tshirt-1-4-1', 20, NULL, NULL, 1),
(472, 'kids-boy-tshirt-1', 'Trắng', '110', 'SKU-kids-boy-tshirt-1-4-2', 20, NULL, NULL, 1),
(473, 'kids-boy-tshirt-1', 'Trắng', '120', 'SKU-kids-boy-tshirt-1-4-3', 20, NULL, NULL, 1),
(474, 'kids-boy-tshirt-1', 'Trắng', '130', 'SKU-kids-boy-tshirt-1-4-4', 20, NULL, NULL, 1),
(475, 'kids-boy-tshirt-1', 'Trắng', '140', 'SKU-kids-boy-tshirt-1-4-5', 20, NULL, NULL, 1),
(476, 'kids-boy-tshirt-2', 'Xanh lá', '100', 'SKU-kids-boy-tshirt-2-1-1', 20, NULL, NULL, 1),
(477, 'kids-boy-tshirt-2', 'Xanh lá', '110', 'SKU-kids-boy-tshirt-2-1-2', 20, NULL, NULL, 1),
(478, 'kids-boy-tshirt-2', 'Xanh lá', '120', 'SKU-kids-boy-tshirt-2-1-3', 20, NULL, NULL, 1),
(479, 'kids-boy-tshirt-2', 'Xanh lá', '130', 'SKU-kids-boy-tshirt-2-1-4', 20, NULL, NULL, 1),
(480, 'kids-boy-tshirt-2', 'Xanh lá', '140', 'SKU-kids-boy-tshirt-2-1-5', 20, NULL, NULL, 1),
(481, 'kids-boy-tshirt-2', 'Xanh lá', '150', 'SKU-kids-boy-tshirt-2-1-6', 20, NULL, NULL, 1),
(482, 'kids-boy-tshirt-2', 'Xám', '100', 'SKU-kids-boy-tshirt-2-2-1', 20, NULL, NULL, 1),
(483, 'kids-boy-tshirt-2', 'Xám', '110', 'SKU-kids-boy-tshirt-2-2-2', 20, NULL, NULL, 1),
(484, 'kids-boy-tshirt-2', 'Xám', '120', 'SKU-kids-boy-tshirt-2-2-3', 20, NULL, NULL, 1),
(485, 'kids-boy-tshirt-2', 'Xám', '130', 'SKU-kids-boy-tshirt-2-2-4', 20, NULL, NULL, 1),
(486, 'kids-boy-tshirt-2', 'Xám', '140', 'SKU-kids-boy-tshirt-2-2-5', 20, NULL, NULL, 1),
(487, 'kids-boy-tshirt-2', 'Xám', '150', 'SKU-kids-boy-tshirt-2-2-6', 20, NULL, NULL, 1),
(488, 'kids-boy-tshirt-2', 'Đen', '100', 'SKU-kids-boy-tshirt-2-3-1', 20, NULL, NULL, 1),
(489, 'kids-boy-tshirt-2', 'Đen', '110', 'SKU-kids-boy-tshirt-2-3-2', 20, NULL, NULL, 1),
(490, 'kids-boy-tshirt-2', 'Đen', '120', 'SKU-kids-boy-tshirt-2-3-3', 20, NULL, NULL, 1),
(491, 'kids-boy-tshirt-2', 'Đen', '130', 'SKU-kids-boy-tshirt-2-3-4', 20, NULL, NULL, 1),
(492, 'kids-boy-tshirt-2', 'Đen', '140', 'SKU-kids-boy-tshirt-2-3-5', 20, NULL, NULL, 1),
(493, 'kids-boy-tshirt-2', 'Đen', '150', 'SKU-kids-boy-tshirt-2-3-6', 20, NULL, NULL, 1),
(494, 'kids-girl-dress-1', 'Hồng', '100', 'SKU-kids-girl-dress-1-1-1', 20, NULL, NULL, 1),
(495, 'kids-girl-dress-1', 'Hồng', '110', 'SKU-kids-girl-dress-1-1-2', 20, NULL, NULL, 1),
(496, 'kids-girl-dress-1', 'Hồng', '120', 'SKU-kids-girl-dress-1-1-3', 20, NULL, NULL, 1),
(497, 'kids-girl-dress-1', 'Hồng', '130', 'SKU-kids-girl-dress-1-1-4', 20, NULL, NULL, 1),
(498, 'kids-girl-dress-1', 'Xanh nhạt', '100', 'SKU-kids-girl-dress-1-2-1', 20, NULL, NULL, 1),
(499, 'kids-girl-dress-1', 'Xanh nhạt', '110', 'SKU-kids-girl-dress-1-2-2', 20, NULL, NULL, 1),
(500, 'kids-girl-dress-1', 'Xanh nhạt', '120', 'SKU-kids-girl-dress-1-2-3', 20, NULL, NULL, 1),
(501, 'kids-girl-dress-1', 'Xanh nhạt', '130', 'SKU-kids-girl-dress-1-2-4', 20, NULL, NULL, 1),
(502, 'kids-girl-dress-1', 'Vàng', '100', 'SKU-kids-girl-dress-1-3-1', 20, NULL, NULL, 1),
(503, 'kids-girl-dress-1', 'Vàng', '110', 'SKU-kids-girl-dress-1-3-2', 20, NULL, NULL, 1),
(504, 'kids-girl-dress-1', 'Vàng', '120', 'SKU-kids-girl-dress-1-3-3', 20, NULL, NULL, 1),
(505, 'kids-girl-dress-1', 'Vàng', '130', 'SKU-kids-girl-dress-1-3-4', 20, NULL, NULL, 1),
(506, 'kids-girl-dress-1', 'Trắng', '100', 'SKU-kids-girl-dress-1-4-1', 20, NULL, NULL, 1),
(507, 'kids-girl-dress-1', 'Trắng', '110', 'SKU-kids-girl-dress-1-4-2', 20, NULL, NULL, 1),
(508, 'kids-girl-dress-1', 'Trắng', '120', 'SKU-kids-girl-dress-1-4-3', 20, NULL, NULL, 1),
(509, 'kids-girl-dress-1', 'Trắng', '130', 'SKU-kids-girl-dress-1-4-4', 20, NULL, NULL, 1),
(510, 'kids-girl-dress-2', 'Hồng', '100', 'SKU-kids-girl-dress-2-1-1', 20, NULL, NULL, 1),
(511, 'kids-girl-dress-2', 'Hồng', '110', 'SKU-kids-girl-dress-2-1-2', 20, NULL, NULL, 1),
(512, 'kids-girl-dress-2', 'Hồng', '120', 'SKU-kids-girl-dress-2-1-3', 20, NULL, NULL, 1),
(513, 'kids-girl-dress-2', 'Hồng', '130', 'SKU-kids-girl-dress-2-1-4', 20, NULL, NULL, 1),
(514, 'kids-girl-dress-2', 'Hồng', '140', 'SKU-kids-girl-dress-2-1-5', 20, NULL, NULL, 1),
(515, 'kids-girl-dress-2', 'Tím', '100', 'SKU-kids-girl-dress-2-2-1', 20, NULL, NULL, 1),
(516, 'kids-girl-dress-2', 'Tím', '110', 'SKU-kids-girl-dress-2-2-2', 20, NULL, NULL, 1),
(517, 'kids-girl-dress-2', 'Tím', '120', 'SKU-kids-girl-dress-2-2-3', 20, NULL, NULL, 1),
(518, 'kids-girl-dress-2', 'Tím', '130', 'SKU-kids-girl-dress-2-2-4', 20, NULL, NULL, 1),
(519, 'kids-girl-dress-2', 'Tím', '140', 'SKU-kids-girl-dress-2-2-5', 20, NULL, NULL, 1),
(520, 'kids-girl-dress-2', 'Xanh', '100', 'SKU-kids-girl-dress-2-3-1', 20, NULL, NULL, 1),
(521, 'kids-girl-dress-2', 'Xanh', '110', 'SKU-kids-girl-dress-2-3-2', 20, NULL, NULL, 1),
(522, 'kids-girl-dress-2', 'Xanh', '120', 'SKU-kids-girl-dress-2-3-3', 20, NULL, NULL, 1),
(523, 'kids-girl-dress-2', 'Xanh', '130', 'SKU-kids-girl-dress-2-3-4', 20, NULL, NULL, 1),
(524, 'kids-girl-dress-2', 'Xanh', '140', 'SKU-kids-girl-dress-2-3-5', 20, NULL, NULL, 1),
(525, 'kids-jean-1', 'Xanh đậm', '100', 'SKU-kids-jean-1-1-1', 20, NULL, NULL, 1),
(526, 'kids-jean-1', 'Xanh đậm', '110', 'SKU-kids-jean-1-1-2', 20, NULL, NULL, 1),
(527, 'kids-jean-1', 'Xanh đậm', '120', 'SKU-kids-jean-1-1-3', 20, NULL, NULL, 1),
(528, 'kids-jean-1', 'Xanh đậm', '130', 'SKU-kids-jean-1-1-4', 20, NULL, NULL, 1),
(529, 'kids-jean-1', 'Xanh đậm', '140', 'SKU-kids-jean-1-1-5', 20, NULL, NULL, 1),
(530, 'kids-jean-1', 'Xanh đậm', '150', 'SKU-kids-jean-1-1-6', 20, NULL, NULL, 1),
(531, 'kids-jean-1', 'Xanh nhạt', '100', 'SKU-kids-jean-1-2-1', 20, NULL, NULL, 1),
(532, 'kids-jean-1', 'Xanh nhạt', '110', 'SKU-kids-jean-1-2-2', 20, NULL, NULL, 1),
(533, 'kids-jean-1', 'Xanh nhạt', '120', 'SKU-kids-jean-1-2-3', 20, NULL, NULL, 1),
(534, 'kids-jean-1', 'Xanh nhạt', '130', 'SKU-kids-jean-1-2-4', 20, NULL, NULL, 1),
(535, 'kids-jean-1', 'Xanh nhạt', '140', 'SKU-kids-jean-1-2-5', 20, NULL, NULL, 1),
(536, 'kids-jean-1', 'Xanh nhạt', '150', 'SKU-kids-jean-1-2-6', 20, NULL, NULL, 1),
(537, 'kids-jean-1', 'Đen', '100', 'SKU-kids-jean-1-3-1', 20, NULL, NULL, 1),
(538, 'kids-jean-1', 'Đen', '110', 'SKU-kids-jean-1-3-2', 20, NULL, NULL, 1),
(539, 'kids-jean-1', 'Đen', '120', 'SKU-kids-jean-1-3-3', 20, NULL, NULL, 1),
(540, 'kids-jean-1', 'Đen', '130', 'SKU-kids-jean-1-3-4', 20, NULL, NULL, 1),
(541, 'kids-jean-1', 'Đen', '140', 'SKU-kids-jean-1-3-5', 20, NULL, NULL, 1),
(542, 'kids-jean-1', 'Đen', '150', 'SKU-kids-jean-1-3-6', 20, NULL, NULL, 1),
(543, 'kids-jean-2', 'Xanh đậm', '100', 'SKU-kids-jean-2-1-1', 20, NULL, NULL, 1),
(544, 'kids-jean-2', 'Xanh đậm', '110', 'SKU-kids-jean-2-1-2', 20, NULL, NULL, 1),
(545, 'kids-jean-2', 'Xanh đậm', '120', 'SKU-kids-jean-2-1-3', 20, NULL, NULL, 1),
(546, 'kids-jean-2', 'Xanh đậm', '130', 'SKU-kids-jean-2-1-4', 20, NULL, NULL, 1),
(547, 'kids-jean-2', 'Xanh đậm', '140', 'SKU-kids-jean-2-1-5', 20, NULL, NULL, 1),
(548, 'kids-jean-2', 'Xanh nhạt', '100', 'SKU-kids-jean-2-2-1', 20, NULL, NULL, 1),
(549, 'kids-jean-2', 'Xanh nhạt', '110', 'SKU-kids-jean-2-2-2', 20, NULL, NULL, 1),
(550, 'kids-jean-2', 'Xanh nhạt', '120', 'SKU-kids-jean-2-2-3', 20, NULL, NULL, 1),
(551, 'kids-jean-2', 'Xanh nhạt', '130', 'SKU-kids-jean-2-2-4', 20, NULL, NULL, 1),
(552, 'kids-jean-2', 'Xanh nhạt', '140', 'SKU-kids-jean-2-2-5', 20, NULL, NULL, 1),
(553, 'kids-jean-2', 'Hồng nhạt', '100', 'SKU-kids-jean-2-3-1', 20, NULL, NULL, 1),
(554, 'kids-jean-2', 'Hồng nhạt', '110', 'SKU-kids-jean-2-3-2', 20, NULL, NULL, 1),
(555, 'kids-jean-2', 'Hồng nhạt', '120', 'SKU-kids-jean-2-3-3', 20, NULL, NULL, 1),
(556, 'kids-jean-2', 'Hồng nhạt', '130', 'SKU-kids-jean-2-3-4', 20, NULL, NULL, 1),
(557, 'kids-jean-2', 'Hồng nhạt', '140', 'SKU-kids-jean-2-3-5', 20, NULL, NULL, 1),
(558, 'kids-short-1', 'Be', '100', 'SKU-kids-short-1-1-1', 20, NULL, NULL, 1),
(559, 'kids-short-1', 'Be', '110', 'SKU-kids-short-1-1-2', 20, NULL, NULL, 1),
(560, 'kids-short-1', 'Be', '120', 'SKU-kids-short-1-1-3', 20, NULL, NULL, 1),
(561, 'kids-short-1', 'Be', '130', 'SKU-kids-short-1-1-4', 20, NULL, NULL, 1),
(562, 'kids-short-1', 'Be', '140', 'SKU-kids-short-1-1-5', 20, NULL, NULL, 1),
(563, 'kids-short-1', 'Xanh Navy', '100', 'SKU-kids-short-1-2-1', 20, NULL, NULL, 1),
(564, 'kids-short-1', 'Xanh Navy', '110', 'SKU-kids-short-1-2-2', 20, NULL, NULL, 1),
(565, 'kids-short-1', 'Xanh Navy', '120', 'SKU-kids-short-1-2-3', 20, NULL, NULL, 1),
(566, 'kids-short-1', 'Xanh Navy', '130', 'SKU-kids-short-1-2-4', 20, NULL, NULL, 1),
(567, 'kids-short-1', 'Xanh Navy', '140', 'SKU-kids-short-1-2-5', 20, NULL, NULL, 1),
(568, 'kids-short-1', 'Xám', '100', 'SKU-kids-short-1-3-1', 20, NULL, NULL, 1),
(569, 'kids-short-1', 'Xám', '110', 'SKU-kids-short-1-3-2', 20, NULL, NULL, 1),
(570, 'kids-short-1', 'Xám', '120', 'SKU-kids-short-1-3-3', 20, NULL, NULL, 1),
(571, 'kids-short-1', 'Xám', '130', 'SKU-kids-short-1-3-4', 20, NULL, NULL, 1),
(572, 'kids-short-1', 'Xám', '140', 'SKU-kids-short-1-3-5', 20, NULL, NULL, 1),
(573, 'kids-short-1', 'Đen', '100', 'SKU-kids-short-1-4-1', 20, NULL, NULL, 1),
(574, 'kids-short-1', 'Đen', '110', 'SKU-kids-short-1-4-2', 20, NULL, NULL, 1),
(575, 'kids-short-1', 'Đen', '120', 'SKU-kids-short-1-4-3', 20, NULL, NULL, 1),
(576, 'kids-short-1', 'Đen', '130', 'SKU-kids-short-1-4-4', 20, NULL, NULL, 1),
(577, 'kids-short-1', 'Đen', '140', 'SKU-kids-short-1-4-5', 20, NULL, NULL, 1),
(578, 'kids-short-2', 'Hồng', '100', 'SKU-kids-short-2-1-1', 20, NULL, NULL, 1),
(579, 'kids-short-2', 'Hồng', '110', 'SKU-kids-short-2-1-2', 20, NULL, NULL, 1),
(580, 'kids-short-2', 'Hồng', '120', 'SKU-kids-short-2-1-3', 20, NULL, NULL, 1),
(581, 'kids-short-2', 'Hồng', '130', 'SKU-kids-short-2-1-4', 20, NULL, NULL, 1),
(582, 'kids-short-2', 'Hồng', '140', 'SKU-kids-short-2-1-5', 20, NULL, NULL, 1),
(583, 'kids-short-2', 'Trắng', '100', 'SKU-kids-short-2-2-1', 20, NULL, NULL, 1),
(584, 'kids-short-2', 'Trắng', '110', 'SKU-kids-short-2-2-2', 20, NULL, NULL, 1),
(585, 'kids-short-2', 'Trắng', '120', 'SKU-kids-short-2-2-3', 20, NULL, NULL, 1),
(586, 'kids-short-2', 'Trắng', '130', 'SKU-kids-short-2-2-4', 20, NULL, NULL, 1),
(587, 'kids-short-2', 'Trắng', '140', 'SKU-kids-short-2-2-5', 20, NULL, NULL, 1),
(588, 'kids-short-2', 'Xanh nhạt', '100', 'SKU-kids-short-2-3-1', 20, NULL, NULL, 1),
(589, 'kids-short-2', 'Xanh nhạt', '110', 'SKU-kids-short-2-3-2', 20, NULL, NULL, 1),
(590, 'kids-short-2', 'Xanh nhạt', '120', 'SKU-kids-short-2-3-3', 20, NULL, NULL, 1),
(591, 'kids-short-2', 'Xanh nhạt', '130', 'SKU-kids-short-2-3-4', 20, NULL, NULL, 1),
(592, 'kids-short-2', 'Xanh nhạt', '140', 'SKU-kids-short-2-3-5', 20, NULL, NULL, 1),
(593, 'kids-short-2', 'Vàng', '100', 'SKU-kids-short-2-4-1', 20, NULL, NULL, 1),
(594, 'kids-short-2', 'Vàng', '110', 'SKU-kids-short-2-4-2', 20, NULL, NULL, 1),
(595, 'kids-short-2', 'Vàng', '120', 'SKU-kids-short-2-4-3', 20, NULL, NULL, 1),
(596, 'kids-short-2', 'Vàng', '130', 'SKU-kids-short-2-4-4', 20, NULL, NULL, 1),
(597, 'kids-short-2', 'Vàng', '140', 'SKU-kids-short-2-4-5', 20, NULL, NULL, 1),
(598, 'kids-jacket-1', 'Xanh Navy', '100', 'SKU-kids-jacket-1-1-1', 20, NULL, NULL, 1),
(599, 'kids-jacket-1', 'Xanh Navy', '110', 'SKU-kids-jacket-1-1-2', 20, NULL, NULL, 1),
(600, 'kids-jacket-1', 'Xanh Navy', '120', 'SKU-kids-jacket-1-1-3', 20, NULL, NULL, 1),
(601, 'kids-jacket-1', 'Xanh Navy', '130', 'SKU-kids-jacket-1-1-4', 20, NULL, NULL, 1),
(602, 'kids-jacket-1', 'Xanh Navy', '140', 'SKU-kids-jacket-1-1-5', 20, NULL, NULL, 1),
(603, 'kids-jacket-1', 'Xanh Navy', '150', 'SKU-kids-jacket-1-1-6', 20, NULL, NULL, 1),
(604, 'kids-jacket-1', 'Đen', '100', 'SKU-kids-jacket-1-2-1', 20, NULL, NULL, 1),
(605, 'kids-jacket-1', 'Đen', '110', 'SKU-kids-jacket-1-2-2', 20, NULL, NULL, 1),
(606, 'kids-jacket-1', 'Đen', '120', 'SKU-kids-jacket-1-2-3', 20, NULL, NULL, 1),
(607, 'kids-jacket-1', 'Đen', '130', 'SKU-kids-jacket-1-2-4', 20, NULL, NULL, 1),
(608, 'kids-jacket-1', 'Đen', '140', 'SKU-kids-jacket-1-2-5', 20, NULL, NULL, 1),
(609, 'kids-jacket-1', 'Đen', '150', 'SKU-kids-jacket-1-2-6', 20, NULL, NULL, 1),
(610, 'kids-jacket-1', 'Xám', '100', 'SKU-kids-jacket-1-3-1', 20, NULL, NULL, 1),
(611, 'kids-jacket-1', 'Xám', '110', 'SKU-kids-jacket-1-3-2', 20, NULL, NULL, 1),
(612, 'kids-jacket-1', 'Xám', '120', 'SKU-kids-jacket-1-3-3', 20, NULL, NULL, 1),
(613, 'kids-jacket-1', 'Xám', '130', 'SKU-kids-jacket-1-3-4', 20, NULL, NULL, 1),
(614, 'kids-jacket-1', 'Xám', '140', 'SKU-kids-jacket-1-3-5', 20, NULL, NULL, 1),
(615, 'kids-jacket-1', 'Xám', '150', 'SKU-kids-jacket-1-3-6', 20, NULL, NULL, 1),
(616, 'kids-jacket-2', 'Hồng', '100', 'SKU-kids-jacket-2-1-1', 20, NULL, NULL, 1),
(617, 'kids-jacket-2', 'Hồng', '110', 'SKU-kids-jacket-2-1-2', 20, NULL, NULL, 1),
(618, 'kids-jacket-2', 'Hồng', '120', 'SKU-kids-jacket-2-1-3', 20, NULL, NULL, 1),
(619, 'kids-jacket-2', 'Hồng', '130', 'SKU-kids-jacket-2-1-4', 20, NULL, NULL, 1),
(620, 'kids-jacket-2', 'Hồng', '140', 'SKU-kids-jacket-2-1-5', 20, NULL, NULL, 1);
INSERT INTO `product_variants` (`id`, `product_id`, `color`, `size`, `sku`, `stock_qty`, `price`, `original_price`, `is_active`) VALUES
(621, 'kids-jacket-2', 'Tím', '100', 'SKU-kids-jacket-2-2-1', 20, NULL, NULL, 1),
(622, 'kids-jacket-2', 'Tím', '110', 'SKU-kids-jacket-2-2-2', 20, NULL, NULL, 1),
(623, 'kids-jacket-2', 'Tím', '120', 'SKU-kids-jacket-2-2-3', 20, NULL, NULL, 1),
(624, 'kids-jacket-2', 'Tím', '130', 'SKU-kids-jacket-2-2-4', 20, NULL, NULL, 1),
(625, 'kids-jacket-2', 'Tím', '140', 'SKU-kids-jacket-2-2-5', 20, NULL, NULL, 1),
(626, 'kids-jacket-2', 'Trắng', '100', 'SKU-kids-jacket-2-3-1', 20, NULL, NULL, 1),
(627, 'kids-jacket-2', 'Trắng', '110', 'SKU-kids-jacket-2-3-2', 20, NULL, NULL, 1),
(628, 'kids-jacket-2', 'Trắng', '120', 'SKU-kids-jacket-2-3-3', 20, NULL, NULL, 1),
(629, 'kids-jacket-2', 'Trắng', '130', 'SKU-kids-jacket-2-3-4', 20, NULL, NULL, 1),
(630, 'kids-jacket-2', 'Trắng', '140', 'SKU-kids-jacket-2-3-5', 20, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id` bigint NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `user_id` bigint NOT NULL,
  `rating` tinyint NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `content` text,
  `images` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `product_id`, `user_id`, `rating`, `title`, `content`, `images`, `created_at`, `updated_at`) VALUES
(1, 'men-tshirt-1', 2, 5, 'Áo đẹp', 'Áo chất lượng tốt, form chuẩn.', NULL, '2025-09-12 19:12:56', '2025-09-12 19:12:56'),
(2, 'women-dress-1', 2, 4, 'Váy ổn', 'Mặc vừa vặn, chất liệu ok.', NULL, '2025-09-12 19:12:56', '2025-09-12 19:12:56');

-- --------------------------------------------------------

--
-- Table structure for table `shipments`
--

DROP TABLE IF EXISTS `shipments`;
CREATE TABLE `shipments` (
  `id` bigint NOT NULL,
  `order_id` bigint NOT NULL,
  `carrier` varchar(64) NOT NULL,
  `service` varchar(64) DEFAULT NULL,
  `tracking_code` varchar(64) DEFAULT NULL,
  `status` enum('waiting_pick','in_transit','delivered','lost','returned','cancelled') NOT NULL DEFAULT 'waiting_pick',
  `est_delivery` date DEFAULT NULL,
  `tracking_meta` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `shipments`
--

INSERT INTO `shipments` (`id`, `order_id`, `carrier`, `service`, `tracking_code`, `status`, `est_delivery`, `tracking_meta`, `created_at`, `updated_at`) VALUES
(1, 1, 'GHN', 'standard', 'GHN202509130001', 'in_transit', NULL, NULL, '2025-09-12 19:12:56', '2025-09-12 19:12:56');

-- --------------------------------------------------------

--
-- Table structure for table `subcategories`
--

DROP TABLE IF EXISTS `subcategories`;
CREATE TABLE `subcategories` (
  `id` bigint NOT NULL,
  `category_id` varchar(32) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `subcategories`
--

INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES
(18, 'kids', 'Áo Khoác'),
(16, 'kids', 'Quần Jean'),
(17, 'kids', 'Quần Short'),
(14, 'kids', 'T-shirt'),
(15, 'kids', 'Váy'),
(6, 'men', 'Áo Khoác'),
(2, 'men', 'Áo Polo'),
(3, 'men', 'Áo Sơ Mi'),
(4, 'men', 'Quần Jean'),
(5, 'men', 'Quần Kaki'),
(7, 'men', 'Quần Short'),
(1, 'men', 'T-shirt'),
(8, 'women', 'Áo Blouse'),
(13, 'women', 'Áo Khoác'),
(11, 'women', 'Cardigan'),
(12, 'women', 'Quần Jean'),
(9, 'women', 'T-shirt'),
(10, 'women', 'Váy');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `role` enum('customer','admin') NOT NULL DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`, `full_name`, `phone`, `role`, `created_at`, `updated_at`) VALUES
(1, 'admin@example.com', 'hashed_admin_pw', 'Admin User', '0123456789', 'admin', '2025-09-12 19:12:56', '2025-09-12 19:12:56'),
(2, 'user1@example.com', 'hashed_user1_pw', 'Nguyen Van A', '0912345678', 'customer', '2025-09-12 19:12:56', '2025-09-12 19:12:56'),
(3, 'nguyenvana@email.com', 'seeded_pw_hash', 'Nguyễn Văn A', '0901234567', 'customer', '2025-10-13 15:48:30', '2025-10-13 15:48:30'),
(4, 'tranthib@email.com', 'seeded_pw_hash', 'Trần Thị B', '0907654321', 'customer', '2025-10-13 15:48:30', '2025-10-13 15:48:30'),
(5, 'levanc@email.com', 'seeded_pw_hash', 'Lê Văn C', '0912345678', 'customer', '2025-10-13 15:48:30', '2025-10-13 15:48:30');

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
CREATE TABLE `wishlist` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `wishlist`
--

INSERT INTO `wishlist` (`id`, `user_id`, `product_id`, `created_at`) VALUES
(1, 2, 'women-cardigan-2', '2025-09-12 19:12:56'),
(2, 2, 'kids-jacket-2', '2025-09-12 19:12:56');

-- --------------------------------------------------------

--
-- Structure for view `product_rating_agg`
--
DROP TABLE IF EXISTS `product_rating_agg`;

DROP VIEW IF EXISTS `product_rating_agg`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `product_rating_agg`  AS SELECT `reviews`.`product_id` AS `product_id`, round(avg(`reviews`.`rating`),1) AS `avg_rating`, count(0) AS `total_reviews` FROM `reviews` GROUP BY `reviews`.`product_id``product_id`  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `admin_customers`
--
ALTER TABLE `admin_customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_orders`
--
ALTER TABLE `admin_orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cart_prod_var` (`cart_id`,`product_id`,`variant_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_code` (`order_code`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_provider_txn` (`provider`,`txn_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subcategory_id` (`subcategory_id`),
  ADD KEY `idx_cat_sub` (`category_id`,`subcategory_id`),
  ADD KEY `idx_isnew_issale` (`is_new`,`is_sale`),
  ADD KEY `idx_rating` (`rating`);

--
-- Indexes for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_prod_color_size` (`product_id`,`color`,`size`),
  ADD UNIQUE KEY `sku` (`sku`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `shipments`
--
ALTER TABLE `shipments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tracking` (`carrier`,`tracking_code`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cat_name` (`category_id`,`name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_prod` (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1259;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shipments`
--
ALTER TABLE `shipments`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `subcategories`
--
ALTER TABLE `subcategories`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `cart_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`id`);

--
-- Constraints for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `shipments`
--
ALTER TABLE `shipments`
  ADD CONSTRAINT `shipments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `fk_sub_cat` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
