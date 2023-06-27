-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2023-06-27 11:05:24
-- 伺服器版本： 10.4.24-MariaDB
-- PHP 版本： 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `health_manage`
--

-- --------------------------------------------------------

--
-- 資料表結構 `bmi`
--

CREATE TABLE `bmi` (
  `bmi_ID` int(11) NOT NULL,
  `uID` int(11) NOT NULL,
  `users_bmi` float DEFAULT NULL,
  `bmi_state` enum('體重過輕','正常','體重過重','輕度肥胖','中度肥胖','重度肥胖') CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 傾印資料表的資料 `bmi`
--

INSERT INTO `bmi` (`bmi_ID`, `uID`, `users_bmi`, `bmi_state`) VALUES
(1, 1, 17.3, '體重過輕'),
(3, 3, 23.5, '正常');

-- --------------------------------------------------------

--
-- 資料表結構 `record`
--

CREATE TABLE `record` (
  `rID` int(11) NOT NULL,
  `uID` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  `tdee` double NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 傾印資料表的資料 `record`
--

INSERT INTO `record` (`rID`, `uID`, `height`, `weight`, `tdee`, `created_at`) VALUES
(2, 1, 170, 50, 1763.3, '2023-05-29'),
(3, 1, 173, 55, 2407.4, '2023-05-29');

-- --------------------------------------------------------

--
-- 資料表結構 `users`
--

CREATE TABLE `users` (
  `uID` int(11) NOT NULL,
  `account` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 傾印資料表的資料 `users`
--

INSERT INTO `users` (`uID`, `account`, `password`, `created_at`) VALUES
(1, 'user1', '$2y$10$tI.UnkUO6Fk1Oe/loSb84OePW7ibHtxrDNWjn6wB3bkZqiXUQLpGe', '2023-05-10 09:49:50'),
(3, 'user2', '$2y$10$33UXN5Kk5mtUq6mqHaLgROadJ099aoOl79.LZmlaub1qmLlE/mSKa', '2023-05-15 12:28:06');

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `bmi`
--
ALTER TABLE `bmi`
  ADD PRIMARY KEY (`bmi_ID`),
  ADD KEY `uID` (`uID`);

--
-- 資料表索引 `record`
--
ALTER TABLE `record`
  ADD PRIMARY KEY (`rID`),
  ADD KEY `uID` (`uID`);

--
-- 資料表索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`uID`),
  ADD UNIQUE KEY `account_unique` (`account`) USING HASH;

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `bmi`
--
ALTER TABLE `bmi`
  MODIFY `bmi_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `record`
--
ALTER TABLE `record`
  MODIFY `rID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `users`
--
ALTER TABLE `users`
  MODIFY `uID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `bmi`
--
ALTER TABLE `bmi`
  ADD CONSTRAINT `bmi_ibfk_1` FOREIGN KEY (`uID`) REFERENCES `users` (`uID`);

--
-- 資料表的限制式 `record`
--
ALTER TABLE `record`
  ADD CONSTRAINT `record_ibfk_1` FOREIGN KEY (`uID`) REFERENCES `users` (`uID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
