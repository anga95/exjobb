-- Schema: SCHOOL
CREATE SCHEMA SCHOOL;

-- Table: SCHOOL.COURSES
CREATE TABLE SCHOOL.COURSES (
  COURSEID INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  COURSENAME VARCHAR(100) NOT NULL,
  TEACHERID INTEGER NOT NULL,
  PRIMARY KEY (COURSEID),
  UNIQUE (COURSEID));

-- Foreign Key Constraint: SQL230519113755480
ALTER TABLE SCHOOL.COURSES ADD CONSTRAINT SQL230519113755480 FOREIGN KEY (TEACHERID) REFERENCES SCHOOL.TEACHERS (TEACHERID);

-- Table: SCHOOL.ENROLLMENTS
CREATE TABLE SCHOOL.ENROLLMENTS (
  ENROLLMENTID INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  STUDENTID INTEGER NOT NULL,
  COURSEID INTEGER NOT NULL,
  PRIMARY KEY (ENROLLMENTID),
  UNIQUE (ENROLLMENTID));

-- Foreign Key Constraint: SQL230519113755510
ALTER TABLE SCHOOL.ENROLLMENTS ADD CONSTRAINT SQL230519113755510 FOREIGN KEY (COURSEID) REFERENCES SCHOOL.COURSES (COURSEID);

-- Foreign Key Constraint: SQL230519113755500
ALTER TABLE SCHOOL.ENROLLMENTS ADD CONSTRAINT SQL230519113755500 FOREIGN KEY (STUDENTID) REFERENCES SCHOOL.STUDENTS (STUDENTID);

-- Table: SCHOOL.STUDENTS
CREATE TABLE SCHOOL.STUDENTS (
  STUDENTID INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  STUDENTNAME VARCHAR(100) NOT NULL,
  DATEOFBIRTH DATE NOT NULL,
  PRIMARY KEY (STUDENTID),
  UNIQUE (STUDENTID));

