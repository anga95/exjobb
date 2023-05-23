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

-- Table: School.Table100Attributes
CREATE TABLE School.Table100Attributes (
  ID int identity NOT NULL,
  Attribute1 nvarchar(100) NOT NULL,
  Attribute2 nvarchar(100) NOT NULL,
  Attribute3 nvarchar(100) NOT NULL,
  Attribute4 nvarchar(100) NOT NULL,
  Attribute5 nvarchar(100) NOT NULL,
  Attribute6 nvarchar(100) NOT NULL,
  Attribute7 nvarchar(100) NOT NULL,
  Attribute8 nvarchar(100) NOT NULL,
  Attribute9 nvarchar(100) NOT NULL,
  Attribute10 nvarchar(100) NOT NULL,
  Attribute11 nvarchar(100) NOT NULL,
  Attribute12 nvarchar(100) NOT NULL,
  Attribute13 nvarchar(100) NOT NULL,
  Attribute14 nvarchar(100) NOT NULL,
  Attribute15 nvarchar(100) NOT NULL,
  Attribute16 nvarchar(100) NOT NULL,
  Attribute17 nvarchar(100) NOT NULL,
  Attribute18 nvarchar(100) NOT NULL,
  Attribute19 nvarchar(100) NOT NULL,
  Attribute20 nvarchar(100) NOT NULL,
  Attribute21 nvarchar(100) NOT NULL,
  Attribute22 nvarchar(100) NOT NULL,
  Attribute23 nvarchar(100) NOT NULL,
  Attribute24 nvarchar(100) NOT NULL,
  Attribute25 nvarchar(100) NOT NULL,
  Attribute26 nvarchar(100) NOT NULL,
  Attribute27 nvarchar(100) NOT NULL,
  Attribute28 nvarchar(100) NOT NULL,
  Attribute29 nvarchar(100) NOT NULL,
  Attribute30 nvarchar(100) NOT NULL,
  Attribute31 nvarchar(100) NOT NULL,
  Attribute32 nvarchar(100) NOT NULL,
  Attribute33 nvarchar(100) NOT NULL,
  Attribute34 nvarchar(100) NOT NULL,
  Attribute35 nvarchar(100) NOT NULL,
  Attribute36 nvarchar(100) NOT NULL,
  Attribute37 nvarchar(100) NOT NULL,
  Attribute38 nvarchar(100) NOT NULL,
  Attribute39 nvarchar(100) NOT NULL,
  Attribute40 nvarchar(100) NOT NULL,
  Attribute41 nvarchar(100) NOT NULL,
  Attribute42 nvarchar(100) NOT NULL,
  Attribute43 nvarchar(100) NOT NULL,
  Attribute44 nvarchar(100) NOT NULL,
  Attribute45 nvarchar(100) NOT NULL,
  Attribute46 nvarchar(100) NOT NULL,
  Attribute47 nvarchar(100) NOT NULL,
  Attribute48 nvarchar(100) NOT NULL,
  Attribute49 nvarchar(100) NOT NULL,
  Attribute50 nvarchar(100) NOT NULL,
  Attribute51 nvarchar(100) NOT NULL,
  Attribute52 nvarchar(100) NOT NULL,
  Attribute53 nvarchar(100) NOT NULL,
  Attribute54 nvarchar(100) NOT NULL,
  Attribute55 nvarchar(100) NOT NULL,
  Attribute56 nvarchar(100) NOT NULL,
  Attribute57 nvarchar(100) NOT NULL,
  Attribute58 nvarchar(100) NOT NULL,
  Attribute59 nvarchar(100) NOT NULL,
  Attribute60 nvarchar(100) NOT NULL,
  Attribute61 nvarchar(100) NOT NULL,
  Attribute62 nvarchar(100) NOT NULL,
  Attribute63 nvarchar(100) NOT NULL,
  Attribute64 nvarchar(100) NOT NULL,
  Attribute65 nvarchar(100) NOT NULL,
  Attribute66 nvarchar(100) NOT NULL,
  Attribute67 nvarchar(100) NOT NULL,
  Attribute68 nvarchar(100) NOT NULL,
  Attribute69 nvarchar(100) NOT NULL,
  Attribute70 nvarchar(100) NOT NULL,
  Attribute71 nvarchar(100) NOT NULL,
  Attribute72 nvarchar(100) NOT NULL,
  Attribute73 nvarchar(100) NOT NULL,
  Attribute74 nvarchar(100) NOT NULL,
  Attribute75 nvarchar(100) NOT NULL,
  Attribute76 nvarchar(100) NOT NULL,
  Attribute77 nvarchar(100) NOT NULL,
  Attribute78 nvarchar(100) NOT NULL,
  Attribute79 nvarchar(100) NOT NULL,
  Attribute80 nvarchar(100) NOT NULL,
  Attribute81 nvarchar(100) NOT NULL,
  Attribute82 nvarchar(100) NOT NULL,
  Attribute83 nvarchar(100) NOT NULL,
  Attribute84 nvarchar(100) NOT NULL,
  Attribute85 nvarchar(100) NOT NULL,
  Attribute86 nvarchar(100) NOT NULL,
  Attribute87 nvarchar(100) NOT NULL,
  Attribute88 nvarchar(100) NOT NULL,
  Attribute89 nvarchar(100) NOT NULL,
  Attribute90 nvarchar(100) NOT NULL,
  Attribute91 nvarchar(100) NOT NULL,
  Attribute92 nvarchar(100) NOT NULL,
  Attribute93 nvarchar(100) NOT NULL,
  Attribute94 nvarchar(100) NOT NULL,
  Attribute95 nvarchar(100) NOT NULL,
  Attribute96 nvarchar(100) NOT NULL,
  Attribute97 nvarchar(100) NOT NULL,
  Attribute98 nvarchar(100) NOT NULL,
  Attribute99 nvarchar(100) NOT NULL,
  Attribute100 nvarchar(100) NOT NULL,
  CONSTRAINT PK__Table100__3214EC27EF1F751F PRIMARY KEY (ID));

