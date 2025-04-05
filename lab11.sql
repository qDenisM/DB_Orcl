DECLARE
  var_teacher_name TEACHER.TEACHER_NAME%TYPE;
  var_pulpit TEACHER.PULPIT%TYPE;           
BEGIN
  SELECT TEACHER_NAME, PULPIT
  INTO var_teacher_name, var_pulpit
  FROM TEACHER
  WHERE TEACHER = 'СМЛВ';
  
  DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || var_teacher_name || ', Кафедра: ' || var_pulpit);
END;
/

DECLARE
  var_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
  SELECT TEACHER_NAME
  INTO var_teacher_name
  FROM TEACHER
  WHERE PULPIT = 'ИСиТ';
  
  DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || var_teacher_name);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Код ошибки: ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('Сообщение об ошибке: ' || SQLERRM);
END;
/

DECLARE
  var_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
  SELECT TEACHER_NAME
  INTO var_teacher_name
  FROM TEACHER
  WHERE PULPIT = 'ИСиТ';
  
  DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || var_teacher_name);
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: Слишком много строк возвращено');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Другая ошибка: ' || SQLERRM);
END;
/

DECLARE
  var_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
  SELECT TEACHER_NAME
  INTO var_teacher_name
  FROM TEACHER
  WHERE TEACHER = 'XXX';
  
  DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || var_teacher_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Данные не найдены');
    DBMS_OUTPUT.PUT_LINE('Обработано строк: ' || SQL%ROWCOUNT);
    DBMS_OUTPUT.PUT_LINE('Курсор открыт: ' || CASE WHEN SQL%ISOPEN THEN 'Да' ELSE 'Нет' END);
    DBMS_OUTPUT.PUT_LINE('Найдено: ' || CASE WHEN SQL%FOUND THEN 'Да' ELSE 'Нет' END);
END;
/

DECLARE
  err_constraint EXCEPTION;
  PRAGMA EXCEPTION_INIT(err_constraint, -2291);
BEGIN
  INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
  VALUES ('TEST', 'Тестовый Преподаватель', 'XXX');
  
  UPDATE TEACHER 
  SET TEACHER = 'СМЛВ'
  WHERE TEACHER = 'АКНВЧ';
  
  DELETE FROM FACULTY
  WHERE FACULTY = 'ИДиП';
  
EXCEPTION
  WHEN err_constraint THEN
    DBMS_OUTPUT.PUT_LINE('Нарушение ограничения внешнего ключа');
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('Нарушение ограничения первичного ключа');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;
/

DECLARE
  CURSOR teacher_cursor IS
    SELECT TEACHER, TEACHER_NAME, PULPIT
    FROM TEACHER;
  var_teacher TEACHER.TEACHER%TYPE;         
  var_teacher_name TEACHER.TEACHER_NAME%TYPE;
  var_pulpit TEACHER.PULPIT%TYPE;           
BEGIN
  OPEN teacher_cursor;
  LOOP
    FETCH teacher_cursor INTO var_teacher, var_teacher_name, var_pulpit;
    EXIT WHEN teacher_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || var_teacher || ', Имя: ' || var_teacher_name || ', Кафедра: ' || var_pulpit);
  END LOOP;
  CLOSE teacher_cursor;
END;
/

DECLARE
  CURSOR subject_cursor IS
    SELECT *
    FROM SUBJECT;
  var_subject subject_cursor%ROWTYPE;
BEGIN
  OPEN subject_cursor;
  FETCH subject_cursor INTO var_subject;
  WHILE subject_cursor%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('Предмет: ' || var_subject.SUBJECT || 
                        ', Название: ' || var_subject.SUBJECT_NAME || 
                        ', Кафедра: ' || var_subject.PULPIT);
    FETCH subject_cursor INTO var_subject;
  END LOOP;
  CLOSE subject_cursor;
END;
/

DECLARE
  CURSOR aud_cursor(p_min NUMBER, p_max NUMBER) IS
    SELECT AUDITORIUM, AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY BETWEEN p_min AND p_max;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Вместимость до 20:');
  FOR rec IN aud_cursor(0, 20) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.AUDITORIUM || ': ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Вместимость 21-30:');
  DECLARE
    var_rec aud_cursor%ROWTYPE;
  BEGIN
    OPEN aud_cursor(21, 30);
    FETCH aud_cursor INTO var_rec;
    WHILE aud_cursor%FOUND LOOP
      DBMS_OUTPUT.PUT_LINE(var_rec.AUDITORIUM || ': ' || var_rec.AUDITORIUM_CAPACITY);
      FETCH aud_cursor INTO var_rec;
    END LOOP;
    CLOSE aud_cursor;
  END;
  
  DBMS_OUTPUT.PUT_LINE('Вместимость 31-60:');
  DECLARE
    var_rec aud_cursor%ROWTYPE;
  BEGIN
    OPEN aud_cursor(31, 60);
    LOOP
      FETCH aud_cursor INTO var_rec;
      EXIT WHEN aud_cursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(var_rec.AUDITORIUM || ': ' || var_rec.AUDITORIUM_CAPACITY);
    END LOOP;
    CLOSE aud_cursor;
  END;
  
  DBMS_OUTPUT.PUT_LINE('Вместимость 61-80:');
  FOR rec IN aud_cursor(61, 80) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.AUDITORIUM || ': ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Вместимость 81 и выше:');
  FOR rec IN aud_cursor(81, 9999) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.AUDITORIUM || ': ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;
END;
/

DECLARE
  TYPE ref_cursor IS REF CURSOR;
  aud_cv ref_cursor;                  
  var_aud AUDITORIUM.AUDITORIUM%TYPE;   
  var_cap AUDITORIUM.AUDITORIUM_CAPACITY%TYPE; 
BEGIN
  OPEN aud_cv FOR 
    SELECT AUDITORIUM, AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY BETWEEN 40 AND 80;
    
  LOOP
    FETCH aud_cv INTO var_aud, var_cap;
    EXIT WHEN aud_cv%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(var_aud || ': ' || var_cap);
  END LOOP;
  CLOSE aud_cv;
END;
/

DECLARE
  CURSOR aud_cursor IS
    SELECT AUDITORIUM, AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY BETWEEN 40 AND 80
    FOR UPDATE;
BEGIN
  FOR rec IN aud_cursor LOOP
    UPDATE AUDITORIUM
    SET AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 0.9
    WHERE CURRENT OF aud_cursor;
    DBMS_OUTPUT.PUT_LINE('Обновлена ' || rec.AUDITORIUM || ': ' || 
                        rec.AUDITORIUM_CAPACITY || ' -> ' || 
                        ROUND(rec.AUDITORIUM_CAPACITY * 0.9));
  END LOOP;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;
/