-- Table: SCHOOL.TABLE100ATTRIBUTES
CREATE TABLE SCHOOL.TABLE100ATTRIBUTES (
  ID INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  ATTRIBUTE1 VARCHAR(100) NOT NULL,
  ATTRIBUTE2 VARCHAR(100) NOT NULL,
  ATTRIBUTE3 VARCHAR(100) NOT NULL,
  ATTRIBUTE4 VARCHAR(100) NOT NULL,
  ATTRIBUTE5 VARCHAR(100) NOT NULL,
  ATTRIBUTE6 VARCHAR(100) NOT NULL,
  ATTRIBUTE7 VARCHAR(100) NOT NULL,
  ATTRIBUTE8 VARCHAR(100) NOT NULL,
  ATTRIBUTE9 VARCHAR(100) NOT NULL,
  ATTRIBUTE10 VARCHAR(100) NOT NULL,
  ATTRIBUTE11 VARCHAR(100) NOT NULL,
  ATTRIBUTE12 VARCHAR(100) NOT NULL,
  ATTRIBUTE13 VARCHAR(100) NOT NULL,
  ATTRIBUTE14 VARCHAR(100) NOT NULL,
  ATTRIBUTE15 VARCHAR(100) NOT NULL,
  ATTRIBUTE16 VARCHAR(100) NOT NULL,
  ATTRIBUTE17 VARCHAR(100) NOT NULL,
  ATTRIBUTE18 VARCHAR(100) NOT NULL,
  ATTRIBUTE19 VARCHAR(100) NOT NULL,
  ATTRIBUTE20 VARCHAR(100) NOT NULL,
  ATTRIBUTE21 VARCHAR(100) NOT NULL,
  ATTRIBUTE22 VARCHAR(100) NOT NULL,
  ATTRIBUTE23 VARCHAR(100) NOT NULL,
  ATTRIBUTE24 VARCHAR(100) NOT NULL,
  ATTRIBUTE25 VARCHAR(100) NOT NULL,
  ATTRIBUTE26 VARCHAR(100) NOT NULL,
  ATTRIBUTE27 VARCHAR(100) NOT NULL,
  ATTRIBUTE28 VARCHAR(100) NOT NULL,
  ATTRIBUTE29 VARCHAR(100) NOT NULL,
  ATTRIBUTE30 VARCHAR(100) NOT NULL,
  ATTRIBUTE31 VARCHAR(100) NOT NULL,
  ATTRIBUTE32 VARCHAR(100) NOT NULL,
  ATTRIBUTE33 VARCHAR(100) NOT NULL,
  ATTRIBUTE34 VARCHAR(100) NOT NULL,
  ATTRIBUTE35 VARCHAR(100) NOT NULL,
  ATTRIBUTE36 VARCHAR(100) NOT NULL,
  ATTRIBUTE37 VARCHAR(100) NOT NULL,
  ATTRIBUTE38 VARCHAR(100) NOT NULL,
  ATTRIBUTE39 VARCHAR(100) NOT NULL,
  ATTRIBUTE40 VARCHAR(100) NOT NULL,
  ATTRIBUTE41 VARCHAR(100) NOT NULL,
  ATTRIBUTE42 VARCHAR(100) NOT NULL,
  ATTRIBUTE43 VARCHAR(100) NOT NULL,
  ATTRIBUTE44 VARCHAR(100) NOT NULL,
  ATTRIBUTE45 VARCHAR(100) NOT NULL,
  ATTRIBUTE46 VARCHAR(100) NOT NULL,
  ATTRIBUTE47 VARCHAR(100) NOT NULL,
  ATTRIBUTE48 VARCHAR(100) NOT NULL,
  ATTRIBUTE49 VARCHAR(100) NOT NULL,
  ATTRIBUTE50 VARCHAR(100) NOT NULL,
  ATTRIBUTE51 VARCHAR(100) NOT NULL,
  ATTRIBUTE52 VARCHAR(100) NOT NULL,
  ATTRIBUTE53 VARCHAR(100) NOT NULL,
  ATTRIBUTE54 VARCHAR(100) NOT NULL,
  ATTRIBUTE55 VARCHAR(100) NOT NULL,
  ATTRIBUTE56 VARCHAR(100) NOT NULL,
  ATTRIBUTE57 VARCHAR(100) NOT NULL,
  ATTRIBUTE58 VARCHAR(100) NOT NULL,
  ATTRIBUTE59 VARCHAR(100) NOT NULL,
  ATTRIBUTE60 VARCHAR(100) NOT NULL,
  ATTRIBUTE61 VARCHAR(100) NOT NULL,
  ATTRIBUTE62 VARCHAR(100) NOT NULL,
  ATTRIBUTE63 VARCHAR(100) NOT NULL,
  ATTRIBUTE64 VARCHAR(100) NOT NULL,
  ATTRIBUTE65 VARCHAR(100) NOT NULL,
  ATTRIBUTE66 VARCHAR(100) NOT NULL,
  ATTRIBUTE67 VARCHAR(100) NOT NULL,
  ATTRIBUTE68 VARCHAR(100) NOT NULL,
  ATTRIBUTE69 VARCHAR(100) NOT NULL,
  ATTRIBUTE70 VARCHAR(100) NOT NULL,
  ATTRIBUTE71 VARCHAR(100) NOT NULL,
  ATTRIBUTE72 VARCHAR(100) NOT NULL,
  ATTRIBUTE73 VARCHAR(100) NOT NULL,
  ATTRIBUTE74 VARCHAR(100) NOT NULL,
  ATTRIBUTE75 VARCHAR(100) NOT NULL,
  ATTRIBUTE76 VARCHAR(100) NOT NULL,
  ATTRIBUTE77 VARCHAR(100) NOT NULL,
  ATTRIBUTE78 VARCHAR(100) NOT NULL,
  ATTRIBUTE79 VARCHAR(100) NOT NULL,
  ATTRIBUTE80 VARCHAR(100) NOT NULL,
  ATTRIBUTE81 VARCHAR(100) NOT NULL,
  ATTRIBUTE82 VARCHAR(100) NOT NULL,
  ATTRIBUTE83 VARCHAR(100) NOT NULL,
  ATTRIBUTE84 VARCHAR(100) NOT NULL,
  ATTRIBUTE85 VARCHAR(100) NOT NULL,
  ATTRIBUTE86 VARCHAR(100) NOT NULL,
  ATTRIBUTE87 VARCHAR(100) NOT NULL,
  ATTRIBUTE88 VARCHAR(100) NOT NULL,
  ATTRIBUTE89 VARCHAR(100) NOT NULL,
  ATTRIBUTE90 VARCHAR(100) NOT NULL,
  ATTRIBUTE91 VARCHAR(100) NOT NULL,
  ATTRIBUTE92 VARCHAR(100) NOT NULL,
  ATTRIBUTE93 VARCHAR(100) NOT NULL,
  ATTRIBUTE94 VARCHAR(100) NOT NULL,
  ATTRIBUTE95 VARCHAR(100) NOT NULL,
  ATTRIBUTE96 VARCHAR(100) NOT NULL,
  ATTRIBUTE97 VARCHAR(100) NOT NULL,
  ATTRIBUTE98 VARCHAR(100) NOT NULL,
  ATTRIBUTE99 VARCHAR(100) NOT NULL,
  ATTRIBUTE100 VARCHAR(100) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE (ID));

