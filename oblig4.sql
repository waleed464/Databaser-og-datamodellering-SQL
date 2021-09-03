-- Oppgave 1
SELECT filmcharacter AS rollefigurnavn , COUNT(filmcharacter) AS forekomste
FROM filmcharacter
GROUP BY filmcharacter
HAVING count(filmcharacter) > 2000
ORDER BY forekomste DESC;

-- Oppgave 2a
SELECT f.title, f.prodyear
FROM film AS f INNER JOIN filmparticipation USING (filmid) INNER JOIN person USING (personid)
WHERE firstname = 'Stanley' AND lastname = 'Kubrick' AND parttype = 'director';

-- Oppgave 2b
SELECT f.title, f.prodyear
FROM film AS f NATURAL JOIN filmparticipation NATURAL JOIN person
WHERE firstname = 'Stanley' AND lastname = 'Kubrick' AND parttype = 'director';

-- Oppgave 2C
SELECT f.title, f.prodyear
FROM film f, filmparticipation fp, person p
WHERE f.filmid = fp.filmid AND fp.personid = p.personid AND p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'director';

-- Oppgave 3
SELECT p.personid, p.firstname || ' ' || p.lastname AS fullt_navn, title AS  filmtittelen, country AS land
FROM person AS p INNER JOIN filmparticipation USING(personid) INNER JOIN filmcharacter USING (partid) INNER JOIN film USING(filmid)
INNER JOIN filmcountry USING (filmid)
WHERE p.firstname = 'Ingrid' AND filmcharacter = 'Ingrid';

-- Oppgave 4
SELECT f.filmid, f.title, COUNT(genre) AS antall_sjangre
FROM film f LEFT JOIN filmgenre USING (filmid)
WHERE title LIKE '%Antoine %'
GROUP BY f.filmid , f.title;

-- Oppgave 5
SELECT title AS  filmtittel, fp.parttype AS deltagelsestype, COUNT(fp.parttype) AS antall_deltagere
FROM filmparticipation fp NATURAL JOIN film NATURAL JOIN filmitem
WHERE title LIKE '%Lord of the Rings%' AND filmtype = 'C'
GROUP BY title, fp.parttype;

-- Oppgave 6
SELECT title, prodyear AS produksjonsår
FROM film
WHERE prodyear = (SELECT MIN(prodyear) FROM film);

-- Oppgave 7
SELECT title, prodyear AS produksjonsår
FROM film f INNER JOIN filmgenre fg1 USING(filmid) INNER JOIN filmgenre fg2 USING(filmid)
WHERE fg1.genre = 'Comedy' AND fg2.genre = 'Film-Noir';

-- Oppgave 8
SELECT title, prodyear AS produksjonsår
FROM film
WHERE prodyear = (SELECT MIN(prodyear) FROM film)
UNION ALL
SELECT title, prodyear AS produksjonsår
FROM film f INNER JOIN filmgenre fg1 USING(filmid) INNER JOIN filmgenre fg2 USING(filmid)
WHERE fg1.genre = 'Comedy' AND fg2.genre = 'Film-Noir';

-- Oppgave 9
SELECT f.title, f.prodyear
FROM film AS f NATURAL JOIN filmparticipation NATURAL JOIN person
WHERE firstname = 'Stanley' AND lastname = 'Kubrick' AND parttype = 'director'
INTERSECT
SELECT f.title, f.prodyear
FROM film AS f NATURAL JOIN filmparticipation NATURAL JOIN person
WHERE firstname = 'Stanley' AND lastname = 'Kubrick' AND parttype = 'cast';

-- Oppgave 10
SELECT maintitle
FROM filmrating fr INNER JOIN series s ON (fr.filmid = s.seriesid)
WHERE fr.votes > 1000 AND fr.rank = (SELECT MAX(fr.rank) FROM filmrating fr WHERE fr.votes > 1000);

-- Oppgave 11
SELECT fc.country
FROM filmcountry fc
GROUP BY fc.country
HAVING COUNT(fc.country) = 1;

-- Oppgave 12
WITH unike AS (
    SELECT *
    FROM (SELECT filmcharacter, COUNT(*) FROM filmcharacter GROUP BY filmcharacter HAVING COUNT(*) = 1) AS uc, filmcharacter AS fc
    WHERE uc.filmcharacter = fc.filmcharacter
)
SELECT firstname ||''|| lastname AS skuespiller_navn, COUNT(*) AS antall_filmer
FROM person NATURAL JOIN filmparticipation NATURAL JOIN unike
GROUP BY skuespiller_navn
HAVING COUNT(*) > 199;

-- Oppgave 13
SELECT firstname AS fornavn, lastname AS etternavn
FROM film NATURAL JOIN person NATURAL JOIN filmrating NATURAL JOIN filmparticipation
WHERE parttype = 'director' AND votes > 60000
EXCEPT
SELECT firstname AS fornavn, lastname AS etternavn
FROM film NATURAL JOIN person NATURAL JOIN filmrating NATURAL JOIN filmparticipation
WHERE parttype = 'director' AND votes > 60000 AND rank < 8;
