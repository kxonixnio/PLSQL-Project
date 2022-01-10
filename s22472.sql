/*
Si³ownia
Baza danych dotycz¹ca lokalnej si³owni. Przechowuje ona informacje o pracownikach (ich stanowiskach, zmianach i mieœcie zamieszkania) oraz klientach (ich karnetach oraz mieœcie zamieszkania)

-Ka¿dy pracownik posiada id, imiê, nazwisko, telefon kontaktowy, w³asn¹ premiê oraz informacjê o mieœcie zamieszkania i zajmowanym stanowisku.
-Ka¿dy klient posiada id, imiê, nazwisko, telefon kontaktowy oraz informacjê o mieœcie zamieszkania i posiadanym karnecie
-Ka¿dy karnet posiada id, datê wydania oraz swój rodzaj.
-Ka¿dy rodzaj karnetu ma swoje id, nazwê oraz iloœæ dni, przez któr¹ jest wa¿ny.
-Ka¿de stanowisko ma swoje id, nazwê i stawkê na godzinê.
-Ka¿da zmiana ma swoje id oraz informacjê o dacie, pracowniku którego zmiana ta dotyczy oraz iloœci czasu jak¹ przepracowa³.
-Zak³adamy, ¿e pracownik nie mo¿e byæ klientem - to jest nie posiada karnetu (mo¿e korzystaæ z si³owni za darmo)
*/

/*
Procedura dropujaca tabele, jesli ta istnieje
(Procedura pomocnicza)
*/
CREATE OR REPLACE PROCEDURE DropTable
(tableName VARCHAR2)
AS
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || tableName || ' CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

--"Drop table if exists"
EXECUTE DropTable('STANOWISKO');
/
EXECUTE DropTable('PRACOWNIK');
/
EXECUTE DropTable('MIASTO');
/
EXECUTE DropTable('KLIENT');
/
EXECUTE DropTable('KARNET');
/
EXECUTE DropTable('RODZAJ');
/
EXECUTE DropTable('ZMIANA');
/

-- Stworzenie tabel
-- Table: karnet
CREATE TABLE karnet (
    id_karnet int  NOT NULL,
    data_wydania date  NOT NULL,
    id_rodzaj int  NOT NULL,
    CONSTRAINT karnet_pk PRIMARY KEY  (id_karnet)
);
/

-- Table: klient
CREATE TABLE klient (
    id_klient int  NOT NULL,
    imie varchar2(20)  NOT NULL,
    nazwisko varchar2(20)  NOT NULL,
    telefon number(9,0)  NOT NULL,
    id_miasto int  NOT NULL,
    id_karnet int  NOT NULL,
    CONSTRAINT klient_pk PRIMARY KEY  (id_klient)
);
/

-- Table: miasto
CREATE TABLE miasto (
    id_miasto int  NOT NULL,
    miasto varchar2(20)  NOT NULL,
    CONSTRAINT miasto_pk PRIMARY KEY  (id_miasto)
);
/

-- Table: pracownik
CREATE TABLE pracownik (
    id_pracownik int  NOT NULL,
    imie varchar2(20)  NOT NULL,
    nazwisko varchar2(20)  NOT NULL,
    telefon number(9,0)  NOT NULL,
    premia number(10,4)  NOT NULL,
    id_miasto int  NOT NULL,
    id_stanowisko int  NOT NULL,
    CONSTRAINT pracownik_pk PRIMARY KEY  (id_pracownik)
);
/

-- Table: rodzaj
CREATE TABLE rodzaj (
    id_rodzaj int  NOT NULL,
    nazwa varchar2(20)  NOT NULL,
    ilosc_dni int  NOT NULL,
    CONSTRAINT rodzaj_pk PRIMARY KEY  (id_rodzaj)
);
/

-- Table: stanowisko
CREATE TABLE stanowisko (
    id_stanowisko int  NOT NULL,
    nazwa varchar2(20)  NOT NULL,
    stawka number(10,4)  NOT NULL,
    CONSTRAINT stanowisko_pk PRIMARY KEY  (id_stanowisko)
);
/

-- Table: zmiana
CREATE TABLE zmiana (
    id_zmiany int  NOT NULL,
    data date  NOT NULL,
    czas_pracy number(3,1)  NOT NULL,
    id_pracownik int  NOT NULL,
    CONSTRAINT zmiana_pk PRIMARY KEY  (id_zmiany)
);
/

-- Klucze
-- Reference: karnet_rodzaj (table: karnet)
ALTER TABLE karnet ADD CONSTRAINT karnet_rodzaj
    FOREIGN KEY (id_rodzaj)
    REFERENCES rodzaj (id_rodzaj);
