--1 Wszystkie ksi¹¿ki autora Jakub Wojewoda
SELECT * FROM ksiazka
	WHERE ISBN IN (
		SELECT ISBN_ksiazki FROM napisal
			WHERE imie_autora = 'Jakub' AND nazwisko_autora = 'Wojewoda');

--2 Poka¿ wszystkich klientów którzy wykonali co najmniej 1 zamówienie w ci¹gu ostatniego roku.
SELECT * FROM klient
	WHERE id IN (
		SELECT id FROM klient
			GROUP BY id
			HAVING id IN 
				(SELECT id_klienta FROM zamowienie_od_klienta
				WHERE numer_zamowienia IN
					(SELECT numer_zamowienia FROM zamowienie
					WHERE [data] >= DATEADD(YEAR, -1, GETDATE()))));

--3 Poka¿ ostatnie zamówienie klienta o id 5 którego sposób dostawy by³ paczkomat.
SElECT TOP(1) zamowienie.numer_zamowienia, zamowienie.[data] FROM zamowienie
	zamowienie JOIN zamowienie_od_klienta
		ON zamowienie.numer_zamowienia = zamowienie_od_klienta.numer_zamowienia
	WHERE zamowienie_od_klienta.id_klienta = 5 AND
	zamowienie_od_klienta.sposob_dostawy = 'paczkomat'
	ORDER BY zamowienie.[data] DESC;

--4 Poka¿ który klient zamówi³ najwiêcej ksi¹¿ek w ostatnim miesi¹cu.
SELECT TOP(1) SUM(ilosc) AS ilosc, id FROM klient
	klient JOIN zamowienie_od_klienta
		ON klient.id = zamowienie_od_klienta.id_klienta
	JOIN zamowione_ksiazki
		ON zamowienie_od_klienta.numer_zamowienia = zamowione_ksiazki.numer_zamowienia
	JOIN zamowienie
		ON zamowienie.numer_zamowienia = zamowienie_od_klienta.numer_zamowienia
	WHERE zamowienie.[data] >= DATEADD(MONTH, -1, GETDATE())
	GROUP BY id
	ORDER BY ilosc DESC;

--5 Wyœwietl wszystkie ksi¹¿ki z ksiêgarni wraz z ich autorami.
GO
CREATE VIEW ksiazki_i_autorzy (ISBN, tytul, imie_autora, nazwisko_autora)
	AS SELECT ksiazka.ISBN, ksiazka.tytul, autor.imie, autor.nazwisko
		FROM ksiazka, autor
		WHERE ksiazka.ISBN IN (
			SELECT ISBN_ksiazki FROM napisal
				WHERE imie_autora = autor.imie AND nazwisko_autora = autor.nazwisko)
	WITH CHECK OPTION;
GO
SELECT * FROM ksiazki_i_autorzy;
DROP VIEW ksiazki_i_autorzy;

--6 Poka¿ ile hurtowni wspó³pracuje z ksiêgarni¹
SELECT COUNT(DISTINCT id) AS ilosc_hurtowni FROM hurtownia;

--7 Wszystkie ksi¹¿ki polskich autorów
SELECT ksiazka.ISBN, ksiazka.tytul, autor.imie, autor.nazwisko, autor.narodowosc, autor.rok_urodzenia FROM ksiazka
	ksiazka JOIN napisal
		ON ksiazka.ISBN = napisal.ISBN_ksiazki
	JOIN autor 
		ON autor.imie = napisal.imie_autora AND autor.nazwisko = napisal.nazwisko_autora
	WHERE autor.narodowosc = 'Polska'

