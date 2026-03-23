-- =========================
-- DATABASE
-- =========================
CREATE DATABASE IF NOT EXISTS rappelFacile 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_general_ci;

USE rappelFacile;

CREATE USER IF NOT EXISTS 'rappelFacileUser'@'localhost' IDENTIFIED BY '*********';
GRANT SELECT, INSERT, UPDATE, DELETE ON rappelFacile.* TO 'rappelFacileUser'@'localhost';

-- =========================
-- DROP TABLES
-- =========================
DROP TABLE IF EXISTS Rappel;
DROP TABLE IF EXISTS RDV;
DROP TABLE IF EXISTS Local;
DROP TABLE IF EXISTS Categorie;
DROP TABLE IF EXISTS Profession;
DROP TABLE IF EXISTS Adresse;
DROP TABLE IF EXISTS Prestataire;
DROP TABLE IF EXISTS User_;

-- =========================
-- TABLE USER
-- =========================
CREATE TABLE User_ (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    mdp VARCHAR(255) NOT NULL,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    tel VARCHAR(20),
    isValide BOOLEAN DEFAULT TRUE
);

-- =========================
-- TABLE PRESTATAIRE
-- =========================
CREATE TABLE Prestataire (
    id_prestataire INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    isValide BOOLEAN DEFAULT TRUE
);

-- =========================
-- TABLE ADRESSE
-- =========================
CREATE TABLE Adresse (
    id_adresse INT AUTO_INCREMENT PRIMARY KEY,
    rue VARCHAR(100),
    numero VARCHAR(10),
    code_postal VARCHAR(10),
    ville VARCHAR(50)
);

-- =========================
-- TABLE PROFESSION
-- =========================
CREATE TABLE Profession (
    id_profession INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    isValide BOOLEAN DEFAULT TRUE,
    id_prestataire INT NOT NULL,

    CONSTRAINT fk_profession_prestataire
        FOREIGN KEY (id_prestataire)
        REFERENCES Prestataire(id_prestataire)
        ON DELETE CASCADE
);

-- =========================
-- TABLE CATEGORIE
-- =========================
CREATE TABLE Categorie (
    id_categorie INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    id_profession INT,

    CONSTRAINT fk_categorie_profession
        FOREIGN KEY (id_profession)
        REFERENCES Profession(id_profession)
        ON DELETE SET NULL
);

-- =========================
-- TABLE LOCAL (relation prestataire/adresse)
-- =========================
CREATE TABLE Local (
    id_prestataire INT,
    id_adresse INT,
    PRIMARY KEY (id_prestataire, id_adresse),

    CONSTRAINT fk_local_prestataire
        FOREIGN KEY (id_prestataire)
        REFERENCES Prestataire(id_prestataire)
        ON DELETE CASCADE,

    CONSTRAINT fk_local_adresse
        FOREIGN KEY (id_adresse)
        REFERENCES Adresse(id_adresse)
        ON DELETE CASCADE
);

-- =========================
-- TABLE RDV
-- =========================
CREATE TABLE RDV (
    id_rdv INT AUTO_INCREMENT PRIMARY KEY,
    dateRdv DATETIME NOT NULL,
    isOk BOOLEAN DEFAULT FALSE,

    id_user INT,
    id_prestataire INT,
    id_adresse INT,

    CONSTRAINT fk_rdv_user
        FOREIGN KEY (id_user)
        REFERENCES User_(id_user)
        ON DELETE SET NULL,

    CONSTRAINT fk_rdv_prestataire
        FOREIGN KEY (id_prestataire)
        REFERENCES Prestataire(id_prestataire)
        ON DELETE SET NULL,

    CONSTRAINT fk_rdv_adresse
        FOREIGN KEY (id_adresse)
        REFERENCES Adresse(id_adresse)
        ON DELETE SET NULL
);

-- =========================
-- TABLE RAPPEL
-- =========================
CREATE TABLE Rappel (
    id_rappel INT AUTO_INCREMENT PRIMARY KEY,
    delai VARCHAR(50),
    type VARCHAR(50),
    id_rdv INT NOT NULL,

    CONSTRAINT fk_rappel_rdv
        FOREIGN KEY (id_rdv)
        REFERENCES RDV(id_rdv)
        ON DELETE CASCADE
);

-- ============================================================
-- 🔥 DONNEES DE TEST
-- ============================================================

-- USERS
INSERT INTO User_ (email, mdp, nom, prenom, tel) VALUES
('seb@mail.com', '1234', 'Cossus', 'Sebastien', '0600000001'),
('dylan@mail.com', 'abcd', 'Cossus', 'Dylan', '0600000002');

-- PRESTATAIRES
INSERT INTO Prestataire (nom, prenom) VALUES
('Martin', 'Paul'),
('Durand', 'Sophie');

-- ADRESSES
INSERT INTO Adresse (rue, numero, code_postal, ville) VALUES
('Rue Victor Hugo', '10', '75001', 'Paris'),
('Boulevard National', '25', '13001', 'Marseille');

-- PROFESSION
INSERT INTO Profession (nom, id_prestataire) VALUES
('Médecin', 1),
('Coiffeur', 2);

-- CATEGORIE
INSERT INTO Categorie (nom, id_profession) VALUES
('Santé', 1),
('Beauté', 2);

-- LOCAL
INSERT INTO Local (id_prestataire, id_adresse) VALUES
(1,1),
(2,2);

-- RDV
INSERT INTO RDV (dateRdv, isOk, id_user, id_prestataire, id_adresse) VALUES
('2026-04-01 10:00:00', TRUE, 1, 1, 1),
('2026-04-02 15:30:00', FALSE, 2, 2, 2);

-- RAPPELS
INSERT INTO Rappel (delai, type, id_rdv) VALUES
('24h', 'Email', 1),
('1h', 'SMS', 1),
('2h', 'Email', 2);
