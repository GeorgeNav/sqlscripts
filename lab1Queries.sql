-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- -- -- -- -- --  Queries for LAB 1 -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* DONE: Question a */
SELECT S.StudentFirstName, S.StudentLastName, S.StudentGender 
    FROM Students S
        WHERE StudentGender = 'M';

/* DONE: Question b */
SELECT SE. TutorKey, SE.CourseKey, SE.SessionDateKey, SE.StudentKey
    FROM Sessions SE
        WHERE SessionDateKey BETWEEN '01/NOV/09' AND '15/NOV/09';

/* DONE: Question c */
SELECT COUNT(*) AS TotalOver25
    FROM Students
        WHERE StudentAge > '25';

/* DONE: Question d */
SELECT SE.TutorKey AS TotalSessions
    FROM Sessions SE
        WHERE SE.SessionStatus = 'C'
    GROUP BY SE.TutorKey
        HAVING COUNT(*) < 4;

/* DONE: Question e */
DROP VIEW vw_Sessions;
CREATE OR REPLACE VIEW vw_Sessions AS
    SELECT
        T.TutorLastName AS Tutor,
        SE.StudentKey AS Student,
        SE.SessionDateKey AS Datee, -- Date is a keyword. Cannot use it as a column name
        SE.SessionTimeKey AS Time,
        SE.CourseKey AS Course
        FROM Sessions SE, Tutor T;
SELECT * FROM vw_Sessions;

/* DONE: Question f */
SELECT DISTINCT Tutor FROM vw_Sessions;

/* DONE: Question g */
DROP TRIGGER SessionHours;
CREATE TRIGGER SessionHours
    BEFORE INSERT ON Sessions
    REFERENCING NEW AS n
    FOR EACH ROW
        DECLARE
            sessionsSoFar INTEGER;
            projectedHours REAL;
        BEGIN
            sessionsSoFar := 0;
            SELECT MonthCount INTO sessionsSoFar -- SELECT INTO Statement retrieves data from database tables and assigns the data into a variable or collection. In this case a variable (sessionsSoFar)
                -- FROM is refering to a table created
                -- SELECT TutorKey, COUNT(EXTRACT(MONTH FROM SessionDateKey)) AS MonthCount 
                --   This is the table created with fields TutorKey, MonthCount
                --      COUNT(EXTRACT(MONTH FROM SessionDateKey)) field gives the count of session tuples and is renamed to MonthCount with AS keyword
                FROM ( SELECT TutorKey, COUNT(EXTRACT(MONTH FROM SessionDateKey)) AS MonthCount FROM Sessions
                        -- This WHERE part cecks if the Sessions current row..
                        -- has the same month value as the one being inserted AND 
                        -- has the same TutorKey value as the one being inserted
                        --   this makes sure that the only tuples used are ones that contain the same TutorKey value as the new TutorKey 
                        WHERE EXTRACT(MONTH FROM SessionDateKey) = EXTRACT(MONTH FROM :n.SessionDateKey) AND TutorKey = :n.TutorKey
                        GROUP BY TutorKey); -- Each tutor has their own session count
            projectedHours := 0.5 * (sessionsSoFar + 1); -- +1 takes into account the new tuple being added
            IF (projectedHours > 60) THEN
                RAISE_APPLICATION_ERROR(-20000, 'This tutor cannot work more than 60 Hours');
            END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                BEGIN
                    DBMS_OUTPUT.PUT_LINE('Total session hours is vaild after insert.');
                END;
        END;
/

/* DONE: Question h */
-- Create a stored procedure usp_StudentLogin that tests if a student exists
-- After the stored procedure name, you list all the parameters for the procedure (Parameters are values the user must enter when they execute the procedure. In this case, you will just need the StudentKey)
-- After the parameters, the ‘ AS’ keyword signals the start of the content of the procedure
    -- The BEGIN and END keywords mark the beginning and ending of the true block
        -- If the student record does exist, it will return the student’s last name
        -- Else If the student doesn’t exist, the stored procedure won’t do anything
    -- The application can test to see whether the name is returned.
CREATE OR REPLACE PROCEDURE usp_StudentLogin ( StudentKey NUMBER ) AS -- Tests if a student exists
    val NUMBER;
    BEGIN
        SELECT S.StudentLastName INTO val FROM Students S
            WHERE S.StudentKey = StudentKey
                GROUP BY StudentKey;
        DBMS_OUTPUT.PUT_LINE(val);
    END;
/

EXECUTE usp_StudentLogin ('990001010'); -- TODO: Test procedure