/

-- Reference: klient_karnet (table: klient)
ALTER TABLE klient ADD CONSTRAINT klient_karnet
    FOREIGN KEY (id_karnet)
    REFERENCES karnet (id_karnet);
/

-- Reference: klient_miasto (table: klient)
ALTER TABLE klient ADD CONSTRAINT klient_miasto
    FOREIGN KEY (id_miasto)
    REFERENCES miasto (id_miasto);
/

-- Reference: pracownik_miasto (table: pracownik)
ALTER TABLE pracownik ADD CONSTRAINT pracownik_miasto
    FOREIGN KEY (id_miasto)
    REFERENCES miasto (id_miasto);
/

-- Reference: pracownik_stanowisko (table: pracownik)
ALTER TABLE pracownik ADD CONSTRAINT pracownik_stanowisko
    FOREIGN KEY (id_stanowisko)
    REFERENCES stanowisko (id_stanowisko);
/

-- Reference: zmiana_pracownik (table: zmiana)
ALTER TABLE zmiana ADD CONSTRAINT zmiana_pracownik
    FOREIGN KEY (id_pracownik)
    REFERENCES pracownik (id_pracownik);
/
-- End of file.

--Inserty
INSERT INTO miasto VALUES (0, 'WARSZAWA');
/
INSERT INTO miasto VALUES (1, 'PIASECZNO');
/
INSERT INTO miasto VALUES (2, 'PIASTOW');
/

INSERT INTO stanowisko VALUES (0, 'RECEPCJA', 22);
/
INSERT INTO stanowisko VALUES (1, 'TRENER', 27);
/
INSERT INTO stanowisko VALUES (2, 'MANAGER', 50);
/

INSERT INTO rodzaj VALUES (0, 'STANDARD', 30);
/
INSERT INTO rodzaj VALUES (1, 'STANDARD', 60);
/
INSERT INTO rodzaj VALUES (2, 'STANDARD', 90);
/
INSERT INTO rodzaj VALUES (3, 'PREMIUM', 30);
/
INSERT INTO rodzaj VALUES (4, 'PREMIUM', 60);
/
INSERT INTO rodzaj VALUES (5, 'PREMIUM', 90);
/
INSERT INTO rodzaj VALUES (6, 'VIP', 30);
/
INSERT INTO rodzaj VALUES (7, 'VIP', 60);
/
INSERT INTO rodzaj VALUES (8, 'VIP', 90);
/

INSERT INTO karnet VALUES (0, '2020-05-01', 0);
/
INSERT INTO karnet VALUES (1, '2020-05-01', 0);
/
INSERT INTO karnet VALUES (2, '2020-05-03', 0);
/
INSERT INTO karnet VALUES (3, '2020-05-03', 2);
/
INSERT INTO karnet VALUES (4, '2020-05-03', 3);
/
INSERT INTO karnet VALUES (5, '2020-05-03', 4);
/
INSERT INTO karnet VALUES (6, '2020-05-04', 4);
/
INSERT INTO karnet VALUES (7, '2020-05-04', 4);
/
INSERT INTO karnet VALUES (8, '2020-05-05', 5);
/
INSERT INTO karnet VALUES (9, '2020-05-06', 8);
/
INSERT INTO karnet VALUES (10, '2020-05-07', 8);
/

INSERT INTO klient VALUES (0, 'JAN', 'PAPAYA', 502101123, 0, 0);
/
INSERT INTO klient VALUES (1, 'TOMASZ', 'HENDRICK', 798417132, 0, 1);
/
INSERT INTO klient VALUES (2, 'JERZY', 'PISZCZEK', 497614723, 0, 2);
/
INSERT INTO klient VALUES (3, 'MAGDALENA', 'MAZUREK', 791487315, 0, 3);
/
INSERT INTO klient VALUES (4, 'ALICJA', 'NESBO', 123654824, 0, 4);
/
INSERT INTO klient VALUES (5, 'ANNA', 'PIORKOWSKA', 645978357, 0, 5);
/
INSERT INTO klient VALUES (6, 'ROBERT', 'PIASECZNY', 753951486, 1, 6);
/
INSERT INTO klient VALUES (7, 'SYLWIA', 'PIASECZNA', 489276134, 1, 7);
/
INSERT INTO klient VALUES (8, 'MICHAL', 'DROPSKI', 456987789, 1, 8);
/
INSERT INTO klient VALUES (9, 'WERONIKA', 'DRZEWKO', 456789370, 2, 9);
/
INSERT INTO klient VALUES (10, 'WIKTORIA', 'CHODZKO', 498761002, 2, 10);
/

