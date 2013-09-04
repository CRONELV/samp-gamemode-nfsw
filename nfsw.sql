/*
Navicat MySQL Data Transfer

Source Server         : MySQL
Source Server Version : 40122
Source Host           : localhost:3306
Source Database       : nfsw

Target Server Type    : MYSQL
Target Server Version : 40122
File Encoding         : 65001

Date: 2013-09-04 22:13:43
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `drivers`
-- ----------------------------
DROP TABLE IF EXISTS `drivers`;
CREATE TABLE `drivers` (
  `drivername` varchar(32) NOT NULL default '',
  `money` int(11) NOT NULL default '150000',
  `vehiclesnum` smallint(1) NOT NULL default '0',
  `vehmodels` varchar(32) default NULL,
  `exp` int(11) default '0',
  `level` int(11) default '1',
  `actvehnum` smallint(1) default '0',
  `vehparams1` varchar(128) default '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|-1',
  `vehparams2` varchar(128) default '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|-1',
  `vehparams3` varchar(128) default '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|-1',
  `treasparams` varchar(16) default '1|0|0',
  `lastlogin` date default '0000-00-00',
  `bonuses` varchar(32) default '50|50|50',
  PRIMARY KEY  (`drivername`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of drivers
-- ----------------------------

-- ----------------------------
-- Table structure for `emails`
-- ----------------------------
DROP TABLE IF EXISTS `emails`;
CREATE TABLE `emails` (
  `email` varchar(128) NOT NULL default '',
  `password` varchar(128) NOT NULL default '',
  `driversnum` int(11) NOT NULL default '0',
  `drivers` varchar(128) NOT NULL default '',
  `used` smallint(5) NOT NULL default '1',
  PRIMARY KEY  (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of emails
-- ----------------------------
