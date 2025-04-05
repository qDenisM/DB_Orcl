BEGIN
  NULL;
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello World!');
END;
/

select keyword from v$reserved_words
    where length = 1 and keyword != 'A'
/

select keyword from v$reserved_words
    where length > 1 and keyword != 'A' order by keyword
/

BEGIN
  DECLARE
    num_int1 NUMBER := 10;
    num_int2 NUMBER := 3;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Целые числа: ' || num_int1 || ', ' || num_int2);
    DBMS_OUTPUT.PUT_LINE('Сложение: ' || (num_int1 + num_int2));
    DBMS_OUTPUT.PUT_LINE('Вычитание: ' || (num_int1 - num_int2));
    DBMS_OUTPUT.PUT_LINE('Умножение: ' || (num_int1 * num_int2));
    DBMS_OUTPUT.PUT_LINE('Деление: ' || (num_int1 / num_int2));
    DBMS_OUTPUT.PUT_LINE('Остаток: ' || MOD(num_int1, num_int2));
  END;

  DECLARE
    num_fixed NUMBER(5,2) := 123.45;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Фиксированная точка: ' || num_fixed);
  END;

  DECLARE
    num_round NUMBER(5,-2) := 12345;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Отрицательный масштаб: ' || num_round);
  END;

  DECLARE
    num_exp NUMBER := 1.23E2;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Экспонента: ' || num_exp);
  END;

  -- Переменные типа даты
  DECLARE
    num_date DATE := TO_DATE('05-04-2025', 'DD-MM-YYYY');
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Дата: ' || TO_CHAR(num_date, 'DD-MON-YYYY'));
  END;

  DECLARE
    num_varchar2 VARCHAR2(10) := 'Hello';
    num_char CHAR(5) := 'World';
  BEGIN
    DBMS_OUTPUT.PUT_LINE('VARCHAR2: ' || num_varchar2);
    DBMS_OUTPUT.PUT_LINE('CHAR: ' || num_char);
  END;

  DECLARE
    num_bool BOOLEAN := TRUE;
  BEGIN
    IF num_bool THEN
      DBMS_OUTPUT.PUT_LINE('BOOLEAN: TRUE');
    ELSE
      DBMS_OUTPUT.PUT_LINE('BOOLEAN: FALSE');
    END IF;
  END;
END;
/

BEGIN
  DECLARE
    c_varchar2 CONSTANT VARCHAR2(10) := 'Constant';
    c_char CONSTANT CHAR(5) := 'Fixed';
    c_number CONSTANT NUMBER := 100;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('VARCHAR2 константа: ' || c_varchar2);
    DBMS_OUTPUT.PUT_LINE('CHAR константа: ' || c_char);
    DBMS_OUTPUT.PUT_LINE('NUMBER константа: ' || c_number);
    DBMS_OUTPUT.PUT_LINE('Операция с константой: ' || (c_number + 50));
  END;
END;
/

BEGIN
  DECLARE
    v_table_name USER_TABLES.table_name%TYPE;
  BEGIN
    SELECT table_name INTO v_table_name
    FROM USER_TABLES
    WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('Имя таблицы: ' || v_table_name);
  END;
END;
/

BEGIN
  DECLARE
    v_object_rec USER_OBJECTS%ROWTYPE;
  BEGIN
    SELECT * INTO v_object_rec
    FROM USER_OBJECTS
    WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('Объект: ' || v_object_rec.object_name || 
                         ', Тип: ' || v_object_rec.object_type || 
                         ', Дата создания: ' || TO_CHAR(v_object_rec.created, 'DD-MM-YYYY'));
  END;
END;
/

BEGIN
  DECLARE
    init_num NUMBER := 10;
  BEGIN
    -- IF
    IF init_num > 0 THEN
      DBMS_OUTPUT.PUT_LINE('Число положительное');
    END IF;

    -- IF-ELSE
    IF init_num < 0 THEN
      DBMS_OUTPUT.PUT_LINE('Число отрицательное');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Число неотрицательное');
    END IF;

    -- IF-ELSIF
    IF init_num = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Число равно 0');
    ELSIF init_num > 0 THEN
      DBMS_OUTPUT.PUT_LINE('Число больше 0');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Число меньше 0');
    END IF;
  END;
END;
/

BEGIN
  DECLARE
    exam_grade number(1) := 6;
  BEGIN
    CASE exam_grade
      WHEN IN(8,9,10) THEN DBMS_OUTPUT.PUT_LINE('Отлично');
      WHEN IN(6,7) THEN DBMS_OUTPUT.PUT_LINE('Хорошо');
      WHEN IN(4,5) THEN DBMS_OUTPUT.PUT_LINE('Удовлетворительно');
      ELSE DBMS_OUTPUT.PUT_LINE('Пересдача');
    END CASE;
  END;
END;
/

BEGIN
  DECLARE
    num_count NUMBER := 0;
  BEGIN
    LOOP
      num_count := num_count + 1;
      DBMS_OUTPUT.PUT_LINE('Итерация: ' || num_count);
      EXIT WHEN num_count = 3;
    END LOOP;
  END;
END;
/

BEGIN
  DECLARE
    num_count NUMBER := 0;
  BEGIN
    WHILE num_count < 3 LOOP
      num_count := num_count + 1;
      DBMS_OUTPUT.PUT_LINE('Итерация: ' || num_count);
    END LOOP;
  END;
END;
/

BEGIN
  FOR i IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE('Итерация: ' || i);
  END LOOP;
END;
/