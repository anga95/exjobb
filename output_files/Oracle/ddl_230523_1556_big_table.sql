-- Schema: ANDRE
CREATE SCHEMA ANDRE;

-- Table: ANDRE.COURSES
CREATE TABLE ANDRE.COURSES (
  COURSEID NUMBER NOT NULL,
  COURSENAME VARCHAR2 NOT NULL,
  TEACHERID NUMBER NOT NULL,
  CONSTRAINT SYS_C008576 PRIMARY KEY (COURSEID),
  CONSTRAINT SYS_C008576 UNIQUE (COURSEID));

-- Foreign Key Constraint: SYS_C008577
ALTER TABLE ANDRE.COURSES ADD CONSTRAINT SYS_C008577 FOREIGN KEY (TEACHERID) REFERENCES ANDRE.TEACHERS (TEACHERID);

-- Table: ANDRE.ENROLLMENTS
CREATE TABLE ANDRE.ENROLLMENTS (
  ENROLLMENTID NUMBER NOT NULL,
  STUDENTID NUMBER NOT NULL,
  COURSEID NUMBER NOT NULL,
  CONSTRAINT SYS_C008580 PRIMARY KEY (ENROLLMENTID),
  CONSTRAINT SYS_C008580 UNIQUE (ENROLLMENTID));

-- Foreign Key Constraint: SYS_C008582
ALTER TABLE ANDRE.ENROLLMENTS ADD CONSTRAINT SYS_C008582 FOREIGN KEY (COURSEID) REFERENCES ANDRE.COURSES (COURSEID);

-- Foreign Key Constraint: SYS_C008581
ALTER TABLE ANDRE.ENROLLMENTS ADD CONSTRAINT SYS_C008581 FOREIGN KEY (STUDENTID) REFERENCES ANDRE.STUDENTS (STUDENTID);

-- Table: ANDRE.STUDENTS
CREATE TABLE ANDRE.STUDENTS (
  STUDENTID NUMBER NOT NULL,
  STUDENTNAME VARCHAR2 NOT NULL,
  DATEOFBIRTH DATE NOT NULL,
  CONSTRAINT SYS_C008571 PRIMARY KEY (STUDENTID),
  CONSTRAINT SYS_C008571 UNIQUE (STUDENTID));

