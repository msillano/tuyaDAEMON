-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 26, 2023 at 08:22 AM
-- Server version: 10.11.2-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tuyathome`
--
CREATE DATABASE IF NOT EXISTS `tuyathome` DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci;
USE `tuyathome`;

-- --------------------------------------------------------

--
-- Table structure for table `devicedpoints`
--

CREATE TABLE IF NOT EXISTS `devicedpoints` (
  `id` int(11) NOT NULL COMMENT 'auto index',
  `dName` char(80) DEFAULT NULL COMMENT 'fk from deviceinfos',
  `DPnumber` char(40) NOT NULL COMMENT 'Data Point ID (number)',
  `DPname` char(80) DEFAULT NULL COMMENT 'User data point name, or from smartlife app or from https://iot.tuya.com/cloud/appinfo/cappId/deviceList (info/detail) if available.',
  `DPtype` enum('boolean','enum','int','number','string','binary','see note') DEFAULT NULL COMMENT 'Used only if DPdecode not exist.\r\nDefault ''auto'' (i.e. number as INT).\r\nFrom device response.\r\nCompare also with https://iot.tuya.com/cloud/appinfo/cappId/deviceList (info/detail) if available. \r\n',
  `DPvalues` tinytext DEFAULT NULL COMMENT 'Free info, like:  A|B = one|two or range [1..255]',
  `DPdecode` char(40) DEFAULT NULL COMMENT 'from lookupudecode table. Keep it updated.',
  `DPcapability` enum('RO','WO','WW','GW','RW','TRG','PUSH','SKIP','UNK') DEFAULT 'RW' COMMENT 'WW: SET + GET as SET:null\r\nGW: only GET as SET:null\r\nTRG: none, it is TRIGGER;\r\nPUSH: only proactive \r\nDefault: RW',
  `DPnote01` tinytext DEFAULT NULL COMMENT 'free  comment, used in ''alldevices''',
  `DPnote02` tinytext DEFAULT NULL COMMENT 'free comment, used in ''alldevices'''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deviceinfos`
--

CREATE TABLE IF NOT EXISTS `deviceinfos` (
  `dName` char(80) NOT NULL COMMENT 'UNIQUE device name.\r\nLimit: only the chars allowed in file names. Unhallowed chars are replaced by ''_''.',
  `model` char(80) DEFAULT NULL COMMENT 'The original model by manufacturer.',
  `picName` char(80) DEFAULT NULL COMMENT 'only name for image file, 300x300, jpeg, like\r\n''switch_ab02.jpg'', required.\r\nPredefined dir: ''./pics''\r\n',
  `tuyaType` char(80) DEFAULT NULL COMMENT 'The Tuya ''Product Type'' definition, from page: https://iot.tuya.com/cloud/appinfo/cappId/deviceList',
  `tuyaProductID` char(40) DEFAULT NULL COMMENT 'The Tuya ''Product ID'' definition, from page: https://iot.tuya.com/cloud/appinfo/cappId/deviceList.\r\n',
  `protocol` enum('WiFi','ZigBee','Bluethoot','mixed','other') DEFAULT 'WiFi' COMMENT 'Device communication protocol.\r\nDefault: WiFi',
  `power` enum('AC','BAT','USB','USB+BAT','AC+BAT','UPS') DEFAULT 'BAT' COMMENT 'Device power suppy.\r\nFor alarms: if NULL the device is not tested for alarms.',
  `capabilities` set('SET','GET','SCHEMA','REFRESH','MULTIPLE','NONE','ALL') DEFAULT 'ALL' COMMENT 'Global device capabilities: one or more from SET|GET|SCHEMA|MULTIPLE or ALL|NONE.\r\nDefault ALL.\r\nLimits device access.',
  `description` tinytext DEFAULT NULL COMMENT 'free descripion.\r\nOnly for documentation.',
  `note01` tinytext DEFAULT NULL COMMENT 'Free. Used in ''alldevices''.',
  `note02` tinytext DEFAULT NULL COMMENT 'Free. Used in ''alldevices''.',
  `sellerURL` tinytext DEFAULT NULL COMMENT 'References to one or more sellers.',
  `refURL` tinytext DEFAULT NULL COMMENT 'Original manufactured reference.',
  `infoURL` tinytext DEFAULT NULL COMMENT 'More technical references: user manuals, schemas, use example, etc.',
  `copynotice` char(80) NOT NULL DEFAULT '2021 marco.sillano@gmail.com'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lookupdecode`
--

CREATE TABLE IF NOT EXISTS `lookupdecode` (
  `type` char(40) NOT NULL COMMENT 'data encode/decode function'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `lookupdecode`
--

INSERT INTO `lookupdecode` (`type`) VALUES
('ARRAY8INT'),
('BOOLEANONOFF'),
('BOOLEANOPENCLOSE'),
('BYTESMALLFLOAT'),
('ENUMHIGHGOODLOW'),
('ENUMONOFFHOLD'),
('INTE2FLOAT'),
('NULL'),
('RECMODE'),
('SDSPACES'),
('STRUCTARGETTEMP'),
('STRUCTCOLOUR'),
('STRUCTELERT'),
('STRUCTINCH'),
('STRUCTRAND'),
('STRUCTREPEAT'),
('STRUCTTIMEHMS'),
('TSTAMP2TIME');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL,
  `daemon` char(16) DEFAULT NULL,
  `action` char(8) DEFAULT NULL,
  `device-id` char(30) NOT NULL,
  `device-name` char(40) NOT NULL,
  `dps` char(40) NOT NULL,
  `dp-name` char(40) NOT NULL,
  `data` text DEFAULT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22844 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