-- Table: SCHOOL.TABLE25ATTRIBUTES
CREATE TABLE SCHOOL.TABLE25ATTRIBUTES (
  ID INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  ATTRIBUTE1 VARCHAR(100) NOT NULL,
  ATTRIBUTE2 VARCHAR(100) NOT NULL,
  ATTRIBUTE3 VARCHAR(100) NOT NULL,
  ATTRIBUTE4 VARCHAR(100) NOT NULL,
  ATTRIBUTE5 VARCHAR(100) NOT NULL,
  ATTRIBUTE6 VARCHAR(100) NOT NULL,
  ATTRIBUTE7 VARCHAR(100) NOT NULL,
  ATTRIBUTE8 VARCHAR(100) NOT NULL,
  ATTRIBUTE9 VARCHAR(100) NOT NULL,
  ATTRIBUTE10 VARCHAR(100) NOT NULL,
  ATTRIBUTE11 VARCHAR(100) NOT NULL,
  ATTRIBUTE12 VARCHAR(100) NOT NULL,
  ATTRIBUTE13 VARCHAR(100) NOT NULL,
  ATTRIBUTE14 VARCHAR(100) NOT NULL,
  ATTRIBUTE15 VARCHAR(100) NOT NULL,
  ATTRIBUTE16 VARCHAR(100) NOT NULL,
  ATTRIBUTE17 VARCHAR(100) NOT NULL,
  ATTRIBUTE18 VARCHAR(100) NOT NULL,
  ATTRIBUTE19 VARCHAR(100) NOT NULL,
  ATTRIBUTE20 VARCHAR(100) NOT NULL,
  ATTRIBUTE21 VARCHAR(100) NOT NULL,
  ATTRIBUTE22 VARCHAR(100) NOT NULL,
  ATTRIBUTE23 VARCHAR(100) NOT NULL,
  ATTRIBUTE24 VARCHAR(100) NOT NULL,
  ATTRIBUTE25 VARCHAR(100) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE (ID));

