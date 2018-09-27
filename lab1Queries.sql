-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- -- -- -- -- --  Queries for LAB 1 -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* Question a */
SELECT S.StudentFirstName, S.StudentLastName, S.StudentGender 
    FROM Students S
        WHERE StudentGender = 'M';

/* Question b */
SELECT SE. TutorKey, SE.CourseKey, SE.SessionDateKey, SE.StudentKey
    FROM Sessions SE
        WHERE SessionDateKey BETWEEN '01/NOV/09' AND '15/NOV/09';

/* Question c */
SELECT COUNT(*) AS TotalOver25
    FROM Students
        WHERE StudentAge > '25';

/* Question d */
-- Returns Empty Set. Will need to confirm.
SELECT SE.TutorKey AS TotalSessions
    FROM Sessions SE
        WHERE SessionStatus = 'C'
    GROUP BY SE.TutorKey
        HAVING COUNT(*) < 4;

/* Question e */
CREATE VIEW vw_Sessions() AS
    SELECT
        T.TutorLastName AS Tutor, 
        S.StudentKey AS Student,
        SE.SessionDateKey AS DATE,
        SE.SessionTimeKey AS TIME,
        SE.CourseKey AS Course
    FROM Student S, Sessions SE, Tutor T;

SELECT * FROM vw_Sessions;
