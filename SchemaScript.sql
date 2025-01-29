CREATE TABLE Branch
(
  ID    int          NOT NULL IDENTITY(1,1),
  Phone varchar(13) ,
  City  nvarchar(20) NOT NULL,
  CONSTRAINT PK_Branch PRIMARY KEY (ID)
)
GO

ALTER TABLE Branch
  ADD CONSTRAINT UQ_BranchPhone UNIQUE (Phone)
GO

ALTER TABLE Branch
  ADD CONSTRAINT UQ_BranchCity UNIQUE (City)
GO

CREATE TABLE BranchTracks
(
  BranchID int NOT NULL,
  TrackID  int NOT NULL,
  CONSTRAINT PK_BranchTracks PRIMARY KEY (BranchID, TrackID)
)
GO

CREATE TABLE Course
(
  ID       int         NOT NULL IDENTITY(1,1),
  Name     varchar(50) NOT NULL,
  Duration smallint    NOT NULL,
  CONSTRAINT PK_Course PRIMARY KEY (ID)
)
GO

ALTER TABLE Course
  ADD CONSTRAINT UQ_CourseName UNIQUE (Name)
GO

CREATE TABLE CoursesInstructors
(
  CrsID int NOT NULL,
  InsID int NOT NULL,
  CONSTRAINT PK_CoursesInstructors PRIMARY KEY (CrsID, InsID)
)
GO

CREATE TABLE Exam
(
  ID            int           NOT NULL IDENTITY(1,1),
  Name          varchar(50)   NOT NULL,
  StartTime     datetime              ,
  Duration      DECIMAL(3,2)  NOT NULL CHECK(Duration > 0 ),
  EndTime       AS            DATEADD(hour , Duration , StartTime),
  QuestionCount tinyint       NOT NULL CHECK(QuestionCount > 0 ),
  TotalMark     tinyint       DEFAULT  0 ,
  CrsID         int           NOT NULL,
  InsID         int           NOT NULL,
  CONSTRAINT PK_Exam PRIMARY KEY (ID)
)
GO

CREATE TABLE ExamQuestions
(
  ExamID     int NOT NULL,
  QuestionID int NOT NULL,
  CONSTRAINT PK_ExamQuestions PRIMARY KEY (ExamID, QuestionID)
)
GO

CREATE TABLE Instructor
(
  ID       int          NOT NULL IDENTITY(1,1),
  Fname    nvarchar(30) NOT NULL,
  Lname    nvarchar(30)         ,
  BD       date         NOT NULL,
  Age      AS           YEAR(GETDATE()) - YEAR(BD),
  Gender   varchar(1)   NOT NULL CHECK (Gender in ('m','f')),
  Email    varchar(50)  NOT NULL,
  Password varchar(10)  NOT NULL,
  St       nvarchar(50) NOT NULL,
  City     nvarchar(50) NOT NULL,
  Phone    varchar(13)  NOT NULL,
  HireDate date          DEFAULT GETDATE(),
  Salary   decimal(8,2) NOT NULL CHECK(Salary > 0),
  SuperID  int                  ,
  CONSTRAINT PK_Instructor PRIMARY KEY (ID)
)
GO

ALTER TABLE Instructor
  ADD CONSTRAINT UQ_InstructorEmail UNIQUE (Email)
GO

ALTER TABLE Instructor
  ADD CONSTRAINT UQ_InstructorPhone UNIQUE (Phone)
GO

CREATE TABLE Intake
(
  ID        int         NOT NULL IDENTITY(1,1),
  Name      varchar(30) NOT NULL,
  StartDate date        NOT NULL,
  EndDate   date        NOT NULL,
  CONSTRAINT CHK_Date_Validity CHECK (EndDate > StartDate),  -- Table-level constraint
  CONSTRAINT PK_Intake PRIMARY KEY (ID)
)
GO

ALTER TABLE Intake
  ADD CONSTRAINT UQ_IntakeName UNIQUE (Name)
GO

CREATE TABLE Question
(
  ID            int          NOT NULL IDENTITY(1,1),
  Body          varchar(150) NOT NULL,
  Mark          tinyint      NOT NULL CHECK(Mark > 0),
  CorrectAnswer tinyint              ,
  TypeID        int          NOT NULL,
  CrsID         int          NOT NULL,
  InsID         int          NOT NULL,
  CONSTRAINT PK_Question PRIMARY KEY (ID)
)
GO

CREATE TABLE QuestionOptions
(
  QuestionID int         NOT NULL,
  OptionNum  tinyint     NOT NULL CHECK(OptionNum BETWEEN 1 AND 4),
  OptionBody varchar(50) NOT NULL,
  CONSTRAINT PK_QuestionOptions PRIMARY KEY (QuestionID, OptionNum)
)
GO

