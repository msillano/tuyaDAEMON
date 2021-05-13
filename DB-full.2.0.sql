-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mag 13, 2021 alle 17:14
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

CREATE TABLE `devicedpoints` (
  `id` int(11) NOT NULL COMMENT 'auto index',
  `dName` char(80) DEFAULT NULL COMMENT 'fk from deviceinfos',
  `DPnumber` char(40) NOT NULL COMMENT 'Data Point ID (number)',
  `DPname` char(80) DEFAULT NULL COMMENT 'User data point name, or from smartlife app or from https://iot.tuya.com/cloud/appinfo/cappId/deviceList (info/detail) if available.',
  `DPtype` enum('boolean','enum','int','number','string','binary','see note') DEFAULT NULL COMMENT 'Used only if DPdecode not exist.\r\nDefault ''auto'' (i.e. number as INT).\r\nFrom device response.\r\nCompare also with https://iot.tuya.com/cloud/appinfo/cappId/deviceList (info/detail) if available. \r\n',
  `DPvalues` tinytext DEFAULT NULL COMMENT 'Free info, like:  A|B = one|two or range [1..255]',
  `DPdecode` char(40) DEFAULT NULL COMMENT 'from lookupudecode table. Keep it updated.',
  `DPcapability` enum('RO','WO','WW','GW','RW','TRG','PUSH','UNK') DEFAULT 'RW' COMMENT 'WW: SET + GET as SET:null\r\nGW: only GET as SET:null\r\nTRG: none, it is TRIGGER;\r\nPUSH: only proactive \r\nDefault: RW',
  `DPnote01` tinytext DEFAULT NULL COMMENT 'free  comment, used in ''alldevices''',
  `DPnote02` tinytext DEFAULT NULL COMMENT 'free comment, used in ''alldevices'''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `devicedpoints`
--

INSERT INTO `devicedpoints` (`id`, `dName`, `DPnumber`, `DPname`, `DPtype`, `DPvalues`, `DPdecode`, `DPcapability`, `DPnote01`, `DPnote02`) VALUES
(1, 'Smart_Switch01', '1', 'switch', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', 'Toggles when the countdown goes to 0; SET(102):0 =&#62; the switch does not change', NULL),
(2, 'Smart_Switch01', '102', 'countdown', 'int', '0..86500 s  (24H max.)', NULL, 'WW', 'PUSH every (30 * k) s; GET returns last PUSHed value, not the actual count', 'DPcapability for test: &#39;RW&#39;, for use: &#39;WW&#39;, as &#39;tuya_bridge&#39;:  &#39;TRG&#39;'),
(5, 'Smart_Switch01', '101', 'on reset', 'int', '0|1|2 = OFF|ON|HOLD', 'ENUMONOFFHOLD', 'WW', 'The initial switch status, after a reset.', NULL),
(34, 'LED_700ml_Humidifier', '1', 'spray', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'RW', NULL, NULL),
(35, 'LED_700ml_Humidifier', '2', 'output', 'string', '\'large\'|\'small\'', NULL, 'RW', 'Defined as boolean by Tuya, it works (GET,SET) with strings.', NULL),
(37, 'LED_700ml_Humidifier', '5', 'led', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'RW', 'When SET:ON it sends itself and default colour. ( FF00000000FFFF )', 'If led OFF, the colour is 00000000000000 and cannot be changed.'),
(38, 'LED_700ml_Humidifier', '6', 'led mode', 'string', '&#39;colour&#39;|&#39;colourful1&#39;', NULL, 'RW', 'In colourful1 mode, LED changes colour, but GET gives always FF00000000FFFF', NULL),
(41, 'LED_700ml_Humidifier', '8', 'colour', 'binary', 'RRGGBBHHHHSSVV = r,g,b [0..255], Hue [0..360], SS=VV=[0..0x64] (100%) ??', 'STRUCTCOLOUR', 'RW', 'JSON: {&#34;hex&#34;:&#34;RRGGBB0000FFFF&#34;} or {&#34;r&#34;:255, &#34;g&#34;:0,&#34; b&#34;:0, &#34;h&#34;:0, &#34;s&#34;:255, &#34;v&#34;:255}. The actual encoder accepts also {&#34;r&#34;:255, &#34;g&#34;:0, &#34;b&#34;:0}. ', 'Values h, v, s have no effect!? '),
(44, 'LED_700ml_Humidifier', '3', 'timer', 'string', '&#39;1&#39;|&#39;3&#39;|&#39;6&#39;|&#39;cancel&#39;', NULL, 'RW', 'In &#34;alldevices&#34;  type:string is mandatory, so  &#39;3&#39; do not becomes 3', NULL),
(50, 'TRV_Thermostatic_Radiator_Valve', '8', 'Open windows sensitivity', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WO', 'If ON ignores fast temperature down', NULL),
(51, 'TRV_Thermostatic_Radiator_Valve', '10', 'Antifreeze', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WO', 'Autostart:  5° ON, 8 °C OFF', NULL),
(52, 'TRV_Thermostatic_Radiator_Valve', '27', 'Actual T offset', 'int', '-6..+6 °C', NULL, 'WO', 'To compensate for the error in the actual T measurements', NULL),
(53, 'TRV_Thermostatic_Radiator_Valve', '40', 'Lock', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WO', 'Child lock', NULL),
(54, 'TRV_Thermostatic_Radiator_Valve', '101', 'Device', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WO', 'general ON|OFF', NULL),
(55, 'TRV_Thermostatic_Radiator_Valve', '102', 'Temperature', 'int', '50..300 = 5.0 .. 30.0 °C', 'BYTESMALLFLOAT', 'PUSH', 'Actual T', NULL),
(56, 'TRV_Thermostatic_Radiator_Valve', '103', 'Target T', 'int', '50..300 = 5.0..30.0 °C', 'BYTESMALLFLOAT', 'WO', 'Accepts increment of 0.1 (on smartlife app only 0.5)', NULL),
(57, 'TRV_Thermostatic_Radiator_Valve', '106', 'Away mode', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WO', 'Set target T to 16 °C', NULL),
(58, 'TRV_Thermostatic_Radiator_Valve', '110', 'Hist. day target T', 'binary', 'base64(Uint8Array[24]) =  [16,16,16,16,16,16,16,20,20,20,20,20,...', 'ARRAY8INT', 'PUSH', 'PUSHed  at HH:00', NULL),
(59, 'TRV_Thermostatic_Radiator_Valve', '112', 'Hist. week target T', 'binary', 'base64(Uint8Array[7]) =  [18,18,18,18,0,0,0]', 'ARRAY8INT', 'PUSH', NULL, NULL),
(60, 'TRV_Thermostatic_Radiator_Valve', '113', 'Hist. month target T', 'binary', 'base64(Uint8Array[31]) =  [18,18,18,18,18,18,18,18,18,18,18,18,18,18,18...', 'ARRAY8INT', 'PUSH', 'PUSHed ewery 4/5 days, at 00:00', NULL),
(61, 'TRV_Thermostatic_Radiator_Valve', '114', 'Hist. year target T', 'binary', 'base64(Uint8Array[12]) =  [18,18,18,18,0,0,0,0,0,0,0,0]', 'ARRAY8INT', 'PUSH', NULL, NULL),
(62, 'TRV_Thermostatic_Radiator_Valve', '115', 'Hist. day real T', 'binary', 'base64(Uint8Array[24]) = [15,14,14,14,13,13,16,18,19,0,0,0 ....', 'ARRAY8INT', 'PUSH', 'PUSHed  at HH:00', NULL),
(63, 'TRV_Thermostatic_Radiator_Valve', '116', 'Hist. week real T', 'binary', 'base64(Uint8Array[7]) = [17,18,17,18,18,0,0]', 'ARRAY8INT', 'PUSH', NULL, NULL),
(64, 'TRV_Thermostatic_Radiator_Valve', '117', 'Hist. month real T', 'binary', 'base64(Uint8Array[31]) =  [17,16,16,16,17,16,16,17,17,17,16,16,17,...', 'ARRAY8INT', 'PUSH', 'PUSHed ewery 4/5 days, at 00:00', NULL),
(65, 'TRV_Thermostatic_Radiator_Valve', '118', 'Hist. year real T', 'binary', 'base64(Uint8Array[12]) =  [17,18,18,18,0,0,0,0,0,0,0,0]', 'ARRAY8INT', 'PUSH', NULL, NULL),
(66, 'TRV_Thermostatic_Radiator_Valve', '119', 'Hist. day % power', 'binary', 'base64(Uint8Array[24]) =  [86,100,100,100,100,95,21,30,85,100,100,63,', 'ARRAY8INT', 'PUSH', 'PUSHed  at HH:00', 'If max &#38;#60; 100: redo \'rESE\' valve match.'),
(67, 'TRV_Thermostatic_Radiator_Valve', '120', 'Hist. week % power', 'binary', 'base64(Uint8Array[7]) = [80,83,79,0,0,0,0]', 'ARRAY8INT', 'PUSH', NULL, NULL),
(68, 'TRV_Thermostatic_Radiator_Valve', '121', 'Hist. month % power', 'binary', 'base64(Uint8Array[31]) = [78,71,85,88,76,80,79,76,78,85,90,82,78,67 ...', 'ARRAY8INT', 'PUSH', 'PUSHed ewery 4/5 days, at 00:00', NULL),
(69, 'TRV_Thermostatic_Radiator_Valve', '122', 'Hist. year % power', 'binary', 'base64(Uint8Array[12]) =  [68,72,0,0,0,0,0,0,0,0,0,0]', 'ARRAY8INT', 'PUSH', NULL, NULL),
(70, 'TRV_Thermostatic_Radiator_Valve', '123', 'Monday target T', 'binary', 'base64(Uint8Array[17])  = {\"count\":4,\"changes\":[{\"time\":\"06:00\",\"temp\":16},{\"time\":\"10:00\",\"temp\":21},{\"time\":\"13:00\",\"temp\":21},{\"time\":\"23:00\",\"temp\":16}]}', 'STRUCTARGETTEMP', 'PUSH', 'PUSHed  only on variations by smartlife app.', NULL),
(71, 'TRV_Thermostatic_Radiator_Valve', '124', 'Tuesday target T', 'binary', 'base64(Uint8Array[17])  = {\"count\":4,\"changes\":[{\"time\":\"06:00\",\"temp\":16},  ...', 'STRUCTARGETTEMP', 'PUSH', 'PUSHed  only on variations by smartlife app.', NULL),
(72, 'TRV_Thermostatic_Radiator_Valve', '125', 'Friday target T', 'binary', 'base64(Uint8Array[17])  = {\"count\":4,\"changes\":[{\"time\":\"06:00\",\"temp\":16},  ...', 'STRUCTARGETTEMP', 'PUSH', 'PUSHed  only on variations by smartlife app.', NULL),
(73, 'TRV_Thermostatic_Radiator_Valve', '126', 'Thursday target T', 'binary', 'base64(Uint8Array[17])  = {\"count\":4,\"changes\":[{\"time\":\"06:00\",\"temp\":16},  ...', 'STRUCTARGETTEMP', 'PUSH', 'PUSHed  only on variations by smartlife app.', NULL),
(74, 'TRV_Thermostatic_Radiator_Valve', '127', 'Friday target T', 'binary', 'base64(Uint8Array[17])  = {\"count\":4,\"changes\":[{\"time\":\"06:00\",\"temp\":16},  ...', 'STRUCTARGETTEMP', 'PUSH', 'PUSHed  only on variations by smartlife app.', NULL),
(75, 'TRV_Thermostatic_Radiator_Valve', '128', 'Saturday target T', 'binary', 'base64(Uint8Array[17])  = {\"count\":4,\"changes\":[{\"time\":\"06:00\",\"temp\":16},  ...', 'STRUCTARGETTEMP', 'PUSH', 'PUSHed  only on variations by smartlife app.', NULL),
(76, 'TRV_Thermostatic_Radiator_Valve', '129', 'Sunday target T', 'binary', 'base64(Uint8Array[17])  = {\"count\":4,\"changes\":[{\"time\":\"06:00\",\"temp\":16},  ...', 'STRUCTARGETTEMP', 'PUSH', 'PUSHed  only on variations by smartlife app.', NULL),
(77, 'TRV_Thermostatic_Radiator_Valve', '130', 'Water scale proof', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WO', 'Forces valve moves every two weeks', NULL),
(79, 'TRV_Thermostatic_Radiator_Valve', '108', 'Day program', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WO', 'If TRUE uses the daily T schedule, otherwise the target T is fixed ', NULL),
(81, 'TRV_Thermostatic_Radiator_Valve', '105', 'unknown01', NULL, '0?', NULL, 'PUSH', 'Found value 0 at 00:00 (rare: battery?)', NULL),
(85, 'TRV_Thermostatic_Radiator_Valve', '109', 'unknown02', NULL, 'unknown', NULL, 'WO', 'Unknown behavior: if SET, data as STRUCTARGETEMP, garbage in all day programs !?', NULL),
(86, 'Door_Sensor', '1030', 'status', 'boolean', 'true|false  = ON|OFF', 'BOOLEANOPENCLOSE', 'TRG', 'Automation  \'1030doorclosed\': if status.close, tuya_bridge.countdown:1030', 'Automation  \'1040dooropen\':   if status.open, tuya_bridge.countdown:1040'),
(87, 'PIR_motion', '1010', 'alarm', 'boolean', 'trigger 1010, 1020', NULL, 'TRG', 'Automation &#39;1010PIRoff&#39;: if status.open, tuya_bridge.countdown:1010', 'Automation &#39;1020PIRon&#39;: if status.close, tuya_bridge.countdown:1020'),
(88, 'Alarm_siren', '104', 'alarm', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(89, 'Alarm_siren', '102', 'type', 'string', '&#39;1&#39;..&#39;10&#39;', NULL, 'WW', 'Defines the sound (the use)', NULL),
(90, 'Alarm_siren', '103', 'duration', 'int', '0..60 s', NULL, 'WW', NULL, NULL),
(101, 'Temperature_Humidity_Sensor', '101', 'humidity', NULL, NULL, NULL, 'PUSH', NULL, NULL),
(106, 'Temperature_Humidity_Sensor', '103', 'temperature', NULL, NULL, NULL, 'PUSH', NULL, NULL),
(108, 'switch-4CH', '1', 'relay1', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(109, 'switch-4CH', '2', 'relay2', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(110, 'switch-4CH', '3', 'relay3', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(111, 'switch-4CH', '4', 'relay4', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(112, 'switch-4CH', '7', 'countdown1', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Countdown >= 0: PUSHed every sec. Count to 0, or SET 0: relay toggles. ', NULL),
(113, 'switch-4CH', '8', 'countdown2', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Countdown >= 0: PUSHed every sec. Count to 0, or SET 0: relay toggles.', NULL),
(114, 'switch-4CH', '9', 'countdown3', 'int', '0..86500 s  (24H max.)', NULL, 'WW', 'Countdown >= 0: PUSHed every sec. Count to 0, or SET 0: relay toggles.', NULL),
(115, 'switch-4CH', '10', 'countdown4', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Countdown >= 0: PUSHed every sec. Count to 0, or SET 0: relay toggles.', NULL),
(116, 'switch-4CH', '13', 'switch all', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(117, 'switch-4CH', '101', 'power-on status', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(118, 'switch-4CH', '102', 'mode', 'string', '&#39;selflock&#39;|&#39;inching&#39;|&#39;interlock&#39;', NULL, 'WW', '&#39;inching&#39; = momentary: time is &#39;dp&#39; 103', NULL),
(119, 'switch-4CH', '103', 'momentary time', 'int', '0...600 = 0...60.0 s', 'BYTESMALLFLOAT', 'WW', NULL, NULL),
(120, 'WiFi_IP_Camera', '106', 'sensibilità movimento', 'string', '&#39;0&#39;|&#39;1&#39;|&#39;2&#39; = LO|OK|HI', 'ENUMHIGHGOODLOW', 'WO', 'SET(null) don&#39;t works as GET', NULL),
(121, 'WiFi_IP_Camera', '134', 'rilevazione movimento', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WO', 'SET(null) don&#39;t works as GET', NULL),
(122, 'WiFi_IP_Camera', '110', 'mode', 'string', '5: format, 1: replay', NULL, 'PUSH', NULL, NULL),
(123, 'WiFi_IP_Camera', '103', 'upside down', 'boolean', 'true|false ', NULL, 'WO', 'SET(null) don&#39;t works as GET', NULL),
(124, 'WiFi_IP_Camera', '104', 'timestamp', 'boolean', 'true|false  ', NULL, 'WO', 'SET(null) don&#39;t works as GET', NULL),
(125, 'WiFi_IP_Camera', '109', 'SD status', 'string', 'all|used|free  (bytes)', 'SDSPACES', 'GW', 'only GET (as SET:null), no other SET.', NULL),
(126, 'WiFi_IP_Camera', '151', 'recording', 'string', '1|2 = continuous | events', 'RECMODE', 'WO', 'SET(null) don&#39;t works as GET', NULL),
(127, 'WiFi_IP_Camera', '111', 'start SD format', 'int', 'any ', NULL, 'WO', 'acts as a trigger', NULL),
(128, 'WiFi_IP_Camera', '117', 'SD format progress', 'int', '0...100 (%)', NULL, 'PUSH', NULL, NULL),
(129, 'switch-1CH', '1', 'relay', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', 'Toggles when the countdown goes to 0; SET(7):0 => the switch does not change', NULL),
(130, 'switch-1CH', '7', 'countdown', 'int', '0..86500 s  (24H max.)', NULL, 'WW', 'PUSH every (30 * k) s; GET returns last PUSHed value, not the actual count', 'DPcapability for test: &#39;RW&#39;, for use: &#39;WW&#39;, as &#39;tuya_bridge&#39;: &#39;TRG&#39;'),
(131, 'switch-1CH', '15', 'light mode', 'string', '&#39;pos&#39;|&#39;none&#39;|&#39;relay&#39;', NULL, 'WW', 'no HW: can be used as trigger', NULL),
(132, 'switch-1CH', '16', 'backlight', 'boolean', 'true|false ', NULL, 'WW', 'no HW: can be used as trigger', NULL),
(135, 'switch-1CH', '19', 'inching', 'binary', '{ inching: true|false delay: 0..3660} in sec', 'STRUCTINCH', 'WW', 'The inching (temporary) counter	SET:{} to clear	', NULL),
(136, 'switch-1CH', '14', 'restart status', 'string', '&#39;off&#39;|&#39;on&#39;|&#39;memory&#39;', NULL, 'WW', 'The initial switch status, after a reset.', NULL),
(137, 'switch-1CH', '17', 'circulate', 'binary', 'array of {active: true|false, day:SMTWTFS|DLMMGVS, start HH:MM, end: HH:MM, on: HH:MM, off: HH:MM}', 'STRUCTREPEAT', 'WW', 'Undocumented tentative.', 'day: skip=&#39;-&#39;, do: any char. If day:&#39;-------&#39;, once. SET:[] to clear	'),
(138, 'switch-1CH', '18', 'random', NULL, 'array of {active: true|false, day:SMTWTFS|DLMMGVS, start HH:MM end: HH:MM}', 'STRUCTRAND', 'WW', 'Undocumented tentative.', 'day: skip=&#39;-&#39;, do: any char. If day:&#39;-------&#39;, once.. SET:[] to clear'),
(139, 'smart_breaker', '1', 'relay', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(140, 'smart_breaker', '9', 'countdown', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Relay toggles when count reaches 0. SET:0  no toggle.', 'PUSHed every 30 sec.'),
(141, 'smart_breaker', '38', 'restart status', 'string', 'off|on|memory', NULL, 'WW', NULL, NULL),
(142, 'smart_breaker', '40', 'light mode', 'string', 'pos|none|relay', NULL, 'WW', 'Led BLUE: as &#39;relay&#39; = OFF/ON, &#39;pos&#39; (position) inverted = ON/OFF, &#39;none&#39; = always OFF', NULL),
(143, 'smart_breaker', '41', 'child lock', 'boolean', 'true|false  = ON|OFF', 'BOOLEANONOFF', 'WW', 'in lock mode, the manual switch does not toggle the relay.', NULL),
(144, 'smart_breaker', '44', 'inching', 'binary', ' { inching: true|false delay: 0..3660} in sec', 'STRUCTINCH', 'WW', 'The inching (temporary) counter', 'SET:{} to clear'),
(145, 'smart_breaker', '42', 'circulate', 'binary', 'array of {active: true|false, day:SMTWTFS|DLMMGVS, start HH:MM,  end: HH:MM, on: HH:MM, off: HH:MM}', 'STRUCTREPEAT', 'WW', 'day: skip=&#39;-&#39;, do: any char. If day:&#39;-------&#39;, once.', 'SET:[] to clear'),
(146, 'smart_breaker', '43', 'random', 'binary', 'array of {active: true|false, day:SMTWTFS|DLMMGVS, start HH:MM  end: HH:MM}', 'STRUCTRAND', 'WW', 'day: skip=&#39;-&#39;, do: any char. If day:&#39;-------&#39;, once.', 'SET:[] to clear'),
(148, 'Smoke_Detector', '1800', 'alarm', 'string', '&#39;ON&#39;|&#39;OFF&#39;', NULL, 'PUSH', 'smoke1800: if alarm:on, &#39;tuya_bridge&#39;countdown:1800; ', 'smoke1810: if alarm:off, &#39;tuya_bridge&#39;countdown:1810; '),
(149, 'Smoke_Detector', '1820', 'battery', 'string', '&#39;OK&#39;|&#39;LOW&#39;', NULL, 'PUSH', 'smoke1820: if battery:low, &#39;tuya_bridge&#39;countdown:1820 (+ timer: 3:00H every day)', 'smoke1830A: if battery:medium, &#39;tuya_bridge&#39;countdown:1830 (+ timer: 3:00H every day); smoke1830B: if battery:good, &#39;tuya_bridge&#39;countdown:1830 (+ timer: 3:00H every day); '),
(150, 'Smoke_Detector', '1840', 'silence', 'string', ' &#39;ON&#39;|&#39;OFF&#39;', NULL, 'WO', 'smoke1840: if silence:on, &#39;tuya_bridge&#39;countdown:1840; smoke1850: if silence:off, &#39;tuya_bridge&#39;countdown:1850 ', 'smoke5800:if &#39;tuya_bridge&#39;countdown:5800,  &#39;tuya_bridge&#39;countdown:0+&#39;smoke&#39;silence:on   smoke5810:if &#39;tuya_bridge&#39;countdown:5810,  &#39;tuya_bridge&#39;countdown:0+&#39;smoke&#39;silence:off'),
(151, 'Alarm_siren', '101', 'battery', 'enum', '0..5 ?? = AC FULL|HIGHT |MEDIUM|LOW|BAD ??', NULL, 'GW', 'under investigation', NULL),
(152, 'PM_detector', '1', 'sendtime', 'int', '0..999 (s)', NULL, 'RW', 'PUSH period', NULL),
(153, 'PM_detector', '2', 'storetime', 'int', '0..999 (s)', NULL, 'RW', 'Store period, internal, auto', 'Set to have 4-5 values/hour'),
(154, 'PM_detector', '3', 'set clock', 'string', 'NULL |  &#39;21-03-02 20:57:24&#39; ', NULL, 'RW', 'If NULL, now() added by default', NULL),
(155, 'PM_detector', '4', 'dump data', NULL, 'any', NULL, 'WO', 'trigger (internal, auto)', 'Stored data are processed every hour to generate history.'),
(156, 'PM_detector', '5', 'startRT', 'enum', '1|0 = ON|OFF', 'ENUMONOFFHOLD', 'RW', 'Setting it to ON, the data is sent immediately.', NULL),
(157, 'PM_detector', '6', 'memory clear', NULL, 'any', NULL, 'WO', 'trigger (internal, auto) at 00:00', 'Stored data reset every 24H'),
(158, 'PM_detector', '80', 'WritePoints', 'int', 'number', NULL, 'RO', 'number of records stored ', NULL),
(160, 'PM_detector', '81', 'ReadPoint', 'int', NULL, NULL, 'PUSH', 'unknown (updated by 80)', NULL),
(161, 'PM_detector', '82', 'SendIternalFlag', 'int', NULL, NULL, 'PUSH', 'unknown (updated by 80)', NULL),
(162, 'PM_detector', '200', 'cpm1_0', 'int', 'µg/m³', NULL, 'PUSH', 'real time update', NULL),
(163, 'PM_detector', '201', 'cpm2_5', 'int', 'µg/m³', NULL, 'PUSH', 'real time update', NULL),
(164, 'PM_detector', '202', 'cpm10', 'int', 'µg/m³', NULL, 'PUSH', 'real time update', NULL),
(165, 'PM_detector', '203', 'apm1_0', 'int', 'µg/m³', NULL, 'PUSH', 'real time update', NULL),
(166, 'PM_detector', '204', 'apm2_5', 'int', 'µg/m³', NULL, 'PUSH', 'real time update', NULL),
(167, 'PM_detector', '205', 'apm10', 'int', 'µg/m³', NULL, 'PUSH', 'real time update', NULL),
(168, 'PM_detector', '206', 'aqi', 'int', 'Air Quality Index: 0..500', NULL, 'PUSH', 'real time update', NULL),
(169, 'PM_detector', '207', 'Temperature', 'string', 'tt.t  °C', NULL, 'PUSH', 'real time update', NULL),
(170, 'PM_detector', '208', 'RH', 'int', '0..100(%)', NULL, 'PUSH', 'real time update', NULL),
(171, 'PM_detector', '300', 'Hist. Day CPM1_0', 'string', 'JSONarray[24] =  [85,70,50,33,26,22,17,14,13,141,171,21,0,0,0...]', NULL, 'PUSH', NULL, NULL),
(172, 'PM_detector', '301', 'Hist. Day CPM2_5', 'string', 'JSONarray[24] =  [85,70,50,33,26,22,17,14,13,141,171,21,0,0,0...]', NULL, 'PUSH', NULL, NULL),
(173, 'PM_detector', '302', 'Hist. Day CPM10', 'string', 'JSONarray[24] =  [85,70,50,33,26,22,17,14,13,141,171,21,0,0,0...]', NULL, 'PUSH', NULL, NULL),
(174, 'PM_detector', '303', 'Hist. Day APM1_0', 'string', 'JSONarray[24] =  [85,70,50,33,26,22,17,14,13,141,171,21,0,0,0...]', NULL, 'PUSH', NULL, NULL),
(175, 'PM_detector', '304', 'Hist. Day APM2_5', 'string', 'JSONarray[24] =  [85,70,50,33,26,22,17,14,13,141,171,21,0,0,0...]', NULL, 'PUSH', NULL, NULL),
(176, 'PM_detector', '305', 'Hist. Day APM10', 'string', 'JSONarray[24] =  [85,70,50,33,26,22,17,14,13,141,171,21,0,0,0...]', NULL, 'PUSH', NULL, NULL),
(177, 'PM_detector', '306', 'Hist. Day AQI', 'string', 'JSONarray[24] = [69,63,55,33,24,19,15,13,12,114,134,19,0,0,...]', NULL, 'PUSH', NULL, NULL),
(178, 'PM_detector', '307', 'Hist. Day  Temp', 'string', 'JSONarray[24] = 	 [22.6,22.3,22.2,22.0,22.0,21.7,21.6,21.5,20.9,20.1,22.4,20.9,0,...]', NULL, 'PUSH', NULL, NULL),
(179, 'PM_detector', '308', 'Hist. Day RH', 'string', 'JSONarray[24] = [48.0,48.0,47.0,47.0,47.0,47.0,47.0,47.0,46.6,48.0,45.3,47.2,0,...],', NULL, 'PUSH', NULL, NULL),
(180, 'watering_sys', '42ans', NULL, 'binary', 'see dp 42', NULL, 'PUSH', 'pushed share message', 'internal use'),
(181, 'watering_sys', '1ans', NULL, 'string', 'see dp 1', NULL, 'PUSH', 'pushed share message', 'internal use'),
(182, 'watering_sys', '2ans', NULL, 'string', 'see dp 2', NULL, 'PUSH', 'pushed share message', 'internal use'),
(184, 'watering_sys', '4', 'adjust water', 'number', '0...100 (%)', NULL, 'RO', 'calculated by fuzzy controller once a day', NULL),
(185, 'watering_sys', '111', 'timer connected', 'boolean', 'true|false ', NULL, 'PUSH', NULL, '&#39;use&#39; info from &#39;smart_breaker&#39;,dp(_connected)'),
(186, 'watering_sys', '112', 'main connected', 'boolean', 'true|false', NULL, 'PUSH', NULL, '&#39;use&#39; info from &#39;smart_switch&#39;,dp(_connected)'),
(187, 'watering_sys', '6', 'reset', NULL, 'any', NULL, 'WO', 'trigger.', 'Initialize and restore saved programming data.'),
(188, 'watering_sys', '201', 'Temp', 'int', '-20... +50 °C', NULL, 'PUSH', 'External temperature for fuzzy controller ', '&#39;use&#39; info from &#39;external&#39; sensor,dp(103)'),
(189, 'watering_sys', '202', 'RH', 'int', '0..100 %', NULL, 'PUSH', 'External Relative Humidity for fuzzy controller', '&#39;use&#39; info from &#39;external&#39; sensor,dp(101)'),
(190, 'watering_sys', '3', 'toggle timer', NULL, 'any', NULL, 'WO', 'trigger, changes output temporally, until next programmed time', 'Implemented setting &#39;countdown&#39; = 1 '),
(191, 'watering_sys', '5', 'waterweek', 'int', '0.... ', NULL, 'RW', 'litres/week of water. With a slider the user defines the max value.', 'After do a STORE to save / RESTORE to delete the new value.'),
(192, 'LED_700ml_Humidifier', '4', 'unknow', NULL, 'pushed 0', NULL, 'UNK', NULL, NULL),
(193, 'watering_sys', '1', 'timer', 'string', 'ON|OFF', NULL, 'RW', 'temporally, until next programmed time.', ' Inheritance from &#39;smart_breaker&#39;,dp(1)'),
(194, 'watering_sys', '2', 'switch', 'string', 'ON|OFF', NULL, 'RW', 'when the &#39;switch&#39; is OFF, the &#39;timer&#39; is disconnected (no power)', ' inheritance from &#39;Smart_Switch01&#39;,dp(1)'),
(195, 'watering_sys', '42', 'circulate', 'binary', 'decoded: array of {active: true|false, day:SMTWTFS|DLMMGVS, start HH:MM, end: HH:MM, on: HH:MM, off: HH:MM}', NULL, 'RW', 'stored in the breaker: + water/week, + adjust + store-times, to get persistence.', 'Inheritance from &#39;smart_breaker&#39;,dp(42).  '),
(196, 'power_strip', '1', 'Switch1', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(197, 'power_strip', '2', 'Switch2', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(198, 'power_strip', '3', 'Switch3', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(199, 'power_strip', '4', 'Switch4', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(200, 'power_strip', '5', 'SwitchUSB', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(201, 'power_strip', '9', 'countdown1', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Relay toggles when count reaches 0. SET:0 no toggle.', 'PUSHed every 30 sec.'),
(202, 'power_strip', '10', 'countdown2', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Relay toggles when count reaches 0. SET:0  no toggle.', 'PUSHed every 30 sec.'),
(203, 'power_strip', '11', 'countdown3', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Relay toggles when count reaches 0. SET:0  no toggle.', 'PUSHed every 30 sec.'),
(204, 'power_strip', '12', 'countdown4', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Relay toggles when count reaches 0. SET:0  no toggle.', 'PUSHed every 30 sec.'),
(205, 'power_strip', '13', 'countdownUSB', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Toggles when count reaches 0. SET:0  no toggle.', 'PUSHed every 30 sec.'),
(212, 'watering_sys', '7', 'store', NULL, 'any', NULL, 'WO', 'trigger', 'Saves data from UI to the switch memory.'),
(213, 'watering_sys', '8', 'restore', NULL, 'any', NULL, 'WO', 'trigger', 'Restores data from the switch memory'),
(214, '_system', '_laststart', NULL, 'string', '&#39;2021-03-24 16:06:33&#39;', NULL, 'RO', 'PUSHed some seconds after the restart.', 'See also node start_DAEMON'),
(215, '_system', '_trgPing', NULL, NULL, 'GET:  object like: { count: 5, avg: 300, min: 220, max: 420}  SET: any', NULL, 'RW', 'Time for a tuya-trigger roundtrip. GET: returns last values (if any) from tuyastatus.', ' SET:  starts a new update.'),
(216, '_system', '_doTrigger', NULL, 'int', ' trigger value', NULL, 'WO', 'Help property to send a TRIGGER to tuya.', 'note: in code is wired the &#39;tuya_bridge&#39; countdown &#39;dp&#39;.'),
(217, '_system', '_Dbase', NULL, 'boolean', 'true|false', NULL, 'RO', 'Signals when a DB is down. In CORE, from mysql nodes. ', 'See also node DB_ALARM. PUSHed at any change.'),
(218, '_system', '_ACpower', NULL, 'boolean', 'true|false ', NULL, 'RO', 'Signals when all AC devices are down. From tuya-smart-device-node.', ' See also node AC_ALARM. PUSHed at any change.'),
(219, '_system', '_WiFinet', NULL, NULL, 'true|false', NULL, 'RO', 'Signals when all WIFI devices are down. From tuya-smart-device-node.', 'See also node WiFi_ALARM. PUSHed at any change.'),
(220, '_system', '_ACunconnected', NULL, NULL, 'a list like:  [&#39;dev_name1&#39;, &#39;dev_name2&#39;...]', NULL, 'RO', 'List of all AC devices unconnected. From tuya-smart-device-node.', ' PUSHed at any change.'),
(221, '_system', '_WiFiunconnected', NULL, NULL, 'a list like: [&#39;dev_name1&#39;, &#39;dev_name2&#39;...]', NULL, 'RO', 'List of all WiFi devices unconnected. From tuya-smart-device-node. ', 'PUSHed at any change.'),
(222, '_system', '_LANnet', NULL, 'boolean', 'true|false ', NULL, 'RO', 'Signals when the WEB access is down.', ' See also node LAN_ALARM. PUSHed at any change.'),
(223, '_system', '_proxy', NULL, NULL, 'std_msg: { (remote:&#39;name&#39;,) (device:&#39;name|pseudoDP|id&#39; (, property:&#39;name|dp&#39; (, value:&#39;any&#39;)))}', NULL, 'RW', 'SET: uses REST to connect a remote tuyaDAEMON.', 'GET: retuns last response from &#39;remote&#39;, in global.alldevices.&#60;system>.&#60;proxy>'),
(224, '_system', '_name', NULL, 'string', 'any', NULL, 'RO', 'GET: returns the name of actual instance of tuyaDAEMON ', 'same as global.remotemap.itself'),
(226, '_system', '_timerON', NULL, NULL, '{(&#39;id&#39;: &#39;&#60;any>&#39;,)  &#39;timeout|datetime|time&#39;: &#60;atime>, &#39;alarmPayload&#39;: { &#39;share&#39;: [... ]  } }', NULL, 'WO', 'Set a new timer and the &#39;share&#39; actions associated.', 'see https://flows.nodered.org/node/node-red-contrib-jsontimer  and https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMOM-global.alldevices#share-actions'),
(227, '_system', '_timerOFF', NULL, 'string', 'the timer &#39;id&#39;', NULL, 'WO', 'To delete a timer. The &#39;id&#39; is mandatory.', 'see https://flows.nodered.org/node/node-red-contrib-jsontimer for more info'),
(228, '_system', '_timerList', NULL, NULL, '[{id:&#60;any>, datetime: N, dateTimeStr: &#39;xxx&#39;, alarmPayload: {&#60;share>}},..]', NULL, 'RO', 'GET a list of all active timers.', 'see https://flows.nodered.org/node/node-red-contrib-jsontimer for more info'),
(229, '_system', '_toLowIN', NULL, NULL, '{&#39;toDev&#39;:&#60;deviceID>, &#39;payload&#39;:{&#60;for the tya_smart_device>}}.', NULL, 'WO', 'To inject a msg to a real device, using the &#39;low_level_IN&#39; node', 'To test new features (in devices or connection node). see  core.&#39;low_level_IN&#39; node.description'),
(230, '_system', '_toFastIN', NULL, NULL, 'std_msg: { (remote:&#39;name&#39;,) (device:&#39;name|id&#39; (, property:&#39;name|dp&#39; (, value:&#39;any&#39;)))}', NULL, 'WO', 'To inject a msg to &#39;fast_cmds&#39; node.', 'Format: see  core.&#39;fast_cmds&#39; node.description'),
(231, '_system', '_toStdCmd', NULL, NULL, 'std_msg: { remote:&#39;name&#39;, device:&#39;name|id&#39;, property:&#39;name|dp&#39;, value:&#39;any&#39;}', NULL, 'WO', 'To inject a msg to &#39;std_cmd&#39; node.', 'Format: see  core.&#39;std_cmd&#39; node.description'),
(232, '_system', '_toShare', NULL, NULL, '{ &#39;share&#39;: [ {  &#39;test&#39;: [ &#39;&#60;test1>&#39;,..], &#39;action&#39;: [{  &#39;device&#39;: &#39;name|id&#39;,  &#39;property&#39;: &#39;name|id|@exp&#39;, &#39;value&#39;: &#39;any|@exp&#39; },... ]  },... ] }', NULL, 'WO', 'To inject a msg to &#39;share IN&#39; node.', 'see &#39;share&#39;: https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMOM-global.alldevices#share-actions'),
(233, '_system', '_tuyastatus', NULL, NULL, 'like a std_msg: { (&#39;device&#39;:&#60;name>, ( &#39;property&#39;:&#60;name>, (&#39;value&#39;:&#60;any>)))}', NULL, 'WO', 'Alternative access to global.tuyastatus (e.g. from remote).', ' Performs: LIST, if value:undef,  SCHEMA, if value.property:undef, GET, if .value.value: undef, else SET'),
(234, '_system', '_toLogging', NULL, NULL, 'like std. answer: &#39;payload&#39;:{ &#39;deviceId&#39;: &#60;id|gateway-id>,  &#39;data&#39;: {   (&#39;t&#39;: &#60;timestamp>,) (&#39;cid&#39;: &#60;cid>,)   &#39;dps&#39;:{ &#60;dp>:&#60;value>}}};', NULL, 'WO', 'To process a response: echo on Pad, DB and global.tuyastatus updated.', 'Format: see  core.&#39;logging&#39; node.description'),
(235, '_system', '_toDebug', NULL, NULL, '&#60;string> or {[&#60;string>,&#60;object>,...]}', NULL, 'WO', 'Sends the  value to debug pad.', NULL),
(236, '_system', '_toWarn', NULL, 'string', 'any', NULL, 'WO', 'Show in locale the value using node.warn().', NULL),
(237, 'ACmeter', '101', 'Energy', 'int', 'KWh *100', NULL, 'RO', 'This is a cumulative counter, it cannot be reset.', NULL),
(238, 'ACmeter', '18', 'current', 'int', 'mA', NULL, 'RO', 'PUSH time variable', 'GET returns last pushed value'),
(239, 'ACmeter', '19', 'power', 'int', 'W * 10', NULL, 'RO', 'PUSH time variable', 'GET returns last pushed value'),
(240, 'ACmeter', '20', 'voltage', 'int', 'V*10', NULL, 'RO', 'PUSH time variable', 'GET returns last pushed value'),
(241, 'ACmeter', '9', 'countdown', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Switch toggles when count reaches 0. SET:0  no toggle. Push every 1s.', 'GET acts like SCHEMA'),
(242, 'ACmeter', '1', 'switch', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WW', 'Without manual operation', 'GET acts like SCHEMA'),
(243, '_system', '_benchmark', NULL, NULL, 'a task:{ device, property (, value (,timeout)) }', NULL, 'RW', 'defines the task used in benckmarks.', ' defaults:  _system._zeroTask, timeout: 20000 ms'),
(244, '_system', '_doBenchmark', NULL, NULL, 'any', NULL, 'RW', 'trigger', NULL),
(245, '_system', '_benchmark_step', NULL, NULL, 'any', NULL, 'TRG', 'called via share by the task on benchmark', 'internal use, no log'),
(247, '_system', '_zeroTask', NULL, NULL, 'any', NULL, 'RW', 'Task for benchmark without log.', 'triggers the fastest fake task: it does nothing.'),
(248, '_system', '_zeroLog', NULL, NULL, 'any', NULL, 'RW', 'Task for benchmark with log.', 'Like zeroTask, but this updates debug pad, DB and tuyastatus.'),
(249, '_system', '_benchmark_end', NULL, NULL, 'any', NULL, 'RW', 'To terminate a running benchmark', 'trigger, usually auto, no log'),
(250, '_system', '_sqlDBlocal', NULL, 'string', 'sql', NULL, 'RW', 'SET: send to local DB a sql (value) and log the response', 'GET: get the last DB response'),
(251, '_system', '_sqlDBandroid', NULL, 'string', 'sql', NULL, 'RW', 'Like _sqlDBlocal: it is a custom addition, for the DB on ANDROID server', 'GET: get the last DB response'),
(252, '_system', '_doSCHEMA', NULL, 'string', 'device', NULL, 'RW', 'SET: simulates a SCHEMA request  GETting all DPs of a device, updates global.tuyastatus', 'GET: return the list of last PDs  updated.'),
(253, '_system', '_doUPDATE', NULL, NULL, 'any', NULL, 'RW', 'SET trigger: executes doSCHEMA for every local connected device, updates global.tuyastatus', 'GET: return the list of last update devices'),
(254, 'PM_detector', '_refresh', 'refresh', NULL, 'any', NULL, 'WO', 'trigger: send all data', 'implement standard pseudoDP &#39;_refresh&#39; '),
(255, 'PM_detector', '_refreshCycle', 'refresh cycle', 'int', '0..999 s', NULL, 'RW', 'implements the standard pseudoDP &#39;_refreshCycle&#39;', NULL),
(256, '_system', '_beep', NULL, NULL, 'any', NULL, 'WO', 'trigger: sends a short beep', NULL),
(257, '_system', '_play', NULL, 'see note', 'string|buffer', NULL, 'WO', 'string: text to spreach. Choose the voice in the &#39;play audio&#39; node', 'buffer WAV: play sound.'),
(258, '_system', '_exec', NULL, NULL, NULL, NULL, 'RW', 'to do O.S. task', 'Returns last output'),
(259, 'Wifi_Plug', '1', 'switch', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WW', NULL, NULL),
(260, 'Wifi_Plug', '18', 'current', 'int', 'mA', NULL, 'GW', NULL, NULL),
(261, 'Wifi_Plug', '19', 'power', 'int', 'W * 10', 'BYTESMALLFLOAT', 'GW', NULL, NULL),
(262, 'Wifi_Plug', '20', 'voltage', 'int', 'V*10', 'BYTESMALLFLOAT', 'GW', NULL, NULL),
(263, 'Wifi_Plug', '38', 'reset', 'string', '&#39;off&#39;|&#39;on&#39;|&#39;memory&#39;', NULL, 'WW', NULL, NULL),
(264, 'Wifi_Plug', '46', 'owercharge', 'boolean', 'true|false = ON|OFF', 'BOOLEANONOFF', 'WW', '!6A  protection', NULL),
(265, 'Wifi_Plug', '9', 'countdown', 'int', '0..86500 s (24H max.)', NULL, 'WW', 'Switch toggles when count reaches 0. SET:0  no toggle. ', 'PUSHed every 30*K sec., '),
(266, 'Wifi_Plug', '17', 'unknown17', NULL, NULL, NULL, 'WW', 'constant 3 ?', NULL),
(267, 'Wifi_Plug', '21', 'unknown21', NULL, NULL, NULL, 'GW', 'constant 1 ?', NULL),
(268, 'Wifi_Plug', '22', 'unknown22', NULL, NULL, NULL, 'GW', 'constant 627 ?', NULL),
(269, 'Wifi_Plug', '23', 'unknown23', NULL, NULL, NULL, 'GW', 'constant 29228 ?', NULL),
(270, 'Wifi_Plug', '24', 'unknown24', NULL, NULL, NULL, 'GW', 'constant 17033 ?', NULL),
(271, 'Wifi_Plug', '25', 'unknown25', NULL, NULL, NULL, 'GW', 'constant 2460 ?', NULL),
(272, 'Wifi_Plug', '26', 'unknown26', NULL, NULL, NULL, 'GW', 'constant 0 ?', NULL),
(273, 'Wifi_Plug', '41', 'circulate', 'binary', 'array of {active: true|false, day:SMTWTFS|DLMMGVS, start HH:MM, end: HH:MM, on: HH:MM, off: HH:MM}', 'STRUCTREPEAT', 'WW', 'day: skip=&#39;-&#39;, do: any char. If day:&#39;-------&#39;, once.', 'SET:[] to clear'),
(274, 'Wifi_Plug', '42', 'random', 'binary', 'array of {active: true|false, day:SMTWTFS|DLMMGVS, start HH:MM end: HH:MM}', 'STRUCTRAND', 'WW', 'array of {active: true|false, day:SMTWTFS|DLMMGVS, start HH:MM end: HH:MM}', 'SET:[] to clear'),
(275, 'Water_leak_sensor', '1150', 'leak alarm', 'boolean', 'triggers 1150, 1160', NULL, 'TRG', 'Automation &#39;1150Leakoff&#39;: if status.done, tuya_bridge.countdown:1150', 'Automation &#39;1160Leakon&#39;: if status.alarm, tuya_bridge.countdown:1160'),
(276, '_system', '_beep_loop', NULL, NULL, '{&#39;count&#39;: N , &#39;timeout&#39;: XXXX [ms]}', NULL, 'WO', 'trigger for a recursive  &#39;chain&#39; example.', 'see https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-as-event-processor#iteration');

-- --------------------------------------------------------

--
-- Struttura della tabella `deviceinfos`
--

CREATE TABLE `deviceinfos` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `deviceinfos`
--

INSERT INTO `deviceinfos` (`dName`, `model`, `picName`, `tuyaType`, `tuyaProductID`, `protocol`, `power`, `capabilities`, `description`, `note01`, `note02`, `sellerURL`, `refURL`, `infoURL`, `copynotice`) VALUES
('ACmeter', 'DDS238-2 WIFI', 'ACmeter.jpg', 'Socket', 'sw9asyjj8j44frjl', 'WiFi', 'AC', 'SET,GET,SCHEMA,REFRESH', 'Single Phase 65A Din Rail WIFI Smart Energy Meter', 'Sends total Energy, R.M.S current , voltage , active power', 'Real-time display of Voltage, Current, Active Power, reactive Power, power factor ,frequence, total Energy kWh', 'https://www.aliexpress.com/item/4000530641386.html', 'https://m.made-in-china.com/product/Dds238-2-WiFi-Single-Phase-DIN-Rail-Type-WiFi-Remote-Control-Energy-Meter-790065132.html', NULL, '2021 marco.sillano@gmail.com'),
('Alarm_siren', 'WKD-ALM01', 'Alarm_siren.jpg', 'Others', 'DYgId0sz6zWlmmYu', 'WiFi', 'AC+BAT', 'REFRESH,ALL', 'WiFi Smart alarm, sound alarm at the same time flashing, dazzling red light with alarm, full of power.', NULL, 'GET result like SCHEMA', 'https://www.aliexpress.com/item/1005001897410585.html', 'http://www.zsviot.com/pd.jsp?id=10', NULL, '2021 marco.sillano@gmail.com'),
('Door_Sensor', 'WKD-D01', 'Door_Sensor.jpg', 'Door/Window Controller', 'oSQljE9YDqwCwTUA', 'WiFi', 'BAT', 'NONE', 'Tuya Smart Home Door Window Contact Sensor WiFi App Notification Alerts Battery Operated', 'Mirror device: low power standby without MQTT, data PUSHed only by tuyaTRIGGER ', NULL, 'https://www.aliexpress.com/item/4001276833472.html', 'http://www.zsviot.com/pd.jsp?id=27', NULL, '2021 marco.sillano@gmail.com'),
('LED_700ml_Humidifier', '1201W', 'LED_700ml_Humidifier.jpg', 'Humidifier', 'c0nh3LmEk0NDebrq', 'WiFi', 'AC', 'ALL', 'WiFi Profession Desktop Square Mist Humidifier Led Light Humidifier Machine Diffuser Oil Humidifier', 'Any GET and SCHEMA  returns all 1,2,3,5,6,8 dp infos. User actions on buttons are sent.', 'Automatic shutdown if there is not enough water.', 'https://www.aliexpress.com/item/4000432962187.html', 'https://yymhealth.manufacturer.globalsources.com', NULL, '2021 marco.sillano@gmail.com'),
('PIR_motion', 'WDK-PR01', 'PIR_motion.jpg', 'Motion Detector', 'Okurono2XLVRV0fB', 'WiFi', 'BAT', 'NONE', 'Tuya Mini WIFI PIR Motion Sensor Human Body Sensor Wireless Infrared Detector built-in battery Hole-free installation ', 'Mirror device: low power standby without MQTT, data PUSHed only by tuyaTRIGGER	', NULL, 'https://www.aliexpress.com/item/4001000424566.html', 'http://www.zsviot.com/pd.jsp?id=48', NULL, '2021 marco.sillano@gmail.com'),
('PM_detector', '1615550', 'PM_detector.jpg', 'custom', 'HW USB device v. 2.0', 'mixed', 'USB', 'SET,GET,REFRESH', 'PM1.0 PM2.5 PM10 Detector Module Air Quality Dust Sensor,', 'Custom device, with extra code to be handled by tuyaDAEMON', ' USB-serial protocol, requires driver USB (CH340)', 'https://www.banggood.com/PM1_0-PM2_5-PM10-Detector-Module-Air-Quality-Dust-Sensor-Tester-Detector-Support-Export-Data-Monitoring-Home-Office-Car-Tools-p-1615550.html', 'https://www.geekcreit.com/', 'https://github.com/msillano/tuyaDAEMON/wiki/custom-device-%27PM-detector%27:-case-study', '2021 marco.sillano@gmail.com'),
('power_strip', 'MS1801214', 'power_strip.jpg', 'Socket', 'ahwernlcacvtwe3c', 'WiFi', 'AC', 'ALL', 'Power Strip EU Standard With 4 Plug and 4 USB Port', 'Any GET sends all data (1-5,9-13, like SCHEMA), SET:null works OK, so all dp &#39;WW&#39;', 'MULTIPLE  sends switch data only if status changed.', 'https://www.aliexpress.com/item/32921984017.html', 'http://www.mumubiz.com/pd.jsp?id=153#_pp=102_582,https://aileen188.en.ec21.com/EU_WiFi_Smart_Power_Socket--10639011_10639195.html', 'https://www.youtube.com/watch?v=denQwjMjD3I', '2021 marco.sillano@gmail.com'),
('smart_breaker', 'S3077', 'smart_breaker.jpg', 'Breaker', 'ily6yaiza2eytgnc', 'WiFi', 'AC', 'ALL', 'Good switch rich of features: circulate and random with week planning, countdown and inching.', 'Any GET sends all data (like SCHEMA), SET:null works OK, so all dp &#39;WW&#39;', NULL, 'https://www.aliexpress.com/item/1005001863612580.html', NULL, NULL, '2021 marco.sillano@gmail.com'),
('Smart_Switch01', 'MOES QS-WIFI-S03', 'Smart_Switch01.jpg', 'switch', '5vorxbbzvavwrrqs', 'WiFi', 'AC', 'SET,GET,MULTIPLE', 'Wifi Smart Light Switch, DIY Breaker Module Smart Life/Tuya APP Remote Control, Works with Alexa Echo Google Home, 1/2 Way', 'Can be used as tuya_bridge: set name &#39;tuya_bridge&#39;, dp 102 name &#39;reserved (trigger)&#39; and capability &#39;TRG&#39;', 'All dps: GET fires the &#34;json obj data unvalid&#34; warning, then sends a valid response: SET:null works better.', 'https://www.aliexpress.com/item/33012114855.html', 'https://www.moeshouse.com/collections/diy-smart-switch', 'https://lamiacasaelettrica.com/moes-interruttore-intelligente-smart-life/', '2021 marco.sillano@gmail.com'),
('Smoke_Detector', 'TYYG2', 'Smoke_Detector.jpg', 'Smoke detector', 'ljmfjahi9bbv2huq', 'WiFi', 'BAT', 'SET', 'Tuya WiFi Smoke Alarm Fire Protection Smoke Detector Smoke', 'Low power standby without MQTT. ', 'Mirror device: tuyaDAEMON uses TRIGGERs to exchange data with the real device.', 'https://www.aliexpress.com/item/4000990605711.html', 'https://ewelink.eachen.cc/product/eachen-wifi-strobe-smoke-detector-sensor-phone-call-app-push-alarm-compatible-with-tuya-smart-life/', NULL, '2021 marco.sillano@gmail.com'),
('switch-1CH', 'TYWR 7-32', 'switch-1CH.jpg', 'switch', 'hryktirnvgdua5cm', 'WiFi', 'USB', 'ALL', 'WIFI Wireless Smart Home Switch with RF433 Control', 'Any GET sends all data (like SCHEMA), SET:null works OK, so all dp &#39;WW&#39;', 'Can be used as tuya_bridge device', 'https://www.aliexpress.com/item/1005001292612142.html', NULL, 'https://developer.tuya.com/en/docs/iot/device-development/module/wifibt-dual-mode-module/wb-series-module/wb3sipex-module-datasheet', '2021 marco.sillano@gmail.com'),
('switch-4CH', NULL, 'switch-4CH.jpg', 'switch', 'waq2wj9pjadcg1qc', 'WiFi', 'USB', 'ALL', '4CH Tuya Switch WiFi Switch Module', 'Any GET sends all data (like SCHEMA), SET:null works OK, so all dp &#39;WW&#39;', 'To SET countdown to 0, toggles relay', 'https://www.aliexpress.com/item/4001268704361.html', NULL, 'https://developer.tuya.com/en/docs/iot/device-development/module/wifibt-dual-mode-module/wb-series-module/wb3sipex-module-datasheet', '2021 marco.sillano@gmail.com'),
('Temperature_Humidity_Sensor', 'WSDCGQ11LM', 'Temperature_Humidity_Sensor.jpg', 'Others', 'vtA4pDd6PLUZzXgZ', 'ZigBee', 'BAT', 'NONE', 'Monitors temperature, humidity, and atmospheric pressure in real time. No Wiring Required | Temperature and Humidity Notification | 2 Years Battery Life', 'For Mijia Homekit app. With smartLife pushes temperature, humidity  20&#39;-3h interval (no pressure)', 'Works only SET with last value received (?)', 'https://www.aliexpress.com/32977883360.html', 'https://www.aqara.com/us/temperature_humidity_sensor.html', NULL, '2021 marco.sillano@gmail.com'),
('TRV_Thermostatic_Radiator_Valve', 'SEA801-ZIGBEE', 'TRV_Thermostatic_Radiator_Valve.jpg', 'Thermostat', 'c88teujp', 'ZigBee', 'BAT', 'SET', 'SEA801 TRV Programmable Controller is a stylish and accurate TRV programmable controller has been designed for independent control heating radiators.', 'Chosen for front panel, having no side space: but never needed to look panel!', 'Few SET dp, PUSH actual temperature every 20-30 min, historical data for the graphs every h.', 'https://www.aliexpress.com/item/4000805305958.html', 'https://www.saswell.com/trv-programmable-controller-sea801_p101.html', 'https://www.zigbee2mqtt.io/devices/SEA801-Zigbee_SEA802-Zigbee.html', '2021 marco.sillano@gmail.com'),
('watering_sys', 'ver. 1.0', 'watering_sys.jpg', 'derived device', 'custom', 'WiFi', 'AC', 'SET,GET', 'Advanced watering controller, derived from standard Tuya switches', 'This fake derived device uses one  &#39;smart_breaker&#39;  and one Smart_Switch01. Days and time programming.', 'Fuzzy logic for PDM control using data shared from external sensors. ', NULL, NULL, 'https://github.com/msillano/tuyaDAEMON/wiki/derived-device-%27watering_sys%27:-case-study', '2021 marco.sillano@gmail.com'),
('Water_leak_sensor', 'TYWI01', 'Water_leak_sensor.jpg', 'Flooding Detector', 'tcox5unyj7n1oq1u', 'WiFi', 'BAT', 'NONE', 'When the Leak Alarm detects even a small water leak, it sounds a very loud alarm', 'Mirror device: low power standby without MQTT, data PUSHed only by tuyaTRIGGER', NULL, 'https://www.aliexpress.com/item/1005002512540956.html', 'http://chuangkesafe.com/en/product/p/tywi01.html', NULL, '2021 marco.sillano@gmail.com'),
('WiFi_IP_Camera', 'WKD-IPC02', 'WiFi_IP_Camera.jpg', 'Smart camera', 'ds0dztbnkfwlnhrk', 'mixed', 'USB', 'SET,GET,MULTIPLE', '&#39;The best choice for your guard home security&#39;', 'Uses WiFi for status control, and FTP for  sdcard access (unknown).', NULL, NULL, 'http://www.zsviot.com/pd.jsp?id=9', NULL, '2021 marco.sillano@gmail.com'),
('Wifi_Plug', 'LU-LSPA8-IT', 'Wifi_Plug.jpg', 'Socket', 'j0zozzoarutv0nu1', 'WiFi', 'AC', 'REFRESH,ALL', 'Smart Plug WiFi Socket + power energy meter', 'any GET acts like SCHEMA', 'REFRESH sends only changed DPs', 'https://www.aliexpress.com/item/1005001845795494.html', 'http://www.qdlucent.com/content/?604.html', NULL, '2021 marco.sillano@gmail.com'),
('_system', 'system 2.0', '_system.jpg', 'custom', 'SW only device', 'WiFi', 'BAT', 'SET,GET,SCHEMA', 'tuyaDAEMON  utilities and control', 'This is a fake software device, to extend and improve the capabilities of tuyaDAEMON', ' areas: security and alarms, performance, DB, timers, network', NULL, NULL, 'https://github.com/msillano/tuyaDAEMON/wiki/custom-device-_system', '2021 marco.sillano@gmail.com');

-- --------------------------------------------------------

--
-- Struttura della tabella `lookupdecode`
--

CREATE TABLE `lookupdecode` (
  `type` char(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `lookupdecode`
--

INSERT INTO `lookupdecode` (`type`) VALUES
(''),
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
('STRUCTINCH'),
('STRUCTRAND'),
('STRUCTREPEAT'),
('STRUCTTIMEHMS');

-- --------------------------------------------------------

--
-- Struttura della tabella `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `timestamp` datetime NOT NULL,
  `daemon` char(16) DEFAULT NULL,
  `action` char(8) DEFAULT NULL,
  `device-id` char(30) NOT NULL,
  `device-name` char(40) NOT NULL,
  `dps` char(40) NOT NULL,
  `dp-name` char(40) NOT NULL,
  `data` tinytext DEFAULT NULL,
  `value` tinytext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `odt_queries`
--

CREATE TABLE `odt_queries` (
  `ID` int(11) NOT NULL COMMENT 'key auto',
  `templateID` char(80) NOT NULL COMMENT 'template name',
  `block` char(40) DEFAULT NULL COMMENT 'only if block, name',
  `parent` char(40) DEFAULT NULL COMMENT 'only if nested block, name',
  `query` varchar(16000) NOT NULL COMMENT 'SQL query'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='fields and blocks queries definitions';

--
-- Dump dei dati per la tabella `odt_queries`
--

INSERT INTO `odt_queries` (`ID`, `templateID`, `block`, `parent`, `query`) VALUES
(1, 'deviceinfo', NULL, NULL, 'SELECT * FROM deviceinfos WHERE dName = \'#key1#\''),
(2, 'deviceinfo', NULL, NULL, 'SELECT CONCAT(\'pics/\',picname) AS \'img_device\', \r\nif( (LOWER(note01) LIKE \'%mirror%\') OR (LOWER(note02) LIKE \'%mirror%\') OR (LOWER(note01) LIKE \'%fake%\') OR (LOWER(note02) LIKE \'%fake%\')  OR (LOWER(note01) LIKE \'%custom%\') OR (LOWER(note02) LIKE \'%custom%\') ,\'User defined\',\'Known\') as \'Known\',\r\nif( (LOWER(note01) LIKE \'%mirror%\') OR (LOWER(note02) LIKE \'%mirror%\') OR (LOWER(note01) LIKE \'%fake%\') OR (LOWER(note02) LIKE \'%fake%\')  OR (LOWER(note01) LIKE \'%custom%\') OR (LOWER(note02) LIKE \'%custom%\') ,\'tuyaDAEMON\',\'Tuya\') as \'Tuya\'\r\n FROM deviceinfos WHERE dName = \'#key1#\''),
(3, 'deviceinfo', 'dps', NULL, 'SELECT *, CONCAT(DPnote01, IF(ISNULL(DPnote02),\'\', CONCAT(\' \',DPnote02))) AS DPnotes FROM devicedpoints WHERE dName = \'#key1#\' ORDER BY DPnumber * 1, DPnumber');

-- --------------------------------------------------------

--
-- Struttura della tabella `odt_reports`
--

CREATE TABLE `odt_reports` (
  `ID` int(11) NOT NULL COMMENT 'index auto',
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
  `key5value` varchar(2500) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Definizione reports';

--
-- Dump dei dati per la tabella `odt_reports`
--

INSERT INTO `odt_reports` (`ID`, `page`, `position`, `templateID`, `show`, `outmode`, `outfilepath`, `shortName`, `description`, `key1type`, `key1name`, `key1value`, `key2type`, `key2name`, `key2value`, `key3type`, `key3name`, `key3value`, `key4type`, `key4name`, `key4value`, `key5type`, `key5name`, `key5value`) VALUES
(3, 'index_page', 1, 'deviceinfo', 'return true;', 'save', '\r\n\r\nreturn \"$baseDir/devicedata/device_$key1.odt\";', 'return \'device documentation\';', 'return \'An information page about the Tuya device. Use OpenOffice4 to export it as .pdf.\';', 'list', 'Tuya device', 'SELECT dName, dName FROM deviceinfos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `devicedpoints`
--
ALTER TABLE `devicedpoints`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dName_2` (`dName`,`DPnumber`),
  ADD KEY `dataformat` (`DPdecode`),
  ADD KEY `dName` (`dName`) USING BTREE;

--
-- Indici per le tabelle `deviceinfos`
--
ALTER TABLE `deviceinfos`
  ADD PRIMARY KEY (`dName`);

--
-- Indici per le tabelle `lookupdecode`
--
ALTER TABLE `lookupdecode`
  ADD PRIMARY KEY (`type`) USING BTREE;

--
-- Indici per le tabelle `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `timestamp` (`timestamp`,`device-id`,`dps`) USING BTREE;

--
-- Indici per le tabelle `odt_queries`
--
ALTER TABLE `odt_queries`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `templateID` (`templateID`),
  ADD KEY `block` (`block`);

--
-- Indici per le tabelle `odt_reports`
--
ALTER TABLE `odt_reports`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `templateID` (`templateID`),
  ADD UNIQUE KEY `page` (`page`,`position`) USING BTREE;

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `devicedpoints`
--
ALTER TABLE `devicedpoints`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'auto index', AUTO_INCREMENT=277;

--
-- AUTO_INCREMENT per la tabella `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `odt_queries`
--
ALTER TABLE `odt_queries`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'key auto', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT per la tabella `odt_reports`
--
ALTER TABLE `odt_reports`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'index auto', AUTO_INCREMENT=4;

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
