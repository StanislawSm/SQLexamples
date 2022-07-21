--pokazanie jakiegoœ zwi¹zku zale¿y od tego jaki to ma byæ zwi¹zek, niektóre widaæ nawet w tych zapytanich:
SELECT * FROM ksiazka;
SELECT * FROM autor;
SELECT * FROM napisal;
SELECT * FROM gatunek;
SELECT * FROM bycie_z;
SELECT * FROM wydawnictwo;
SELECT * FROM wydanie;
SELECT * FROM osoba_prawna;
SELECT * FROM hurtownia;
SELECT * FROM klient;

--kaskadowy update
SELECT * FROM wydanie;
SELECT * FROM ksiazka;

UPDATE ksiazka SET ISBN = '0000000000100' WHERE ISBN = '0000000000006'

SELECT * FROM wydanie;
SELECT * FROM ksiazka;

--kaskadowy delete

SELECT * FROM wydawnictwo;
SELECT * FROM wydanie;

UPDATE wydawnictwo SET nazwa = 'Drukarna2' WHERE nazwa = 'Drukarna'

SELECT * FROM wydawnictwo;
SELECT * FROM wydanie;