/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 80011
Source Host           : localhost:3306
Source Database       : tymql

Target Server Type    : MYSQL
Target Server Version : 80011
File Encoding         : 65001

Date: 2018-09-19 19:32:51
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `customers`
-- ----------------------------
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
  `cust_id` char(10) NOT NULL,
  `cust_name` char(50) NOT NULL,
  `cust_address` char(50) DEFAULT NULL,
  `cust_city` char(50) DEFAULT NULL,
  `cust_state` char(5) DEFAULT NULL,
  `cust_zip` char(10) DEFAULT NULL,
  `cust_country` char(50) DEFAULT NULL,
  `cust_contact` char(50) DEFAULT NULL,
  `cust_email` char(255) DEFAULT NULL,
  PRIMARY KEY (`cust_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of customers
-- ----------------------------
INSERT INTO `customers` VALUES ('1000000001', 'Village Toys', '200 Maple Lane', 'Detroit', 'MI', '44444', 'USA', 'John Smith', 'sales@villagetoys.com');
INSERT INTO `customers` VALUES ('1000000002', 'Kids Place', '333 South Lake Drive', 'Columbus', 'OH', '43333', 'USA', 'Michelle Green', null);
INSERT INTO `customers` VALUES ('1000000003', 'Fun4All', '1 Sunny Place', 'Muncie', 'IN', '42222', 'USA', 'Jim Jones', 'jjones@fun4all.com');
INSERT INTO `customers` VALUES ('1000000004', 'Fun4All', '829 Riverside Drive', 'Phoenix', 'AZ', '88888', 'USA', 'Denise L. Stephens', 'dstephens@fun4all.com');
INSERT INTO `customers` VALUES ('1000000005', 'The Toy Store', '4545 53rd Street', 'Chicago', 'IL', '54545', 'USA', 'Kim Howard', null);

-- ----------------------------
-- Table structure for `orderitems`
-- ----------------------------
DROP TABLE IF EXISTS `orderitems`;
CREATE TABLE `orderitems` (
  `order_num` int(11) NOT NULL,
  `order_item` int(11) NOT NULL,
  `prod_id` char(10) NOT NULL,
  `quantity` int(11) NOT NULL,
  `item_price` decimal(8,2) NOT NULL,
  PRIMARY KEY (`order_num`,`order_item`),
  KEY `FK_OrderItems_Products` (`prod_id`),
  CONSTRAINT `FK_OrderItems_Orders` FOREIGN KEY (`order_num`) REFERENCES `orders` (`order_num`),
  CONSTRAINT `FK_OrderItems_Products` FOREIGN KEY (`prod_id`) REFERENCES `products` (`prod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of orderitems
-- ----------------------------
INSERT INTO `orderitems` VALUES ('20005', '1', 'BR01', '100', '5.49');
INSERT INTO `orderitems` VALUES ('20005', '2', 'BR03', '100', '10.99');
INSERT INTO `orderitems` VALUES ('20006', '1', 'BR01', '20', '5.99');
INSERT INTO `orderitems` VALUES ('20006', '2', 'BR02', '10', '8.99');
INSERT INTO `orderitems` VALUES ('20006', '3', 'BR03', '10', '11.99');
INSERT INTO `orderitems` VALUES ('20007', '1', 'BR03', '50', '11.49');
INSERT INTO `orderitems` VALUES ('20007', '2', 'BNBG01', '100', '2.99');
INSERT INTO `orderitems` VALUES ('20007', '3', 'BNBG02', '100', '2.99');
INSERT INTO `orderitems` VALUES ('20007', '4', 'BNBG03', '100', '2.99');
INSERT INTO `orderitems` VALUES ('20007', '5', 'RGAN01', '50', '4.49');
INSERT INTO `orderitems` VALUES ('20008', '1', 'RGAN01', '5', '4.99');
INSERT INTO `orderitems` VALUES ('20008', '2', 'BR03', '5', '11.99');
INSERT INTO `orderitems` VALUES ('20008', '3', 'BNBG01', '10', '3.49');
INSERT INTO `orderitems` VALUES ('20008', '4', 'BNBG02', '10', '3.49');
INSERT INTO `orderitems` VALUES ('20008', '5', 'BNBG03', '10', '3.49');
INSERT INTO `orderitems` VALUES ('20009', '1', 'BNBG01', '250', '2.49');
INSERT INTO `orderitems` VALUES ('20009', '2', 'BNBG02', '250', '2.49');
INSERT INTO `orderitems` VALUES ('20009', '3', 'BNBG03', '250', '2.49');

-- ----------------------------
-- Table structure for `orders`
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `order_num` int(11) NOT NULL,
  `order_date` datetime NOT NULL,
  `cust_id` char(10) NOT NULL,
  PRIMARY KEY (`order_num`),
  KEY `FK_Orders_Customers` (`cust_id`),
  CONSTRAINT `FK_Orders_Customers` FOREIGN KEY (`cust_id`) REFERENCES `customers` (`cust_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('20005', '2012-05-01 00:00:00', '1000000001');
INSERT INTO `orders` VALUES ('20006', '2012-01-12 00:00:00', '1000000003');
INSERT INTO `orders` VALUES ('20007', '2012-01-30 00:00:00', '1000000004');
INSERT INTO `orders` VALUES ('20008', '2012-02-03 00:00:00', '1000000005');
INSERT INTO `orders` VALUES ('20009', '2012-02-08 00:00:00', '1000000001');

-- ----------------------------
-- Table structure for `products`
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `prod_id` char(10) NOT NULL,
  `vend_id` char(10) NOT NULL,
  `prod_name` char(255) NOT NULL,
  `prod_price` decimal(8,2) NOT NULL,
  `prod_desc` text,
  PRIMARY KEY (`prod_id`),
  KEY `FK_Products_Vendors` (`vend_id`),
  CONSTRAINT `FK_Products_Vendors` FOREIGN KEY (`vend_id`) REFERENCES `vendors` (`vend_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES ('BNBG01', 'DLL01', 'Fish bean bag toy', '3.49', 'Fish bean bag toy, complete with bean bag worms with which to feed it');
INSERT INTO `products` VALUES ('BNBG02', 'DLL01', 'Bird bean bag toy', '3.49', 'Bird bean bag toy, eggs are not included');
INSERT INTO `products` VALUES ('BNBG03', 'DLL01', 'Rabbit bean bag toy', '3.49', 'Rabbit bean bag toy, comes with bean bag carrots');
INSERT INTO `products` VALUES ('BR01', 'BRS01', '8 inch teddy bear', '5.99', '8 inch teddy bear, comes with cap and jacket');
INSERT INTO `products` VALUES ('BR02', 'BRS01', '12 inch teddy bear', '8.99', '12 inch teddy bear, comes with cap and jacket');
INSERT INTO `products` VALUES ('BR03', 'BRS01', '18 inch teddy bear', '11.99', '18 inch teddy bear, comes with cap and jacket');
INSERT INTO `products` VALUES ('RGAN01', 'DLL01', 'Raggedy Ann', '4.99', '18 inch Raggedy Ann doll');
INSERT INTO `products` VALUES ('RYL01', 'FNG01', 'King doll', '9.49', '12 inch king doll with royal garments and crown');
INSERT INTO `products` VALUES ('RYL02', 'FNG01', 'Queen doll', '9.49', '12 inch queen doll with royal garments and crown');

-- ----------------------------
-- Table structure for `vendors`
-- ----------------------------
DROP TABLE IF EXISTS `vendors`;
CREATE TABLE `vendors` (
  `vend_id` char(10) NOT NULL,
  `vend_name` char(50) NOT NULL,
  `vend_address` char(50) DEFAULT NULL,
  `vend_city` char(50) DEFAULT NULL,
  `vend_state` char(5) DEFAULT NULL,
  `vend_zip` char(10) DEFAULT NULL,
  `vend_country` char(50) DEFAULT NULL,
  PRIMARY KEY (`vend_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of vendors
-- ----------------------------
INSERT INTO `vendors` VALUES ('BRE02', 'Bear Emporium', '500 Park Street', 'Anytown', 'OH', '44333', 'USA');
INSERT INTO `vendors` VALUES ('BRS01', 'Bears R Us', '123 Main Street', 'Bear Town', 'MI', '44444', 'USA');
INSERT INTO `vendors` VALUES ('DLL01', 'Doll House Inc.', '555 High Street', 'Dollsville', 'CA', '99999', 'USA');
INSERT INTO `vendors` VALUES ('FNG01', 'Fun and Games', '42 Galaxy Road', 'London', null, 'N16 6PS', 'England');
INSERT INTO `vendors` VALUES ('FRB01', 'Furball Inc.', '1000 5th Avenue', 'New York', 'NY', '11111', 'USA');
INSERT INTO `vendors` VALUES ('JTS01', 'Jouets et ours', '1 Rue Amusement', 'Paris', null, '45678', 'France');
