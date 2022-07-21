DROP TABLE bycie_z
DROP TABLE napisal
DROP TABLE zamowienie_do_hurtowni
DROP TABLE hurtownia
DROP TABLE zamowienie_od_klienta
DROP TABLE klient
DROP TABLE osoba_prawna
DROP TABLE zamowione_ksiazki
DROP TABLE zamowienie
DROP TABLE wydanie
DROP TABLE wydawnictwo
DROP TABLE gatunek
DROP TABLE autor
DROP TABLE ksiazka


CREATE TABLE ksiazka (
  ISBN CHAR(13) PRIMARY KEY CHECK (ISBN not like '%[^0-9]%'),
  tytul VARCHAR(30) CHECK (LEN(tytul) >= 3)
);

CREATE TABLE autor (
  imie VARCHAR(30) CHECK (LEN(imie) >= 3),
  nazwisko VARCHAR(30) CHECK (LEN(nazwisko) >= 3),
  narodowosc VARCHAR(30) CHECK (LEN(narodowosc) >= 3),
  rok_urodzenia CHAR(4) CHECK (rok_urodzenia not like '%[^0-9]%'),
  PRIMARY KEY (imie, nazwisko)
);

CREATE TABLE gatunek (
  nazwa VARCHAR(30) CHECK (LEN(nazwa) >= 3) PRIMARY KEY
);

CREATE TABLE wydawnictwo (
  nazwa VARCHAR(40) PRIMARY KEY CHECK (LEN(nazwa) >= 3),
  adres VARCHAR(50) CHECK (LEN(adres) >=	3),
  rok_zalozenia CHAR(4) CHECK (rok_zalozenia not like '%[^0-9]%')
);

CREATE TABLE wydanie (
  nazwa_wydawnictwa VARCHAR(40) REFERENCES wydawnictwo ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  ISBN_ksiazki CHAR(13) REFERENCES ksiazka ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  data_rozpoczecia DATE,
  data_zakonczenia DATE,
  PRIMARY KEY (nazwa_wydawnictwa, ISBN_ksiazki)
);

CREATE TABLE zamowienie (
  numer_zamowienia INT IDENTITY(1,1) PRIMARY KEY,
  [data] DATETIME CHECK([data] <= GETDATE())
);

CREATE TABLE zamowione_ksiazki (
  numer_zamowienia INT REFERENCES zamowienie ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  ISBN_ksiazki CHAR(13) NOT NULL,
  nazwa_wydawnictwa VARCHAR(40) NOT NULL,
  ilosc INT CHECK(ilosc >= 0),
  CONSTRAINT wydanieKey FOREIGN KEY (nazwa_wydawnictwa, ISBN_ksiazki) REFERENCES wydanie (nazwa_wydawnictwa, ISBN_ksiazki) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (numer_zamowienia, ISBN_ksiazki, nazwa_wydawnictwa),
);

CREATE TABLE osoba_prawna (
  id INT PRIMARY KEY IDENTITY(1,1),
  nr_telefonu CHAR(9) CHECK (nr_telefonu not like '%[^0-9]%'),
  osoba_kontaktowa VARCHAR(40) CHECK(LEN(osoba_kontaktowa) >= 3),
  adres VARCHAR(50) CHECK(LEN(adres) >= 3)
);

CREATE TABLE klient (
  id INT PRIMARY KEY REFERENCES osoba_prawna ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  dolaczenie DATE CHECK(dolaczenie <= GETDATE()),
  punkty INT CHECK(punkty >= 0),
  ostatnia_aktywnosc DATE CHECK(ostatnia_aktywnosc <= GETDATE())
);

CREATE TABLE zamowienie_od_klienta (
  id_klienta INT REFERENCES klient ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  numer_zamowienia INT REFERENCES zamowienie ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  sposob_dostawy VARCHAR(40) CHECK(LEN(sposob_dostawy) >= 3),
  platnosci NVARCHAR (30) NOT NULL CHECK ([platnosci] IN('przelew', 'BLIK', 'karta_przy_odbiorze', 'gotowka_przy_odbiorze')) DEFAULT 'BLIK',
  PRIMARY KEY (id_klienta, numer_zamowienia)
);

CREATE TABLE hurtownia (
  id INT PRIMARY KEY REFERENCES osoba_prawna ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  strona_internetowa VARCHAR(70) CHECK(LEN(strona_internetowa) >= 5),
  godzina_otwarcia TIME,
  godzina_zamkniecia TIME,
  NIP INT UNIQUE CHECK(NIP > 0),
  sposob_zaladunku NVARCHAR (4) NOT NULL CHECK ([sposob_zaladunku] IN('bok', 'tyl', 'gora')) DEFAULT 'bok',
);

CREATE TABLE zamowienie_do_hurtowni (
  id_hurtowni INT REFERENCES hurtownia ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  numer_zamowienia INT REFERENCES zamowienie ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  id_przewoznika INT IDENTITY (1,1),
  PRIMARY KEY (id_hurtowni, numer_zamowienia)
);

CREATE TABLE napisal (
  ISBN_ksiazki CHAR(13) REFERENCES ksiazka ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  imie_autora VARCHAR(30) NOT NULL,
  nazwisko_autora VARCHAR(30) NOT NULL,
  CONSTRAINT autorKey FOREIGN KEY (imie_autora, nazwisko_autora) REFERENCES autor (imie, nazwisko) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (ISBN_ksiazki, imie_autora, nazwisko_autora)
);

CREATE TABLE bycie_z (
  ISBN_ksiazki CHAR(13) REFERENCES ksiazka ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  nazwa_gatunku VARCHAR(30) REFERENCES gatunek ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  PRIMARY KEY (ISBN_ksiazki, nazwa_gatunku)
);