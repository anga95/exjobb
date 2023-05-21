-- Skapa schema
CREATE SCHEMA School;
GO

-- Skapa Students tabell
CREATE TABLE School.Students (
     StudentID INT PRIMARY KEY IDENTITY(1,1),
     StudentName NVARCHAR(100) NOT NULL,
     DateOfBirth DATE NOT NULL
);
GO

-- Skapa Teachers tabell
CREATE TABLE School.Teachers (
     TeacherID INT PRIMARY KEY IDENTITY(1,1),
     TeacherName NVARCHAR(100) NOT NULL,
);
GO

-- Skapa Courses tabell
CREATE TABLE School.Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(100) NOT NULL,
    TeacherID INT NOT NULL,
    FOREIGN KEY(TeacherID) REFERENCES School.Teachers(TeacherID)
);
GO

-- Skapa Enrollments tabell
CREATE TABLE School.Enrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    FOREIGN KEY(StudentID) REFERENCES School.Students(StudentID),
    FOREIGN KEY(CourseID) REFERENCES School.Courses(CourseID)
);
GO

-- Skapa vyer
CREATE VIEW School.StudentCourseSummary AS
SELECT S.StudentName, COUNT(E.CourseID) AS NumberOfCourses
FROM School.Students S
         JOIN School.Enrollments E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;
GO

CREATE VIEW School.TeacherCourseSummary AS
SELECT T.TeacherName, COUNT(C.CourseID) AS NumberOfCourses
FROM School.Teachers T
         JOIN School.Courses C ON T.TeacherID = C.TeacherID
GROUP BY T.TeacherName;
GO