CREATE TABLE QuestionTypes
(
  ID   int          NOT NULL IDENTITY(1,1),
  Type nvarchar(30) NOT NULL,
  CONSTRAINT PK_QuestionTypes PRIMARY KEY (ID)
)
GO

ALTER TABLE QuestionTypes
  ADD CONSTRAINT UQ_Type UNIQUE (Type)
GO

CREATE TABLE Student
(
  ID       int          NOT NULL IDENTITY(1,1),
  Fname    nvarchar(30) NOT NULL,
  Lname    nvarchar(30),
  BD       date         NOT NULL,
  Age      AS           YEAR(GETDATE()) - YEAR(BD),
  Gender   varchar(1)   NOT NULL CHECK (Gender in ('m','f')),
  Email    varchar(50)  NOT NULL,
  Password varchar(10)  NOT NULL,
  St       nvarchar(50) NOT NULL,
  City     nvarchar(50) NOT NULL,
  Phone    varchar(13)  NOT NULL,
  IntakeID int          NOT NULL,
  TrackID  int          NOT NULL,
  CONSTRAINT PK_Student PRIMARY KEY (ID)
)
GO

ALTER TABLE Student
  ADD CONSTRAINT UQ_StudentEmail UNIQUE (Email)
GO

ALTER TABLE Student
  ADD CONSTRAINT UQ_StudentPhone UNIQUE (Phone)
GO

CREATE TABLE StudentCourses
(
  StdID int NOT NULL,
  CrsID int NOT NULL,
  CONSTRAINT PK_StudentCourses PRIMARY KEY (StdID, CrsID)
)
GO

CREATE TABLE StudentExams
(
  StdID  int     NOT NULL,
  ExamID int     NOT NULL,
  Grade  tinyint DEFAULT 0 NOT NULL,
  CONSTRAINT PK_StudentExams PRIMARY KEY (StdID, ExamID)
)
GO

CREATE TABLE StudentsExamsAnswers
(
  StdID       int     NOT NULL,
  QuestionID  int     NOT NULL,
  ExamID      int     NOT NULL,
  StdAnswer   tinyint         ,
  AnswerGrade tinyint         ,
  CONSTRAINT PK_StudentsExamsAnswers PRIMARY KEY (StdID, QuestionID, ExamID)
)
GO

CREATE TABLE Topic
(
  ID    int         NOT NULL IDENTITY(1,1),
  CrsID int         NOT NULL,
  Name  varchar(50) NOT NULL,
  CONSTRAINT PK_Topic PRIMARY KEY (ID)
)
GO

CREATE TABLE Track
(
  ID       int          NOT NULL IDENTITY(1,1),
  Name     nvarchar(30) NOT NULL,
  IntakeID int                  ,
  MngrID   int          NOT NULL,
  HireDate date         NOT NULL DEFAULT GETDATE(),
  CONSTRAINT PK_Track PRIMARY KEY (ID)
)
GO

-- ALTER TABLE Track
--   ADD CONSTRAINT UQ_TrackName UNIQUE (Name)
-- GO

CREATE TABLE TrackCourses
(
  TrackID int NOT NULL,
  CrsID   int NOT NULL,
  CONSTRAINT PK_TrackCourses PRIMARY KEY (TrackID, CrsID)
)
GO

CREATE TABLE TrackInstructors
(
  TrackID int NOT NULL,
  InsID   int NOT NULL,
  CONSTRAINT PK_TrackInstructors PRIMARY KEY (TrackID, InsID)
)
GO

ALTER TABLE BranchTracks
  ADD CONSTRAINT FK_Branch_TO_BranchTracks
    FOREIGN KEY (BranchID)
    REFERENCES Branch (ID)
GO

ALTER TABLE BranchTracks
  ADD CONSTRAINT FK_Track_TO_BranchTracks
    FOREIGN KEY (TrackID)
    REFERENCES Track (ID)
GO

ALTER TABLE Track
  ADD CONSTRAINT FK_Intake_TO_Track
    FOREIGN KEY (IntakeID)
    REFERENCES Intake (ID)
GO

ALTER TABLE Student
  ADD CONSTRAINT FK_Intake_TO_Student
    FOREIGN KEY (IntakeID)
    REFERENCES Intake (ID)
GO

ALTER TABLE Student
  ADD CONSTRAINT FK_Track_TO_Student
    FOREIGN KEY (TrackID)
    REFERENCES Track (ID)
GO

