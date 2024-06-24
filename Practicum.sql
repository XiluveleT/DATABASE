--CREATING TABLES
CREATE TABLE INSTRUCTOR(
INS_ID  NUMBER NOT NULL,
INS_FNAME VARCHAR2(100) NOT NULL,
INS_SNAME VARCHAR2(100) NOT NULL,
INS_CONTACT CHAR(15) NOT NULL,
INS_LEVEL NUMBER NOT NULL,
CONSTRAINT PK_INSTRUCTOR PRIMARY KEY(INS_ID )
);

CREATE TABLE CUSTOMER(
CUST_ID CHAR(10) NOT NULL,
CUST_FNAME VARCHAR2(100) NOT NULL,
CUST_SNAME VARCHAR2(100) NOT NULL,
CUST_ADDRESS VARCHAR2(50) NOT NULL,
CUST_CONTACT CHAR(15) NOT NULL,
CONSTRAINT PK_CUSTOMER PRIMARY KEY(CUST_ID)
);

CREATE TABLE DIVE(
DIVE_ID NUMBER NOT NULL,
DIVE_NAME VARCHAR2(100) NOT NULL,
DIVE_DURATION VARCHAR2(50) NOT NULL,
DIVE_LOCATION VARCHAR2(100) NOT NULL,
DIVE_EXP_LEVEL NUMBER NOT NULL,
DIVE_COST INT NOT NULL,
CONSTRAINT PK_DIVE PRIMARY KEY(DIVE_ID)
);

CREATE TABLE DIVE_EVENT(
DIVE_EVENT_ID VARCHAR2(100) NOT NULL,
DIVE_DATE DATE NOT NULL,
DIVE_PARTICIPANTS NUMBER NOT NULL,
INS_ID  NUMBER NOT NULL,
CUST_ID CHAR(10) NOT NULL,
DIVE_ID NUMBER NOT NULL,
CONSTRAINT PK_DIVE_EVENT PRIMARY KEY(DIVE_EVENT_ID),
CONSTRAINT FK_INSTRUCTOR_DIVE_EVENT FOREIGN KEY(INS_ID) REFERENCES INSTRUCTOR(INS_ID),
CONSTRAINT FK_CUSTOMER_DIVE_EVENT FOREIGN KEY(CUST_ID) REFERENCES CUSTOMER(CUST_ID),
CONSTRAINT FK_DIVE_DIVE_EVENT FOREIGN KEY(DIVE_ID) REFERENCES DIVE(DIVE_ID)
);

--POPULATING DATA
INSERT ALL
   INTO INSTRUCTOR VALUES(101,'James','Willis','0843569851',7)
   INTO INSTRUCTOR VALUES(102,'Sam','Wait','0763698521',2)
   INTO INSTRUCTOR VALUES(103,'Sally','Gumede','0786598521',8)
   INTO INSTRUCTOR VALUES(104,'Bob','Du Preez','0796369857',3)
   INTO INSTRUCTOR VALUES(105,'Simon','Jones','0826598741',9)
   SELECT * FROM DUAL;
   SELECT * FROM INSTRUCTOR;

INSERT ALL
  INTO CUSTOMER VALUES('C115','Heinrich','Willis','3 Main Road','0821253659')
  INTO CUSTOMER VALUES('C116','David','Watson','12 Cape Road','0769658547')
  INTO CUSTOMER VALUES('C117','Waldo','Smith','3 Mountain Road','0863256574')
  INTO CUSTOMER VALUES('C118','Alex','Hanson','8 Circle Road','0762356587')
  INTO CUSTOMER VALUES('C119','Kuhle','Bitterhout','15 Main Road','0821235258')
  INTO CUSTOMER VALUES('C120','Thando','Zolani','88 Summer Road','0847541254')
  INTO CUSTOMER VALUES('C121','Philip','Jackson','3 Long Road','0745556658')
  INTO CUSTOMER VALUES('C122','Sarah','Jones','7 Sea Road','0814745745')
  INTO CUSTOMER VALUES('C123','Catherine','Howard','31 Lake Side Road','0822232521')
  SELECT * FROM DUAL;
  SELECT * FROM CUSTOMER;
  
INSERT ALL
  INTO DIVE VALUES(550,'Shark Dive','3 hours','Shark Point',8,500)
  INTO DIVE VALUES(551,'Coral Dive','1 hour','Break Point',7,300)
  INTO DIVE VALUES(552,'Wave Crescent','2 hours','Ship wreck ally',3,800)
  INTO DIVE VALUES(553,'Underwater Exploration','1 hour','Coral Ally',2,250)
  INTO DIVE VALUES(554,'Underwater Advanture','3 hours','Sandy Beach',3,750)
  INTO DIVE VALUES(555,'Deep Blue Ocean','30 minutes','Lazy Waves',2,120)
  INTO DIVE VALUES(556,'Rough Seas','1 hour','Pipe',9,700)
  INTO DIVE VALUES(557,'White Water','2 hours','Drifts',5,200)
  INTO DIVE VALUES(558,'Current Advanture','2 hours','Rock Lands',3,150)
  SELECT * FROM DUAL;
  SELECT * FROM DIVE;
  
