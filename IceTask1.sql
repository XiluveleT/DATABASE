--CREATING TABLES--
CREATE TABLE STUDENT 
(
studID char(5) NOT NULL,
fisrName VARCHAR2 (100) NOT NULL,
Surname VARCHAR2 (100) NOT NULL,
Email VARCHAR2 (100) NOT NULL,
CONSTRAINT PK_STUDENT PRIMARY KEY (studID)
);

CREATE TABLE COURSE 
(
 courseID CHAR (5) NOT NULL,
 courseName VARCHAR2 (100) NOT NULL,
 Credits INT NOT NULL,
 CONSTRAINT PK_COURSE PRIMARY KEY (courseID)
);

CREATE TABLE RESULTS 
(
 resultID char(10) NOT NULL,
 Results INT NOT NULL,
 studID CHAR(5) NOT NULL,
 courseID CHAR (5) NOT NULL,
 CONSTRAINT PK_RESULTS PRIMARY KEY( resultID),
 CONSTRAINT FK_STUDENT_RESULTS FOREIGN KEY (studID) REFERENCES STUDENT(studID),
 CONSTRAINT FK_COURSE_RESULTS FOREIGN KEY (courseID) REFERENCES COURSE(courseID)
);

--POPULATING THE DATA-
INSERT ALL
   INTO STUDENT VALUES ('1011','Kevin','Jones','kj@isat.co.za')
   INTO STUDENT VALUES ('1022','Bob','Ferreira','bf@imail.com')
   INTO STUDENT VALUES ('1033','Clark','Le Roux','cerou@mca.com')
   INTO STUDENT VALUES ('1044','Anda','Johnson','aj@isat.co.za')
   INTO STUDENT VALUES ('1055','Mark','Waters','watersm@nrom.co.za')
   SELECT * FROM DUAL;

INSERT ALL
  INTO COURSE VALUES('1','Java Concepts','15')
  INTO COURSE VALUES('2','PHP for begnners','10')
  INTO COURSE VALUES('3','Android Development','12')
  SELECT * FROM DUAL;
  
  INSERT ALL
     INTO RESULTS VALUES ('101','58','1011','1')
     INTO RESULTS VALUES ('102','52','1033','2')
     INTO RESULTS VALUES ('103','85','1022','1')
     INTO RESULTS VALUES ('104','45','1011','2')
     INTO RESULTS VALUES ('105','92','1055','3')
      SELECT * FROM DUAL;
      
    
SELECT * FROM STUDENT;
SELECT * FROM COURSE;
SELECT * FROM RESULTS;

--  QUESTION 2--
SELECT s.fisrName || ', ' || s.Surname AS NAMES, c.courseName, r.Results || '%' AS RESULTS
FROM STUDENT s
JOIN RESULTS r ON s.StudID = r.StudID
JOIN COURSE c ON r.CourseID = c.CourseID ;

--correction of question 2--
SELECT s.fisrName||','||s.Surname AS Names,

--QUESTION 3--
DECLARE
    v_student_name VARCHAR2(100);
    v_course_name VARCHAR2(100);
    v_result NUMBER;
BEGIN
    SELECT s.fisrName || ', ' || s.Surname, c.courseName, r.Results
    INTO v_student_name, v_course_name, v_result
    FROM STUDENT s
    JOIN RESULTS r ON s.StudID = r.StudID
    JOIN COURSE c ON r.CourseID = c.CourseID
    WHERE s.StudID = 1033;
    
    dbms_output.put_line('The student results is: ' || v_student_name || ', ' || v_course_name || ', ' || v_result || '%');
END;
/

SET SERVEROUTPUT ON;
DECLARE
v_SfisrName STUDENT.fisrName%TYPE;
v_courseName COURSE.courseName%TYPE;
v_result RESULTS.Results%TYPE;

CURSOR c1
IS

SELECT s.fisrName||' '||s.Surname AS student_name, c.courseName, r.Results
FROM STUDENT s
INNER JOIN RESULTS r ON s.StudID = r.StudID
JOIN COURSE c ON r.CourseID = c.CourseID
WHERE s.studID = 1033;

BEGIN
 OPEN c1;
 LOOP
 FETCH c1 INTO v_SfisrName, v_courseName, v_result;
 EXIT WHEN c1%NOTFOUND;
 
 dbms_output.put_line('anonymous block completed');
 dbms_output.put_line('The student results is: ' ||  v_SfisrName || ', ' ||v_courseName || ', ' || v_result || '%');

END LOOP;
CLOSE c1;
END;
/

--question 4---
SET SERVEROUTPUT ON;
DECLARE
 v_SstudID STUDENT.studID%TYPE;
 v_result_count NUMBER;
 
 CURSOR c1 
 IS
 SELECT StudID, COUNT(*) AS result_count
 FROM RESULTS
 GROUP BY StudID;
 
BEGIN
 OPEN c1;
 LOOP
 FETCH c1 INTO  v_SstudID, v_result_count;
 EXIT WHEN C1%NOTFOUND;
 
  
 dbms_output.put_line('The result count for ' || v_SstudID || ' is: ' || v_result_count);
 
 END LOOP;
 CLOSE c1;

END;
/

---QUESTION 5--
CREATE VIEW Course_Credits AS
SELECT courseName, Credits
FROM COURSE
WHERE Credits > 12;

SELECT * FROM Course_Credits;
 
 
 --QUESTION 6---
SET SERVEROUTPUT ON;
DECLARE
    v_SstudID STUDENT.studID%TYPE;
    v_result NUMBER;
    v_outcome VARCHAR2(15);
BEGIN
    SELECT RESULTS INTO v_result
    FROM RESULTS
    WHERE StudID = 1011 AND ResultID = 101;

    IF v_result >= 75 THEN
        v_outcome := 'distinction';
    ELSIF v_result >= 50 THEN
        v_outcome := 'pass';
    ELSE
        v_outcome := 'fail';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Student ID: 1011');
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_result || '%');
    DBMS_OUTPUT.PUT_LINE('Outcome: ' || v_outcome);
END;
/

--QUESTION 7--
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER pat_jones IDENTIFIED BY pat12345;
GRANT SELECT ON RESULTS TO pat_jones;
COMMIT;

--QUESTION 8---
CREATE SEQUENCE result_id START WITH 106 INCREMENT BY 1;