-- Table: School.Table25Attributes
CREATE TABLE School.Table25Attributes (
  ID int identity NOT NULL,
  Attribute1 nvarchar(100) NOT NULL,
  Attribute2 nvarchar(100) NOT NULL,
  Attribute3 nvarchar(100) NOT NULL,
  Attribute4 nvarchar(100) NOT NULL,
  Attribute5 nvarchar(100) NOT NULL,
  Attribute6 nvarchar(100) NOT NULL,
  Attribute7 nvarchar(100) NOT NULL,
  Attribute8 nvarchar(100) NOT NULL,
  Attribute9 nvarchar(100) NOT NULL,
  Attribute10 nvarchar(100) NOT NULL,
  Attribute11 nvarchar(100) NOT NULL,
  Attribute12 nvarchar(100) NOT NULL,
  Attribute13 nvarchar(100) NOT NULL,
  Attribute14 nvarchar(100) NOT NULL,
  Attribute15 nvarchar(100) NOT NULL,
  Attribute16 nvarchar(100) NOT NULL,
  Attribute17 nvarchar(100) NOT NULL,
  Attribute18 nvarchar(100) NOT NULL,
  Attribute19 nvarchar(100) NOT NULL,
  Attribute20 nvarchar(100) NOT NULL,
  Attribute21 nvarchar(100) NOT NULL,
  Attribute22 nvarchar(100) NOT NULL,
  Attribute23 nvarchar(100) NOT NULL,
  Attribute24 nvarchar(100) NOT NULL,
  Attribute25 nvarchar(100) NOT NULL,
  CONSTRAINT PK__Table25A__3214EC2738476A90 PRIMARY KEY (ID));

-- Table: School.Table50Attributes
CREATE TABLE School.Table50Attributes (
  ID int identity NOT NULL,
  Attribute1 nvarchar(100) NOT NULL,
  Attribute2 nvarchar(100) NOT NULL,
  Attribute3 nvarchar(100) NOT NULL,
  Attribute4 nvarchar(100) NOT NULL,
  Attribute5 nvarchar(100) NOT NULL,
  Attribute6 nvarchar(100) NOT NULL,
  Attribute7 nvarchar(100) NOT NULL,
  Attribute8 nvarchar(100) NOT NULL,
  Attribute9 nvarchar(100) NOT NULL,
  Attribute10 nvarchar(100) NOT NULL,
  Attribute11 nvarchar(100) NOT NULL,
  Attribute12 nvarchar(100) NOT NULL,
  Attribute13 nvarchar(100) NOT NULL,
  Attribute14 nvarchar(100) NOT NULL,
  Attribute15 nvarchar(100) NOT NULL,
  Attribute16 nvarchar(100) NOT NULL,
  Attribute17 nvarchar(100) NOT NULL,
  Attribute18 nvarchar(100) NOT NULL,
  Attribute19 nvarchar(100) NOT NULL,
  Attribute20 nvarchar(100) NOT NULL,
  Attribute21 nvarchar(100) NOT NULL,
  Attribute22 nvarchar(100) NOT NULL,
  Attribute23 nvarchar(100) NOT NULL,
  Attribute24 nvarchar(100) NOT NULL,
  Attribute25 nvarchar(100) NOT NULL,
  Attribute26 nvarchar(100) NOT NULL,
  Attribute27 nvarchar(100) NOT NULL,
  Attribute28 nvarchar(100) NOT NULL,
  Attribute29 nvarchar(100) NOT NULL,
  Attribute30 nvarchar(100) NOT NULL,
  Attribute31 nvarchar(100) NOT NULL,
  Attribute32 nvarchar(100) NOT NULL,
  Attribute33 nvarchar(100) NOT NULL,
  Attribute34 nvarchar(100) NOT NULL,
  Attribute35 nvarchar(100) NOT NULL,
  Attribute36 nvarchar(100) NOT NULL,
  Attribute37 nvarchar(100) NOT NULL,
  Attribute38 nvarchar(100) NOT NULL,
  Attribute39 nvarchar(100) NOT NULL,
  Attribute40 nvarchar(100) NOT NULL,
  Attribute41 nvarchar(100) NOT NULL,
  Attribute42 nvarchar(100) NOT NULL,
  Attribute43 nvarchar(100) NOT NULL,
  Attribute44 nvarchar(100) NOT NULL,
  Attribute45 nvarchar(100) NOT NULL,
  Attribute46 nvarchar(100) NOT NULL,
  Attribute47 nvarchar(100) NOT NULL,
  Attribute48 nvarchar(100) NOT NULL,
  Attribute49 nvarchar(100) NOT NULL,
  Attribute50 nvarchar(100) NOT NULL,
  CONSTRAINT PK__Table50A__3214EC27E0E155AF PRIMARY KEY (ID));

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

