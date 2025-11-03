-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Creato il: Nov 01, 2025 alle 10:07
-- Versione del server: 10.6.23-MariaDB-cll-lve-log
-- Versione PHP: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jmvvznbb_finanze_db`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `categorie_entrate`
--

CREATE TABLE `categorie_entrate` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descrizione` text DEFAULT NULL,
  `attiva` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `categorie_entrate`
--

INSERT INTO `categorie_entrate` (`id`, `nome`, `descrizione`, `attiva`, `created_at`) VALUES
(1, 'Quota d\'ingresso', 'Quota da pagare per l\'iniziazione', 1, '2025-06-04 16:00:29'),
(2, 'Capitazione', 'Quota annuale Associazione', 1, '2025-06-04 16:00:29'),
(3, 'Quota Passaggio di Grado', 'Quota da pagare al passaggio', 1, '2025-06-04 16:00:29'),
(4, 'Vendita Libri', 'Ricavi dalla vendita di libri', 1, '2025-06-04 16:00:29'),
(5, 'Donazioni', 'Donazioni ricevute', 1, '2025-06-04 16:00:29'),
(6, 'Eventi', 'Ricavi da eventi organizzati', 1, '2025-06-04 16:00:29'),
(7, 'Varie', 'Entrate varie non categorizzate', 1, '2025-06-04 16:00:29'),
(8, 'Cene Sociali', 'Importato da Excel', 1, '2025-06-04 16:49:24'),
(9, 'Vestiario', 'Importato da Excel', 1, '2025-06-04 16:49:24'),
(10, 'Sponsor', 'Importato da Excel', 1, '2025-06-04 16:49:24');

-- --------------------------------------------------------

--
-- Struttura della tabella `categorie_uscite`
--

