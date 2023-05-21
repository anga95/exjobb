-- Skapa sekvenser
CREATE SEQUENCE seq_student_id MINVALUE 1 START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE SEQUENCE seq_teacher_id MINVALUE 1 START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE SEQUENCE seq_course_id MINVALUE 1 START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE SEQUENCE seq_enrollment_id MINVALUE 1 START WITH 1 INCREMENT BY 1 CACHE 20;

-- Skapa Students tabell
CREATE TABLE Students (
      StudentID INT DEFAULT seq_student_id.NEXTVAL PRIMARY KEY,
      StudentName VARCHAR2(100) NOT NULL,
      DateOfBirth DATE NOT NULL
);

-- Skapa Teachers tabell
CREATE TABLE Teachers (
      TeacherID INT DEFAULT seq_teacher_id.NEXTVAL PRIMARY KEY,
      TeacherName VARCHAR2(100) NOT NULL
);

-- Skapa Courses tabell
CREATE TABLE Courses (
     CourseID INT DEFAULT seq_course_id.NEXTVAL PRIMARY KEY,
     CourseName VARCHAR2(100) NOT NULL,
     TeacherID INT NOT NULL,
     FOREIGN KEY(TeacherID) REFERENCES Teachers(TeacherID)
);

-- Skapa Enrollments tabell
CREATE TABLE Enrollments (
     EnrollmentID INT DEFAULT seq_enrollment_id.NEXTVAL PRIMARY KEY,
     StudentID INT NOT NULL,
     CourseID INT NOT NULL,
     FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
     FOREIGN KEY(CourseID) REFERENCES Courses(CourseID)
);

-- Skapa vyer
CREATE VIEW StudentCourseSummary AS
SELECT S.StudentName, COUNT(E.CourseID) AS NumberOfCourses
FROM Students S
         JOIN Enrollments E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;

CREATE VIEW TeacherCourseSummary AS
SELECT T.TeacherName, COUNT(C.CourseID) AS NumberOfCourses
FROM Teachers T
         JOIN Courses C ON T.TeacherID = C.TeacherID
GROUP BY T.TeacherName;
