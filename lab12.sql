ALTER TABLE TEACHER 
ADD (BIRTHDAY DATE, SALARY NUMBER(10,2));

UPDATE TEACHER SET BIRTHDAY = DATE '1980-05-15', SALARY = 1500.00 WHERE TEACHER = 'СМЛВ';    
UPDATE TEACHER SET BIRTHDAY = DATE '1975-11-22', SALARY = 1800.00 WHERE TEACHER = 'АКНВЧ';   
UPDATE TEACHER SET BIRTHDAY = DATE '1982-03-01', SALARY = 1600.00 WHERE TEACHER = 'КЛСНВ';   
UPDATE TEACHER SET BIRTHDAY = DATE '1978-09-12', SALARY = 1700.00 WHERE TEACHER = 'ГРМН';    
UPDATE TEACHER SET BIRTHDAY = DATE '1985-07-28', SALARY = 1400.00 WHERE TEACHER = 'ЛЩНК';    
UPDATE TEACHER SET BIRTHDAY = DATE '1979-02-14', SALARY = 1550.00 WHERE TEACHER = 'БРКВЧ';   
UPDATE TEACHER SET BIRTHDAY = DATE '1983-12-03', SALARY = 1450.00 WHERE TEACHER = 'ДДК';     
UPDATE TEACHER SET BIRTHDAY = DATE '1977-06-19', SALARY = 1650.00 WHERE TEACHER = 'КБЛ';     
UPDATE TEACHER SET BIRTHDAY = DATE '1981-08-25', SALARY = 1520.00 WHERE TEACHER = 'УРБ';     
UPDATE TEACHER SET BIRTHDAY = DATE '1984-04-07', SALARY = 1480.00 WHERE TEACHER = 'РМНК';    
UPDATE TEACHER SET BIRTHDAY = DATE '1972-10-30', SALARY = 1420.00 WHERE TEACHER = 'ПСТВЛВ';  
UPDATE TEACHER SET BIRTHDAY = DATE '1970-01-01', SALARY = 1300.00 WHERE TEACHER = '?';       
UPDATE TEACHER SET BIRTHDAY = DATE '1976-03-15', SALARY = 1750.00 WHERE TEACHER = 'ГРН';     
UPDATE TEACHER SET BIRTHDAY = DATE '1977-10-14', SALARY = 1470.00 WHERE TEACHER = 'ЖЛК';     
UPDATE TEACHER SET BIRTHDAY = DATE '1974-07-09', SALARY = 1850.00 WHERE TEACHER = 'БРТШВЧ';  
UPDATE TEACHER SET BIRTHDAY = DATE '1973-05-22', SALARY = 1680.00 WHERE TEACHER = 'ЮДНКВ';   
UPDATE TEACHER SET BIRTHDAY = DATE '1980-09-18', SALARY = 1580.00 WHERE TEACHER = 'БРНВСК';  
UPDATE TEACHER SET BIRTHDAY = DATE '1972-12-25', SALARY = 1900.00 WHERE TEACHER = 'НВРВ';    
UPDATE TEACHER SET BIRTHDAY = DATE '1983-02-08', SALARY = 1530.00 WHERE TEACHER = 'РВКЧ';    
UPDATE TEACHER SET BIRTHDAY = DATE '1981-06-14', SALARY = 1460.00 WHERE TEACHER = 'ДМДК';    
UPDATE TEACHER SET BIRTHDAY = DATE '1975-04-30', SALARY = 1720.00 WHERE TEACHER = 'МШКВСК';  
UPDATE TEACHER SET BIRTHDAY = DATE '1979-08-02', SALARY = 1590.00 WHERE TEACHER = 'ЛБХ';     
UPDATE TEACHER SET BIRTHDAY = DATE '1977-10-17', SALARY = 1670.00 WHERE TEACHER = 'ЗВГЦВ';   
UPDATE TEACHER SET BIRTHDAY = DATE '1971-03-05', SALARY = 1950.00 WHERE TEACHER = 'БЗБРДВ';  
UPDATE TEACHER SET BIRTHDAY = DATE '1976-01-28', SALARY = 1780.00 WHERE TEACHER = 'ПРКПЧК';  
UPDATE TEACHER SET BIRTHDAY = DATE '1980-07-13', SALARY = 1540.00 WHERE TEACHER = 'НСКВЦ';   
UPDATE TEACHER SET BIRTHDAY = DATE '1978-11-20', SALARY = 1630.00 WHERE TEACHER = 'МХВ';     
UPDATE TEACHER SET BIRTHDAY = DATE '1982-05-09', SALARY = 1490.00 WHERE TEACHER = 'ЕЩНК';    
UPDATE TEACHER SET BIRTHDAY = DATE '1973-09-27', SALARY = 1820.00 WHERE TEACHER = 'ЖРСК';    

COMMIT;

SELECT 
    SUBSTR(TEACHER_NAME, 1, INSTR(TEACHER_NAME, ' ')) || ' ' ||
    SUBSTR(TEACHER_NAME, INSTR(TEACHER_NAME, ' ') + 1, 1) || '.' ||
    SUBSTR(TEACHER_NAME, INSTR(TEACHER_NAME, ' ', 1, 2) + 1, 1) || '.' AS "Фамилия И.О."