CREATE TABLE `categorie_uscite` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descrizione` text DEFAULT NULL,
  `attiva` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `categorie_uscite`
--

INSERT INTO `categorie_uscite` (`id`, `nome`, `descrizione`, `attiva`, `created_at`) VALUES
(1, 'Arredi Tempio', 'Acquisti per l\'arredamento del tempio', 1, '2025-06-04 16:00:29'),
(2, 'Rituali', 'Materiali e oggetti per i rituali', 1, '2025-06-04 16:00:29'),
(3, 'Vestiario', 'Abbigliamento e accessori', 1, '2025-06-04 16:00:29'),
(4, 'Stampe', 'Materiali di stampa e pubblicazioni', 1, '2025-06-04 16:00:29'),
(5, 'Pulizia Casa', 'Prodotti e servizi per la pulizia', 1, '2025-06-04 16:00:29'),
(6, 'Costi associazione', 'Costi amministrativi dell\'associazione', 1, '2025-06-04 16:00:29'),
(7, 'Varie', 'Spese varie non categorizzate', 1, '2025-06-04 16:00:29'),
(8, 'Bollette', 'Utenze e bollette', 1, '2025-06-04 16:00:29'),
(9, 'Libri', 'Acquisto di libri e pubblicazioni', 1, '2025-06-04 16:00:29'),
(10, 'Alimentari', 'Importato da Excel', 1, '2025-06-04 16:49:24'),
(13, 'Agriturismo', '', 0, '2025-06-05 06:28:30'),
(14, 'Software', '', 1, '2025-10-01 08:33:36');

-- --------------------------------------------------------

--
-- Struttura della tabella `saldo_iniziale`
--

CREATE TABLE `saldo_iniziale` (
  `anno` int(11) NOT NULL,
  `saldo` decimal(10,2) NOT NULL DEFAULT 0.00,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `saldo_iniziale`
--

INSERT INTO `saldo_iniziale` (`anno`, `saldo`, `updated_at`) VALUES
(2025, 0.00, '2025-06-04 16:00:29');

-- --------------------------------------------------------

--
-- Struttura della tabella `transazioni`
--

CREATE TABLE `transazioni` (
  `id` int(11) NOT NULL,
  `data_transazione` date NOT NULL,
  `tipo` enum('entrata','uscita') NOT NULL,
  `importo` decimal(10,2) NOT NULL,
  `descrizione` text NOT NULL,
  `categoria_entrata_id` int(11) DEFAULT NULL,
  `categoria_uscita_id` int(11) DEFAULT NULL,
  `anno` int(11) GENERATED ALWAYS AS (year(`data_transazione`)) STORED,
  `mese` int(11) GENERATED ALWAYS AS (month(`data_transazione`)) STORED,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `transazioni`
--

INSERT INTO `transazioni` (`id`, `data_transazione`, `tipo`, `importo`, `descrizione`, `categoria_entrata_id`, `categoria_uscita_id`, `created_at`, `updated_at`, `created_by`) VALUES
(88, '2025-06-04', 'uscita', 26.44, 'Bolletta Gas del 15/05/25 n.2521604826', NULL, 8, '2025-06-04 16:53:47', '2025-06-06 16:23:34', 1),
(89, '2025-06-04', 'uscita', 74.33, 'Bolletta Luce del 10/05/25 n. 2520462676', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(90, '2025-05-31', 'uscita', 140.00, 'Libri \"Il Tempio di Pietra\"', NULL, 9, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(91, '2025-04-28', 'uscita', 100.00, 'Quota Federazione Logge San Giovanni', NULL, 6, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(92, '2025-04-21', 'uscita', 28.00, 'Petali per consacrazione coniugale', NULL, 1, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(93, '2025-04-16', 'uscita', 30.00, 'Candelabri', NULL, 1, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(94, '2025-04-14', 'entrata', 165.00, 'Libro AM Vinci,Eli,Luca,Gianc,Robe,Guiducci,Spampi,Cozz,Dario,Ale,Stefano,Leo', 4, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(95, '2025-04-08', 'entrata', 180.00, 'Libro Ant, Emi,Fra, Gabr, Rob, Luc,Pian,Sant,Lun,Gianc,Guiducci,Stefano', 4, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(96, '2025-04-07', 'entrata', 60.00, 'Libro Vinci, Spampinato, Alessio, Emiliano', 4, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(97, '2025-03-28', 'uscita', 50.00, 'Security al Mandoleto', NULL, 7, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(98, '2025-03-24', 'uscita', 91.00, 'Prolunga 50mt + calzari pioggia + pile microfoni', NULL, 1, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(99, '2025-03-22', 'uscita', 89.94, 'Stampa 30 copie il tempio di pietra doctaprint', NULL, 9, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(100, '2025-03-19', 'entrata', 50.00, 'Passaggio Compagno Cozzolino', 2, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(101, '2025-03-19', 'entrata', 400.00, 'Raccolta fondi per esclusiva ristorante', 3, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(102, '2025-03-19', 'uscita', 78.34, 'Bolletta Luce del 08/03/2025 n. 2512748103', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(103, '2025-03-19', 'uscita', 39.56, 'Bolletta Gas del 12/03/2025 n. 2513944667', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(104, '2025-03-18', 'uscita', 369.00, 'Acquisto 30 copie 2° Libro x la Loggia e per regali', NULL, 9, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(105, '2025-03-11', 'entrata', 130.00, 'Versamento da fondo cassa cene', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(106, '2025-03-11', 'uscita', 51.90, 'Bolletta gas del 08/02/25 n. 2508265825', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(107, '2025-03-11', 'uscita', 77.41, 'Bolletta luce del 08/02/25 n. 2508306251', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(108, '2025-03-03', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Marzo', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(109, '2025-03-03', 'uscita', 76.00, 'Spesa Cena Sociale 2 Marzo 2025', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(110, '2025-02-24', 'entrata', 50.00, 'Passaggio Compagno Barberi', 2, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(111, '2025-02-24', 'entrata', 50.00, 'Passaggio Compagno Spampinato', 2, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(112, '2025-02-24', 'entrata', 50.00, 'Passaggio Compagno Guiducci', 2, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(113, '2025-02-17', 'entrata', 50.00, 'Versamento Passaggio di Compagno Muscolino', 2, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(114, '2025-02-15', 'uscita', 39.50, 'Bolletta gas 12/01/25 n. 2502745836', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(115, '2025-02-15', 'uscita', 64.81, 'Bolletta luce 08/01/25 n. 2502786278', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(116, '2025-02-03', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Febbraio', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(117, '2025-02-01', 'uscita', 92.00, 'Spesa Cena Sociale 1° Febbraio 2025', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(118, '2025-01-27', 'entrata', 50.00, 'Versamento passaggio maestro Dario', 2, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(119, '2025-01-20', 'entrata', 80.00, 'Libro Alessio + libro Cozzolino', 4, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(120, '2025-01-20', 'uscita', 45.00, 'Spese di spedizione libro \"il tempio di pietra\"', NULL, 4, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(121, '2025-01-20', 'entrata', 40.00, 'Libro x Spampinato', 4, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(122, '2025-01-13', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Gennaio', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(123, '2025-01-11', 'uscita', 82.00, 'Spesa Cena Sociale 11 Gennaio 2025', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(124, '2025-01-08', 'uscita', 79.20, 'Bolletta luce del 08/12/24 n. 2451386252', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(125, '2025-01-08', 'uscita', 47.72, 'Bolletta gas del 08/12/24 n. 2451372748', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(126, '2024-12-22', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Dicembre', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(127, '2024-12-21', 'uscita', 89.00, 'Cena Sociale 21 Dicembre 2024', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(128, '2024-12-11', 'uscita', 69.34, 'Bolletta luce del 08/11/24 n. 2445730244', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(129, '2024-12-11', 'uscita', 35.83, 'Bolletta gas del 12/11/24 n. 2445717366', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(130, '2024-11-17', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Novembre', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(131, '2024-11-16', 'uscita', 95.00, 'Cena Sociale 16 Novembre 2024', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(132, '2024-11-12', 'uscita', 70.88, 'Bolletta luce del 08/10/24 n. 2440026183', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(133, '2024-11-12', 'uscita', 31.77, 'Bolletta gas del 11/10/24 n. 2440006367', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(134, '2024-10-20', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Ottobre', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(135, '2024-10-19', 'uscita', 94.00, 'Cena Sociale 19 Ottobre 2024', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(136, '2024-10-14', 'uscita', 78.45, 'Bolletta luce del 08/09/24 n. 2434414192', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(137, '2024-10-14', 'uscita', 32.35, 'Bolletta gas del 10/09/24 n. 2434413177', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(138, '2024-09-29', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Settembre', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(139, '2024-09-28', 'uscita', 91.00, 'Cena Sociale 28 Settembre 2024', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(140, '2024-09-13', 'uscita', 88.27, 'Bolletta luce del 08/08/24 n. 2428818163', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(141, '2024-09-13', 'uscita', 31.06, 'Bolletta gas del 12/08/24 n. 2428779654', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(142, '2024-08-25', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Agosto', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(143, '2024-08-24', 'uscita', 105.00, 'Cena Sociale 24 Agosto 2024', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(144, '2024-08-13', 'uscita', 95.29, 'Bolletta luce del 08/07/24 n. 2423161129', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(145, '2024-08-13', 'uscita', 33.07, 'Bolletta gas del 11/07/24 n. 2423148117', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(146, '2024-07-28', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Luglio', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(147, '2024-07-27', 'uscita', 89.00, 'Cena Sociale 27 Luglio 2024', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(148, '2024-07-11', 'uscita', 80.12, 'Bolletta luce del 08/06/24 n. 2417492238', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(149, '2024-07-11', 'uscita', 31.46, 'Bolletta gas del 11/06/24 n. 2417552176', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(150, '2024-06-30', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Giugno', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(151, '2024-06-29', 'uscita', 97.00, 'Cena Sociale 29 Giugno 2024', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(152, '2024-06-11', 'uscita', 74.23, 'Bolletta luce del 08/05/24 n. 2411812254', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(153, '2024-06-11', 'uscita', 29.95, 'Bolletta gas del 10/05/24 n. 2411883174', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(154, '2024-05-26', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Maggio', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(155, '2024-05-25', 'uscita', 96.00, 'Cena Sociale 25 Maggio 2024', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(156, '2024-05-13', 'uscita', 68.09, 'Bolletta luce del 08/04/24 n. 2406160239', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(157, '2024-05-13', 'uscita', 33.38, 'Bolletta gas del 09/04/24 n. 2406168236', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(158, '2024-04-28', 'entrata', 100.00, 'Versamento Spampinato per cena sociale Aprile', 8, NULL, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(159, '2024-04-27', 'uscita', 94.00, 'Cena Sociale 27 Aprile 2024', NULL, 10, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(160, '2024-04-11', 'uscita', 66.76, 'Bolletta luce del 08/03/24 n. 2400482212', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(161, '2024-04-11', 'uscita', 36.31, 'Bolletta gas del 12/03/24 n. 2400481254', NULL, 8, '2025-06-04 16:53:47', '2025-06-04 16:53:47', 1),
(162, '2025-03-17', 'uscita', 319.00, 'Ibizia Cassa Portatile', NULL, 1, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(163, '2025-03-17', 'uscita', 149.00, 'Debra Audio Microfoni', NULL, 1, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(164, '2025-03-01', 'uscita', 19.17, 'Spirale per rilegare', NULL, 4, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(165, '2025-02-16', 'uscita', 369.00, 'Acquisto 30 copie Libro x la Loggia e per regali', NULL, 9, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(166, '2025-02-10', 'entrata', 25.00, 'Versamento da fondo cassa cene', 8, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(167, '2025-01-26', 'uscita', 64.40, 'Bolletta Gas n. 2508422433', NULL, 8, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(168, '2025-01-26', 'uscita', 7.99, 'App Cellulare Musica', NULL, 7, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(169, '2025-01-26', 'entrata', 50.00, 'Capitazione Antonio De Chiara', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(170, '2025-01-25', 'entrata', 100.00, 'Capitazione Stefano Bonifazi', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(171, '2025-01-18', 'uscita', 91.94, 'Bolletta Luce del 11/01/25 n. 2507016717', NULL, 8, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(172, '2025-01-12', 'entrata', 100.00, 'Capitazione Roberto Terranova', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(173, '2025-01-12', 'entrata', 100.00, 'Capitazione Francesco Stefani', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(174, '2025-01-12', 'entrata', 100.00, 'Capitazione Paolo Giulio Gazzano', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(175, '2025-01-12', 'entrata', 100.00, 'Acconto Capitazione Giancarlo Bordi', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(176, '2025-01-12', 'entrata', 100.00, 'Capitazione Emiliano Menicucci', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(177, '2025-01-10', 'uscita', 100.00, 'Cellulare di Loggia', NULL, 6, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(178, '2025-01-06', 'entrata', 100.00, 'Capitazione Francesco Ropresti', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(179, '2025-01-06', 'entrata', 100.00, 'Capitazione Stefano Piantone', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(180, '2025-01-06', 'entrata', 70.00, 'Versamento da fondo cassa cene', 8, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(181, '2025-01-06', 'entrata', 100.00, 'Capitazione Marco De Giovanni', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(182, '2025-01-06', 'entrata', 50.00, 'Passaggio Compagno Spampinato', 2, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(183, '2025-01-06', 'entrata', 100.00, 'Capitazione Antonio Cozzolino', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(184, '2025-01-06', 'entrata', 100.00, 'Capitazione Luca Guidicci', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(185, '2025-01-06', 'entrata', 100.00, 'Capitazione Roberto Vinci', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(186, '2025-01-02', 'uscita', 70.00, '10LT - Olio d\'oliva', NULL, 10, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(187, '2025-01-02', 'entrata', 100.00, 'Capitazione Dario Genova', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(188, '2025-01-02', 'entrata', 100.00, 'Capitazione Spampinato', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(189, '2025-01-01', 'entrata', 100.00, 'Capitazione Luca Terranova', 3, NULL, '2025-06-04 16:58:49', '2025-06-04 16:58:49', 1),
(190, '2024-01-01', 'entrata', 70.00, 'Davide Santori (paypal)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(191, '2024-01-02', 'entrata', 70.00, 'Roberto Terranova (paypal)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(192, '2024-01-03', 'entrata', 70.00, 'Francesco Stefani (bonifico)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(193, '2024-01-08', 'entrata', 70.00, 'Giancarlo Bordi (contanti)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(194, '2024-01-08', 'entrata', 70.00, 'Francesco Ropresti (paypal)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(195, '2024-01-10', 'entrata', 70.00, 'Alessio De Martis (bonifico)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(196, '2024-01-10', 'entrata', 70.00, 'Luca Terranova (paypal)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(197, '2024-01-10', 'entrata', 70.00, 'Stefano Bonifazi (paypal)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(198, '2024-01-15', 'entrata', 70.00, 'Roberto Vinci (contante)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(199, '2024-01-24', 'entrata', 70.00, 'Riccardo Anselmi (contanti)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(200, '2024-01-24', 'entrata', 70.00, 'Marco Jacopucci (contanti)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(201, '2024-01-24', 'entrata', 70.00, 'Marco De Giovanni (contanti)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(202, '2024-01-24', 'entrata', 70.00, 'Antonio Cozzolino (paypal)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(203, '2024-02-11', 'entrata', 70.00, 'Emanuele Seretti (bonifico)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(204, '2024-02-11', 'entrata', 70.00, 'Fabio Seretti (bonifico)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(205, '2024-02-12', 'entrata', 40.00, 'Gabriele Recanatesi (contanti)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(206, '2024-02-15', 'entrata', 500.00, 'Sponsor SSC', 10, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(207, '2024-02-21', 'entrata', 70.00, 'Leonardo Lunetto (contanti)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(208, '2024-02-21', 'entrata', 70.00, 'Emiliano Menicucci (bonifico)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(209, '2024-03-11', 'entrata', 70.00, 'Andrea Spampinato (contanti)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(210, '2024-03-22', 'entrata', 70.00, 'Capponi (bonifico)', 2, NULL, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(211, '2024-02-03', 'uscita', 24.69, 'Clamide', NULL, 3, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(212, '2024-02-07', 'uscita', 24.00, 'Il libro della massoneria Capitolare', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(213, '2024-02-14', 'uscita', 90.50, 'Squadra e compasso / Grembiule', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(214, '2024-02-14', 'uscita', 41.14, 'Tappeto di Loggia e Bandiera Scozzese', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(215, '2024-02-14', 'uscita', 9.39, 'Sacchetto nero per metalli', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(216, '2024-02-14', 'uscita', 20.16, 'Il cappello del Mago', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(217, '2024-02-18', 'uscita', 10.00, 'Bastone da Brico', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(218, '2024-02-18', 'uscita', 42.00, 'Scatola, piatti, bicchieri, tende per bastone', NULL, 10, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(219, '2024-02-19', 'uscita', 36.57, 'Storia dell\'occultismo magico', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(220, '2024-02-23', 'uscita', 50.94, 'Temu (porta incenso, cera, buste, campana, chiave, timbro, violino)', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(221, '2024-02-23', 'uscita', 39.90, 'Bibbia 1912 Marco Sales (ebay)', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(222, '2024-02-23', 'uscita', 35.00, 'Leggio del priore templare (ebay)', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(223, '2024-02-27', 'uscita', 11.99, 'Pergamena per stampe', NULL, 2, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(224, '2024-02-28', 'uscita', 15.20, 'Simboli della scienza sacra', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(225, '2024-03-10', 'uscita', 266.00, 'Maglietti, Statue e Telo terzo grado', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(226, '2024-03-10', 'uscita', 7.60, 'Il simbolismo dei tarocchi.', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(227, '2024-03-11', 'uscita', 29.60, 'Ruota dello zodiaco', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(228, '2024-03-11', 'uscita', 40.00, 'Tappeto di Loggia \"Compagno d\'arte\"', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(229, '2024-03-11', 'uscita', 34.70, 'Bolletta Gas del 12/03/24 n. 2414006931', NULL, 8, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(230, '2024-03-17', 'uscita', 12.00, 'Dialoghi con la morte', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(231, '2024-03-17', 'uscita', 22.00, 'Tavole per Apprendisti Liberi Muratori', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(232, '2024-03-20', 'uscita', 64.77, 'Bolletta Luce del 08/03/24 n. 241298162', NULL, 8, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(233, '2024-03-23', 'uscita', 15.77, 'Acea \"874438\"', NULL, 8, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(234, '2024-01-11', 'uscita', 62.29, 'Bolletta Luce 2406988825', NULL, 8, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(235, '2024-01-15', 'uscita', 16.81, 'Bolletta Gas 2408203391', NULL, 8, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(236, '2024-01-21', 'uscita', 20.00, 'Teschio', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(237, '2024-01-22', 'uscita', 15.00, 'Tovaglia Nera', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(238, '2024-01-22', 'uscita', 12.63, 'Calici', NULL, 1, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(239, '2024-01-25', 'uscita', 23.75, 'Sei Lezioni sull\'Antica Massoneria', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(240, '2024-01-25', 'uscita', 12.91, 'Sulla via dell\'iniziazione', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(241, '2024-01-25', 'uscita', 20.00, 'Hiram - Il mistero della maestria e le origini della Libera Muratoria', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(242, '2024-01-25', 'uscita', 11.88, 'L\'iniziazione (R. Steiner)', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(243, '2024-01-25', 'uscita', 29.50, 'Simbolica dei Capitoli', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(244, '2024-01-25', 'uscita', 19.13, 'Bolletta Acqua ACEA 87366', NULL, 8, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(245, '2024-01-31', 'uscita', 10.90, 'Daimon', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(246, '2024-01-31', 'uscita', 19.00, 'Cosa Farete della vostra vita?', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(247, '2024-01-31', 'uscita', 24.00, 'Rousseau - Discorso sull\'origine..', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(248, '2024-01-31', 'uscita', 12.00, 'De Templo Salomonis Liber', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(249, '2024-01-31', 'uscita', 12.00, 'La scala degli idioti di Gurdjieff', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(250, '2024-01-31', 'uscita', 25.00, 'Il Mistro del Graal (J. Evola)', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(251, '2024-01-31', 'uscita', 11.40, 'I Catari. Storia e Dottrina', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(252, '2024-01-31', 'uscita', 28.00, 'La Dottrina del Risveglio (J. Evola)', NULL, 9, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(253, '2024-02-03', 'uscita', 24.69, 'Clamide', NULL, 3, '2025-06-05 06:59:57', '2025-06-05 06:59:57', 1),
(254, '2024-01-01', 'entrata', 70.00, 'Davide Santori (paypal)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(255, '2024-01-02', 'entrata', 70.00, 'Roberto Terranova (paypal)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(256, '2024-01-03', 'entrata', 70.00, 'Francesco Stefani (bonifico)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(257, '2024-01-08', 'entrata', 70.00, 'Giancarlo Bordi (contanti)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(258, '2024-01-08', 'entrata', 70.00, 'Francesco Ropresti (paypal)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(259, '2024-01-10', 'entrata', 70.00, 'Alessio De Martis (bonifico)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(260, '2024-01-10', 'entrata', 70.00, 'Luca Terranova (paypal)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(261, '2024-01-10', 'entrata', 70.00, 'Stefano Bonifazi (paypal)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(262, '2024-01-15', 'entrata', 70.00, 'Roberto Vinci (contante)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(263, '2024-01-24', 'entrata', 70.00, 'Riccardo Anselmi (contanti)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(264, '2024-01-24', 'entrata', 70.00, 'Marco Jacopucci (contanti)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(265, '2024-01-24', 'entrata', 70.00, 'Marco De Giovanni (contanti)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(266, '2024-01-24', 'entrata', 70.00, 'Antonio Cozzolino (paypal)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(267, '2024-02-11', 'entrata', 70.00, 'Emanuele Seretti (bonifico)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(268, '2024-02-11', 'entrata', 70.00, 'Fabio Seretti (bonifico)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(269, '2024-02-12', 'entrata', 40.00, 'Gabriele Recanatesi (contanti)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(270, '2024-02-15', 'entrata', 500.00, 'Sponsor SSC', 10, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(271, '2024-02-21', 'entrata', 70.00, 'Leonardo Lunetto (contanti)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(272, '2024-02-21', 'entrata', 70.00, 'Emiliano Menicucci (bonifico)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(273, '2024-03-11', 'entrata', 70.00, 'Andrea Spampinato (contanti)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(274, '2024-03-22', 'entrata', 70.00, 'Capponi (bonifico)', 2, NULL, '2025-06-05 07:00:32', '2025-06-05 07:00:32', 1),
(275, '2024-01-10', 'uscita', 10.35, 'Il codice segreto del Vangelo. Il libro del giovane Giovanni', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(276, '2024-01-11', 'uscita', 62.29, 'Bolletta Luce 2406988825', NULL, 8, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(277, '2024-01-15', 'uscita', 16.81, 'Bolletta Gas 2408203391', NULL, 8, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(278, '2024-01-21', 'uscita', 20.00, 'Teschio', NULL, 1, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(279, '2024-01-22', 'uscita', 15.00, 'Tovaglia Nera', NULL, 1, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(280, '2024-01-22', 'uscita', 12.63, 'Calici', NULL, 1, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(281, '2024-01-25', 'uscita', 23.75, 'Sei Lezioni sull\'Antica Massoneria', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(282, '2024-01-25', 'uscita', 12.91, 'Sulla via dell\'iniziazione', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(283, '2024-01-25', 'uscita', 20.00, 'Hiram - Il mistero della maestria e le origini della Libera Muratoria', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(284, '2024-01-25', 'uscita', 11.88, 'L\'iniziazione (R. Steiner)', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(285, '2024-01-25', 'uscita', 29.50, 'Simbolica dei Capitoli', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(286, '2024-01-25', 'uscita', 19.13, 'Bolletta Acqua ACEA 87366', NULL, 8, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(287, '2024-01-31', 'uscita', 10.90, 'Daimon', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(288, '2024-01-31', 'uscita', 19.00, 'Cosa Farete della vostra vita?', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(289, '2024-01-31', 'uscita', 24.00, 'Rousseau - Discorso sull\'origine..', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(290, '2024-01-31', 'uscita', 12.00, 'De Templo Salomonis Liber', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(291, '2024-01-31', 'uscita', 12.00, 'La scala degli idioti di Gurdjieff', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(292, '2024-01-31', 'uscita', 25.00, 'Il Mistro del Graal (J. Evola)', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(293, '2024-01-31', 'uscita', 11.40, 'I Catari. Storia e Dottrina', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(294, '2024-01-31', 'uscita', 28.00, 'La Dottrina del Risveglio (J. Evola)', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(295, '2024-02-03', 'uscita', 24.69, 'Clamide', NULL, 3, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(296, '2024-02-07', 'uscita', 24.00, 'Il libro della massoneria Capitolare', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(297, '2024-02-14', 'uscita', 90.50, 'Squadra e compasso / Grembiule', NULL, 1, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(298, '2024-02-14', 'uscita', 41.14, 'Tappeto di Loggia e Bandiera Scozzese', NULL, 1, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(299, '2024-02-14', 'uscita', 9.39, 'Sacchetto nero per metalli', NULL, 1, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(300, '2024-02-14', 'uscita', 20.16, 'Il cappello del Mago', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(301, '2024-02-18', 'uscita', 10.00, 'Bastone da Brico', NULL, 1, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(302, '2024-02-18', 'uscita', 42.00, 'Scatola, piatti, bicchieri, tende per bastone', NULL, 10, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(303, '2024-02-19', 'uscita', 36.57, 'Storia dell\'occultismo magico', NULL, 9, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(304, '2024-02-23', 'uscita', 50.94, 'Temu (porta incenso, cera, buste, campana, chiave, timbro, violino)', NULL, 1, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(305, '2024-02-23', 'uscita', 39.90, 'Bibbia 1912 Marco Sales (ebay)', NULL, 1, '2025-06-05 07:01:46', '2025-06-05 07:01:46', 1),
(306, '2024-02-23', 'uscita', 35.00, 'Leggio del priore templare (ebay)', NULL, 1, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(307, '2024-02-27', 'uscita', 11.99, 'Pergamena per stampe', NULL, 2, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(308, '2024-02-28', 'uscita', 15.20, 'Simboli della scienza sacra', NULL, 9, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(309, '2024-03-10', 'uscita', 266.00, 'Maglietti, Statue e Telo terzo grado', NULL, 1, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(310, '2024-03-10', 'uscita', 7.60, 'Il simbolismo dei tarocchi.', NULL, 9, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(311, '2024-03-11', 'uscita', 29.60, 'Ruota dello zodiaco', NULL, 1, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(312, '2024-03-11', 'uscita', 40.00, 'Tappeto di Loggia Compagno arte', NULL, 1, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(313, '2024-03-11', 'uscita', 34.70, 'Bolletta Gas del 12/03/24 n. 2414006931', NULL, 8, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(314, '2024-03-17', 'uscita', 12.00, 'Dialoghi con la morte', NULL, 9, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(315, '2024-03-17', 'uscita', 22.00, 'Tavole per Apprendisti Liberi Muratori', NULL, 9, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(316, '2024-03-20', 'uscita', 64.77, 'Bolletta Luce del 08/03/24 n. 241298162', NULL, 8, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(317, '2024-03-23', 'uscita', 15.77, 'Acea 874438', NULL, 8, '2025-06-05 07:01:47', '2025-06-05 07:01:47', 1),
(319, '2023-05-08', 'entrata', 125.00, 'Alessio de Martis', 1, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(320, '2023-05-08', 'entrata', 125.00, 'Luca Terranova', 1, NULL, '2025-06-05 07:06:00', '2025-06-06 16:19:11', 1),
(321, '2023-05-14', 'entrata', 70.00, 'Paolo Giulio Gazzano', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(322, '2023-05-15', 'entrata', 70.00, 'Fabio Seretti (21/02)', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(323, '2023-06-12', 'entrata', 70.00, 'Riccardo Anselmi', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(324, '2023-06-12', 'entrata', 125.00, 'Francesco Stefani', 1, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(325, '2023-06-12', 'entrata', 125.00, 'Stefano Bonifazi', 1, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(326, '2023-06-12', 'entrata', 70.00, 'Giancarlo Bordi', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(327, '2023-06-12', 'entrata', 70.00, 'Alessandro Spampinato', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(328, '2023-06-25', 'entrata', 120.00, 'Marco De Giovanni', 1, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(329, '2023-06-25', 'entrata', 130.00, 'Maurizio Capponi', 1, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(330, '2023-06-25', 'entrata', 70.00, 'Ugo Stincarelli', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(331, '2023-06-25', 'entrata', 70.00, 'Giorgio Onorati', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(332, '2023-06-25', 'entrata', 70.00, 'Roberto Vinci', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(333, '2023-06-25', 'entrata', 70.00, 'Davide Santori', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(334, '2023-06-25', 'entrata', 70.00, 'Emanuele Seretti', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(335, '2023-07-11', 'entrata', 70.00, 'Marco Jacopucci', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(336, '2023-08-30', 'entrata', 70.00, 'Patrizio Usai', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(337, '2023-09-13', 'entrata', 70.00, 'Giancarlo', 2, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(338, '2023-10-31', 'entrata', 95.00, 'Fondo Cassa', 8, NULL, '2025-06-05 07:06:00', '2025-06-05 07:06:00', 1),
(339, '2023-02-01', 'uscita', 17.10, 'I templari in Portogallo', NULL, 9, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(340, '2023-05-04', 'uscita', 25.00, 'Candele, pile (PG)', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(341, '2023-05-05', 'uscita', 15.00, 'Stampe Etsy (PG)', NULL, 4, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(342, '2023-05-06', 'uscita', 30.00, 'Tovaglia Nera/Rossa (PG)', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(343, '2023-05-06', 'uscita', 52.00, 'Colonnine (PG)', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(344, '2023-05-06', 'uscita', 65.00, 'Gioiello GS, Squadra e Compasso (PG)', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(345, '2023-05-07', 'uscita', 21.00, 'Cornici per Stampe (PG)', NULL, 4, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(346, '2023-05-08', 'uscita', 18.00, 'Dorsini rilegafogli (PG)', NULL, 2, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(347, '2023-05-09', 'uscita', 16.00, 'Stampe da Copia/Incolla (PG)', NULL, 4, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(348, '2023-05-10', 'uscita', 20.00, 'Cappello Venerabilissimo (PG)', NULL, 3, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(349, '2023-05-10', 'uscita', 75.00, 'Spade (LUCA)', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(350, '2023-05-10', 'uscita', 60.00, 'Clamide (Francesco)', NULL, 3, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(351, '2023-05-13', 'uscita', 110.00, 'Clamide (Roberto, Maurizio)', NULL, 3, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(352, '2023-05-14', 'uscita', 160.00, 'Clamide (Alessio,Luca,Marco)', NULL, 3, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(353, '2023-05-15', 'uscita', 57.00, 'Separé', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(354, '2023-05-15', 'uscita', 60.00, 'Clamide (Stefano)', NULL, 3, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(355, '2023-05-16', 'uscita', 30.00, '2 Clessidre', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(356, '2023-05-16', 'uscita', 75.00, 'Filo a piombo e Pietra (PG)', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(357, '2023-05-18', 'uscita', 18.00, 'Libro Kilwinning', NULL, 9, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(358, '2023-05-21', 'uscita', 18.00, 'Salvadanaio', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(359, '2023-05-31', 'uscita', 60.00, 'Telo nero per ambiente', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(360, '2023-05-31', 'uscita', 20.00, 'Oneri doganali squadre e compasso', NULL, 1, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(361, '2023-05-31', 'uscita', 20.00, 'Piatti e bicchieri di plastica', NULL, 5, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(362, '2023-06-06', 'uscita', 43.27, 'Bolletta Luce 2320607470', NULL, 8, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(363, '2023-06-11', 'uscita', 17.00, 'Inchiesta su Gesù', NULL, 9, '2025-06-05 07:11:20', '2025-06-05 07:11:20', 1),
(364, '2023-06-11', 'uscita', 10.00, 'Libro Papus', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(365, '2023-06-20', 'uscita', 20.00, 'Rimborso Fabio Agape', NULL, 1, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(366, '2023-06-20', 'uscita', 28.00, 'Bicchieri Vetro Agape (PG)', NULL, 10, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(367, '2023-06-20', 'uscita', 50.00, 'Bibite + Spesa Agape (PG)', NULL, 10, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(368, '2023-06-21', 'uscita', 11.00, 'Sulle orme dei templari', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(369, '2023-06-21', 'uscita', 20.00, 'Rituale', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(370, '2023-06-21', 'uscita', 16.00, 'Miele, pane, Prosciutto, olive', NULL, 10, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(371, '2023-06-25', 'uscita', 32.00, '2 Marche da bollo', NULL, 6, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(372, '2023-06-25', 'uscita', 264.00, 'Pratiche Ass. Culturale', NULL, 6, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(373, '2023-06-30', 'uscita', 2.50, 'Blocchetto Ricevute', NULL, 6, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(374, '2023-06-30', 'uscita', 25.00, 'Pulizie Loggia', NULL, 5, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(375, '2023-07-04', 'uscita', 9.50, 'Lao Tzu', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(376, '2023-07-04', 'uscita', 20.90, 'Contattismi di massa', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(377, '2023-07-09', 'uscita', 17.00, 'Cassetta Postale Associazione', NULL, 6, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(378, '2023-07-10', 'uscita', 46.07, 'Targa Associazione', NULL, 6, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(379, '2023-07-14', 'uscita', 52.00, 'Dominio Internet', NULL, 6, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(380, '2023-07-23', 'uscita', 56.52, 'Bolletta Luce maggio/giugno 23', NULL, 8, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(381, '2023-08-07', 'uscita', 10.00, 'Libri', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(382, '2023-08-14', 'uscita', 18.50, 'Il segreto dei massoni', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(383, '2023-08-14', 'uscita', 30.00, 'Da Simon Mago ai Catari', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(384, '2023-08-14', 'uscita', 6.25, 'Il secondo messia', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(385, '2023-09-08', 'uscita', 42.46, 'Candele, Scatole, Piatti, Bicchieri', NULL, 10, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(386, '2023-09-12', 'uscita', 31.78, 'Tovaglia Bianca / Nera', NULL, 1, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(387, '2023-09-24', 'uscita', 9.50, 'Il rito del marchio. Secondo il cerimoniale inglese', NULL, 9, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(388, '2023-09-26', 'uscita', 73.32, 'Luce 09439', NULL, 8, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(389, '2023-09-26', 'uscita', 11.89, 'Acea 34597', NULL, 8, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(390, '2023-09-26', 'uscita', 82.50, 'Tari 2023 al 50% (€165 in totale)', NULL, 8, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(391, '2023-10-01', 'uscita', 32.92, 'Guanti neri', NULL, 3, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(392, '2023-10-01', 'uscita', 11.80, 'Dorsini Rilegafogli', NULL, 2, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(393, '2023-10-17', 'uscita', 13.67, 'Bolletta gas 2335381354', NULL, 8, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(394, '2023-11-01', 'uscita', 35.00, 'Spese Pulizia Amelia', NULL, 5, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(395, '2023-11-06', 'uscita', 47.10, 'Luce 81960', NULL, 8, '2025-06-05 07:11:21', '2025-06-05 07:11:21', 1),
(396, '2023-01-01', 'uscita', 160.91, 'Bilancio Ass. Culturale Viterbo dal 2017 al 2022', NULL, 6, '2025-06-05 07:22:42', '2025-06-05 07:22:42', 1),
(397, '2025-06-05', 'uscita', 50.00, 'Torta al Mandoleto', NULL, 10, '2025-06-06 16:03:04', '2025-06-06 16:03:04', 1),
(398, '2025-06-05', 'entrata', 15.00, 'Apprendista Libero Muratore De Chiara', 4, NULL, '2025-06-06 16:05:22', '2025-06-06 16:05:22', 1),
(399, '2023-05-06', 'entrata', 125.00, 'Roberto Terranova', 1, NULL, '2025-06-06 16:20:20', '2025-06-06 16:20:20', 1),
(400, '2025-05-08', 'uscita', 21.05, 'ACEA ATO N. 2025011001667833', NULL, 8, '2025-06-09 12:40:20', '2025-06-09 12:40:20', 1),
(401, '2025-03-07', 'uscita', 15.57, 'ACEA ATO N. 2025011000886510', NULL, 8, '2025-06-09 12:40:46', '2025-06-09 12:40:46', 1),
(402, '2025-06-11', 'entrata', 30.00, 'Vendita Libri Margherita', 4, NULL, '2025-06-11 07:05:58', '2025-06-11 07:06:11', 1),
(403, '2025-06-17', 'uscita', 124.00, 'Dominio Internet ', NULL, 6, '2025-06-17 12:54:05', '2025-06-17 12:54:05', 1),
(404, '2025-06-17', 'entrata', 170.00, 'Incasso cene Tolfa', 8, NULL, '2025-06-17 17:22:44', '2025-06-17 17:32:14', 1),
(405, '2025-06-17', 'entrata', 10.00, 'Terzo Libro - Luca Guiducci', 4, NULL, '2025-06-17 17:29:04', '2025-06-17 17:29:04', 1),
(406, '2025-06-17', 'entrata', 10.00, 'Terzo Libro - Emiliano Menicucci', 4, NULL, '2025-06-17 19:18:52', '2025-06-17 19:18:52', 1),
(407, '2025-06-17', 'entrata', 10.00, 'Terzo Libro - Emiliano Menicucci', 4, NULL, '2025-06-17 19:18:52', '2025-06-17 19:18:52', 1),
(408, '2025-06-17', 'entrata', 10.00, 'Terzo libro - Gabriele', 4, NULL, '2025-06-17 20:40:54', '2025-06-17 20:40:54', 1),
(409, '2025-06-18', 'entrata', 10.00, 'Terzo libro - Giancarlo', 4, NULL, '2025-06-18 06:52:19', '2025-06-18 06:52:19', 1),
(410, '2025-06-20', 'entrata', 10.00, 'Terzo Libro - Luca Terranova', 4, NULL, '2025-06-20 07:41:59', '2025-06-20 07:41:59', 1),
(411, '2025-06-23', 'uscita', 18.00, 'Rose rosse Solstizio', NULL, 1, '2025-06-23 18:41:22', '2025-06-23 18:41:22', 1),
(412, '2025-07-01', 'entrata', 192.50, 'Tassa Iniziazione + 2025 Salvatore', 2, NULL, '2025-07-01 20:33:40', '2025-07-01 20:33:40', 1),
(413, '2025-07-01', 'uscita', 86.50, 'Clamide, Guanti, Spilla, Cornice, Pergamena Salvatore ', NULL, 3, '2025-07-01 20:35:09', '2025-07-01 20:35:09', 1),
(414, '2025-07-09', 'uscita', 45.00, 'Microfoni per video Social Loggia ', NULL, 7, '2025-07-09 15:47:16', '2025-07-09 15:47:16', 1),
(415, '2025-07-15', 'uscita', 60.00, '3 grembiuli apprendista (Salvatore, Giancarlo, Leonardo)', NULL, 3, '2025-07-15 13:57:18', '2025-07-15 13:57:18', 1),
(416, '2025-07-08', 'uscita', 82.89, 'Bolletta Luce del 08/07/25 n. 2526554670', NULL, 8, '2025-07-21 17:54:02', '2025-07-21 17:54:02', 1),
(417, '2025-07-10', 'uscita', 26.36, 'Bolletta Gas  del 10/07/25 n. 2527459044', NULL, 8, '2025-07-21 17:54:40', '2025-07-21 17:54:40', 1),
(418, '2025-07-21', 'uscita', 359.00, 'Acquisto 50 Copie Libro: Il Cammino nei Miti', NULL, 9, '2025-07-21 17:55:44', '2025-07-21 17:55:44', 1),
(419, '2025-07-13', 'uscita', 80.00, 'Beta Reader il Cammino dei Miti', NULL, 9, '2025-07-22 05:16:32', '2025-07-22 05:16:32', 1),
(420, '2025-07-22', 'uscita', 143.80, 'Acconto Tari Tolfa 2025', NULL, 8, '2025-07-22 16:11:23', '2025-07-22 16:11:23', 1),
(421, '2025-07-29', 'entrata', 100.00, 'Cena del 29/7/25', 8, NULL, '2025-07-29 19:41:09', '2025-07-29 19:41:09', 1),
(422, '2025-07-29', 'entrata', 10.00, 'Kilwinning Antonio', 4, NULL, '2025-07-29 19:41:58', '2025-07-29 19:41:58', 1),
(423, '2025-07-29', 'entrata', 20.00, 'Grembiule Giancarlo', 9, NULL, '2025-07-29 19:42:18', '2025-07-29 19:42:18', 1),
(424, '2025-07-29', 'entrata', 20.00, 'Grembiule Apprnedista Leonardo ', 9, NULL, '2025-07-29 19:43:21', '2025-07-29 19:43:21', 1),
(425, '2025-09-02', 'entrata', 80.00, 'Cena sociale', 8, NULL, '2025-09-02 18:57:00', '2025-09-02 18:57:00', 1),
(426, '2025-09-02', 'entrata', 90.00, 'Terranova, Cozzolino, giuducci, jaco, Lunetto, emiliano, reca, rop, spamp, vinci', 4, NULL, '2025-09-02 19:04:12', '2025-09-02 19:04:12', 1),
(427, '2025-09-03', 'entrata', 45.00, 'Emiliano, 3 copie Il cammino nei Miti', 4, NULL, '2025-09-03 17:12:16', '2025-09-03 17:12:16', 1),
(428, '2025-09-03', 'uscita', 50.00, 'Acquisto 1° Tablet', NULL, 2, '2025-09-03 17:13:05', '2025-09-03 17:13:05', 1),
(429, '2025-09-04', 'entrata', 125.00, 'Tablet Giancarlo, Paolo Giulio, Francesco S.,', 7, NULL, '2025-09-04 06:23:22', '2025-09-04 15:33:56', 1),
(430, '2025-09-04', 'entrata', 10.00, 'Alessio il tegolatore ', 4, NULL, '2025-09-04 15:28:51', '2025-09-04 15:28:51', 1),
(431, '2025-09-04', 'uscita', 250.00, '5 tablet android', NULL, 2, '2025-09-04 15:33:30', '2025-09-04 15:33:30', 1),
(432, '2025-09-06', 'uscita', 40.43, 'Luci per Equinozio', NULL, 1, '2025-09-08 06:17:56', '2025-09-08 06:17:56', 1),
(433, '2025-09-08', 'entrata', 60.00, 'Il cammino nei Miti (4 copie Paolo Giulio)', 4, NULL, '2025-09-08 06:18:38', '2025-09-08 06:18:38', 1),
(434, '2025-09-04', 'entrata', 200.00, 'Paypal Antonio pagamento Tablet Fratelli', 7, NULL, '2025-09-08 06:20:47', '2025-09-08 06:20:47', 1),
(435, '2025-09-09', 'entrata', 20.00, 'Custode della Soglia. Davide e Emanuele ', 4, NULL, '2025-09-10 13:01:14', '2025-09-10 13:01:14', 1),
(436, '2025-09-12', 'uscita', 200.00, '2 Tablet doogee Amazon ', NULL, 2, '2025-09-12 10:40:28', '2025-09-12 10:40:28', 1),
(437, '2025-09-12', 'entrata', 150.00, 'Pagamento fratelli tablet', 7, NULL, '2025-09-12 10:40:54', '2025-09-12 10:40:54', 1),
(438, '2025-09-16', 'entrata', 25.00, 'Roberto Vinci Tablet', 7, NULL, '2025-09-16 05:48:03', '2025-09-16 05:48:03', 1),
(439, '2025-09-16', 'uscita', 86.65, 'Bolletta luce n. 2533598760 del 30/09/25', NULL, 8, '2025-09-16 05:49:01', '2025-09-16 05:56:46', 1),
(440, '2025-09-16', 'uscita', 26.36, 'Bolletta gas n. 2527459044 del 04/08/25', NULL, 8, '2025-09-16 05:49:36', '2025-09-16 05:49:36', 1),
(441, '2025-09-26', 'entrata', 15.00, 'Miti - Antonio', 4, NULL, '2025-09-26 10:41:00', '2025-09-26 10:41:00', 1),
(442, '2025-09-27', 'entrata', 200.00, 'Iniziazione Manuel', 1, NULL, '2025-09-27 17:52:24', '2025-09-27 17:52:24', 1),
(443, '2025-09-26', 'entrata', 45.00, 'Libro Miti Antonio + 2 Francesco', 4, NULL, '2025-09-27 17:52:48', '2025-09-27 17:52:48', 1),
(444, '2025-09-27', 'uscita', 32.00, 'Clamide, guanti e spille Manuel', NULL, 3, '2025-09-27 17:53:11', '2025-09-27 17:53:11', 1),
(445, '2025-09-28', 'uscita', 56.00, 'Grembiuli Apprendista e Compagno', NULL, 3, '2025-09-28 14:15:14', '2025-09-28 14:15:14', 1),
(446, '2025-09-15', 'uscita', 190.00, 'MultiCloud per Sincronizzazione tra fratelli', NULL, 14, '2025-10-01 08:33:25', '2025-10-01 08:33:51', 1),
(447, '2025-10-09', 'uscita', 60.00, 'Filtri Acqua 10/25', NULL, 8, '2025-10-09 14:54:46', '2025-10-09 14:54:46', 1),
(448, '2025-10-10', 'entrata', 100.00, 'cena del 9/10', 8, NULL, '2025-10-10 10:38:52', '2025-10-10 10:38:52', 1),
(449, '2025-10-10', 'entrata', 30.00, 'PG+Salvatore', 4, NULL, '2025-10-10 10:39:19', '2025-10-10 10:39:19', 1),
(450, '2025-10-11', 'uscita', 15.00, 'Photopea per brevetti e immagini rituali\n', NULL, 14, '2025-10-11 18:40:11', '2025-10-11 18:40:11', 1),
(451, '2025-10-14', 'entrata', 200.00, 'Iniziazione Massimo', 1, NULL, '2025-10-14 19:48:48', '2025-10-14 19:48:48', 1),
(452, '2025-10-23', 'entrata', 155.00, 'cena del 23/10', 8, NULL, '2025-10-23 20:40:23', '2025-10-23 20:40:23', 1),
(453, '2025-10-14', 'uscita', 35.00, 'clamide più 2 guanti massimo', NULL, 3, '2025-10-25 08:13:45', '2025-10-25 08:13:45', 1),
(454, '2025-10-25', 'uscita', 200.00, 'TP-LINK ROUTER 5g SIM', NULL, 1, '2025-10-25 08:14:13', '2025-10-25 08:14:13', 1),
(455, '2025-10-30', 'uscita', 165.28, 'Arretrati bollette ACEA dal 2023 al 2025', NULL, 8, '2025-10-30 10:46:01', '2025-10-30 10:46:01', 1);

-- --------------------------------------------------------

--
-- Struttura della tabella `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','viewer') DEFAULT 'viewer',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `role`, `created_at`, `last_login`) VALUES
(1, 'admin', 'Kilwinning2025', 'admin', '2025-06-04 16:00:29', NULL),
(2, 'Fratello', 'puntorosso', 'viewer', '2025-06-04 18:20:33', NULL),
(3, 'Tesoriere', 'Tesoriere2025', 'viewer', '2025-06-05 06:30:34', NULL),
(7, 'tempuser', 'temppassword', 'admin', '2025-06-10 13:08:46', NULL);

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `categorie_entrate`
--
ALTER TABLE `categorie_entrate`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indici per le tabelle `categorie_uscite`
--
ALTER TABLE `categorie_uscite`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indici per le tabelle `saldo_iniziale`
--
ALTER TABLE `saldo_iniziale`
  ADD PRIMARY KEY (`anno`);

--
-- Indici per le tabelle `transazioni`
--
ALTER TABLE `transazioni`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_entrata_id` (`categoria_entrata_id`),
  ADD KEY `categoria_uscita_id` (`categoria_uscita_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_data` (`data_transazione`),
  ADD KEY `idx_anno_mese` (`anno`,`mese`),
  ADD KEY `idx_tipo` (`tipo`);

--
-- Indici per le tabelle `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `categorie_entrate`
--
ALTER TABLE `categorie_entrate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT per la tabella `categorie_uscite`
--
ALTER TABLE `categorie_uscite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT per la tabella `transazioni`
--
ALTER TABLE `transazioni`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=456;

--
-- AUTO_INCREMENT per la tabella `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `transazioni`
--
ALTER TABLE `transazioni`
  ADD CONSTRAINT `transazioni_ibfk_1` FOREIGN KEY (`categoria_entrata_id`) REFERENCES `categorie_entrate` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transazioni_ibfk_2` FOREIGN KEY (`categoria_uscita_id`) REFERENCES `categorie_uscite` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transazioni_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