INSERT ALL
   INTO DIVE_EVENT VALUES('de_101','15/JUL/17',5,103,'C115',558)
   INTO DIVE_EVENT VALUES('de_102','16/JUL/17',7,102,'C117',555)
   INTO DIVE_EVENT VALUES('de_103','18/JUL/17',8,104,'C118',552)
   INTO DIVE_EVENT VALUES('de_104','19/JUL/17',3,101,'C119',551)
   INTO DIVE_EVENT VALUES('de_105','21/JUL/17',5,104,'C121',558)
   INTO DIVE_EVENT VALUES('de_106','22/JUL/17',8,105,'C120',556)
   INTO DIVE_EVENT VALUES('de_107','25/JUL/17',10,105,'C115',554)
   INTO DIVE_EVENT VALUES('de_108','27/JUL/17',5,101,'C122',552)
   INTO DIVE_EVENT VALUES('de_109','28/JUL/17',3,102,'C123',553)
   SELECT * FROM DUAL;
   SELECT * FROM DIVE_EVENT;
   
   
   --QUESTION 2
   -- Create user ADMINISTRATOR with password Password1  and grant INSERT privileges
--It helps maintain accountability within an organization. When responsibilities are divided among different users, it's easier to identify who is responsible for decision making
   ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER ADMINISTRATOR IDENTIFIED BY Password1;
GRANT ALL PRIVILEGES TO ADMINISTRATOR;
COMMIT;

-- Create user CUSTOMER with password Password1  and grant INSERT privileges
--
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER CUSTOMER IDENTIFIED BY Password1;
GRANT ALL PRIVILEGES TO CUSTOMER;
COMMIT;

--QUESTION 3
SELECT I.INS_FNAME|| ' '|| I.INS_SNAME AS INSTRUCTOR, C.CUST_FNAME || ' '|| C.CUST_SNAME AS CUSTOMER, D.DIVE_LOCATION,  DE.DIVE_PARTICIPANTS
FROM DIVE_EVENT DE
INNER JOIN INSTRUCTOR I ON DE.INS_ID = I.INS_ID
INNER JOIN CUSTOMER C ON DE.CUST_ID =C.CUST_ID
INNER JOIN DIVE D ON DE.DIVE_ID = D.DIVE_ID
WHERE DE.DIVE_PARTICIPANTS BETWEEN 8 AND 10;

--QUESTION 4
SET SERVEROUTPUT ON;
BEGIN
 FOR rec IN(
SELECT D.DIVE_NAME,DE.DIVE_DATE,DE.DIVE_PARTICIPANTS
FROM DIVE_EVENT DE
JOIN DIVE D ON DE.DIVE_ID = D.DIVE_ID
WHERE  DE.DIVE_PARTICIPANTS >= 10
)
LOOP 
--DISPLAYING OUTPUT
DBMS_OUTPUT.PUT_LINE('DIVE NAME: '|| rec.DIVE_NAME);
DBMS_OUTPUT.PUT_LINE('DIVE DATE: '|| rec.DIVE_DATE);
DBMS_OUTPUT.PUT_LINE('DIVE NAME: '|| rec.DIVE_PARTICIPANTS);
DBMS_OUTPUT.PUT_LINE('-------------------------------');
END LOOP;
END;
/

---QUESTION 5


SET SERVEROUTPUT ON;

DECLARE
    -- Define a record type to hold the fetched data
    TYPE DiveEventRec IS RECORD (
        cust_full_name   VARCHAR2(201),
        dive_name        VARCHAR2(100),
        dive_participants NUMBER,
        instructors_required NUMBER
    );
    
    -- Cursor to select required data
    CURSOR dive_event_cur IS
        SELECT 
            C.CUST_FNAME || ' ' || C.CUST_SNAME AS cust_full_name,
            D.DIVE_NAME,
            DE.DIVE_PARTICIPANTS,
            CASE 
                WHEN DE.DIVE_PARTICIPANTS <= 4 THEN 1
                WHEN DE.DIVE_PARTICIPANTS BETWEEN 5 AND 7 THEN 2
                ELSE 3
            END AS instructors_required
        FROM 
            DIVE_EVENT DE
        JOIN 
            CUSTOMER C ON DE.CUST_ID = C.CUST_ID
        JOIN 
            DIVE D ON DE.DIVE_ID = D.DIVE_ID
        WHERE 
            D.DIVE_COST > 500;
    
    dive_event_rec DiveEventRec;
    
    -- Attributes to store cursor status
    v_rowcount NUMBER := 0;
    v_notfound BOOLEAN;