-- Table: SCHOOL.TABLE50ATTRIBUTES
CREATE TABLE SCHOOL.TABLE50ATTRIBUTES (
  ID INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  ATTRIBUTE1 VARCHAR(100) NOT NULL,
  ATTRIBUTE2 VARCHAR(100) NOT NULL,
  ATTRIBUTE3 VARCHAR(100) NOT NULL,
  ATTRIBUTE4 VARCHAR(100) NOT NULL,
  ATTRIBUTE5 VARCHAR(100) NOT NULL,
  ATTRIBUTE6 VARCHAR(100) NOT NULL,
  ATTRIBUTE7 VARCHAR(100) NOT NULL,
  ATTRIBUTE8 VARCHAR(100) NOT NULL,
  ATTRIBUTE9 VARCHAR(100) NOT NULL,
  ATTRIBUTE10 VARCHAR(100) NOT NULL,
  ATTRIBUTE11 VARCHAR(100) NOT NULL,
  ATTRIBUTE12 VARCHAR(100) NOT NULL,
  ATTRIBUTE13 VARCHAR(100) NOT NULL,
  ATTRIBUTE14 VARCHAR(100) NOT NULL,
  ATTRIBUTE15 VARCHAR(100) NOT NULL,
  ATTRIBUTE16 VARCHAR(100) NOT NULL,
  ATTRIBUTE17 VARCHAR(100) NOT NULL,
  ATTRIBUTE18 VARCHAR(100) NOT NULL,
  ATTRIBUTE19 VARCHAR(100) NOT NULL,
  ATTRIBUTE20 VARCHAR(100) NOT NULL,
  ATTRIBUTE21 VARCHAR(100) NOT NULL,
  ATTRIBUTE22 VARCHAR(100) NOT NULL,
  ATTRIBUTE23 VARCHAR(100) NOT NULL,
  ATTRIBUTE24 VARCHAR(100) NOT NULL,
  ATTRIBUTE25 VARCHAR(100) NOT NULL,
  ATTRIBUTE26 VARCHAR(100) NOT NULL,
  ATTRIBUTE27 VARCHAR(100) NOT NULL,
  ATTRIBUTE28 VARCHAR(100) NOT NULL,
  ATTRIBUTE29 VARCHAR(100) NOT NULL,
  ATTRIBUTE30 VARCHAR(100) NOT NULL,
  ATTRIBUTE31 VARCHAR(100) NOT NULL,
  ATTRIBUTE32 VARCHAR(100) NOT NULL,
  ATTRIBUTE33 VARCHAR(100) NOT NULL,
  ATTRIBUTE34 VARCHAR(100) NOT NULL,
  ATTRIBUTE35 VARCHAR(100) NOT NULL,
  ATTRIBUTE36 VARCHAR(100) NOT NULL,
  ATTRIBUTE37 VARCHAR(100) NOT NULL,
  ATTRIBUTE38 VARCHAR(100) NOT NULL,
  ATTRIBUTE39 VARCHAR(100) NOT NULL,
  ATTRIBUTE40 VARCHAR(100) NOT NULL,
  ATTRIBUTE41 VARCHAR(100) NOT NULL,
  ATTRIBUTE42 VARCHAR(100) NOT NULL,
  ATTRIBUTE43 VARCHAR(100) NOT NULL,
  ATTRIBUTE44 VARCHAR(100) NOT NULL,
  ATTRIBUTE45 VARCHAR(100) NOT NULL,
  ATTRIBUTE46 VARCHAR(100) NOT NULL,
  ATTRIBUTE47 VARCHAR(100) NOT NULL,
  ATTRIBUTE48 VARCHAR(100) NOT NULL,
  ATTRIBUTE49 VARCHAR(100) NOT NULL,
  ATTRIBUTE50 VARCHAR(100) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE (ID));

-- Table: SCHOOL.TEACHERS
CREATE TABLE SCHOOL.TEACHERS (
  TEACHERID INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  TEACHERNAME VARCHAR(100) NOT NULL,
  PRIMARY KEY (TEACHERID),
  UNIQUE (TEACHERID));

-- View: SCHOOL.STUDENTCOURSESUMMARY
-- Skapa vyer
CREATE VIEW School.StudentCourseSummary AS
SELECT S.StudentName, COUNT(E.CourseID) AS NumberOfCourses
FROM School.Students S
JOIN School.Enrollments E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;

-- View: SCHOOL.TEACHERCOURSESUMMARY
CREATE VIEW School.TeacherCourseSummary AS
SELECT T.TeacherName, COUNT(C.CourseID) AS NumberOfCourses
FROM School.Teachers T
JOIN School.Courses C ON T.TeacherID = C.TeacherID
GROUP BY T.TeacherName;

