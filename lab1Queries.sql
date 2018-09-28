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

/* Question g */
DROP TRIGGER SessionHours;

/* FIXME: Found this solution online, but does not run */
/* INSTEAD OF key word can only be used on views? */
CREATE TRIGGER SessionHours
    INSTEAD OF INSERT ON vw_Sessions
        BEGIN
            SET NOCOUNT ON; -- TODO: Find out the meaning of this
            DECLARE @currentMonth INT
            DECLARE @totalHours REAL

            SET @currentMonth = EXTRACT(YEAR FROM INSERT(Datee))
            SELECT @totalHours = SUM(Sessions)
            FROM Tutor
            WHERE Month = @currentMonth

            IF @totalHours > 120
                BEGIN
                    RAISEERROR('Cant work more than 60 Hours')
                END
        END;
/
