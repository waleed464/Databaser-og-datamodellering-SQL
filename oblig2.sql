
-- Oppgave 2

--a)  Timelistelinjer som er lagt inn for timeliste nummer 3
SELECT * FROM timelistelinje WHERE timelistenr = 3;
--b) Antall timelister
SELECT COUNT(*) FROM timeliste;
--c) Antall timelister som det ikke er utbetalt penger for
SELECT COUNT(*) FROM timeliste WHERE status != 'utbetalt';
--d)
-- Antall timelistelinjer både med og uten pauseverdi
SELECT COUNT(*) AS antall , COUNT(pause) AS antallmedpause FROM timelistelinje;
--e) Alle timelistelinjer som ikke har pauseverdier
SELECT *  FROM timelistelinje WHERE pause IS Null;

-- Oppgave 3

--a)  Antall timer som det ikke er utbetalt penger for
SELECT ((SUM(varighet))/60.0) AS timer_ikkeutbetalt FROM varighet AS v INNER JOIN timeliste AS t ON(t.timelistenr = v.timelistenr) WHERE t.status != 'utbetalt';
--b) timelister (nr og beskrivelse) som har en timelistelinje med en beskrivelse som inneholder ’test’ eller ’Test’.
SELECT DISTINCT t.timelistenr, t.beskrivelse FROM timeliste AS t INNER JOIN timelistelinje AS tl ON (t.timelistenr = tl.timelistenr) WHERE tl.beskrivelse SIMILAR TO '%(T|t)est%';
--c) penger som har blitt utbetalt, dersom man blir utbetalt 200 kr per time
SELECT (((SUM(varighet))/60.0)*200) AS penger_utbetalt FROM varighet AS v INNER JOIN timeliste AS t ON(t.timelistenr = v.timelistenr) WHERE t.status = 'utbetalt';

-- Oppgave 4
/*
a) De to spørringer IKKE GIR likt svar fordi NATURAL JOIN joiner kun de kolonner som har samme navn med
   samme innhold. I dette tilfellet har vi to kolonner som har samme navn, timelistenr og beskrivelse. Men dette
   gjelder bare for et tilfellet med samme innhold, altså i timelistenr 2. Derimot å koble sammen to tabeller ved bruk av
   INNER JOIN, samtidig som vi presiserer at det joines på grunnlag av timelistenr, reulteres det i
   hele 34 rader.

 b) De to spørringer GIR likt svar ettersom det er kun en felles kolonne "timelistenr" å joines på i begge tabellene.
 */
