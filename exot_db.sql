-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 19. Mai 2025 um 22:21
-- Server-Version: 10.4.32-MariaDB
-- PHP-Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `exot_db`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `role` enum('admin','moderator','seller') NOT NULL,
  `fk_userid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `admin`
--

INSERT INTO `admin` (`id`, `role`, `fk_userid`) VALUES
(1, 'admin', 8);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `category_imagepath` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `category_imagepath`) VALUES
(1, 'Raubtiere', 'backend/public/category_images/Raubtiere.png'),
(2, 'Fische', 'backend/public/category_images/Fische.png'),
(3, 'Säugetiere', 'backend/public/category_images/Saeugetiere.png'),
(4, 'Illegal', 'backend/public/category_images/Illegal_Category.png');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `fk_customer_id` int(11) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `order_status` enum('Awaiting Payment','Shipped','Canceled','Completed') NOT NULL DEFAULT 'Awaiting Payment',
  `order_date` date NOT NULL DEFAULT current_timestamp(),
  `shipping_address` varchar(250) NOT NULL,
  `billing_address` varchar(250) NOT NULL,
  `payment_method` enum('credit_card','debit_card','paypal') NOT NULL,
  `shipping_cost` decimal(10,2) NOT NULL DEFAULT 2.99,
  `tracking_number` varchar(40) NOT NULL,
  `discount` varchar(30) DEFAULT '0',
  `invoice_number` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `orders`
--

INSERT INTO `orders` (`order_id`, `fk_customer_id`, `total_price`, `order_status`, `order_date`, `shipping_address`, `billing_address`, `payment_method`, `shipping_cost`, `tracking_number`, `discount`, `invoice_number`) VALUES
(50, 8, 1251.99, 'Awaiting Payment', '2025-05-18', 'Admin Street 20', 'Admin Street 20', 'paypal', 2.99, '', 'hallo1', 'INV-6829E11A85353'),
(51, 8, 34992.99, 'Awaiting Payment', '2025-05-18', 'Admin Street 20', 'Admin Street 20', 'paypal', 2.99, '', NULL, 'INV-6829E388A94B4'),
(52, 8, 69982.99, 'Awaiting Payment', '2025-05-18', 'Admin Street 20', 'Admin Street 20', 'paypal', 2.99, '', NULL, 'INV-6829E3AD3C794');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `fk_order_id` int(11) DEFAULT NULL,
  `fk_product_id` int(11) DEFAULT NULL,
  `quantity` int(8) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `fk_order_id`, `fk_product_id`, `quantity`, `subtotal`) VALUES
(1, 1, 1, 1, 30.00),
(2, 2, 2, 2, 40.00),
(3, 2, 3, 2, 15.98),
(38, 30, 6, 2, 5980.00),
(39, 30, 3, 1, 1299.00),
(40, 30, 2, 1, 34990.00),
(41, 30, 1, 1, 1299.00),
(42, 31, 1, 1, 1299.00),
(43, 31, 2, 1, 34990.00),
(44, 32, 6, 1, 2990.00),
(45, 33, 6, 1, 2990.00),
(46, 34, 6, 1, 2990.00),
(47, 35, 6, 1, 2990.00),
(48, 36, 6, 1, 2990.00),
(49, 37, 6, 1, 2990.00),
(50, 37, 3, 1, 1299.00),
(51, 38, 1, 1, 1299.00),
(52, 39, 1, 1, 1299.00),
(53, 40, 2, 1, 34990.00),
(54, 41, 2, 1, 34990.00),
(55, 42, 2, 1, 34990.00),
(56, 43, 1, 1, 1299.00),
(57, 44, 2, 1, 34990.00),
(58, 45, 3, 1, 1299.00),
(59, 46, 1, 1, 1299.00),
(60, 47, 1, 1, 1299.00),
(61, 48, 1, 1, 1299.00),
(62, 49, 1, 1, 1299.00),
(63, 50, 1, 1, 1299.00),
(64, 51, 2, 1, 34990.00),
(65, 52, 2, 2, 69980.00);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(150) NOT NULL,
  `product_description` text NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `product_weight` decimal(10,2) NOT NULL,
  `product_quantity` int(10) NOT NULL,
  `product_category` varchar(255) NOT NULL,
  `product_imagepath` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `product`
--

INSERT INTO `product` (`product_id`, `product_name`, `product_description`, `product_price`, `product_weight`, `product_quantity`, `product_category`, `product_imagepath`) VALUES
(1, 'Bergziege', 'Eine hübsche Bergziege, die gute Milch gibt.', 1299.00, 40.00, 7, 'Säugetiere', 'backend/public/product_images/ziege.png'),
(2, 'Weißer Tiger', 'Ein schöner Anmutiger Tiger.\r\nBemerkung: Erst kaufen, dann trainieren, dann selbst füttern, ansonsten werden Sie selbst zum Futter.', 34990.00, 190.00, 5, 'Raubtiere', 'backend/public/product_images/tiger.png'),
(3, 'Fennek', 'Falls Sie es noch nicht wussten: Ein Fennek ist ein kleines Wüstenfuchsartiges Tier, das vor allem durch seine großen Ohren auffällt.', 1299.00, 1.65, 10, 'Illegal', 'backend/public/product_images/fennek.png'),
(6, 'Blopfisch', 'Ein wunderschöner, anmutiger Fisch der gemeinsam mit dem Blauwal zu den schönsten und Eindrucksvollsten Tieren der Welt gehört.', 2990.00, 3.00, 10, 'Fische', 'backend/public/product_images/blop.png');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `salutation` enum('Mr.','Mrs.') NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `address` varchar(100) NOT NULL,
  `zipcode` varchar(20) NOT NULL,
  `city` varchar(64) NOT NULL,
  `email` varchar(150) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(260) NOT NULL,
  `payment_method` enum('credit_card','debit_card','paypal') NOT NULL,
  `status` enum('active','inactive') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `user`
--

INSERT INTO `user` (`id`, `salutation`, `firstname`, `lastname`, `address`, `zipcode`, `city`, `email`, `username`, `password`, `payment_method`, `status`) VALUES
(1, 'Mr.', '123', '123', '1231234', '123', '123', '12345@gmail.com', '123', '$2y$10$tORSOY4RzmmmYKlZUaKny.sINR8vIguGstBltqk0/UNZMS.aZ3Nre', 'credit_card', 'active'),
(2, 'Mrs.', 'tester', 'tester', 'Testerstraße 1', '1001', 'Wien', 'tester@email.com', 'tester123', '$2y$10$4eugjzUBHW8m7vy0KdxnjufG5Qa.GnQ/uYL9/jie7ejFIymNvrJH.', 'debit_card', 'inactive'),
(8, 'Mr.', 'Admin', 'Admin', 'Admin Street 20', '100', 'Administrator Town', 'admin@gmail.com', 'admin', '$2y$10$FMiAiGU.XMjxX50v3XVo6Ow0jyaWFTUUfn4nzTwJ6U6Ui9kYP6vgq', 'paypal', 'active'),
(14, 'Mr.', 'Michael', 'Massimo', 'höchstädtplatz 6', '1200', 'wien', 'a@a.com', 'michimo', '$2y$10$bhzrRkxWVQQRNSGKfPnncOWanYHH920tGHn.K5OCTWm6f01XQWNsq', 'debit_card', 'active');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `vouchers`
--

CREATE TABLE `vouchers` (
  `id` int(11) NOT NULL,
  `voucher_code` varchar(25) NOT NULL,
  `expiration_date` date NOT NULL,
  `discount_type` enum('percentage','fixed') NOT NULL,
  `discount_amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `vouchers`
--

INSERT INTO `vouchers` (`id`, `voucher_code`, `expiration_date`, `discount_type`, `discount_amount`) VALUES
(1, '30percent', '2032-11-18', 'percentage', 0.30),
(6, 'GXI6SYZOOV', '2024-06-27', 'fixed', 20.00),
(8, 'XRF346DMZS', '2025-05-28', 'percentage', 5.00),
(9, '2VIKOIBARE', '2025-05-28', 'fixed', 50.00);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_userid` (`fk_userid`);

--
-- Indizes für die Tabelle `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indizes für die Tabelle `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indizes für die Tabelle `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`);

--
-- Indizes für die Tabelle `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indizes für die Tabelle `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT für Tabelle `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT für Tabelle `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT für Tabelle `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT für Tabelle `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT für Tabelle `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`fk_userid`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
