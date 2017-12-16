-- MySQL dump 10.13  Distrib 5.5.41, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: btcverkauf
-- ------------------------------------------------------
-- Server version       5.5.41-0+wheezy1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `btcverkauf`
--

DROP TABLE IF EXISTS `btcverkauf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `btcverkauf` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `btcverkauf`
--

LOCK TABLES `btcverkauf` WRITE;
/*!40000 ALTER TABLE `btcverkauf` DISABLE KEYS */;
INSERT INTO `btcverkauf` VALUES ('btn20841442176395','err',100,0.322581,'15XcVbydCq8WGGqwjgcvbbZxu6bRuStYLn',22534006,253714,'EUR',427698),('btn19471442054609','err',20,0.064516,'16jbVDuASvFQXsDaJxY96PEmCzt6RpgAbQ',22532103,720269,'EUR',397738);
/*!40000 ALTER TABLE `btcverkauf` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-10-15 18:16:36
