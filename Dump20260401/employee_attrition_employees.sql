-- MySQL dump 10.13  Distrib 8.0.38, for macos14 (arm64)
--
-- Host: 127.0.0.1    Database: employee_attrition
-- ------------------------------------------------------
-- Server version	9.0.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Age` int NOT NULL,
  `BusinessTravel` varchar(50) NOT NULL,
  `Department` varchar(50) NOT NULL,
  `DistanceFromHome` int NOT NULL,
  `Education` int NOT NULL,
  `Gender` varchar(10) NOT NULL,
  `JobRole` varchar(50) NOT NULL,
  `MaritalStatus` varchar(20) NOT NULL,
  `MonthlyIncome` int NOT NULL,
  `YearsAtCompany` int NOT NULL,
  `prediction` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,21,'Travel_Rarely','Sales',122,1,'Male','Manager','Single',12,12,0),(2,12,'Travel_Rarely','Sales',122,1,'Male','Manager','Single',12,12,0),(3,25,'Travel_Frequently','Research & Development',5,4,'Male','Manager','Married',200000,4,0),(4,25,'Travel_Frequently','Research & Development',5,4,'Male','Manager','Married',40000,10,0),(5,21,'Travel_Rarely','Sales',50,4,'Male','Manager','Single',10000,5,0),(6,23,'Travel_Frequently','Sales',25,3,'Male','Sales Executive','Single',35000,1,1),(7,21,'Travel_Rarely','Sales',212,1,'Male','Manager','Single',12,12,0),(8,12,'Travel_Rarely','Sales',122,1,'Male','Manager','Single',12,122,0),(9,33,'Travel_Rarely','Sales',30,1,'Male','Manager','Single',40000,2,0),(10,24,'Travel_Rarely','Research & Development',4,3,'Male','Manager','Married',75000,6,0),(11,23,'Travel_Frequently','Sales',15,3,'Male','Sales Executive','Single',35000,2,0),(12,25,'Travel_Frequently','Sales',60,3,'Male','Sales Executive','Single',35000,1,1),(13,23,'Travel_Rarely','Sales',50,3,'Male','Sales Executive','Single',50000,1,1),(14,45,'Travel_Rarely','Sales',7,1,'Male','Manager','Divorced',90000,12,0),(15,24,'Travel_Frequently','Sales',5,3,'Male','Manager','Divorced',35000,1,0),(16,24,'Travel_Frequently','Sales',5,3,'Male','Sales Executive','Divorced',35000,1,0),(17,32,'Travel_Frequently','Sales',8,3,'Male','Sales Executive','Divorced',39000,1,0),(18,42,'Travel_Rarely','Sales',23,1,'Male','Manager','Single',40000,9,0),(19,13,'Travel_Rarely','Sales',45,1,'Male','Manager','Single',12000,4,1),(20,47,'Travel_Rarely','Sales',22,1,'Male','Developer','Single',210000,9,0),(21,34,'Travel_Rarely','Sales',22,4,'Male','Developer','Single',300000,12,0),(22,28,'Travel_Frequently','Research & Development',-1,5,'Female','Developer','Single',160000,2,1),(23,25,'Travel_Frequently','Human Resources',35,4,'Male','Developer','Single',60000,3,1),(24,20,'Travel_Rarely','Sales',40,2,'Male','Manager','Single',30000,5,1),(25,21,'Travel_Rarely','Sales',50,1,'Male','Manager','Single',90000,2,1),(26,32,'Travel_Frequently','Sales',10,3,'Female','Developer','Married',56000,6,0),(27,37,'Travel_Rarely','Research & Development',15,5,'Male','Manager','Married',120000,3,0),(28,36,'Non-Travel','Research & Development',1700,5,'Male','Developer','Married',100000,3,1);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-01 11:47:45