ALTER TABLE StudentCourses
  ADD CONSTRAINT FK_Course_TO_StudentCourses
    FOREIGN KEY (CrsID)
    REFERENCES Course (ID)
GO

ALTER TABLE StudentCourses
  ADD CONSTRAINT FK_Student_TO_StudentCourses
    FOREIGN KEY (StdID)
    REFERENCES Student (ID)
GO

ALTER TABLE TrackCourses
  ADD CONSTRAINT FK_Course_TO_TrackCourses
    FOREIGN KEY (CrsID)
    REFERENCES Course (ID)
GO

ALTER TABLE TrackCourses
  ADD CONSTRAINT FK_Track_TO_TrackCourses
    FOREIGN KEY (TrackID)
    REFERENCES Track (ID)
GO

ALTER TABLE Question
  ADD CONSTRAINT FK_QuestionTypes_TO_Question
    FOREIGN KEY (TypeID)
    REFERENCES QuestionTypes (ID)
GO

ALTER TABLE QuestionOptions
  ADD CONSTRAINT FK_Question_TO_QuestionOptions
    FOREIGN KEY (QuestionID)
    REFERENCES Question (ID)
GO

ALTER TABLE StudentsExamsAnswers
  ADD CONSTRAINT FK_Student_TO_StudentsExamsAnswers
    FOREIGN KEY (StdID)
    REFERENCES Student (ID)
GO

ALTER TABLE StudentsExamsAnswers
  ADD CONSTRAINT FK_Question_TO_StudentsExamsAnswers
    FOREIGN KEY (QuestionID)
    REFERENCES Question (ID)
GO

ALTER TABLE ExamQuestions
  ADD CONSTRAINT FK_Exam_TO_ExamQuestions
    FOREIGN KEY (ExamID)
    REFERENCES Exam (ID)
GO

ALTER TABLE ExamQuestions
  ADD CONSTRAINT FK_Question_TO_ExamQuestions
    FOREIGN KEY (QuestionID)
    REFERENCES Question (ID)
GO

ALTER TABLE StudentExams
  ADD CONSTRAINT FK_Student_TO_StudentExams
    FOREIGN KEY (StdID)
    REFERENCES Student (ID)
GO

ALTER TABLE StudentExams
  ADD CONSTRAINT FK_Exam_TO_StudentExams
    FOREIGN KEY (ExamID)
    REFERENCES Exam (ID)
GO

ALTER TABLE Exam
  ADD CONSTRAINT FK_Course_TO_Exam
    FOREIGN KEY (CrsID)
    REFERENCES Course (ID)
GO

ALTER TABLE Track
  ADD CONSTRAINT FK_Instructor_TO_Track
    FOREIGN KEY (MngrID)
    REFERENCES Instructor (ID)
GO

ALTER TABLE Instructor
  ADD CONSTRAINT FK_Instructor_TO_Instructor
    FOREIGN KEY (SuperID)
    REFERENCES Instructor (ID)
GO

ALTER TABLE TrackInstructors
  ADD CONSTRAINT FK_Instructor_TO_TrackInstructors
    FOREIGN KEY (InsID)
    REFERENCES Instructor (ID)
GO

ALTER TABLE TrackInstructors
  ADD CONSTRAINT FK_Track_TO_TrackInstructors
    FOREIGN KEY (TrackID)
    REFERENCES Track (ID)
GO

ALTER TABLE CoursesInstructors
  ADD CONSTRAINT FK_Course_TO_CoursesInstructors
    FOREIGN KEY (CrsID)
    REFERENCES Course (ID)
GO

ALTER TABLE CoursesInstructors
  ADD CONSTRAINT FK_Instructor_TO_CoursesInstructors
    FOREIGN KEY (InsID)
    REFERENCES Instructor (ID)
GO

ALTER TABLE Question
  ADD CONSTRAINT FK_Instructor_TO_Question
    FOREIGN KEY (InsID)
    REFERENCES Instructor (ID)
GO

ALTER TABLE Exam
  ADD CONSTRAINT FK_Instructor_TO_Exam
    FOREIGN KEY (InsID)
    REFERENCES Instructor (ID)
GO

ALTER TABLE Question
  ADD CONSTRAINT FK_Course_TO_Question
    FOREIGN KEY (CrsID)
    REFERENCES Course (ID)
GO

ALTER TABLE Topic
  ADD CONSTRAINT FK_Course_TO_Topic
    FOREIGN KEY (CrsID)
    REFERENCES Course (ID)
GO

ALTER TABLE StudentsExamsAnswers
  ADD CONSTRAINT FK_Exam_TO_StudentsExamsAnswers
    FOREIGN KEY (ExamID)
    REFERENCES Exam (ID)
GO
