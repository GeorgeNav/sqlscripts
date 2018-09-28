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
-- Returns Empty Set. Will need to confirm.
SELECT SE.TutorKey AS TotalSessions
    FROM Sessions SE
        WHERE SE.SessionStatus = 'C'
    GROUP BY SE.TutorKey
        HAVING COUNT(*) < 4;

/* DONE: Question e */
-- Date is a keyword. Cannot use it as a column name
DROP VIEW vw_Sessions;
CREATE OR REPLACE VIEW vw_Sessions AS
    SELECT
        S.TutorLastName AS Tutor,
        SE.StudentKey AS Student,
        SE.SessionDateKey AS Datee,
        SE.SessionTimeKey AS Time,
        SE.CourseKey AS Course
        FROM Sessions SE, Tutor S;

/* DONE: Question f */
SELECT DISTINCT Tutor FROM vw_Sessions;

/* DONE: Question g */
DROP TRIGGER SessionHours;
CREATE TRIGGER SessionHours
    BEFORE INSERT ON Sessions
    REFERENCING NEW AS new
    FOR EACH ROW
        DECLARE
            sessionsSoFar INTEGER;
            projectedHours REAL;
        BEGIN
            sessionsSoFar := 0;
            SELECT TotalSessions INTO sessionsSoFar
                FROM ( SELECT TutorKey, COUNT(EXTRACT(MONTH FROM SessionDateKey))
                    AS TotalSessions
                        FROM Sessions
                            WHERE EXTRACT(MONTH FROM SessionDateKey) = EXTRACT(MONTH FROM :new.SessionDateKey) AND TutorKey = :new.TutorKey
                                GROUP BY TutorKey);
            projectedHours := 0.5 * (sessionsSoFar + 1); -- +1 since checking if this new session will put the tutor over the threshold
            IF (projectedHours > 60) THEN
                RAISE_APPLICATION_ERROR(-20001, 'This tutor cannot work more than 60 Hours');
            END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                BEGIN
                    DBMS_OUTPUT.PUT_LINE('Session hours a vaild after insert.');
                END;
        END;
/