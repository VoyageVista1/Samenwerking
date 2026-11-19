-- VoyageVista - ERD Productontwikkeling & Inkoop (Groep 3)
-- PostgreSQL-schema, afgeleid van het ERD in Visual Paradigm.
-- Oracle-types uit het ERD: varchar2 -> VARCHAR, number(10) -> INTEGER, number(10,2) -> NUMERIC, number(1) -> BOOLEAN.

DROP TABLE IF EXISTS beoordeling, taak, reisonderdeel, reisproduct, annuleringsregel, contract, onderhandeling, aanbod, leverancier, medewerker CASCADE;

CREATE TABLE medewerker (
    medewerkerid              INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    naam                      VARCHAR(100) NOT NULL,
    email                     VARCHAR(150) NOT NULL UNIQUE,
    rol                       VARCHAR(30) NOT NULL
);

CREATE TABLE leverancier (
    leverancierid             INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    naam                      VARCHAR(100) NOT NULL,
    type                      VARCHAR(20) NOT NULL,
    adres                     VARCHAR(200) NOT NULL,
    plaats                    VARCHAR(100) NOT NULL,
    landcode                  VARCHAR(2) NOT NULL,
    contactpersoon            VARCHAR(100) NOT NULL,
    email                     VARCHAR(150) NOT NULL,
    telefoon                  VARCHAR(20) NOT NULL,
    actief                    BOOLEAN NOT NULL
);

CREATE TABLE aanbod (
    aanbodid                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    leverancierid             INTEGER NOT NULL REFERENCES leverancier (leverancierid),
    omschrijving              VARCHAR(200) NOT NULL,
    prijs                     NUMERIC(10,2) NOT NULL,
    valutacode                VARCHAR(3) NOT NULL,
    prijseenheid              VARCHAR(20) NOT NULL,
    capaciteit                INTEGER NOT NULL,
    voorwaarden               VARCHAR(1000),
    geldigvan                 DATE NOT NULL,
    geldigtot                 DATE NOT NULL
);

CREATE TABLE onderhandeling (
    onderhandelingid          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    leverancierid             INTEGER NOT NULL REFERENCES leverancier (leverancierid),
    aanbodid                  INTEGER REFERENCES aanbod (aanbodid),
    inkoperid                 INTEGER NOT NULL REFERENCES medewerker (medewerkerid),
    bezoekdatum               DATE,
    status                    VARCHAR(20) NOT NULL,
    inkoopprijs               NUMERIC(10,2),
    verkoopprijs              NUMERIC(10,2),
    volumekorting             NUMERIC(10,2),
    valutacode                VARCHAR(3),
    voorwaarden               VARCHAR(1000),
    notities                  VARCHAR(1000),
    toelichting               VARCHAR(1000)
);

CREATE TABLE contract (
    contractid                INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    leverancierid             INTEGER NOT NULL REFERENCES leverancier (leverancierid),
    onderhandelingid          INTEGER NOT NULL REFERENCES onderhandeling (onderhandelingid),
    inkoperid                 INTEGER NOT NULL REFERENCES medewerker (medewerkerid),
    begindatum                DATE NOT NULL,
    einddatum                 DATE NOT NULL,
    kamertype                 VARCHAR(30) NOT NULL,
    aantalkamerspernacht      INTEGER NOT NULL,
    aantalverkocht            INTEGER NOT NULL,
    inkoopprijs               NUMERIC(10,2) NOT NULL,
    valutacode                VARCHAR(3) NOT NULL,
    voorwaarden               VARCHAR(1000) NOT NULL,
    documentlink              VARCHAR(500) NOT NULL,
    doorgegevenaanverkoopop   DATE NOT NULL,
    versienummer              INTEGER NOT NULL,
    status                    VARCHAR(20) NOT NULL
);

CREATE TABLE annuleringsregel (
    regelid                   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contractid                INTEGER NOT NULL REFERENCES contract (contractid),
    dagenvoorvertrek          INTEGER NOT NULL,
    kostenpercentage          NUMERIC(10,2) NOT NULL
);

CREATE TABLE reisproduct (
    reisproductid             INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    eigenaarid                INTEGER NOT NULL REFERENCES medewerker (medewerkerid),
    naam                      VARCHAR(100) NOT NULL,
    bestemming                VARCHAR(100) NOT NULL,
    landcode                  VARCHAR(2) NOT NULL,
    reisduurdagen             INTEGER,
    beschrijving              VARCHAR(1000),
    doelgroep                 VARCHAR(100),
    onderzoeksinformatie      VARCHAR(1000),
    fase                      VARCHAR(20) NOT NULL,
    streefdatum               DATE,
    versienummer              INTEGER NOT NULL
);

CREATE TABLE reisonderdeel (
    reisonderdeelid           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reisproductid             INTEGER NOT NULL REFERENCES reisproduct (reisproductid),
    contractid                INTEGER REFERENCES contract (contractid),
    aanbodid                  INTEGER REFERENCES aanbod (aanbodid),
    type                      VARCHAR(20) NOT NULL,
    kamertype                 VARCHAR(30),
    langebedden               BOOLEAN NOT NULL,
    keukenblok                BOOLEAN NOT NULL,
    goedekoelkast             BOOLEAN NOT NULL,
    startdag                  INTEGER NOT NULL,
    aantaldagen               INTEGER NOT NULL,
    volgorde                  INTEGER NOT NULL
);

CREATE TABLE taak (
    taakid                    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reisproductid             INTEGER NOT NULL REFERENCES reisproduct (reisproductid),
    verantwoordelijkeid       INTEGER NOT NULL REFERENCES medewerker (medewerkerid),
    onderhandelingid          INTEGER REFERENCES onderhandeling (onderhandelingid),
    omschrijving              VARCHAR(200) NOT NULL,
    deadline                  DATE NOT NULL,
    ismijlpaal                BOOLEAN NOT NULL,
    status                    VARCHAR(10) NOT NULL
);

CREATE TABLE beoordeling (
    beoordelingid             INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    beoordelaarid             INTEGER NOT NULL REFERENCES medewerker (medewerkerid),
    reisproductid             INTEGER REFERENCES reisproduct (reisproductid),
    contractid                INTEGER REFERENCES contract (contractid),
    besluit                   VARCHAR(20) NOT NULL,
    reden                     VARCHAR(1000) NOT NULL,
    datum                     DATE NOT NULL
);