-- Table: ANDRE.TABLE100ATTRIBUTES
CREATE TABLE ANDRE.TABLE100ATTRIBUTES (
  ID NUMBER NOT NULL,
  ATTRIBUTE1 VARCHAR2 NOT NULL,
  ATTRIBUTE2 VARCHAR2 NOT NULL,
  ATTRIBUTE3 VARCHAR2 NOT NULL,
  ATTRIBUTE4 VARCHAR2 NOT NULL,
  ATTRIBUTE5 VARCHAR2 NOT NULL,
  ATTRIBUTE6 VARCHAR2 NOT NULL,
  ATTRIBUTE7 VARCHAR2 NOT NULL,
  ATTRIBUTE8 VARCHAR2 NOT NULL,
  ATTRIBUTE9 VARCHAR2 NOT NULL,
  ATTRIBUTE10 VARCHAR2 NOT NULL,
  ATTRIBUTE11 VARCHAR2 NOT NULL,
  ATTRIBUTE12 VARCHAR2 NOT NULL,
  ATTRIBUTE13 VARCHAR2 NOT NULL,
  ATTRIBUTE14 VARCHAR2 NOT NULL,
  ATTRIBUTE15 VARCHAR2 NOT NULL,
  ATTRIBUTE16 VARCHAR2 NOT NULL,
  ATTRIBUTE17 VARCHAR2 NOT NULL,
  ATTRIBUTE18 VARCHAR2 NOT NULL,
  ATTRIBUTE19 VARCHAR2 NOT NULL,
  ATTRIBUTE20 VARCHAR2 NOT NULL,
  ATTRIBUTE21 VARCHAR2 NOT NULL,
  ATTRIBUTE22 VARCHAR2 NOT NULL,
  ATTRIBUTE23 VARCHAR2 NOT NULL,
  ATTRIBUTE24 VARCHAR2 NOT NULL,
  ATTRIBUTE25 VARCHAR2 NOT NULL,
  ATTRIBUTE26 VARCHAR2 NOT NULL,
  ATTRIBUTE27 VARCHAR2 NOT NULL,
  ATTRIBUTE28 VARCHAR2 NOT NULL,
  ATTRIBUTE29 VARCHAR2 NOT NULL,
  ATTRIBUTE30 VARCHAR2 NOT NULL,
  ATTRIBUTE31 VARCHAR2 NOT NULL,
  ATTRIBUTE32 VARCHAR2 NOT NULL,
  ATTRIBUTE33 VARCHAR2 NOT NULL,
  ATTRIBUTE34 VARCHAR2 NOT NULL,
  ATTRIBUTE35 VARCHAR2 NOT NULL,
  ATTRIBUTE36 VARCHAR2 NOT NULL,
  ATTRIBUTE37 VARCHAR2 NOT NULL,
  ATTRIBUTE38 VARCHAR2 NOT NULL,
  ATTRIBUTE39 VARCHAR2 NOT NULL,
  ATTRIBUTE40 VARCHAR2 NOT NULL,
  ATTRIBUTE41 VARCHAR2 NOT NULL,
  ATTRIBUTE42 VARCHAR2 NOT NULL,
  ATTRIBUTE43 VARCHAR2 NOT NULL,
  ATTRIBUTE44 VARCHAR2 NOT NULL,
  ATTRIBUTE45 VARCHAR2 NOT NULL,
  ATTRIBUTE46 VARCHAR2 NOT NULL,
  ATTRIBUTE47 VARCHAR2 NOT NULL,
  ATTRIBUTE48 VARCHAR2 NOT NULL,
  ATTRIBUTE49 VARCHAR2 NOT NULL,
  ATTRIBUTE50 VARCHAR2 NOT NULL,
  ATTRIBUTE51 VARCHAR2 NOT NULL,
  ATTRIBUTE52 VARCHAR2 NOT NULL,
  ATTRIBUTE53 VARCHAR2 NOT NULL,
  ATTRIBUTE54 VARCHAR2 NOT NULL,
  ATTRIBUTE55 VARCHAR2 NOT NULL,
  ATTRIBUTE56 VARCHAR2 NOT NULL,
  ATTRIBUTE57 VARCHAR2 NOT NULL,
  ATTRIBUTE58 VARCHAR2 NOT NULL,
  ATTRIBUTE59 VARCHAR2 NOT NULL,
  ATTRIBUTE60 VARCHAR2 NOT NULL,
  ATTRIBUTE61 VARCHAR2 NOT NULL,
  ATTRIBUTE62 VARCHAR2 NOT NULL,
  ATTRIBUTE63 VARCHAR2 NOT NULL,
  ATTRIBUTE64 VARCHAR2 NOT NULL,
  ATTRIBUTE65 VARCHAR2 NOT NULL,
  ATTRIBUTE66 VARCHAR2 NOT NULL,
  ATTRIBUTE67 VARCHAR2 NOT NULL,
  ATTRIBUTE68 VARCHAR2 NOT NULL,
  ATTRIBUTE69 VARCHAR2 NOT NULL,
  ATTRIBUTE70 VARCHAR2 NOT NULL,
  ATTRIBUTE71 VARCHAR2 NOT NULL,
  ATTRIBUTE72 VARCHAR2 NOT NULL,
  ATTRIBUTE73 VARCHAR2 NOT NULL,
  ATTRIBUTE74 VARCHAR2 NOT NULL,
  ATTRIBUTE75 VARCHAR2 NOT NULL,
  ATTRIBUTE76 VARCHAR2 NOT NULL,
  ATTRIBUTE77 VARCHAR2 NOT NULL,
  ATTRIBUTE78 VARCHAR2 NOT NULL,
  ATTRIBUTE79 VARCHAR2 NOT NULL,
  ATTRIBUTE80 VARCHAR2 NOT NULL,
  ATTRIBUTE81 VARCHAR2 NOT NULL,
  ATTRIBUTE82 VARCHAR2 NOT NULL,
  ATTRIBUTE83 VARCHAR2 NOT NULL,
  ATTRIBUTE84 VARCHAR2 NOT NULL,
  ATTRIBUTE85 VARCHAR2 NOT NULL,
  ATTRIBUTE86 VARCHAR2 NOT NULL,
  ATTRIBUTE87 VARCHAR2 NOT NULL,
  ATTRIBUTE88 VARCHAR2 NOT NULL,
  ATTRIBUTE89 VARCHAR2 NOT NULL,
  ATTRIBUTE90 VARCHAR2 NOT NULL,
  ATTRIBUTE91 VARCHAR2 NOT NULL,
  ATTRIBUTE92 VARCHAR2 NOT NULL,
  ATTRIBUTE93 VARCHAR2 NOT NULL,
  ATTRIBUTE94 VARCHAR2 NOT NULL,
  ATTRIBUTE95 VARCHAR2 NOT NULL,
  ATTRIBUTE96 VARCHAR2 NOT NULL,
  ATTRIBUTE97 VARCHAR2 NOT NULL,
  ATTRIBUTE98 VARCHAR2 NOT NULL,
  ATTRIBUTE99 VARCHAR2 NOT NULL,
  ATTRIBUTE100 VARCHAR2 NOT NULL,
  CONSTRAINT SYS_C008777 PRIMARY KEY (ID),
  CONSTRAINT SYS_C008777 UNIQUE (ID));

