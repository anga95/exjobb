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

