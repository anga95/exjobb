-- Schema: School
CREATE SCHEMA School;

-- Table: School.Courses
CREATE TABLE School.Courses (
  CourseID int identity NOT NULL,
  CourseName nvarchar(100) NOT NULL,
  TeacherID int NOT NULL,
  CONSTRAINT PK__Courses__C92D718704164132 PRIMARY KEY (CourseID));

-- Foreign Key Constraint: FK__Courses__Teacher__3B75D760
ALTER TABLE School.Courses ADD CONSTRAINT FK__Courses__Teacher__3B75D760 FOREIGN KEY (TeacherID) REFERENCES School.Teachers (TeacherID);

-- Table: School.Enrollments
CREATE TABLE School.Enrollments (
  EnrollmentID int identity NOT NULL,
  StudentID int NOT NULL,
  CourseID int NOT NULL,
  CONSTRAINT PK__Enrollme__7F6877FB49187A1B PRIMARY KEY (EnrollmentID));

-- Foreign Key Constraint: FK__Enrollmen__Cours__3F466844
ALTER TABLE School.Enrollments ADD CONSTRAINT FK__Enrollmen__Cours__3F466844 FOREIGN KEY (CourseID) REFERENCES School.Courses (CourseID);

-- Foreign Key Constraint: FK__Enrollmen__Stude__3E52440B
ALTER TABLE School.Enrollments ADD CONSTRAINT FK__Enrollmen__Stude__3E52440B FOREIGN KEY (StudentID) REFERENCES School.Students (StudentID);

-- Table: School.Students
CREATE TABLE School.Students (
  StudentID int identity NOT NULL,
  StudentName nvarchar(100) NOT NULL,
  DateOfBirth date NOT NULL,
  CONSTRAINT PK__Students__32C52A79C1F18832 PRIMARY KEY (StudentID));

-- Table: School.Teachers
CREATE TABLE School.Teachers (
  TeacherID int identity NOT NULL,
  TeacherName nvarchar(100) NOT NULL,
  CONSTRAINT PK__Teachers__EDF25944B0F510CF PRIMARY KEY (TeacherID));

-- View: School.StudentCourseSummary

-- Skapa vyer
CREATE VIEW School.StudentCourseSummary AS
SELECT S.StudentName, COUNT(E.CourseID) AS NumberOfCourses
FROM School.Students S
JOIN School.Enrollments E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;
;

-- View: School.TeacherCourseSummary

CREATE VIEW School.TeacherCourseSummary AS
SELECT T.TeacherName, COUNT(C.CourseID) AS NumberOfCourses
FROM School.Teachers T
JOIN School.Courses C ON T.TeacherID = C.TeacherID
GROUP BY T.TeacherName;
;

