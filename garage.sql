CREATE TABLE IF NOT EXISTS `vehicle_garage` (
  `identifier` varchar(46) NOT NULL,
  `label` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `garage` varchar(50) NOT NULL,
  `glabel` varchar(50) DEFAULT NULL,
  `props` varchar(2550) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

