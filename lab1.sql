-- -- -- -- -- Major Changes -- -- -- -- --
-- Added NOT NULL to PKs.
-- Checking for same data constraints on all attributes.


-- Add PK on table the FK is referencing to
-- 
-- For Example:
-- Change this: FOREIGN KEY (TutorKey) REFERENCES Tutor
-- To this: FOREIGN KEY (TutorKey) REFERENCES Tutor (TutorKey),
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- -- -- -- -- -- CREATE TABLES -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

CREATE TABLE Tutor (
TutorKey INT NOT NULL ,
TutorLastName CHAR(45),
TutorFirstName CHAR(45),
TutorPhone INT,
TutorEmail CHAR(45),
TutorHireDate DATE,
TutorStatus CHAR(45),
PRIMARY KEY (TutorKey)
);

CREATE TABLE Course (
CourseKey CHAR(6) NOT NULL ,
CourseName CHAR(45),
CourseDescription CHAR(45),
PRIMARY KEY (CourseKey)
);

CREATE TABLE Ethnicity (
EthnicityKey CHAR(20) NOT NULL ,
EthnicityDescription CHAR(45),
PRIMARY KEY (EthnicityKey)
);


CREATE TABLE TutorCourse (
TutorKey INT NOT NULL ,
CourseKey CHAR(6) NOT NULL ,
PRIMARY KEY (TutorKey, CourseKey),
FOREIGN KEY (TutorKey) REFERENCES Tutor (TutorKey),
FOREIGN KEY (CourseKey) REFERENCES Course (CourseKey)
);


create table Students( 
StudentKey INT NOT NULL, 
StudentFirstName CHAR(20), 
StudentLastName CHAR(20), 
StudentEmail CHAR(20), 
StudentPhone INT, 
StudentGender CHAR(5), 
StudentAge INT, 
StudentCitizen CHAR(5), 
StudentWorkerRetraining CHAR(20), 
EthnicityKey CHAR(20) NOT NULL,
PRIMARY KEY (StudentKey)
);

CREATE TABLE StudentCourse (
StudentKey INT NOT NULL ,
CourseKey CHAR(6) NOT NULL,
StudentCourseQuarter CHAR(45),
PRIMARY KEY (StudentKey, CourseKey),
FOREIGN KEY (StudentKey) REFERENCES Students(StudentKey),
FOREIGN KEY (CourseKey) REFERENCES Course(CourseKey)
);

CREATE TABLE Sessions (
SessionDateKey DATE NOT NULL,
SessionTimeKey DATETIME NOT NULL,
TutorKey INT NOT NULL,
CourseKey CHAR(6),
SessionStatus CHAR(45),
SessionMaterialCovered CHAR(45),
PRIMARY KEY (SessionDateKey)
);

CREATE TABLE Requests (
RequestKey INT NOT NULL ,
RequestDate DATE,
CourseKey CHAR(6) ,
RequestStatus CHAR(45),
StudentKey INT ,
PRIMARY KEY (RequestKey)
);

CREATE TABLE RequestNote (
RequestNoteKey DATETIME NOT NULL,
RequestID INT,
RequestNoteText CHAR(100),
PRIMARY KEY (RequestNoteKey)
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- -- -- -- -- -- INSERT VALUES -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Tutor
INSERT INTO Tutor VALUES ();

-- Course
INSERT INTO Course VALUES ();

-- Ethnicity
INSERT INTO Ethnicity VALUES ();

-- RequestNote
INSERT INTO RequestNote VALUES ();

-- Requests
INSERT INTO Requests VALUES();

-- Sessions
INSERT INTO Sessions VALUES();

-- StudentCourse
INSERT INTO StudentCourse VALUES();

-- Students
INSERT INTO Students VALUES();

-- TutorCourse
INSERT INTO TutorCourse VALUES();