FROM TEACHER
WHERE TO_CHAR(BIRTHDAY, 'D') = 2;

CREATE OR REPLACE VIEW NEXT_MONTH_TEACHERS AS
SELECT 
    TEACHER_NAME AS "Преподаватель",
    TO_CHAR(BIRTHDAY, 'DD/MM/YYYY') AS "Дата рождения"
FROM TEACHER
WHERE TO_CHAR(BIRTHDAY, 'MM') = TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'MM');

SELECT * FROM NEXT_MONTH_TEACHERS;

CREATE OR REPLACE VIEW TEACHERS_BY_MONTH AS
SELECT 
    TO_CHAR(BIRTHDAY, 'MM') AS "Номер месяца",
    CASE TO_CHAR(BIRTHDAY, 'MM')
        WHEN '01' THEN 'Январь'
        WHEN '02' THEN 'Февраль'
        WHEN '03' THEN 'Март'
        WHEN '04' THEN 'Апрель'
        WHEN '05' THEN 'Май'
        WHEN '06' THEN 'Июнь'
        WHEN '07' THEN 'Июль'
        WHEN '08' THEN 'Август'
        WHEN '09' THEN 'Сентябрь'
        WHEN '10' THEN 'Октябрь'
        WHEN '11' THEN 'Ноябрь'
        WHEN '12' THEN 'Декабрь'
    END AS "Название месяца",
    COUNT(*) AS "Количество преподавателей"
FROM TEACHER
GROUP BY TO_CHAR(BIRTHDAY, 'MM');

SELECT * FROM TEACHERS_BY_MONTH ORDER BY "Номер месяца";

DECLARE
    CURSOR circle_date_cursor IS
    SELECT TEACHER_NAME, BIRTHDAY,
           FLOOR(MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 12), BIRTHDAY)/12) AS AGE
    FROM TEACHER
    WHERE MOD(FLOOR(MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 12), BIRTHDAY)/12), 10) = 0;
BEGIN
    FOR rec IN circle_date_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.TEACHER_NAME || ' - ' || rec.AGE || ' лет');
    END LOOP;
END;
/

DECLARE
    CURSOR salary_cursor IS
    SELECT PULPIT.PULPIT_NAME, FACULTY.FACULTY_NAME, FLOOR(AVG(TEACHER.SALARY)) AS AVG_SALARY
    FROM TEACHER
    INNER JOIN PULPIT ON TEACHER.PULPIT = PULPIT.PULPIT
    INNER JOIN FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY
    GROUP BY PULPIT.PULPIT_NAME, FACULTY.FACULTY_NAME;
    
    var_total_avg NUMBER;
BEGIN
    FOR rec IN salary_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Кафедра: ' || rec.PULPIT_NAME || 
                           ' - Средняя ЗП: ' || rec.AVG_SALARY);
    END LOOP;
    
    SELECT FLOOR(AVG(SALARY)) INTO var_total_avg FROM TEACHER;
    DBMS_OUTPUT.PUT_LINE('Общая средняя ЗП по всем факультетам: ' || var_total_avg);
END;
/

BEGIN
    DECLARE
        num1 NUMBER := 10;
        num2 NUMBER := 0;
        result_nums NUMBER;
    BEGIN
        IF num2 = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Делитель не может быть равен нулю!');
        END IF;
        
        result_nums := num1 / num2;
        DBMS_OUTPUT.PUT_LINE('Результат: ' || result_nums);
        
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: деление на ноль!');
    END;
END;
/

BEGIN
    DECLARE
        teacher_name NVARCHAR2(50);
    BEGIN
        SELECT TEACHER_NAME INTO teacher_name
        FROM TEACHER
        WHERE TEACHER = 'XXX'; 
        
        DBMS_OUTPUT.PUT_LINE('Найден преподаватель: ' || teacher_name);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Преподаватель не найден!');
    END;
END;
/

DECLARE
    outer_exception EXCEPTION;
    PRAGMA EXCEPTION_INIT(outer_exception, -20001);
BEGIN
    DECLARE
        inner_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT(inner_exception, -20001);
    BEGIN
        RAISE inner_exception;
    EXCEPTION
        WHEN inner_exception THEN
            DBMS_OUTPUT.PUT_LINE('Внутренний блок: исключение обработано');
            RAISE;
    END;
EXCEPTION
    WHEN outer_exception THEN
        DBMS_OUTPUT.PUT_LINE('Внешний блок: исключение обработано');
END;
/

DECLARE
    my_exception EXCEPTION;
BEGIN
    DECLARE
        my_exception EXCEPTION;
    BEGIN
        RAISE my_exception;
    EXCEPTION
        WHEN my_exception THEN
            DBMS_OUTPUT.PUT_LINE('Внутренний блок: исключение обработано');
    END;
    RAISE my_exception;
EXCEPTION
    WHEN my_exception THEN
        DBMS_OUTPUT.PUT_LINE('Внешний блок: исключение обработано');
END;
/

BEGIN
    DECLARE
        max_salary NUMBER;
    BEGIN
        SELECT MAX(SALARY) INTO max_salary
        FROM TEACHER
        WHERE TEACHER = 'XXX';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Данные не найдены!');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
    END;
END;
/