INSERT INTO pracownik VALUES (0, 'ZUZANNA', 'KUNOWSKA', 100111222, 100, 0, 0);
/
INSERT INTO pracownik VALUES (1, 'WIKTORIA', 'KOLODZIEJCZYK', 252141363, 0, 0, 0);
/
INSERT INTO pracownik VALUES (2, 'ALICJA', 'OFICJALSKA', 474585696, 300, 0, 0);
/
INSERT INTO pracownik VALUES (3, 'ALICJA', 'KUCHARSKA', 989656323, 200, 1, 0);
/
INSERT INTO pracownik VALUES (4, 'MARCIN', 'OCHMAN', 761349852, 0, 1, 0);
/
INSERT INTO pracownik VALUES (5, 'KUBA', 'STEPIEN', 793182456, 250, 2, 0);
/
INSERT INTO pracownik VALUES (6, 'NAPOLEON', 'NORKOWSKI', 456913782, 500, 1, 1);
/
INSERT INTO pracownik VALUES (7, 'MAKS', 'JELENIEWSKI', 201302403, 300, 1, 1);
/
INSERT INTO pracownik VALUES (8, 'JULIA', 'WOLSKA', 979731564, 000, 2, 1);
/
INSERT INTO pracownik VALUES (9, 'PIOTR', 'SIARA', 456654004, 800, 0, 2);
/

INSERT INTO zmiana VALUES (0, '2020-05-01', 7, 0);
/
INSERT INTO zmiana VALUES (1, '2020-05-01', 8, 1);
/
INSERT INTO zmiana VALUES (2, '2020-05-01', 6, 2);
/
INSERT INTO zmiana VALUES (3, '2020-05-02', 9, 3);
/
INSERT INTO zmiana VALUES (4, '2020-05-02', 8, 4);
/
INSERT INTO zmiana VALUES (5, '2020-05-02', 6, 5);
/
INSERT INTO zmiana VALUES (6, '2020-05-03', 8, 6);
/
INSERT INTO zmiana VALUES (7, '2020-05-03', 8, 7);
/
INSERT INTO zmiana VALUES (8, '2020-05-03', 6, 8);
/
INSERT INTO zmiana VALUES (9, '2020-05-04', 7, 0);
/
INSERT INTO zmiana VALUES (10, '2020-05-04', 10, 1);
/
INSERT INTO zmiana VALUES (11, '2020-05-04', 6, 2);
/
INSERT INTO zmiana VALUES (12, '2020-05-05', 7, 3);
/
INSERT INTO zmiana VALUES (13, '2020-05-05', 7, 4);
/
INSERT INTO zmiana VALUES (14, '2020-05-05', 10, 5);
/
INSERT INTO zmiana VALUES (15, '2020-05-06', 9, 6);
/
INSERT INTO zmiana VALUES (16, '2020-05-06', 9, 7);
/
INSERT INTO zmiana VALUES (17, '2020-05-06', 8, 0);
/
INSERT INTO zmiana VALUES (18, '2020-05-07', 9, 0);
/
INSERT INTO zmiana VALUES (19, '2020-05-07', 8, 4);
/
INSERT INTO zmiana VALUES (20, '2020-05-07', 7, 7);
/
INSERT INTO zmiana VALUES (21, '2020-05-01', 6, 9);
/
INSERT INTO zmiana VALUES (22, '2020-05-03', 8, 9);
/
INSERT INTO zmiana VALUES (23, '2020-05-05', 12, 9);
/
INSERT INTO zmiana VALUES (24, '2020-05-06', 5, 9);
/

