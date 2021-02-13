-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Feb 13, 2021 alle 19:53
-- Versione del server: 10.4.11-MariaDB
-- Versione PHP: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tuyathome`
--
CREATE DATABASE IF NOT EXISTS `tuyathome` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `tuyathome`;

-- --------------------------------------------------------

--
-- Struttura della tabella `devicedpoints`
--

CREATE TABLE IF NOT EXISTS `devicedpoints` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'auto index',
  `dName` char(80) DEFAULT NULL COMMENT 'fk from deviceinfos',
  `DPnumber` char(40) NOT NULL COMMENT 'Data Point ID (number)',
  `DPname` char(80) DEFAULT NULL COMMENT 'User data point name, or from smartlife app or from https://iot.tuya.com/cloud/appinfo/cappId/deviceList (info/detail) if available.',
  `DPtype` enum('boolean','enum','int','string','binary','see note') DEFAULT NULL COMMENT 'Used only if DPdecode not exist.\r\nDefault ''auto'' (i.e. number as INT).\r\nFrom device response.\r\nCompare also with https://iot.tuya.com/cloud/appinfo/cappId/deviceList (info/detail) if available. \r\n',
  `DPvalues` tinytext DEFAULT NULL COMMENT 'Free info, like:  A|B = one|two or range [1..255]',
  `DPdecode` char(40) DEFAULT NULL COMMENT 'from lookupudecode table. Keep it updated.',
  `DPcapability` enum('RO','WO','WW','RW','TRG','PUSH','UNK') DEFAULT 'RW' COMMENT 'WW: use SET:null as GET;\r\nTRG: none, only TRIGGER;\r\nPUSH: none, auto-send.\r\nDefault: RW',
  `DPnote01` tinytext DEFAULT NULL COMMENT 'free  comment, used in ''alldevices''',
  `DPnote02` tinytext DEFAULT NULL COMMENT 'free comment, used in ''alldevices''',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dName_2` (`dName`,`DPnumber`),
  KEY `dataformat` (`DPdecode`),
  KEY `dName` (`dName`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `deviceinfos`
--

CREATE TABLE IF NOT EXISTS `deviceinfos` (
  `dName` char(80) NOT NULL COMMENT 'UNIQUE device name.\r\nLimit: only the chars allowed in file names. Unhallowed chars are replaced by ''_''.',
  `model` char(80) DEFAULT NULL COMMENT 'The original model by manufacturer.',
  `picName` char(80) DEFAULT NULL COMMENT 'only name for image file, 300x300, jpeg, like\r\n''switch_ab02.jpg'', required.\r\nPredefined dir: ''./pics''\r\n',
  `tuyaType` char(80) DEFAULT NULL COMMENT 'The Tuya ''Product Type'' definition, from page: https://iot.tuya.com/cloud/appinfo/cappId/deviceList',
  `tuyaProductID` char(40) DEFAULT NULL COMMENT 'The Tuya ''Product ID'' definition, from page: https://iot.tuya.com/cloud/appinfo/cappId/deviceList.\r\n',
  `protocol` enum('WiFi','ZigBee','Bluethoot','mixed','other') DEFAULT 'WiFi' COMMENT 'Device communication protocol.\r\nDefault: WiFi',
  `power` enum('AC','BAT','USB','USB+BAT','AC+BAT','UPS') DEFAULT 'BAT' COMMENT 'Device power suppy.\r\nFor alarms: if NULL the device is not tested for alarms.',
  `capabilities` set('SET','GET','SCHEMA','MULTIPLE','NONE','ALL') DEFAULT 'ALL' COMMENT 'Global device capabilities: one or more from SET|GET|SCHEMA|MULTIPLE or ALL|NONE.\r\nDefault ALL.\r\nLimits device access.',
  `description` tinytext DEFAULT NULL COMMENT 'free descripion.\r\nOnly for documentation.',
  `note01` tinytext DEFAULT NULL COMMENT 'Free. Used in ''alldevices''.',
  `note02` tinytext DEFAULT NULL COMMENT 'Free. Used in ''alldevices''.',
  `sellerURL` tinytext DEFAULT NULL COMMENT 'References to one or more sellers.',
  `refURL` tinytext DEFAULT NULL COMMENT 'Original manufactured reference.',
  `infoURL` tinytext DEFAULT NULL COMMENT 'More technical references: user manuals, schemas, use example, etc.',
  `copynotice` char(80) NOT NULL DEFAULT '2021 your-email-here',
  PRIMARY KEY (`dName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `lookupdecode`
--

CREATE TABLE IF NOT EXISTS `lookupdecode` (
  `type` char(40) NOT NULL,
  PRIMARY KEY (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `lookupdecode`
--

INSERT INTO `lookupdecode` (`type`) VALUES
('ARRAY8INT'),
('BOOLEANONOFF'),
('BOOLEANOPENCLOSE'),
('BYTESMALLFLOAT'),
('ENUMONOFFHOLD'),
('NULL'),
('STRUCTARGETTEMP'),
('STRUCTCOLOUR'),
('STRUCTTIMEHMS');

-- --------------------------------------------------------

--
-- Struttura della tabella `odt_queries`
--

CREATE TABLE IF NOT EXISTS `odt_queries` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'key auto',
  `templateID` char(80) NOT NULL COMMENT 'template name',
  `block` char(40) DEFAULT NULL COMMENT 'only if block, name',
  `parent` char(40) DEFAULT NULL COMMENT 'only if nested block, name',
  `query` varchar(16000) NOT NULL COMMENT 'SQL query',
  PRIMARY KEY (`ID`),
  KEY `templateID` (`templateID`),
  KEY `block` (`block`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='fields and blocks queries definitions';

--
-- Dump dei dati per la tabella `odt_queries`
--

INSERT INTO `odt_queries` (`ID`, `templateID`, `block`, `parent`, `query`) VALUES
(1, 'deviceinfo', NULL, NULL, 'SELECT * FROM deviceinfos WHERE dName = \'#key1#\''),
(2, 'deviceinfo', NULL, NULL, 'SELECT CONCAT(\'pics/\',picname) AS \'img_device\', if( (LOWER(note01) LIKE \'%mirror%\') OR (LOWER(note02) LIKE \'%mirror%\') OR (LOWER(note01) LIKE \'%fake%\') OR (LOWER(note02) LIKE \'%fake%\'),\'User defined\',\'Known\') as \'Known\' FROM deviceinfos WHERE dName = \'#key1#\''),
(3, 'deviceinfo', 'dps', NULL, 'SELECT *, CONCAT(DPnote01, IF(ISNULL(DPnote02),\'\', CONCAT(\' \',DPnote02))) AS DPnotes FROM devicedpoints WHERE dName = \'#key1#\' ORDER BY DPnumber * 1, DPnumber');

-- --------------------------------------------------------

--
-- Struttura della tabella `odt_reports`
--

CREATE TABLE IF NOT EXISTS `odt_reports` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'index auto',
  `page` char(60) NOT NULL COMMENT 'the destination page ',
  `position` int(11) UNSIGNED NOT NULL COMMENT 'order index',
  `templateID` char(60) NOT NULL COMMENT 'the file name (.odt)',
  `show` varchar(500) DEFAULT NULL COMMENT 'php: returns true|false',
  `outmode` enum('send','save','send_save') NOT NULL DEFAULT 'send' COMMENT 'Document destination',
  `outfilepath` varchar(200) DEFAULT NULL COMMENT 'php: return file name',
  `shortName` char(250) DEFAULT NULL COMMENT 'php: return short name',
  `description` varchar(500) DEFAULT NULL COMMENT 'php: returns description (HTML)',
  `key1type` enum('hidden','HTML','list','radio','date','foreach') DEFAULT NULL COMMENT 'the key type',
  `key1name` char(60) DEFAULT NULL COMMENT 'the key name (HTML)',
  `key1value` varchar(2500) DEFAULT NULL COMMENT 'php|SELECT query',
  `key2type` enum('hidden','HTML','list','radio','date','foreach') DEFAULT NULL COMMENT 'the key type',
  `key2name` char(60) DEFAULT NULL COMMENT 'the key name (HTML)',
  `key2value` varchar(2500) DEFAULT NULL COMMENT 'php|SELECT query',
  `key3type` enum('hidden','HTML','list','radio','date') DEFAULT NULL COMMENT 'the key type',
  `key3name` char(60) DEFAULT NULL COMMENT 'the key name (HTML)',
  `key3value` varchar(2500) DEFAULT NULL COMMENT 'php|SELECT query',
  `key4type` enum('hidden','HTML','list','radio','date') DEFAULT NULL COMMENT 'the key type',
  `key4name` char(60) DEFAULT NULL COMMENT 'the key name (HTML)',
  `key4value` varchar(2500) DEFAULT NULL COMMENT 'php|SELECT query',
  `key5type` enum('hidden','HTML','list','radio','date') DEFAULT NULL COMMENT 'the key type',
  `key5name` char(60) DEFAULT NULL COMMENT 'php|SELECT query',
  `key5value` varchar(2500) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `templateID` (`templateID`),
  UNIQUE KEY `page` (`page`,`position`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='Definizione reports';

--
-- Dump dei dati per la tabella `odt_reports`
--

INSERT INTO `odt_reports` (`ID`, `page`, `position`, `templateID`, `show`, `outmode`, `outfilepath`, `shortName`, `description`, `key1type`, `key1name`, `key1value`, `key2type`, `key2name`, `key2value`, `key3type`, `key3name`, `key3value`, `key4type`, `key4name`, `key4value`, `key5type`, `key5name`, `key5value`) VALUES
(3, 'index_page', 1, 'deviceinfo', 'return true;', 'save', '\r\n\r\nreturn \"$baseDir/devicedata/device_$key1.odt\";', 'return \'device documentation\';', 'return \'An information page about the Tuya device. Use OpenOffice4 to export it as .pdf.\';', 'list', 'Tuya device', 'SELECT dName, dName FROM deviceinfos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `devicedpoints`
--
ALTER TABLE `devicedpoints`
  ADD CONSTRAINT `dataformat` FOREIGN KEY (`DPdecode`) REFERENCES `lookupdecode` (`type`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `datapointof` FOREIGN KEY (`dName`) REFERENCES `deviceinfos` (`dName`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
