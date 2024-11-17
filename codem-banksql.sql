-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.19-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for es_extended
CREATE DATABASE IF NOT EXISTS `es_extended` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `es_extended`;

-- Dumping structure for table es_extended.codem_banking_incomings
CREATE TABLE IF NOT EXISTS `codem_banking_incomings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `incoming` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table es_extended.codem_banking_incomings: ~1 rows (approximately)
/*!40000 ALTER TABLE `codem_banking_incomings` DISABLE KEYS */;
INSERT IGNORE INTO `codem_banking_incomings` (`id`, `citizenid`, `incoming`) VALUES
	(3, 'char1:299055de10756b9de64a546e74309416fc77059f', 100);
/*!40000 ALTER TABLE `codem_banking_incomings` ENABLE KEYS */;

-- Dumping structure for table es_extended.codem_banking_spendedmoney
CREATE TABLE IF NOT EXISTS `codem_banking_spendedmoney` (
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` varchar(50) DEFAULT NULL,
  `date` longtext DEFAULT NULL,
  `formattedDate` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table es_extended.codem_banking_spendedmoney: ~1 rows (approximately)
/*!40000 ALTER TABLE `codem_banking_spendedmoney` DISABLE KEYS */;
INSERT IGNORE INTO `codem_banking_spendedmoney` (`citizenid`, `amount`, `date`, `formattedDate`) VALUES
	('char1:299055de10756b9de64a546e74309416fc77059f', '4100', '{"month":8,"isdst":true,"min":33,"year":2021,"hour":22,"sec":34,"wday":4,"yday":216,"day":4}', '4/8/2021');
/*!40000 ALTER TABLE `codem_banking_spendedmoney` ENABLE KEYS */;

-- Dumping structure for table es_extended.codem_billing_history
CREATE TABLE IF NOT EXISTS `codem_billing_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` longtext DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table es_extended.codem_billing_history: ~1 rows (approximately)
/*!40000 ALTER TABLE `codem_billing_history` DISABLE KEYS */;
INSERT IGNORE INTO `codem_billing_history` (`id`, `label`, `citizenid`, `amount`) VALUES
	(38, 'Lucid Test', 'char1:299055de10756b9de64a546e74309416fc77059f', 123);
/*!40000 ALTER TABLE `codem_billing_history` ENABLE KEYS */;

-- Dumping structure for table es_extended.codem_transaction_history
CREATE TABLE IF NOT EXISTS `codem_transaction_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `label` longtext NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table es_extended.codem_transaction_history: ~22 rows (approximately)
/*!40000 ALTER TABLE `codem_transaction_history` DISABLE KEYS */;
INSERT IGNORE INTO `codem_transaction_history` (`id`, `citizenid`, `label`, `type`) VALUES
	(73, 'char1:5614ea91cb077724a85de8b1751965b82ab04566', 'Received $178 from Lucid Test', 'incoming'),
	(74, 'char1:5614ea91cb077724a85de8b1751965b82ab04566', 'Received $178 from Lucid Test', 'incoming'),
	(75, 'char1:5614ea91cb077724a85de8b1751965b82ab04566', 'Received $178 from Lucid Test', 'incoming'),
	(76, 'char1:5614ea91cb077724a85de8b1751965b82ab04566', 'Received $178 from Lucid Test', 'incoming'),
	(77, 'char1:5614ea91cb077724a85de8b1751965b82ab04566', 'Received $100 from Lucid Test', 'incoming'),
	(78, 'char1:5ce1d4ccb72f4a65a8560fc1fe1df2667fc88e35', 'Received $100 from Lucid Test', 'incoming'),
	(79, 'char1:5614ea91cb077724a85de8b1751965b82ab04566', 'Received $300 from Lucid Test', 'incoming'),
	(80, 'char1:5614ea91cb077724a85de8b1751965b82ab04566', 'Received $2000 from Lucid Test', 'incoming'),
	(81, 'char1:922f092fc125773b2d7fbad9e7c5bab7ad8530ea', 'Received $100 from Lucid Test', 'incoming'),
	(82, 'char1:922f092fc125773b2d7fbad9e7c5bab7ad8530ea', 'Received $100 from Lucid Test', 'incoming'),
	(83, 'char1:922f092fc125773b2d7fbad9e7c5bab7ad8530ea', 'Received $100 from Lucid Test', 'incoming'),
	(84, 'char1:299055de10756b9de64a546e74309416fc77059f', 'Transferred $100 to Milos Kostic', 'outgoing'),
	(85, 'char1:299055de10756b9de64a546e74309416fc77059f', 'Transferred $100 to Sg RF', 'outgoing'),
	(86, 'char1:299055de10756b9de64a546e74309416fc77059f', 'Transferred $300 to Milos Kostic', 'outgoing'),
	(87, 'char1:299055de10756b9de64a546e74309416fc77059f', 'Transferred $2000 to Milos Kostic', 'outgoing'),
	(88, 'char1:299055de10756b9de64a546e74309416fc77059f', 'Transferred $100 to Neo Dioz', 'outgoing'),
	(89, 'char1:299055de10756b9de64a546e74309416fc77059f', 'Transferred $100 to Neo Dioz', 'outgoing'),
	(90, 'char1:299055de10756b9de64a546e74309416fc77059f', 'Transferred $100 to Neo Dioz', 'outgoing'),
	(91, 'char1:5614ea91cb077724a85de8b1751965b82ab04566', 'Received $100 from Lucid Test', 'incoming'),
	(92, 'char1:5614ea91cb077724a85de8b1751965b82ab04566', 'Received $1000 from Lucid Test', 'incoming'),
	(93, 'char1:5ce1d4ccb72f4a65a8560fc1fe1df2667fc88e35', 'Received $1000 from Lucid Test', 'incoming'),
	(94, 'char1:299055de10756b9de64a546e74309416fc77059f', 'Transferred $1000 to Sg RF', 'outgoing');
/*!40000 ALTER TABLE `codem_transaction_history` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
