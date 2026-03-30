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
DROP TABLE IF EXISTS rdv;
DROP TABLE IF EXISTS Rappel;
DROP TABLE IF EXISTS Exerce;
DROP TABLE IF EXISTS Local;
DROP TABLE IF EXISTS Profession;
DROP TABLE IF EXISTS Categorie;
DROP TABLE IF EXISTS Adresse;
DROP TABLE IF EXISTS Prestataire;
DROP TABLE IF EXISTS User_;

-- =========================
-- USER
-- =========================
CREATE TABLE User_ (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100),
    mdp VARCHAR(50),
    nom VARCHAR(50),
    prenom VARCHAR(50),
    tel VARCHAR(10),
    photo VARCHAR(50),
    siValide BOOLEAN DEFAULT TRUE
);

-- =========================
-- PRESTATAIRE
-- =========================
CREATE TABLE Prestataire (
    id_prestataire INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    siValide BOOLEAN DEFAULT TRUE
);

-- =========================
-- ADRESSE
-- =========================
CREATE TABLE Adresse (
    id_adresse INT AUTO_INCREMENT PRIMARY KEY,
    ville VARCHAR(50),
    rue VARCHAR(100),
    numero VARCHAR(8),
    codePostal VARCHAR(7)
);

-- =========================
-- CATEGORIE
-- =========================
CREATE TABLE Categorie (
    id_categorie INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(20)
);

-- =========================
-- PROFESSION
-- =========================
CREATE TABLE Profession (
    id_profession INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(20),
    siValide BOOLEAN DEFAULT TRUE,
    id_categorie INT,

    FOREIGN KEY (id_categorie)
        REFERENCES Categorie(id_categorie)
        ON DELETE SET NULL
);

-- =========================
-- EXERCE (relation N-N)
-- =========================
CREATE TABLE Exerce (
    id_profession INT,
    id_prestataire INT,
    siValide BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_profession, id_prestataire),

    FOREIGN KEY (id_profession)
        REFERENCES Profession(id_profession)
        ON DELETE CASCADE,

    FOREIGN KEY (id_prestataire)
        REFERENCES Prestataire(id_prestataire)
        ON DELETE CASCADE
);

-- =========================
-- LOCAL (prestataire/adresse)
-- =========================
CREATE TABLE Local (
    id_prestataire INT,
    id_adresse INT,
    siValide BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_prestataire, id_adresse),

    FOREIGN KEY (id_prestataire)
        REFERENCES Prestataire(id_prestataire)
        ON DELETE CASCADE,

    FOREIGN KEY (id_adresse)
        REFERENCES Adresse(id_adresse)
        ON DELETE CASCADE
);

-- =========================
-- RAPPEL
-- =========================
CREATE TABLE Rappel (
    id_rappel INT AUTO_INCREMENT PRIMARY KEY,
    delai INT,
    typeAlerte VARCHAR(10)
);

-- =========================
-- RDV
-- =========================
CREATE TABLE RDV (
    id_rdv INT AUTO_INCREMENT PRIMARY KEY,
    dateRdv DATE,
    siOk BOOLEAN,

    id_prestataire INT,
    id_rappel INT,
    id_user INT,
    id_adresse INT,

    FOREIGN KEY (id_prestataire)
        REFERENCES Prestataire(id_prestataire)
        ON DELETE SET NULL,

    FOREIGN KEY (id_rappel)
        REFERENCES Rappel(id_rappel)
        ON DELETE SET NULL,

    FOREIGN KEY (id_user)
        REFERENCES User_(id_user)
        ON DELETE SET NULL,

    FOREIGN KEY (id_adresse)
        REFERENCES Adresse(id_adresse)
        ON DELETE SET NULL
);

-- =========================
-- 🔥 DONNEES DE TEST
-- =========================

-- USERS
INSERT INTO User_ (email, mdp, nom, prenom, tel) VALUES
('seb@mail.com', '1234', 'Cossus', 'Sebastien', '0600000001'),
('dylan@mail.com', 'abcd', 'Cossus', 'Dylan', '0600000002');

-- PRESTATAIRES
INSERT INTO Prestataire (nom, prenom) VALUES
('Martin', 'Paul'),
('Durand', 'Sophie');

-- ADRESSES
INSERT INTO Adresse (ville, rue, numero, codePostal) VALUES
('Paris', 'Rue Victor Hugo', '10', '75001'),
('Marseille', 'Boulevard National', '25', '13001');

-- CATEGORIES
INSERT INTO Categorie (nom) VALUES
('Santé'),
('Beauté');

-- PROFESSIONS
INSERT INTO Profession (nom, id_categorie) VALUES
('Médecin', 1),
('Coiffeur', 2);

-- EXERCE
INSERT INTO Exerce VALUES
(1,1,TRUE),
(2,2,TRUE);

-- LOCAL
INSERT INTO Local VALUES
(1,1,TRUE),
(2,2,TRUE);

-- RAPPELS
INSERT INTO Rappel (delai, typeAlerte) VALUES
(24, 'Email'),
(1, 'SMS');

-- RDV
INSERT INTO RDV (dateRdv, siOk, id_prestataire, id_rappel, id_user, id_adresse) VALUES
('2026-04-01', TRUE, 1, 1, 1, 1),
('2026-04-02', FALSE, 2, 2, 2, 2);