-------------------------------------------------------------------------------------------------------------------------------
/*
Potrzebne do funkcji FN_EmployeesWorktime
Deklaracja zwracanego typu rekordowego.
Nie mo¿na zadeklarowaæ go w schemacie (?) stad deklaracja w pakiecie.
W tym samym pakiecie jest rowniez deklaracja typu tablicowego zlozonego z elementow wlasnie utworzonego typu rekordowego.
*/
CREATE OR REPLACE PACKAGE opakowanie
IS TYPE wiersz
IS RECORD(
    id INTEGER,
    czas INTEGER
);
TYPE tablica IS TABLE OF wiersz;
END;
/
/*
Potrzebne do procedury EmployeeOfTheMonthBonus.
"Funkcja tablicowa"
Funkcja zwraca tablicê elementów typu rekordowego.
Funkcja wykorzystuje stworzony wyzej typ tablicowy.
PIPELINED - funkcja strumieniowa (wiersze sa zwracane z funkcji jeden po drugim w takim tempie w jakim sa pobierane/generowane).
Nie trzeba czekac na wygenerowanie calego wyniku jak w przypadku funkcji zwracajacej tablice typu obiektowego.
*/
CREATE OR REPLACE FUNCTION FN_EmployeesWorktime(miesiac INTEGER) RETURN opakowanie.tablica PIPELINED IS
CURSOR k IS
SELECT id_pracownik, SUM(czas_pracy) czas_pracy
FROM zmiana
WHERE EXTRACT(MONTH FROM data) = miesiac AND EXTRACT(YEAR FROM data) = 2020
GROUP BY id_pracownik;
/*
Deklaracja pojedynczego elementu do którego wrzucany bedzie zczytany z kursora wiersz.
Jest to potrzebne, poniewa¿ zwracana jest tablica, ale wiersz po wierszu (bo ni¿ej u¿yty jest PIPE ROW, który nie mo¿e zwracaæ tablicy).
Stad potrzebny element, ktory bedzie "kontenerem" na kolejne zwracane wiersze.
(PIPE ROW - zwrocenie kolejnego elementu z funkcji)
*/
w opakowanie.wiersz;
BEGIN
    OPEN k;
        LOOP
        FETCH k INTO w;
        EXIT WHEN k%notfound;
        PIPE ROW(w);
        END LOOP;
    CLOSE k;
--RETURN jest tu z kwestii formalnych - sam zwrot danych zrealizowany zostal wczesniej z uzyciem PIPE ROW
RETURN;
END;
/
SELECT * FROM TABLE(FN_EmployeesWorktime(5));


/*
Procedura, która przyjmuj¹c jako parametr numer miesi¹ca zwiêksza premiê pracownika, który przepracowa³ najwiêcej godzin w podanym miesi¹cu.
Premia wynosi œredni¹ premii wszystkich pracowników, którzy pracuj¹ na tym samym stanowisku, co premiowany pracownik.
Pracowników miesi¹ca mo¿e byæ kilku (je¿eli suma przepracowanych godzin tych pracowników jest równa sobie i wiêksza wzglêdem pozosta³ych pracowników)
*/

SET Serveroutput ON;
dbms_output.enable; 

CREATE OR REPLACE PROCEDURE EmployeeOfTheMonthBonus(miesiac INTEGER)
AS
CURSOR cur IS SELECT id, czas 
                FROM TABLE(FN_EmployeesWorktime(miesiac)) 
                WHERE czas = (SELECT MAX(czas) FROM TABLE(FN_EmployeesWorktime(miesiac)));
current_emp_id  zmiana.id_pracownik%type;
current_emp_time zmiana.czas_pracy%type;
current_emp_bonus pracownik.premia%type;
current_emp_name_and_surname pracownik.imie%type;
BEGIN
    IF miesiac < 1 OR miesiac > 12 THEN
        Raise_application_error(-20100,'Month must be between 1 and 12!') ;
    END IF;
    
    OPEN cur;
    LOOP
    
        FETCH cur INTO current_emp_id, current_emp_time;
        EXIT WHEN cur%NOTFOUND;
        
        SELECT AVG(premia) INTO current_emp_bonus
        FROM pracownik
        WHERE id_stanowisko = (
                                SELECT id_stanowisko
                                FROM pracownik
                                WHERE id_pracownik = current_emp_id
                                );
        
        --https://www.techonthenet.com/oracle/functions/concat.php
        SELECT CONCAT(CONCAT(imie, ' '), nazwisko) INTO current_emp_name_and_surname
        FROM pracownik
        WHERE id_pracownik = current_emp_id;
        
        UPDATE pracownik
        SET premia = premia + current_emp_bonus
        WHERE id_pracownik = current_emp_id;
        
        dbms_output.put_line('Premia dla pracownika ' || current_emp_name_and_surname || ' zostala podwyzszona o '|| current_emp_bonus);
    
    END LOOP;
    CLOSE cur;
    
END;


EXECUTE EmployeeOfTheMonthBonus(5);

SELECT * FROM pracownik


/*
https://stackoverflow.com/questions/1799128/oracle-if-table-exists
https://stackoverflow.com/questions/32292561/dropping-a-table-in-oracle-sql
https://stackoverflow.com/questions/29014283/sql-datatype-to-use-when-inserting-money
https://stackoverflow.com/questions/44994375/how-to-get-year-and-month-of-a-date-using-oracle/44994439
http://andrzejklusiewicz.blogspot.com/2014/12/kurs-oracle-plsql-funkcje-strumieniowe.html
https://renenyffenegger.ch/notes/development/databases/Oracle/PL-SQL/collection-types/return-table-from-function/index
https://www.techonthenet.com/oracle/functions/concat.php
*/