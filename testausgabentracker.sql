-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 28. Feb 2023 um 16:28
-- Server-Version: 10.4.27-MariaDB
-- PHP-Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `testausgabentracker`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ausgabe`
--

CREATE TABLE `ausgabe` (
  `AusgabeID` int(11) NOT NULL,
  `Bezeichnung` varchar(255) NOT NULL,
  `Betrag` double(8,2) NOT NULL,
  `Datum` date NOT NULL,
  `NutzerID` int(11) NOT NULL,
  `KategorieID` int(11) NOT NULL,
  `ZahlungsartID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `ausgabe`
--

INSERT INTO `ausgabe` (`AusgabeID`, `Bezeichnung`, `Betrag`, `Datum`, `NutzerID`, `KategorieID`, `ZahlungsartID`) VALUES
(1, 'Geld Benzin ', 50.00, '2023-02-28', 1, 4, 1),
(2, 'Mittagsessen', 36.00, '2023-01-03', 1, 2, 2),
(3, 'Frühstück', 25.69, '2023-02-28', 1, 2, 2);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `kategorie`
--

CREATE TABLE `kategorie` (
  `KategorieID` int(11) NOT NULL,
  `Bezeichnung` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `kategorie`
--

INSERT INTO `kategorie` (`KategorieID`, `Bezeichnung`) VALUES
(1, 'Sport'),
(2, 'Essen'),
(3, 'Arbeit'),
(4, 'Transport');

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `kategorienprozentual`
-- (Siehe unten für die tatsächliche Ansicht)
--
CREATE TABLE `kategorienprozentual` (
`Betrag` double(19,2)
);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `nutzer`
--

CREATE TABLE `nutzer` (
  `NutzerID` int(15) NOT NULL,
  `EmailAdresse` varchar(255) DEFAULT NULL,
  `Passwort` varchar(255) DEFAULT NULL,
  `Vorname` varchar(255) DEFAULT NULL,
  `Nachname` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `nutzer`
--

INSERT INTO `nutzer` (`NutzerID`, `EmailAdresse`, `Passwort`, `Vorname`, `Nachname`) VALUES
(1, 'test@gmail.com', '73e16f39e7af62b31b2a9566db6f1b6a', 'Isaac ', 'Novoa');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `protokoll`
--

CREATE TABLE `protokoll` (
  `ProtokollID` int(11) NOT NULL,
  `Kennzeichnung` varchar(2) NOT NULL,
  `AusgabenID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `viewimjahr`
-- (Siehe unten für die tatsächliche Ansicht)
--
CREATE TABLE `viewimjahr` (
`Betrag` double(19,2)
,`Kategorie` varchar(255)
,`Zahlungsart` varchar(255)
,`Jahr` int(4)
);

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `viewimjahrmonat`
-- (Siehe unten für die tatsächliche Ansicht)
--
CREATE TABLE `viewimjahrmonat` (
`Betrag` double(19,2)
,`Kategorie` varchar(255)
,`Zahlungsart` varchar(255)
,`Jahr` int(4)
,`Monat` int(2)
);

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `viewkategorieausgaben`
-- (Siehe unten für die tatsächliche Ansicht)
--
CREATE TABLE `viewkategorieausgaben` (
`Betrag` double(19,2)
,`Kategorie` varchar(255)
);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `zahlungsart`
--

CREATE TABLE `zahlungsart` (
  `ZahlungsartID` int(11) NOT NULL,
  `Bezeichnung` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `zahlungsart`
--

INSERT INTO `zahlungsart` (`ZahlungsartID`, `Bezeichnung`) VALUES
(1, 'Bargeld'),
(2, 'Debitkarte'),
(3, 'Kreditkarte'),
(4, 'Darlehen');

-- --------------------------------------------------------

--
-- Struktur des Views `kategorienprozentual`
--
DROP TABLE IF EXISTS `kategorienprozentual`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `kategorienprozentual`  AS SELECT round(sum(`table1`.`Betrag`) * 100 / (select sum(`ausgabe`.`Betrag`) from `ausgabe`),2) AS `Betrag` FROM (`ausgabe` `table1` join `kategorie` `table2` on(`table1`.`KategorieID` = `table2`.`KategorieID`)) GROUP BY `table2`.`KategorieID``KategorieID`  ;

-- --------------------------------------------------------

--
-- Struktur des Views `viewimjahr`
--
DROP TABLE IF EXISTS `viewimjahr`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewimjahr`  AS SELECT sum(`table1`.`Betrag`) AS `Betrag`, `table2`.`Bezeichnung` AS `Kategorie`, `table3`.`Bezeichnung` AS `Zahlungsart`, year(`table1`.`Datum`) AS `Jahr` FROM ((`ausgabe` `table1` join `kategorie` `table2` on(`table1`.`KategorieID` = `table2`.`KategorieID`)) join `zahlungsart` `table3` on(`table3`.`ZahlungsartID` = `table1`.`ZahlungsartID`)) GROUP BY year(`table1`.`Datum`)  ;

-- --------------------------------------------------------

--
-- Struktur des Views `viewimjahrmonat`
--
DROP TABLE IF EXISTS `viewimjahrmonat`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewimjahrmonat`  AS SELECT sum(`table1`.`Betrag`) AS `Betrag`, `table2`.`Bezeichnung` AS `Kategorie`, `table3`.`Bezeichnung` AS `Zahlungsart`, year(`table1`.`Datum`) AS `Jahr`, month(`table1`.`Datum`) AS `Monat` FROM ((`ausgabe` `table1` join `kategorie` `table2` on(`table1`.`KategorieID` = `table2`.`KategorieID`)) join `zahlungsart` `table3` on(`table3`.`ZahlungsartID` = `table1`.`ZahlungsartID`)) GROUP BY year(`table1`.`Datum`), month(`table1`.`Datum`)  ;

-- --------------------------------------------------------

--
-- Struktur des Views `viewkategorieausgaben`
--
DROP TABLE IF EXISTS `viewkategorieausgaben`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewkategorieausgaben`  AS SELECT sum(`table1`.`Betrag`) AS `Betrag`, `table2`.`Bezeichnung` AS `Kategorie` FROM (`ausgabe` `table1` join `kategorie` `table2` on(`table1`.`KategorieID` = `table2`.`KategorieID`)) GROUP BY `table2`.`KategorieID``KategorieID`  ;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `ausgabe`
--
ALTER TABLE `ausgabe`
  ADD PRIMARY KEY (`AusgabeID`),
  ADD KEY `fk_nutzerID` (`NutzerID`),
  ADD KEY `fk_KategorieID` (`KategorieID`),
  ADD KEY `fk_ZahlungsartID` (`ZahlungsartID`);

--
-- Indizes für die Tabelle `kategorie`
--
ALTER TABLE `kategorie`
  ADD PRIMARY KEY (`KategorieID`),
  ADD KEY `KategorieID` (`KategorieID`);

--
-- Indizes für die Tabelle `nutzer`
--
ALTER TABLE `nutzer`
  ADD PRIMARY KEY (`NutzerID`),
  ADD KEY `NutzerID` (`NutzerID`);

--
-- Indizes für die Tabelle `protokoll`
--
ALTER TABLE `protokoll`
  ADD PRIMARY KEY (`ProtokollID`),
  ADD KEY `AusgabenID` (`AusgabenID`);

--
-- Indizes für die Tabelle `zahlungsart`
--
ALTER TABLE `zahlungsart`
  ADD PRIMARY KEY (`ZahlungsartID`),
  ADD KEY `ZahlungsartID` (`ZahlungsartID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `protokoll`
--
ALTER TABLE `protokoll`
  MODIFY `ProtokollID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `ausgabe`
--
ALTER TABLE `ausgabe`
  ADD CONSTRAINT `ausgabe_ibfk_1` FOREIGN KEY (`KategorieID`) REFERENCES `kategorie` (`KategorieID`),
  ADD CONSTRAINT `ausgabe_ibfk_2` FOREIGN KEY (`ZahlungsartID`) REFERENCES `zahlungsart` (`ZahlungsartID`),
  ADD CONSTRAINT `ausgabe_ibfk_3` FOREIGN KEY (`NutzerID`) REFERENCES `nutzer` (`NutzerID`);

--
-- Constraints der Tabelle `protokoll`
--
ALTER TABLE `protokoll`
  ADD CONSTRAINT `protokoll_ibfk_1` FOREIGN KEY (`AusgabenID`) REFERENCES `ausgabe` (`AusgabeID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
