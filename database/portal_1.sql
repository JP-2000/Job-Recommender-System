-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 30, 2022 at 11:49 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `portal`
--

-- --------------------------------------------------------

--
-- Table structure for table `edu`
--

CREATE TABLE `edu` (
  `edun` int(11) NOT NULL,
  `schname` varchar(35) NOT NULL,
  `per` float NOT NULL,
  `degree` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `edu`
--

INSERT INTO `edu` (`edun`, `schname`, `per`, `degree`) VALUES
(1, 'Birla', 90.5, 'BE'),
(2, 'sabu siddique', 70, 'BE'),
(3, 'Birla', 90.5, 'BE'),
(4, 'sabu siddique', 70, 'BE'),
(5, 'Birla', 90.5, 'BE'),
(6, 'sabu siddique', 70, 'BE');

-- --------------------------------------------------------

--
-- Table structure for table `exp`
--

CREATE TABLE `exp` (
  `expn` int(11) NOT NULL,
  `jobt` varchar(30) NOT NULL,
  `companyname` varchar(30) NOT NULL,
  `strtd` date NOT NULL,
  `endd` date NOT NULL,
  `jobdesc` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `exp`
--

INSERT INTO `exp` (`expn`, `jobt`, `companyname`, `strtd`, `endd`, `jobdesc`) VALUES
(1, 'sds', 'sdsdsd', '2021-02-15', '2023-06-17', 'dsdasddsaas'),
(2, 'JKsds', 'sdsdsdsss', '2018-02-20', '2023-06-14', 'ddsds'),
(3, 'sds', 'sdsdsd', '2021-02-15', '2023-06-17', 'dsdasddsaas'),
(4, 'sds', 'sdsdsd', '2021-02-15', '2023-06-17', 'dsdasddsaas'),
(5, 'JKsds', 'sdsdsdsss', '2018-02-20', '2023-06-14', 'ddsds');

-- --------------------------------------------------------

--
-- Table structure for table `lang`
--

CREATE TABLE `lang` (
  `langn` int(11) NOT NULL,
  `lang1` varchar(25) DEFAULT NULL,
  `lang2` varchar(25) DEFAULT NULL,
  `lang3` varchar(25) DEFAULT NULL,
  `lang4` varchar(25) DEFAULT NULL,
  `lang5` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `lang`
--

INSERT INTO `lang` (`langn`, `lang1`, `lang2`, `lang3`, `lang4`, `lang5`) VALUES
(1, 'marathi', 'japanese', 'korean', '0', '0'),
(2, 'marathi', 'japanese', 'korean', '0', '0');

-- --------------------------------------------------------

--
-- Table structure for table `profile`
--

CREATE TABLE `profile` (
  `prefloc` varchar(25) NOT NULL,
  `exp` float NOT NULL,
  `skilln` int(11) NOT NULL,
  `langn` int(11) NOT NULL,
  `edun` int(11) NOT NULL,
  `dob` varchar(20) NOT NULL,
  `linkedin` varchar(20) NOT NULL,
  `uid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `profile`
--

INSERT INTO `profile` (`prefloc`, `exp`, `skilln`, `langn`, `edun`, `dob`, `linkedin`, `uid`) VALUES
('mumbai', 7.66667, 1, 1, 1, '3/10/2000', 'dhdsads', 1),
('mumbai', 7.66667, 1, 1, 2, '3/10/2000', 'dhdsads', 1),
('mumbai', 7.66667, 1, 1, 1, '3/10/2000', 'dhdsads', 1),
('mumbai', 7.66667, 1, 1, 2, '3/10/2000', 'dhdsads', 1);

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `skill1` varchar(35) DEFAULT NULL,
  `skill2` varchar(35) DEFAULT NULL,
  `skill3` varchar(35) DEFAULT NULL,
  `skill4` varchar(35) DEFAULT NULL,
  `skill5` varchar(35) DEFAULT NULL,
  `skill6` varchar(35) DEFAULT NULL,
  `skill7` varchar(35) DEFAULT NULL,
  `skill8` varchar(35) DEFAULT NULL,
  `skill9` varchar(35) DEFAULT NULL,
  `skill10` varchar(35) DEFAULT NULL,
  `skilln` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`skill1`, `skill2`, `skill3`, `skill4`, `skill5`, `skill6`, `skill7`, `skill8`, `skill9`, `skill10`, `skilln`) VALUES
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 1),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 2),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 3),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 4),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 5),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 6),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 7),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 8),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 9),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 10),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 11),
('dart', 'stonks', 'phoenix', '0', '0', '0', '0', '0', '0', '0', 12);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `uname` varchar(35) NOT NULL,
  `pass` varchar(35) NOT NULL,
  `fname` varchar(50) NOT NULL,
  `email` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `uname`, `pass`, `fname`, `email`) VALUES
(1, 'sutar', '1234', 'Shriyash Sutar', 'sutar@gmail.com'),
(4, 'apm', 'sdsaa', 'djscc   sdbsa  asjcsasj', 'sasd'),
(5, 'Patel', '1234', 'Patel Jitendra', 'ndsdssdbbscdc');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `edu`
--
ALTER TABLE `edu`
  ADD PRIMARY KEY (`edun`);

--
-- Indexes for table `exp`
--
ALTER TABLE `exp`
  ADD PRIMARY KEY (`expn`);

--
-- Indexes for table `lang`
--
ALTER TABLE `lang`
  ADD PRIMARY KEY (`langn`);

--
-- Indexes for table `profile`
--
ALTER TABLE `profile`
  ADD KEY `skilln` (`skilln`),
  ADD KEY `langn` (`langn`),
  ADD KEY `edun` (`edun`),
  ADD KEY `uid` (`uid`);

--
-- Indexes for table `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`skilln`),
  ADD KEY `skill2` (`skill2`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uname` (`uname`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `edu`
--
ALTER TABLE `edu`
  MODIFY `edun` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `exp`
--
ALTER TABLE `exp`
  MODIFY `expn` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `lang`
--
ALTER TABLE `lang`
  MODIFY `langn` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `skills`
--
ALTER TABLE `skills`
  MODIFY `skilln` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `profile`
--
ALTER TABLE `profile`
  ADD CONSTRAINT `profile_ibfk_1` FOREIGN KEY (`skilln`) REFERENCES `skills` (`skilln`),
  ADD CONSTRAINT `profile_ibfk_2` FOREIGN KEY (`langn`) REFERENCES `lang` (`langn`),
  ADD CONSTRAINT `profile_ibfk_3` FOREIGN KEY (`edun`) REFERENCES `edu` (`edun`),
  ADD CONSTRAINT `profile_ibfk_4` FOREIGN KEY (`uid`) REFERENCES `user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