BEGIN
    OPEN dive_event_cur;
    
    LOOP
        FETCH dive_event_cur INTO dive_event_rec;
        
        EXIT WHEN dive_event_cur%NOTFOUND;
        
        -- Increment row count
        v_rowcount := dive_event_cur%ROWCOUNT;
        
        -- Display the fetched row data
        DBMS_OUTPUT.PUT_LINE('Customer Full Name: ' || dive_event_rec.cust_full_name);
        DBMS_OUTPUT.PUT_LINE('Dive Name: ' || dive_event_rec.dive_name);
        DBMS_OUTPUT.PUT_LINE('Dive Participants: ' || dive_event_rec.dive_participants);
        DBMS_OUTPUT.PUT_LINE('Instructors Required: ' || dive_event_rec.instructors_required);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------');
    END LOOP;
    
    -- Store the %NOTFOUND attribute status
    v_notfound := dive_event_cur%NOTFOUND;
    
    -- Display the total number of rows processed
    DBMS_OUTPUT.PUT_LINE('Total Rows Processed: ' || v_rowcount);
    
    -- Display whether cursor reached end of data
    IF v_notfound THEN
        DBMS_OUTPUT.PUT_LINE('End of Data Reached');
    END IF;
    
    CLOSE dive_event_cur;
END;
/




--QUESTION 6
-- Create the view Vw_Dive_Event
    
    CREATE OR REPLACE VIEW Vw_Dive_Event AS
SELECT
    DE.INS_ID AS "INS ID",
    DE.CUST_ID AS "CUST ID",
    C.CUST_ADDRESS AS "CUST ADDRESS",
    D.DIVE_DURATION AS "DIVE DURATION",
    DE.DIVE_DATE AS "DIVE DATE"
FROM
    DIVE_EVENT DE
JOIN
    CUSTOMER C ON DE.CUST_ID = C.CUST_ID
JOIN
    DIVE D ON DE.DIVE_ID = D.DIVE_ID
WHERE
    DE.DIVE_DATE < TO_DATE('19-JUL-2017', 'DD-MON-YYYY');
    SELECT * FROM Vw_Dive_Event;

--QUESTION 7
CREATE OR REPLACE TRIGGER New_Dive_Event
BEFORE INSERT ON DIVE_EVENT
FOR EACH ROW
BEGIN
    -- Check if participants count is 0 or less
    IF :NEW.DIVE_PARTICIPANTS <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: Participants count must be greater than 0.');
    END IF;

    -- Check if participants count exceeds 20
    IF :NEW.DIVE_PARTICIPANTS > 20 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: Participants count cannot exceed 20.');
    END IF;
END;
/
---QUESTION 8

CREATE OR REPLACE PROCEDURE sp_Customer_Details (
    p_cust_id IN VARCHAR2,
    p_dive_date IN DATE
)
IS
    v_customer_name VARCHAR2(100);
    v_dive_name VARCHAR2(100);
BEGIN
    -- Retrieve customer's full name
    SELECT CUST_FNAME || ' ' || CUST_SNAME
    INTO v_customer_name
    FROM CUSTOMER
    WHERE CUST_ID = p_cust_id;

    -- Retrieve dive name booked for the specified date and customer
    SELECT D.DIVE_NAME
    INTO v_dive_name
    FROM DIVE_EVENT DE
    JOIN DIVE D ON DE.DIVE_ID = D.DIVE_ID
    WHERE DE.CUST_ID = p_cust_id
    AND DE.DIVE_DATE = p_dive_date;

    -- Display the formatted result
    DBMS_OUTPUT.PUT_LINE('CUSTOMER DETAILS: ' || v_customer_name || ' booked for ' || v_dive_name || ' on ' || TO_CHAR(p_dive_date, 'DD/MON/YYYY'));

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No booking found for Customer ID ' || p_cust_id || ' on ' || TO_CHAR(p_dive_date, 'DD/MON/YYYY'));
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An error occurred while retrieving customer details.');
END sp_Customer_Details;
/ 
EXEc sp_Customer_Details;
--QUESTION 9
-- Function definition
CREATE OR REPLACE FUNCTION fn_Dive_Cost_Adjustment(p_dive_id NUMBER)
RETURN NUMBER
IS
    v_dive_duration NUMBER;
    v_dive_location VARCHAR2(100);
    v_dive_cost NUMBER;
BEGIN
    -- Retrieve dive duration and location based on dive ID
    SELECT DIVE_DURATION, DIVE_LOCATION, DIVE_COST
    INTO v_dive_duration, v_dive_location, v_dive_cost
    FROM DIVE
    WHERE DIVE_ID = p_dive_id;
    

    -- Check if dive duration is less than 1 hour, reduce cost by 10%
    IF v_dive_duration < 1 THEN
        v_dive_cost := v_dive_cost * 0.9; -- 10% reduction
    END IF;

    -- Check if dive location is a premium location, increase cost by 20%
    IF v_dive_location IN ('Ship wreck ally', 'Lazy Waves') THEN
        v_dive_cost := v_dive_cost * 1.2; -- 20% increase
    END IF;

    -- Return adjusted dive cost
    RETURN v_dive_cost;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle case where no data is found for the given dive ID
        DBMS_OUTPUT.PUT_LINE('Error: Dive ID ' || p_dive_id || ' not found.');
        RETURN NULL;
    WHEN OTHERS THEN
        -- Handle other exceptions
        DBMS_OUTPUT.PUT_LINE('Error: An error occurred while processing the dive cost adjustment.');
        RETURN NULL;
END;
/