-- Table: ANDRE.TABLE25ATTRIBUTES
CREATE TABLE ANDRE.TABLE25ATTRIBUTES (
  ID NUMBER NOT NULL,
  ATTRIBUTE1 VARCHAR2 NOT NULL,
  ATTRIBUTE2 VARCHAR2 NOT NULL,
  ATTRIBUTE3 VARCHAR2 NOT NULL,
  ATTRIBUTE4 VARCHAR2 NOT NULL,
  ATTRIBUTE5 VARCHAR2 NOT NULL,
  ATTRIBUTE6 VARCHAR2 NOT NULL,
  ATTRIBUTE7 VARCHAR2 NOT NULL,
  ATTRIBUTE8 VARCHAR2 NOT NULL,
  ATTRIBUTE9 VARCHAR2 NOT NULL,
  ATTRIBUTE10 VARCHAR2 NOT NULL,
  ATTRIBUTE11 VARCHAR2 NOT NULL,
  ATTRIBUTE12 VARCHAR2 NOT NULL,
  ATTRIBUTE13 VARCHAR2 NOT NULL,
  ATTRIBUTE14 VARCHAR2 NOT NULL,
  ATTRIBUTE15 VARCHAR2 NOT NULL,
  ATTRIBUTE16 VARCHAR2 NOT NULL,
  ATTRIBUTE17 VARCHAR2 NOT NULL,
  ATTRIBUTE18 VARCHAR2 NOT NULL,
  ATTRIBUTE19 VARCHAR2 NOT NULL,
  ATTRIBUTE20 VARCHAR2 NOT NULL,
  ATTRIBUTE21 VARCHAR2 NOT NULL,
  ATTRIBUTE22 VARCHAR2 NOT NULL,
  ATTRIBUTE23 VARCHAR2 NOT NULL,
  ATTRIBUTE24 VARCHAR2 NOT NULL,
  ATTRIBUTE25 VARCHAR2 NOT NULL,
  CONSTRAINT SYS_C008623 PRIMARY KEY (ID),
  CONSTRAINT SYS_C008623 UNIQUE (ID));

