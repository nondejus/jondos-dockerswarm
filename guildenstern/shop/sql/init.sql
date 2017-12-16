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

CREATE DATABASE IF NOT EXISTS testcoupons;
USE testcoupons;

