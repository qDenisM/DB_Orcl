CREATE TABLE Books (
    BookID NUMBER(20) PRIMARY KEY,
    Title NVARCHAR2(100)
);

INSERT INTO Books VALUES (1, 'Путешествия Гулливера');
INSERT INTO Books VALUES (2, '1984');
INSERT INTO Books VALUES (3, 'Война и мир');
INSERT INTO Books VALUES (4, 'Остров сокровищ');
INSERT INTO Books VALUES (5, 'Улисс');
INSERT INTO Books VALUES (6, 'Американская трагедия');
INSERT INTO Books VALUES (7, 'О дивный новый мир');
INSERT INTO Books VALUES (8, 'Унесенные ветром');
INSERT INTO Books VALUES (9, 'Над пропастью во ржи');
INSERT INTO Books VALUES (10, 'Сто лет одиночества');
COMMIT;

CREATE OR REPLACE TRIGGER Before_State_Trigger
BEFORE INSERT OR DELETE OR UPDATE ON Books
BEGIN
    DBMS_OUTPUT.PUT_LINE('Before_State_Trigger executed');
END;
/

CREATE OR REPLACE TRIGGER Before_Row_Trigger
BEFORE INSERT OR DELETE OR UPDATE ON Books
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Before_Row_Trigger executed');
END;
/

CREATE OR REPLACE TRIGGER Before_Row_Trigger
BEFORE INSERT OR DELETE OR UPDATE ON Books
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('Before_Row_Trigger: INSERTING');
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('Before_Row_Trigger: UPDATING');
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Before_Row_Trigger: DELETING');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER After_State_Trigger
AFTER INSERT OR DELETE OR UPDATE ON Books
BEGIN
    DBMS_OUTPUT.PUT_LINE('After_State_Trigger executed');
END;
/

CREATE OR REPLACE TRIGGER After_Row_Trigger
AFTER INSERT OR DELETE OR UPDATE ON Books
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('After_Row_Trigger executed');
END;
/

DROP TABLE AUDIT1;
CREATE TABLE AUDIT1 (
    OperationDate DATE,
    OperationType VARCHAR2(10),
    TriggerName VARCHAR2(50),
    Data VARCHAR2(4000)
);

CREATE OR REPLACE TRIGGER Before_State_Trigger
BEFORE INSERT OR DELETE OR UPDATE ON Books
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'INSERT',
                                   'Before_State_Trigger',
                                   'Statement-level trigger');
    ELSIF UPDATING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'UPDATE',
                                   'Before_State_Trigger',
                                   'Statement-level trigger');
    ELSIF DELETING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'DELETE',
                                   'Before_State_Trigger',
                                   'Statement-level trigger');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Before_State_Trigger executed');
END;
/

CREATE OR REPLACE TRIGGER Before_Row_Trigger
BEFORE INSERT OR DELETE OR UPDATE ON Books
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'INSERT',
                                   'Before_Row_Trigger',
                                   'Old: - , New: ' || :NEW.BookID || ' - ' || :NEW.Title);
    ELSIF UPDATING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'UPDATE',
                                   'Before_Row_Trigger', 
                                   'Old: ' || :OLD.BookID || ' - ' || :OLD.Title || ', New: ' || :NEW.BookID || ' - ' || :NEW.Title);
    ELSIF DELETING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'DELETE',
                                   'Before_Row_Trigger', 
                                   'Old: ' || :OLD.BookID || ' - ' || :OLD.Title || ', New: -');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Before_Row_Trigger executed');
END;
/

CREATE OR REPLACE TRIGGER After_State_Trigger
AFTER INSERT OR DELETE OR UPDATE ON Books
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'INSERT',
                                   'After_State_Trigger',
                                   'Statement-level trigger');
    ELSIF UPDATING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'UPDATE',
                                   'After_State_Trigger',
                                   'Statement-level trigger');
    ELSIF DELETING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'DELETE',
                                   'After_State_Trigger',
                                   'Statement-level trigger');
    END IF;
    DBMS_OUTPUT.PUT_LINE('After_State_Trigger executed');
END;
/

CREATE OR REPLACE TRIGGER After_Row_Trigger
AFTER INSERT OR DELETE OR UPDATE ON Books
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'INSERT',
                                   'After_Row_Trigger', 
                                   'Old: - , New: ' || :NEW.BookID || ' - ' || :NEW.Title);
    ELSIF UPDATING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE,
                                   'UPDATE',
                                   'After_Row_Trigger', 
                                   'Old: ' || :OLD.BookID || ' - ' || :OLD.Title || ', New: ' || :NEW.BookID || ' - ' || :NEW.Title);
    ELSIF DELETING THEN
        INSERT INTO AUDIT1 VALUES (SYSDATE, 
                                   'DELETE',
                                   'After_Row_Trigger', 
                                   'Old: ' || :OLD.BookID || ' - ' || :OLD.Title || ', New: -');
    END IF;
    DBMS_OUTPUT.PUT_LINE('After_Row_Trigger executed');
END;
/

INSERT INTO Books VALUES (2, 'Дубликат');

DROP TABLE Books;

CREATE OR REPLACE TRIGGER Prevent_Drop_Books_Trigger
BEFORE DROP ON SCHEMA
BEGIN
    IF ORA_DICT_OBJ_NAME = 'BOOKS' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot drop Books table');
    END IF;
END;
/

DROP TABLE AUDIT1;

CREATE TABLE AUDIT1 (
    OperationDate DATE,
    OperationType VARCHAR2(10),
    TriggerName VARCHAR2(50),
    Data VARCHAR2(4000)
);

ALTER TRIGGER Before_State_Trigger COMPILE;
ALTER TRIGGER Before_Row_Trigger COMPILE;
ALTER TRIGGER After_State_Trigger COMPILE;
ALTER TRIGGER After_Row_Trigger COMPILE;

CREATE OR REPLACE VIEW Books_View AS
SELECT BookID, Title, 'Y' AS IsValid
FROM Books;

CREATE OR REPLACE TRIGGER Instead_Of_Update
INSTEAD OF UPDATE ON Books_View
FOR EACH ROW
BEGIN
    UPDATE Books SET Title = 'INVALID_' || :OLD.Title WHERE BookID = :OLD.BookID;
    INSERT INTO Books (BookID, Title)
    VALUES (:NEW.BookID, :NEW.Title);
END;
/

UPDATE Books_View
SET Title = 'Гэтсби', BookID = 13
WHERE BookID = 12;

SELECT * FROM Books;

UPDATE Books SET Title = 'Заголовок' WHERE BookID = 2;

CREATE OR REPLACE TRIGGER Trigger1
BEFORE INSERT ON Books
BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger1');
END;
/

CREATE OR REPLACE TRIGGER Trigger2
BEFORE INSERT ON Books
BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger2');
END;
/

INSERT INTO Books VALUES (15, 'тест2');

CREATE OR REPLACE TRIGGER Trigger1
BEFORE INSERT ON Books
FOLLOWS Trigger2
BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger1');
END;
/

INSERT INTO Books VALUES (16, 'тест3');