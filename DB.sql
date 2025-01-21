-- Create Database
CREATE DATABASE SWP_OLS_ver1;
GO
-- Use the created database
USE SWP_OLS_ver1;
GO

-- Create Role table
CREATE TABLE Role (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(100) NOT NULL
);

-- Create User table
CREATE TABLE Account (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(255) NOT NULL,
    username NVARCHAR(255) UNIQUE NOT NULL,
    Password NVARCHAR(255) NOT NULL,
	Email NVARCHAR(255) UNIQUE NOT NULL,
    RoleID INT NOT NULL,
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);
-- Create PricePackage table
/*CREATE TABLE PricePackage (
    PricePackageID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    DurationMonths INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    SalePrice DECIMAL(10,2) NULL,
	
);*/
--Create Category
CREATE TABLE Category(
	CategoryID INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(255) NOT NULL
);
-- Create Course table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    ExpertID INT NOT NULL,
    PricePackageID INT NOT NULL,
	CategoryID INT NOT NULL,
    FOREIGN KEY (ExpertID) REFERENCES Account(UserID),
    --FOREIGN KEY (PricePackageID) REFERENCES PricePackage(PricePackageID),
	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
);
-- Create Lesson table
CREATE TABLE Lesson (
    LessonID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX),
    LessonType NVARCHAR(50) NOT NULL,
    CourseID INT NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Create Quiz table
CREATE TABLE Quiz (
    QuizID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Duration INT NOT NULL,
    PassRate DECIMAL(5,2) NOT NULL,
    CourseID INT NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Create Question table
CREATE TABLE Question (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    Content NVARCHAR(MAX) NOT NULL,
    AnswerOptions NVARCHAR(MAX) NOT NULL,
    CorrectAnswer NVARCHAR(255) NOT NULL,
	AnswerExplain NVARCHAR(MAX) NOT NULL,
    QuizID INT NOT NULL,
    FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID)
);

-- Create Registration table
CREATE TABLE Registration (
    RegistrationID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    CourseID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    ValidFrom DATE NOT NULL,
    ValidTo DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Account(UserID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Create Feedback table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    CourseID INT NOT NULL,
    Content NVARCHAR(MAX),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    FOREIGN KEY (UserID) REFERENCES Account(UserID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
