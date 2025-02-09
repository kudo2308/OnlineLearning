--create database
create database SWP_ver2
GO
--use database
use database SWP_ver2
GO
-- Role table
CREATE TABLE Role (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL
);

-- Account table
CREATE TABLE Account (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    RoleID INT,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);

-- Category table
CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NTEXT,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Course table
CREATE TABLE Course (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Description NTEXT,
    ExpertID INT,  -- ID of the instructor/expert
    Price DECIMAL(10,2) DEFAULT 0.00,
    PricePackageID INT,
    CategoryID INT,
    ImageUrl NVARCHAR(255),
    TotalLesson INT DEFAULT 0,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ExpertID) REFERENCES Account(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- Registration table (for course enrollments)
CREATE TABLE Registration (
    RegistrationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    CourseID INT,
    Price DECIMAL(10,2),
    Status NVARCHAR(20) DEFAULT 'pending', -- pending, active, completed, cancelled
    Progress INT DEFAULT 0,
    ValidFrom DATETIME DEFAULT GETDATE(),
    ValidTo DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Account(UserID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Lesson table
CREATE TABLE Lesson (
    LessonID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Content NTEXT,
    LessonType NVARCHAR(50), -- video, document, quiz
    VideoUrl NVARCHAR(255),
    DocumentUrl NVARCHAR(255),
    Duration INT, -- in minutes
    OrderNumber INT,
    CourseID INT,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Quiz table
CREATE TABLE Quiz (
    QuizID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Description NTEXT,
    Duration INT,  -- in minutes
    PassRate DECIMAL(5,2),
    TotalQuestion INT DEFAULT 0,
    CourseID INT,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Question table
CREATE TABLE Question (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    Content NTEXT NOT NULL,
    AnswerOptions NTEXT,  -- Store as JSON array of options
    CorrectAnswer NTEXT,
    Explanation NTEXT,
    PointPerQuestion INT DEFAULT 1,
    QuizID INT,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID)
);

-- Feedback table
CREATE TABLE Feedback (
    FeedbackID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    CourseID INT,
    Content NTEXT,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Account(UserID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

CREATE TABLE Settings (
    SettingID INT IDENTITY(1,1) PRIMARY KEY, 
    [Key] NVARCHAR(100) NOT NULL,          
    [Value] NVARCHAR(MAX) NOT NULL,        
    Description NVARCHAR(255) NULL,        
    CreatedAt DATETIME DEFAULT GETDATE(),   
    UpdatedAt DATETIME DEFAULT GETDATE()    
);


-- Insert roles
INSERT INTO Role (RoleName) VALUES
('Admin'),
('Expert'),
('Student');

-- Insert categories
INSERT INTO Category (Name, Description) VALUES
('Programming', 'Learn various programming languages and concepts'),
('Web Development', 'Master web development technologies'),
('Database', 'Database design and management'),
('Networking', 'Computer networking and protocols'),
('Mobile Development', 'Mobile app development for iOS and Android'),
('DevOps', 'Development operations and deployment'),
('Data Science', 'Data analysis and machine learning'),
('Security', 'Cybersecurity and ethical hacking');

-- Insert a sample admin account (password: admin123)
INSERT INTO Account (FullName, Username, Password, Email, RoleID, Status) VALUES
('System Admin', 'admin', 'admin123', 'admin@onlinelearning.com', 1, 1);

-- Insert a sample expert account (password: expert123)
INSERT INTO Account (FullName, Username, Password, Email, RoleID, Status) VALUES
('John Expert', 'expert1', 'expert123', 'expert1@onlinelearning.com', 2, 1);

-- Insert a sample student account (password: student123)
INSERT INTO Account (FullName, Username, Password, Email, RoleID, Status) VALUES
('Jane Student', 'student1', 'student123', 'student1@onlinelearning.com', 3, 1);

-- Insert sample course
INSERT INTO Course (Title, Description, ExpertID, CategoryID, ImageUrl, TotalLesson, Price) VALUES
('Java Programming Fundamentals', 
 'Learn the basics of Java programming language including syntax, OOP concepts, and practical applications',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/images/courses/java-fundamentals.jpg',
 10,
 120);
