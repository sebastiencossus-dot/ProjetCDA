
CREATE DATABASE IF NOT EXISTS rappelFacile DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE rappelFacile;

CREATE USER IF NOT EXISTS 'rappelFacileUser'@'localhost' IDENTIFIED BY '*********';
GRANT SELECT, INSERT, UPDATE, DELETE ON rappelFacile.* TO 'rappelFacileUser'@'localhost';

DROP TABLE IF EXISTS Rappel;
DROP TABLE IF EXISTS RDV;
DROP TABLE IF EXISTS Local;
DROP TABLE IF EXISTS Profession;
DROP TABLE IF EXISTS Categorie;
DROP TABLE IF EXISTS Adresse;
DROP TABLE IF EXISTS Prestataire;
DROP TABLE IF EXISTS User_;




-- =========================
-- TABLE USER
-- =========================
CREATE TABLE User_ (
    Id_User INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(50) NOT NULL UNIQUE,
    mdp VARCHAR(50) NOT NULL,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    tel VARCHAR(50)
);

-- =========================
-- TABLE PRESTATAIRE
-- =========================
CREATE TABLE Prestataire (
    Id_Prestataire INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
  );

-- =========================
-- TABLE ADRESSE
-- =========================
CREATE TABLE Adresse (
    Id_Adresse INT AUTO_INCREMENT PRIMARY KEY,
    rue VARCHAR(50) NOT NULL,
    numero VARCHAR(50) NOT NULL,
    codePostal VARCHAR(50) NOT NULL,
    ville VARCHAR(50) NOT NULL
);

-- =========================
-- TABLE PROFESSION
-- =========================
CREATE TABLE Profession (
    Id_Profession INT AUTO_INCREMENT PRIMARY KEY,
    id_prestataire INT NOT NULL,
    nom VARCHAR(50) NOT NULL,

    CONSTRAINT fk_profession_prestataire
        FOREIGN KEY (id_prestataire)
        REFERENCES Prestataire(Id_Prestataire)
        ON DELETE CASCADE
);

-- =========================
-- TABLE CATEGORIE
-- =========================
CREATE TABLE Categorie (
    Id_Categorie INT AUTO_INCREMENT PRIMARY KEY,
    id_profession INT NOT NULL,
    nom_de_categorie VARCHAR(50) NOT NULL,

    CONSTRAINT fk_categorie_profession
        FOREIGN KEY (id_profession)
        REFERENCES Profession(Id_Profession)
        ON DELETE CASCADE
);

-- =========================
-- TABLE RDV
-- =========================
CREATE TABLE RDV (
    Id_RDV INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_prestataire INT NOT NULL,
    date_ DATETIME NOT NULL,
    IsOk BOOLEAN,

    CONSTRAINT fk_rdv_user
        FOREIGN KEY (id_user)
        REFERENCES User_(Id_User)
        ON DELETE CASCADE,

    CONSTRAINT fk_rdv_prestataire
        FOREIGN KEY (id_prestataire)
        REFERENCES Prestataire(Id_Prestataire)
        ON DELETE CASCADE
);

-- =========================
-- TABLE RAPPEL
-- =========================
CREATE TABLE Rappel (
    Id_Rappel INT AUTO_INCREMENT PRIMARY KEY,
    id_RDV INT NOT NULL,
    delai VARCHAR(50),
    type VARCHAR(50),

    CONSTRAINT fk_rappel_rdv
        FOREIGN KEY (id_RDV)
        REFERENCES RDV(Id_RDV)
        ON DELETE CASCADE
);

-- =========================
-- TABLE LOCAL
-- =========================
CREATE TABLE Local (
    id_prestataire INT PRIMARY KEY,
    id_adresse INT NOT NULL,

    CONSTRAINT fk_local_prestataire
        FOREIGN KEY (id_prestataire)
        REFERENCES Prestataire(Id_Prestataire)
        ON DELETE CASCADE,

    CONSTRAINT fk_local_adresse
        FOREIGN KEY (id_adresse)
        REFERENCES Adresse(Id_Adresse)
        ON DELETE CASCADE
);


/* ============================================================
   INSERTIONS DE DONNEES DE TEST
   ============================================================ */

-- =========================
-- USERS
-- =========================
INSERT INTO User_ (email, mdp, nom, prenom, tel) VALUES
('sebastien@mail.com', '1234', 'Cossus', 'Sebastien', '0606060606'),
('dylan@mail.com', 'abcd', 'Cossus', 'Dylan', '0606060616');

-- =========================
-- PRESTATAIRES
-- =========================
INSERT INTO Prestataire (nom, prenom) VALUES
('Martin', 'Paul'),
('Durand', 'Sophie'),
('Seb', 'Cos');

-- =========================
-- ADRESSES
-- =========================
INSERT INTO Adresse (rue, numero, codePostal, ville) VALUES
('Avenue Victor Hugo', '55', '13090', 'Aix-en-Provence'),
('Boulevard National', '12', '13001', 'Marseille');

-- =========================
-- LOCAL
-- =========================
INSERT INTO Local (id_prestataire, id_adresse) VALUES
(1, 1),
(2, 2);

-- =========================
-- RDV
-- =========================
INSERT INTO RDV (id_user, id_prestataire, date_, IsOk) VALUES
(1, 1, '2026-03-01 14:00:00', TRUE),
(2, 2, '2026-03-02 10:00:00', FALSE);

-- =========================
-- RAPPELS
-- =========================
INSERT INTO Rappel (id_RDV, delai, type) VALUES
(1, '24h', 'Email'),
(1, '1h', 'SMS'),
(2, '2h', 'Email');