-- Table: ANDRE.TABLE50ATTRIBUTES
CREATE TABLE ANDRE.TABLE50ATTRIBUTES (
  ID NUMBER NOT NULL,
  ATTRIBUTE1 VARCHAR2 NOT NULL,
  ATTRIBUTE2 VARCHAR2 NOT NULL,
  ATTRIBUTE3 VARCHAR2 NOT NULL,
  ATTRIBUTE4 VARCHAR2 NOT NULL,
  ATTRIBUTE5 VARCHAR2 NOT NULL,
  ATTRIBUTE6 VARCHAR2 NOT NULL,
  ATTRIBUTE7 VARCHAR2 NOT NULL,
  ATTRIBUTE8 VARCHAR2 NOT NULL,
  ATTRIBUTE9 VARCHAR2 NOT NULL,
  ATTRIBUTE10 VARCHAR2 NOT NULL,
  ATTRIBUTE11 VARCHAR2 NOT NULL,
  ATTRIBUTE12 VARCHAR2 NOT NULL,
  ATTRIBUTE13 VARCHAR2 NOT NULL,
  ATTRIBUTE14 VARCHAR2 NOT NULL,
  ATTRIBUTE15 VARCHAR2 NOT NULL,
  ATTRIBUTE16 VARCHAR2 NOT NULL,
  ATTRIBUTE17 VARCHAR2 NOT NULL,
  ATTRIBUTE18 VARCHAR2 NOT NULL,
  ATTRIBUTE19 VARCHAR2 NOT NULL,
  ATTRIBUTE20 VARCHAR2 NOT NULL,
  ATTRIBUTE21 VARCHAR2 NOT NULL,
  ATTRIBUTE22 VARCHAR2 NOT NULL,
  ATTRIBUTE23 VARCHAR2 NOT NULL,
  ATTRIBUTE24 VARCHAR2 NOT NULL,
  ATTRIBUTE25 VARCHAR2 NOT NULL,
  ATTRIBUTE26 VARCHAR2 NOT NULL,
  ATTRIBUTE27 VARCHAR2 NOT NULL,
  ATTRIBUTE28 VARCHAR2 NOT NULL,
  ATTRIBUTE29 VARCHAR2 NOT NULL,
  ATTRIBUTE30 VARCHAR2 NOT NULL,
  ATTRIBUTE31 VARCHAR2 NOT NULL,
  ATTRIBUTE32 VARCHAR2 NOT NULL,
  ATTRIBUTE33 VARCHAR2 NOT NULL,
  ATTRIBUTE34 VARCHAR2 NOT NULL,
  ATTRIBUTE35 VARCHAR2 NOT NULL,
  ATTRIBUTE36 VARCHAR2 NOT NULL,
  ATTRIBUTE37 VARCHAR2 NOT NULL,
  ATTRIBUTE38 VARCHAR2 NOT NULL,
  ATTRIBUTE39 VARCHAR2 NOT NULL,
  ATTRIBUTE40 VARCHAR2 NOT NULL,
  ATTRIBUTE41 VARCHAR2 NOT NULL,
  ATTRIBUTE42 VARCHAR2 NOT NULL,
  ATTRIBUTE43 VARCHAR2 NOT NULL,
  ATTRIBUTE44 VARCHAR2 NOT NULL,
  ATTRIBUTE45 VARCHAR2 NOT NULL,
  ATTRIBUTE46 VARCHAR2 NOT NULL,
  ATTRIBUTE47 VARCHAR2 NOT NULL,
  ATTRIBUTE48 VARCHAR2 NOT NULL,
  ATTRIBUTE49 VARCHAR2 NOT NULL,
  ATTRIBUTE50 VARCHAR2 NOT NULL,
  CONSTRAINT SYS_C008675 PRIMARY KEY (ID),
  CONSTRAINT SYS_C008675 UNIQUE (ID));

-- Table: ANDRE.TEACHERS
CREATE TABLE ANDRE.TEACHERS (
  TEACHERID NUMBER NOT NULL,
  TEACHERNAME VARCHAR2 NOT NULL,
  CONSTRAINT SYS_C008573 PRIMARY KEY (TEACHERID),
  CONSTRAINT SYS_C008573 UNIQUE (TEACHERID));

-- View: ANDRE.STUDENTCOURSESUMMARY
CREATE OR REPLACE VIEW ANDRE.STUDENTCOURSESUMMARY AS SELECT S.StudentName, COUNT(E.CourseID) AS NumberOfCourses
FROM Students S
JOIN Enrollments E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;

-- View: ANDRE.TEACHERCOURSESUMMARY
CREATE OR REPLACE VIEW ANDRE.TEACHERCOURSESUMMARY AS SELECT T.TeacherName, COUNT(C.CourseID) AS NumberOfCourses
FROM Teachers T
JOIN Courses C ON T.TeacherID = C.TeacherID
GROUP BY T.TeacherName;
