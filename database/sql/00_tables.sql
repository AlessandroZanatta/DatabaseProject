-------------------------------------------------------------------------------------
-- STARTUP / CLEANUP
-------------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS SistemaTrasportoUrbano CASCADE;
CREATE SCHEMA SistemaTrasportoUrbano;
SET search_path TO SistemaTrasportoUrbano;

-------------------------------------------------------------------------------------
-- DOMAINS
-------------------------------------------------------------------------------------

CREATE DOMAIN NomeFermata               AS VARCHAR(64);
CREATE DOMAIN NumeroLineaTrasporto      AS VARCHAR(4); -- Might also be something like "B" as in Udine
CREATE DOMAIN TargaAutobus              AS CHAR(7) 
    CHECK( VALUE ~ '^[A-Z]{2}[0-9]{3}[A-Z]{2}$' ); -- Check that the plate is a valid one
CREATE DOMAIN NumeroTessera             AS VARCHAR(16);
CREATE DOMAIN CodiceFiscale             AS VARCHAR(16) 
    CHECK( VALUE ~ '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$' ); -- ValiDATE fiscal code
CREATE DOMAIN Nome                      AS VARCHAR(256);
CREATE DOMAIN Cognome                   AS VARCHAR(256);
CREATE DOMAIN LuogoResidenza            AS VARCHAR(256);
CREATE DOMAIN DataNascita               AS DATE;
CREATE DOMAIN numeroTesseraScaduta      AS VARCHAR(10);
CREATE DOMAIN DataInizio                AS DATE;
CREATE DOMAIN NumeroPatente             AS CHAR(10) 
    CHECK( VALUE ~ 'U1[0-9]{7}[A-Z]{1}' );
CREATE DOMAIN NumeroTelefono            AS VARCHAR(10) 
    CHECK( VALUE ~ '^[0-9]{10}$' );
CREATE DOMAIN DataOra                   AS TIMESTAMP;

-------------------------------------------------------------------------------------
-- TYPES
-------------------------------------------------------------------------------------

CREATE TYPE TipoAbbonamento             AS ENUM ('mensile', 'trimestrale', 'annuale');

-------------------------------------------------------------------------------------
-- TABLES
-------------------------------------------------------------------------------------

CREATE TABLE Fermata (
    Nome      NomeFermata PRIMARY KEY,
    Indirizzo VARCHAR(256)
);

CREATE TABLE LineaTrasportoUrbano (
    Numero        NumeroLineaTrasporto PRIMARY KEY,
    NumeroFermate INTEGER NOT NULL check(NumeroFermate > 0)
);

CREATE TABLE Composto (
    Posizione     INTEGER NOT NULL,
    NumeroLinea   NumeroLineaTrasporto REFERENCES LineaTrasportoUrbano(Numero) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    NomeFermata   NomeFermata REFERENCES Fermata(Nome) 
        ON UPDATE CASCADE ON DELETE CASCADE,

    PRIMARY KEY (NumeroLinea,NomeFermata)
);

CREATE TABLE Autobus (
    Targa   TargaAutobus PRIMARY KEY,
    InPiedi INTEGER NOT NULL CHECK(InPiedi >= 0),
    Seduti  INTEGER NOT NULL CHECK(Seduti >= 0),

    CHECK(InPiedi + Seduti > 0)
);

CREATE TABLE Tessera (
    NumeroTessera NumeroTessera PRIMARY KEY
);

CREATE TABLE Cliente (
    CodiceFiscale  CodiceFiscale PRIMARY KEY,
    Nome           Nome           NOT NULL,
    Cognome        Cognome        NOT NULL,
    LuogoResidenza LuogoResidenza NOT NULL,
    DataNascita    DataNascita    NOT NULL,
    NumeroTelefono NumeroTelefono NOT NULL,
    Tessera        NumeroTessera  NOT NULL,
    
    FOREIGN KEY(Tessera) REFERENCES Tessera(NumeroTessera)
);

CREATE TABLE Autista (
    CodiceFiscale  CodiceFiscale PRIMARY KEY,
    Nome           Nome           NOT NULL,
    Cognome        Cognome        NOT NULL,
    LuogoResidenza LuogoResidenza NOT NULL,
    DataNascita    DataNascita    NOT NULL,
    NumeroPatente  NumeroPatente  NOT NULL
);

CREATE TABLE Telefono (
    Numero  NumeroTelefono,
    Autista CodiceFiscale NOT NULL,
    PRIMARY KEY(Numero),
    FOREIGN KEY(Autista) REFERENCES Autista(CodiceFiscale)
);

CREATE TABLE ServitaDa (
    Targa       TargaAutobus REFERENCES Autobus(Targa) 
        on UPDATE CASCADE on DELETE CASCADE,
    NumeroLinea NumeroLineaTrasporto REFERENCES LineaTrasportoUrbano(Numero) 
        on UPDATE CASCADE on DELETE CASCADE,

    PRIMARY KEY (NumeroLinea,Targa)
);

CREATE TABLE Abbonamento (
    DataInizio      DataInizio,
    Tessera         NumeroTessera REFERENCES Tessera(NumeroTessera),
    TipoAbbonamento TipoAbbonamento NOT NULL,

    PRIMARY KEY(DataInizio,Tessera)
);

CREATE TABLE Scaduto (
    Tessera    NumeroTessera NOT NULL,
    DataInizio DataInizio    NOT NULL,

    PRIMARY KEY(Tessera, DataInizio),
    FOREIGN KEY(Tessera, DataInizio) REFERENCES Abbonamento(Tessera, DataInizio)
);

CREATE TABLE Valido (
    Tessera    NumeroTessera NOT NULL,
    DataInizio DataInizio    NOT NULL,

    PRIMARY KEY(Tessera, DataInizio),
    FOREIGN KEY(Tessera, DataInizio) REFERENCES Abbonamento(Tessera, DataInizio)
);

/* Temporary fix */

CREATE TABLE HaEseguito (
    Id      INTEGER PRIMARY KEY, -- Added as a fix
    Autobus TargaAutobus REFERENCES Autobus(Targa) 
        on UPDATE CASCADE on DELETE CASCADE,
    Autista CodiceFiscale REFERENCES Autista(CodiceFiscale) 
        on UPDATE CASCADE on DELETE CASCADE,
    DataOra DataOra CHECK (DataOra <= NOW())

    -- PRIMARY KEY (Autobus, Autista, DataOra)
);

CREATE TABLE Corsa (
    NumeroLinea NumeroLineaTrasporto REFERENCES LineaTrasportoUrbano(Numero) 
        on UPDATE CASCADE on DELETE CASCADE,
    EseguitoId  INTEGER REFERENCES HaEseguito(Id) 
        on UPDATE CASCADE on DELETE CASCADE,
    PRIMARY KEY (NumeroLinea, EseguitoId)
);

CREATE TABLE HaUsufruito (
    Cliente     CodiceFiscale REFERENCES Cliente(CodiceFiscale)
        on UPDATE CASCADE on DELETE CASCADE,
    EseguitoId  INTEGER,
    NumeroLinea NumeroLineaTrasporto,

    PRIMARY KEY (Cliente, EseguitoId, NumeroLinea),
    FOREIGN KEY (EseguitoId, NumeroLinea) REFERENCES Corsa(EseguitoId, NumeroLinea)
);

/* End of temporary fix */
