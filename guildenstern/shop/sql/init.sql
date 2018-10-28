CREATE DATABASE IF NOT EXISTS btcverkauf;
USE btcverkauf;

CREATE TABLE IF NOT EXISTS `btcverkauf` (
  `mtid` varchar(20) NOT NULL DEFAULT '',
  `methode` varchar(3) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `btc` double DEFAULT NULL,
  `btaddress` varchar(40) DEFAULT NULL,
  `zeitstempel` int(11) DEFAULT NULL,
  `myid` int(11) DEFAULT NULL,
  `currency` varchar(5) DEFAULT NULL,
  `nokid` int(11) DEFAULT NULL,
  PRIMARY KEY (`mtid`),
  UNIQUE KEY `myid` (`myid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE DATABASE IF NOT EXISTS bitcoin;
USE bitcoin;

CREATE TABLE `paymentbt` (
  `address` varchar(40) NOT NULL DEFAULT '',
  `code` varchar(20) DEFAULT NULL,
  `preis` varchar(10) DEFAULT NULL,
  `tarif` varchar(20) DEFAULT NULL,
  `aktiv` int(11) DEFAULT NULL,
  `zeit` int(11) DEFAULT NULL,
  `promotion` int(11) DEFAULT NULL,
  PRIMARY KEY (`address`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `payments` (
  `address` varchar(30) NOT NULL DEFAULT '',
  `code` varchar(20) DEFAULT NULL,
  `preis` varchar(5) DEFAULT NULL,
  `tarif` varchar(10) DEFAULT NULL,
  `aktiv` int(11) DEFAULT NULL,
  PRIMARY KEY (`address`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `paymenttest` (
  `address` varchar(40) NOT NULL DEFAULT '',
  `code` varchar(20) DEFAULT NULL,
  `preis` varchar(10) DEFAULT NULL,
  `tarif` varchar(20) DEFAULT NULL,
  `aktiv` int(11) DEFAULT NULL,
  `zeit` int(11) DEFAULT NULL,
  `promotion` int(11) DEFAULT NULL,
  PRIMARY KEY (`address`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE DATABASE IF NOT EXISTS testcoupons;
USE testcoupons;

CREATE TABLE `addresses` (
  `emailsha` varchar(30) NOT NULL,
  `affinilate` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`emailsha`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `ausgabe` (
  `ausgabeid` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(30) DEFAULT NULL,
  `zeitstempel` int(11) DEFAULT NULL,
  PRIMARY KEY (`ausgabeid`),
  KEY `domainindex` (`domain`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

CREATE TABLE `coupons` (
  `couponcode` varchar(30) NOT NULL DEFAULT '',
  `benutzt` int(11) DEFAULT NULL,
  `zeit` int(11) DEFAULT NULL,
  PRIMARY KEY (`couponcode`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `replacelist` (
  `domainalt` varchar(40) NOT NULL DEFAULT '',
  `domainneu` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`domainalt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `verifications` (
  `verificationID` varchar(14) NOT NULL,
  `sendtime` int(11) DEFAULT NULL,
  `affinilate` varchar(10) DEFAULT NULL,
  `emailsha` varchar(30) NOT NULL,
  `coupon` varchar(30) DEFAULT NULL,
  `domain` varchar(30) DEFAULT NULL,
  `language` varchar(5) DEFAULT NULL,
  `ipprefix` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`verificationID`),
  KEY `sendtime` (`sendtime`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `waitlist` (
  `domain` varchar(30) NOT NULL DEFAULT '',
  `anzahl` int(11) DEFAULT NULL,
  PRIMARY KEY (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `whitelist` (
  `domain` varchar(30) NOT NULL DEFAULT '',
  `anzahl` int(11) DEFAULT NULL,
  `max24` int(11) DEFAULT NULL,
  `maxges` int(11) DEFAULT NULL,
  PRIMARY KEY (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
