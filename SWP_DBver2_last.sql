--create database

create database SWP_ver2
GO
--use database
use SWP_ver2
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
    Description NVARCHAR(250) NULL,
    Password NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(100) Null,
    Image NVARCHAR(100) Null,
    Address NVARCHAR(100) Null,
    GenderID NVARCHAR(50) NULL, 
    DOB DATE NULL,
    RoleID INT,
    SubScriptionType VARCHAR(20) DEFAULT 'free' CHECK (SubScriptionType IN ('free', 'plus', 'pro')),
    SubScriptionExpiry DATETIME NULL,
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[CourseID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] NVARCHAR(MAX) NULL,
	[ExpertID] [int] NULL, 
	[Price] [float] NULL,
	[CategoryID] [int] NULL,
	[ImageUrl] [nvarchar](255) NULL,
	[TotalLesson] [int] NULL,
	[Status] [nvarchar](255) NULL,
    [UserId] [int] NULL,        
	CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (ExpertID) REFERENCES Account(UserID),
	FOREIGN KEY (UserId) REFERENCES Account(UserID),
PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE dbo.Course
ADD CONSTRAINT CHK_Status_Values CHECK (Status IN ('Draft', 'Pending', 'Public', 'Rejected', 'Blocked'))
GO
CREATE TABLE Cart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT FOREIGN KEY REFERENCES Account(UserID)
);
GO

-- Create CartDetail table
CREATE TABLE CartDetail (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CartID INT FOREIGN KEY REFERENCES Cart(CartID),
    CourseID INT FOREIGN KEY REFERENCES Course(CourseID)
);
GO

-- Registration table (for course enrollments)
CREATE TABLE Registration (
    RegistrationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    CourseID INT,
    Price DECIMAL(10,2),
    Status NVARCHAR(20) DEFAULT 'pending' CHECK (Status IN ('pending', 'active', 'completed', 'cancelled')),
    Progress INT DEFAULT 0,
    ValidFrom DATETIME DEFAULT GETDATE(),
    ValidTo DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Account(UserID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

CREATE TABLE Packages (
    PackageID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Description NTEXT,
    CourseID INT NOT NULL,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Lesson table 
CREATE TABLE Lesson (
    LessonID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Content NTEXT,
    LessonType NVARCHAR(50) CHECK (LessonType IN ('Basic', 'Advanced')) NOT NULL,
    VideoUrl NVARCHAR(MAX) NULL,
    DocumentUrl NVARCHAR(MAX) NULL,
    Duration INT, -- in minutes
    OrderNumber INT,
    CourseID INT NOT NULL,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    PackageID INT NOT NULL DEFAULT 1,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (PackageID) REFERENCES Packages(PackageID)
);

-- LessonProgress table
CREATE TABLE LessonProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    LessonID INT NOT NULL,
    UserID INT NOT NULL,
    CourseID INT NOT NULL,
    Completed BIT DEFAULT 0,
    CompletedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (LessonID) REFERENCES Lesson(LessonID),
    FOREIGN KEY (UserID) REFERENCES Account(UserID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    CONSTRAINT UQ_UserLesson UNIQUE (UserID, LessonID)
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
    PackageID INT,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (PackageID) REFERENCES Packages(PackageID)
);

-- Question table
CREATE TABLE Question (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    Content NTEXT NOT NULL,
    PointPerQuestion INT DEFAULT 1,
    QuizID INT,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID)
);

CREATE TABLE Answer (
    answerID INT IDENTITY(1,1) PRIMARY KEY,
    content NVARCHAR(MAX) NOT NULL,
    isCorrect BIT NOT NULL DEFAULT 0,
    Explanation NVARCHAR(MAX) NOT NULL,
    questionID INT NOT NULL,
    FOREIGN KEY (questionID) REFERENCES Question(questionID)
);


CREATE TABLE Blog (
    BlogID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Content NTEXT NOT NULL,
	ImageUrl NVARCHAR(255),
	CategoryID INT,
    AuthorID INT,  -- ID of the author (referencing Account table)
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    Status VARCHAR(10) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Private', 'Public', 'Pending')),
    FOREIGN KEY (AuthorID) REFERENCES Account(UserID),
	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);
-- Feedback table
CREATE TABLE Feedback (
    FeedbackID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    CourseID INT,
	BlogID INT,
    Content NVARCHAR(MAX),
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Account(UserID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
	FOREIGN KEY (BlogID) REFERENCES Blog(BlogID)
);

CREATE TABLE Settings (
    SettingID INT IDENTITY(1,1) PRIMARY KEY, 
    [Key] NVARCHAR(100) NOT NULL,          
    [Value] NVARCHAR(MAX) NOT NULL,        
    Description NVARCHAR(255) NULL,        
    CreatedAt DATETIME DEFAULT GETDATE(),   
    UpdatedAt DATETIME DEFAULT GETDATE()    
);

CREATE TABLE SocialLink (
    UserID INT PRIMARY KEY,
    Xspace NVARCHAR(255) NULL,
    Youtube NVARCHAR(255) NULL,
    Facebook NVARCHAR(255) NULL,
    Linkedin NVARCHAR(255) NULL,
	Private NVARCHAR(20) DEFAULT 'public' CHECK (Private IN ('public', 'block-course', 'block-inscrits', 'block-view','view-profile-only')),
    FOREIGN KEY (UserID) REFERENCES Account(UserID)
);

CREATE TABLE [Order] (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL FOREIGN KEY REFERENCES Account(UserID),
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentMethod NVARCHAR(50) DEFAULT 'VNPay',
    PaymentStatus NVARCHAR(20) DEFAULT 'pending' CHECK (PaymentStatus IN ('pending', 'paid', 'failed', 'refunded')),
    VNPayTransactionID NVARCHAR(255) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE OrderItem (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL FOREIGN KEY REFERENCES [Order](OrderID),
    CourseID INT NOT NULL FOREIGN KEY REFERENCES Course(CourseID),
    ExpertID INT NOT NULL FOREIGN KEY REFERENCES Account(UserID),
    OriginalPrice DECIMAL(10,2) NOT NULL,
    CommissionRate DECIMAL(5,2) NOT NULL, -- Ví d?: 0.2 cho 20%
    FinalAmount DECIMAL(10,2) NOT NULL, -- S? ti?n expert nh?n ???c
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE ExpertPayout (
    PayoutID INT IDENTITY(1,1) PRIMARY KEY,
    ExpertID INT NOT NULL FOREIGN KEY REFERENCES Account(UserID),
    Amount DECIMAL(10,2) NOT NULL,
    BankAccountNumber NVARCHAR(255) NOT NULL,
    BankName NVARCHAR(255) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'pending' CHECK (Status IN ('pending','processed', 'successful','withdrawn', 'failed')),
    RequestedAt DATETIME DEFAULT GETDATE(),
    ProcessedAt DATETIME NULL
);
CREATE TABLE ExpertBankInfo (
    ExpertID INT PRIMARY KEY,
    BankAccountNumber NVARCHAR(255) NULL,
    BankName NVARCHAR(255) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
	WalletBalance DECIMAL(18, 2) DEFAULT 0.00,
    FOREIGN KEY (ExpertID) REFERENCES Account(UserID)
);


CREATE TABLE AdminWallet (
    WalletID INT IDENTITY(1,1) PRIMARY KEY,
    AdminID INT NOT NULL,
    Balance DECIMAL(18, 2) DEFAULT 0.00,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AdminID) REFERENCES Account(UserID)
);

-- Bảng lưu trữ lịch sử giao dịch ví
CREATE TABLE WalletTransaction (
     TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    Amount DECIMAL(18, 2) NOT NULL,
    TransactionType NVARCHAR(50) CHECK (TransactionType IN ('deposit', 'withdraw', 'commission', 'payout', 'refund', 'other')) NOT NULL,
	BankTransactionID NVARCHAR(255) NULL,
    Description NVARCHAR(255),
    SenderID INT,
    ReceiverID INT,
    RelatedOrderID INT NULL,
    RelatedPayoutID INT NULL,
    Status NVARCHAR(20) DEFAULT 'completed' CHECK (Status IN ('pending', 'completed', 'failed', 'cancelled')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    ProcessedAt DATETIME NULL,
    ProcessedBy INT NULL,
    FOREIGN KEY (SenderID) REFERENCES Account(UserID),
    FOREIGN KEY (ReceiverID) REFERENCES Account(UserID),
    FOREIGN KEY (RelatedOrderID) REFERENCES [Order](OrderID),
    FOREIGN KEY (RelatedPayoutID) REFERENCES ExpertPayout(PayoutID),
    FOREIGN KEY (ProcessedBy) REFERENCES Account(UserID)
);

-- Bảng cấu hình hoa hồng cho admin
CREATE TABLE CommissionSetting (
    SettingID INT IDENTITY(1,1) PRIMARY KEY,
    CommissionRate DECIMAL(5, 2) DEFAULT 0.20, -- Tỷ lệ mặc định là 20%
    CourseType NVARCHAR(50) DEFAULT 'all', -- Loại khóa học áp dụng (hoặc 'all' cho tất cả)
    EffectiveFrom DATETIME DEFAULT GETDATE(),
    EffectiveTo DATETIME NULL,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    Status BIT DEFAULT 1,
    FOREIGN KEY (CreatedBy) REFERENCES Account(UserID)
);

-- Bảng báo cáo tài chính theo tháng/năm
CREATE TABLE FinancialReport (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    ReportMonth INT NOT NULL,
    ReportYear INT NOT NULL,
    TotalIncome DECIMAL(18, 2) DEFAULT 0.00,
    TotalPayout DECIMAL(18, 2) DEFAULT 0.00,
    TotalProfit DECIMAL(18, 2) DEFAULT 0.00,
    TotalActiveCourses INT DEFAULT 0,
    TotalNewUsers INT DEFAULT 0,
    GeneratedAt DATETIME DEFAULT GETDATE(),
    GeneratedBy INT NOT NULL,
    FOREIGN KEY (GeneratedBy) REFERENCES Account(UserID),
    CONSTRAINT UQ_MonthYearReport UNIQUE (ReportMonth, ReportYear)
);
-- Bảng quản lý thông báo
CREATE TABLE Notification (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Type NVARCHAR(50) CHECK (Type IN ('system', 'course', 'message', 'payment', 'other')),
	RelatedLink NVARCHAR(255)  null,
    RelatedID INT NULL, -- ID của đối tượng liên quan (khóa học, tin nhắn...)
    IsRead BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Account(UserID)
);

-- Bảng chat conversation (cuộc trò chuyện)
CREATE TABLE Conversation (
    ConversationID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NULL,
    Type NVARCHAR(20) CHECK (Type IN ('private', 'group')) DEFAULT 'private',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- Bảng quản lý thành viên trong cuộc trò chuyện
CREATE TABLE ConversationMember (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    ConversationID INT NOT NULL,
    UserID INT NOT NULL,
    JoinedAt DATETIME DEFAULT GETDATE(),
    LeftAt DATETIME NULL,
    Status BIT DEFAULT 1, -- 1: Active, 0: Inactive
    FOREIGN KEY (ConversationID) REFERENCES Conversation(ConversationID),
    FOREIGN KEY (UserID) REFERENCES Account(UserID),
    CONSTRAINT UQ_UserConversation UNIQUE (UserID, ConversationID)
);

-- Bảng tin nhắn
CREATE TABLE Message (
    MessageID INT IDENTITY(1,1) PRIMARY KEY,
    ConversationID INT NOT NULL,
    SenderID INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    AttachmentUrl NVARCHAR(255) NULL,
    SentAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ConversationID) REFERENCES Conversation(ConversationID),
    FOREIGN KEY (SenderID) REFERENCES Account(UserID)
);

-- Bảng trạng thái đọc tin nhắn
CREATE TABLE MessageRead (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MessageID INT NOT NULL,
    UserID INT NOT NULL,
    ReadAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MessageID) REFERENCES Message(MessageID),
    FOREIGN KEY (UserID) REFERENCES Account(UserID),
    CONSTRAINT UQ_MessageUser UNIQUE (MessageID, UserID)
);

-- Insert roles
INSERT INTO Role (RoleName) VALUES
('Admin'),
('Expert'),
('Student'),
('Marketing'),
('Saler')

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
INSERT INTO Account (FullName, Description, Password, Email, RoleID, DOB, Image, Status) 
VALUES
('System Admin', 'Administrator account', 'VmszaVktKzZlKmRlJHMuYWRtaW4xMjM=', 'admin@onlinelearning.com', 1, '1990-01-01', '/assets/images/avatar/pic1.jpg', 1);

INSERT INTO AdminWallet (AdminID, Balance) 
VALUES (1, 0.00);

-- Insert a sample expert account (password: expert123)
INSERT INTO Account (FullName, Description, Password, Email, RoleID, DOB, Image, Status) 
VALUES
('John Expert', 'Expert account', 'VmszaVktKzZlKmRlJHMuZXhwZXJ0MTIz', 'expert1@onlinelearning.com', 2, '1985-05-12', '/assets/images/avatar/pic2.jpg', 1),
('Do Trung Hieu', 'Expert account', 'expert2', 'expert2@onlinelearning.com', 2, '2004-08-23','/assets/images/avatar/pic2.jpg',1 ),
('Nguyen Vo Thai Bao', 'Expert account', 'expert3', 'expert3@onlinelearning.com', 2, '2004-08-23','/assets/images/avatar/pic2.jpg',1 ),
('Vu Danh Hieu', 'Expert account', 'expert4', 'expert4@onlinelearning.com', 2, '2004-08-23','/assets/images/avatar/pic2.jpg',1 ),
('Kieu Tuan Hung', 'Expert account', 'expert5', 'expert5@onlinelearning.com', 2, '2004-08-23','/assets/images/avatar/pic2.jpg',1 );

-- Insert a sample student account (password: student)
INSERT INTO Account (FullName, Description, Password, Email, RoleID, DOB, Image, Status) 
VALUES
('Jane Student', 'Student account', 'VmszaVktKzZlKmRlJHMuc3R1ZGVudA==', 'student1@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1),
('Student9', 'Student account', 'VmszaVktKzZlKmRlJHMuc3R1ZGVudA==', 'student9@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1),
('Student2', 'Student account', 'VmszaVktKzZlKmRlJHMuc3R1ZGVudA==', 'student2@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1),
('Student3', 'Student account', 'VmszaVktKzZlKmRlJHMuc3R1ZGVudA==', 'student3@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1),
('Student4', 'Student account', 'VmszaVktKzZlKmRlJHMuc3R1ZGVudA==', 'student4@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1),
('Student5', 'Student account', 'VmszaVktKzZlKmRlJHMuc3R1ZGVudA==', 'student5@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1),
('Student6', 'Student account', 'VmszaVktKzZlKmRlJHMuc3R1ZGVudA==', 'student6@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1),
('Student7', 'Student account', 'VmszaVktKzZlKmRlJHMuc3R1ZGVudA==', 'student7@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1),
('Student8', 'Student account', 'VmszaVktKzZlKmRlJHMuc3R1ZGVudA==', 'student8@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1);

-- Insert social links for System Admin
INSERT INTO SocialLink (UserID, Xspace, Youtube, Facebook, Linkedin, Private) 
VALUES (1, 'admin', 'admin', 'admin', 'admin', 'public');
-- Insert social links for Expert accounts
INSERT INTO SocialLink (UserID, Xspace, Youtube, Facebook, Linkedin, Private) 
VALUES 
(2, 'expert1', 'expert1', 'expert1', 'expert1', 'public'),
(3, 'expert2', 'expert2', 'expert2', 'expert2', 'public'),
(4, 'expert3', 'expert3', 'expert3', 'expert3', 'public'),
(5, 'expert4', 'expert4', 'expert4', 'expert4', 'public'),
(6, 'expert5', 'expert5', 'expert5', 'expert5', 'public');
-- Insert social links for Student accounts
INSERT INTO SocialLink (UserID, Xspace, Youtube, Facebook, Linkedin, Private) 
VALUES 
(7, 'student1', 'student1', 'student1', 'student1', 'public'),
(8, 'student9', 'student9', 'student9', 'student9', 'public'),
(9, 'student2', 'student2', 'student2', 'student2', 'public'),
(10, 'student3', 'student3', 'student3', 'student3', 'public'),
(11, 'student4', 'student4', 'student4', 'student4', 'public'),
(12, 'student5', 'student5', 'student5', 'student5', 'public'),
(13, 'student6', 'student6', 'student6', 'student6', 'public'),
(14, 'student7', 'student7', 'student7', 'student7', 'public'),
(15, 'student8', 'student8', 'student8', 'student8', 'public');

-- Insert sample course with Status set to 1
-- Insert sample courses with improved titles
-- First half to 'Public'
INSERT INTO Course (Title, Description, ExpertID, CategoryID, ImageUrl, TotalLesson, Price, Status) VALUES
('Java Programming & SQL Database Mastery', 
 'Master Java programming and SQL database fundamentals. Learn core Java concepts, JDBC connectivity, and essential SQL queries for database operations. Perfect for beginners wanting to build database-driven applications.',
 2,
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic1.jpg',
 10,
 280000,
 'Public'),

('Comprehensive Data Structures & Algorithms', 
 'Comprehensive guide to data structures and algorithms. Cover essential topics like arrays, linked lists, trees, sorting algorithms, and complexity analysis. Includes practical coding exercises and problem-solving techniques.',
 2,
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic2.jpg',
 10,
 200000,
 'Public'),

('Complete C++ Programming: From Beginner to Advanced', 
 'Complete C++ programming course from basics to advanced concepts. Learn object-oriented programming, memory management, STL library, and modern C++ features. Includes hands-on projects and coding exercises.',
 3,
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic3.jpg',
 10,
 275000,
 'Public'),

('Modern Frontend Development with React.js', 
 'Master modern React development. Learn components, hooks, state management, routing, and best practices. Build responsive user interfaces and single-page applications using the latest React features.',
 4,
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic4.jpg',
 10,
 640000,
 'Public'),

('Frontend Web Development with HTML & CSS', 
 'Learn web development fundamentals with HTML5 and CSS3. Master responsive design, flexbox, grid layouts, and modern CSS frameworks. Create beautiful, mobile-friendly websites from scratch.',
 5,
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic5.jpg',
 10,
 600000,
 'Public'),

('Advanced JavaScript & Frontend Development', 
 'Comprehensive JavaScript course covering ES6+ features, DOM manipulation, async programming, and modern JS frameworks. Learn to create interactive web applications and dynamic user interfaces.',
 5,
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic6.jpg',
 10,
 300000,
 'Public'),

('Backend Web Development with Node.js & Express', 
 'Build scalable server-side applications with Node.js. Learn Express.js, RESTful APIs, database integration, authentication, and deployment. Includes real-world projects and best practices.',
 6,
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic1.jpg',
 10,
 700000,
 'Public'),

('Java Backend Development with Spring Boot', 
 'Master backend development with Java. Cover Spring Boot, REST APIs, microservices, JPA/Hibernate, and security. Learn to build and deploy enterprise-grade applications using modern Java frameworks.',
 6,
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic2.jpg',
 10,
 750000,
 'Public'),

('Java Programming Fundamentals', 
 'Learn the basics of Java programming language including syntax, OOP concepts, and practical applications',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic3.jpg',
 10,
 120000,
 'Public'),

('Advanced Java Programming', 
 'This course will take you beyond the basics of Java, exploring advanced topics such as multithreading, concurrency, design patterns, and Java s ecosystem for building scalable applications.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic2.jpg',
 15,
 150000,
 'Public'),

('Full Stack Web Development', 
 'Master both front-end and back-end web development. This course covers HTML, CSS, JavaScript, React, Node.js, and database integration. You will also learn how to deploy your full-stack applications.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Web Development'),
 '/assets/images/courses/pic3.jpg',
 20,
 200000,
 'Public'),

('Introduction to Databases and SQL', 
 'In this course, you will learn the fundamentals of relational databases, SQL syntax, and how to work with databases. It covers topics such as database normalization, indexing, and optimization.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Database'),
 '/assets/images/courses/pic4.jpg',
 10,
 100000,
 'Public'),

('Networking Fundamentals', 
 'This course provides an in-depth understanding of networking concepts including IP addressing, subnetting, TCP/IP protocols, routing, and network security.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Networking'),
 '/assets/images/courses/pic5.jpg',
 12,
 120000,
 'Public'),

('Mobile App Development with Flutter', 
 'Learn how to build mobile applications for both iOS and Android using Flutter. This course will guide you through the entire process from setting up the environment to deploying your first app.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Mobile Development'),
 '/assets/images/courses/pic6.jpg',
 18,
 180000,
 'Public');
INSERT INTO Course (Title, Description, ExpertID, CategoryID, ImageUrl, TotalLesson, Price, Status) VALUES
('Data Science with Python', 
 'This course teaches you the essentials of Data Science, focusing on Python programming. Topics covered include data cleaning, visualization, and machine learning algorithms using libraries like Pandas, NumPy, and Scikit-Learn.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Data Science'),
 '/assets/images/courses/pic7.jpg',
 22,
 220000,
 'Public'),

('Introduction to Cybersecurity', 
 'Learn the basics of cybersecurity, including network security, cryptography, and threat analysis. This course provides essential knowledge to protect systems and data from potential cyber threats.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Security'),
 '/assets/images/courses/pic8.jpg',
 14,
 140000,
 'Public'),

('Building Modern DevOps Pipelines', 
 'This course introduces DevOps concepts, including continuous integration, continuous delivery, and the use of tools like Docker, Kubernetes, and Jenkins to automate software development and deployment.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'DevOps'),
 '/assets/images/courses/pic9.jpg',
 16,
 160000,
 'Public'),

('Python for Data Analysis', 
 'Learn how to use Python for data analysis. This course covers libraries such as Pandas, NumPy, and Matplotlib for data manipulation and visualization. You will also learn how to clean and prepare data for analysis.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Data Science'),
 '/assets/images/courses/pic1.jpg',
 18,
 180000,
 'Public'),

('React Native for Mobile Apps', 
 'This course covers the basics of React Native, an open-source framework for building mobile apps. You will learn how to create cross-platform mobile applications for both iOS and Android using JavaScript and React.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Mobile Development'),
 '/assets/images/courses/pic2.jpg',
 20,
 200000,
 'Public'),

('Deep Learning with TensorFlow', 
 'In this course, you will learn the basics of deep learning and how to implement neural networks using TensorFlow. Topics include supervised learning, CNNs, RNNs, and reinforcement learning.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Data Science'),
 '/assets/images/courses/pic3.jpg',
 25,
 250000,
 'Public'),

('Introduction to Cloud Computing', 
 'Cloud computing is transforming the way businesses operate. In this course, you will learn the fundamentals of cloud computing, the different cloud service models, and the leading cloud platforms such as AWS, Azure, and Google Cloud.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Networking'),
 '/assets/images/courses/pic4.jpg',
 12,
 120000,
 'Public'),

('Advanced Cybersecurity Practices', 
 'This course is designed for those who already have a basic understanding of cybersecurity. You will learn about advanced topics such as penetration testing, incident response, advanced threat protection, and ethical hacking.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Security'),
 '/assets/images/courses/pic5.jpg',
 20,
 200000,
 'Public'),

('Agile Project Management', 
 'Agile is a popular project management methodology used in software development and other industries. In this course, you will learn about Agile principles, Scrum framework, and how to manage projects using Agile techniques.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'DevOps'),
 '/assets/images/courses/pic6.jpg',
 15,
 150000,
 'Public'),

('Introduction to Internet of Things (IoT)', 
 'The Internet of Things (IoT) is a rapidly growing technology that connects devices to the internet. This course will introduce you to IoT concepts, including sensors, actuators, and cloud computing for managing IoT devices.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Networking'),
 '/assets/images/courses/pic7.jpg',
 18,
 180000,
 'Public'),

('Building Scalable Web Applications', 
 'This course will teach you how to build scalable web applications using modern technologies such as microservices, containers, and cloud platforms. You will also learn about API design, load balancing, and database scaling.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Web Development'),
 '/assets/images/courses/pic8.jpg',
 22,
 220000,
 'Public');

 -- Insert multiple blog posts with longer content
-- Insert multiple blog posts with longer content
-- Insert multiple blog posts with longer content
INSERT INTO Blog (Title, Content, ImageUrl, CategoryID, AuthorID, Status) 
VALUES
('Understanding SQL Joins', 
 'SQL Joins are fundamental to relational databases and allow us to retrieve data from multiple tables in a single query. There are several types of joins that we can use, such as INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN. Each type serves a different purpose depending on the way we want to combine data from two or more tables. INNER JOIN only returns rows where there is a match in both tables. LEFT JOIN returns all rows from the left table and matching rows from the right table, while RIGHT JOIN returns all rows from the right table and matching rows from the left. FULL OUTER JOIN returns all rows when there is a match in either table. Understanding these joins and when to use them is crucial for writing efficient SQL queries.',
 '/assets/images/courses/pic2.jpg',
 1,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 'Public'),

('Introduction to Data Science', 
 'Data Science is one of the fastest-growing fields today, revolutionizing how industries analyze and interpret data. At its core, Data Science is about using scientific methods, algorithms, and systems to extract knowledge and insights from structured and unstructured data. The field includes a variety of techniques such as machine learning, data mining, and statistical analysis. One of the key aspects of data science is the ability to work with large datasets, often referred to as Big Data. Data scientists need proficiency in various programming languages such as Python and R, as well as familiarity with tools like Hadoop, Spark, and SQL. Additionally, they must possess a strong foundation in mathematics and statistics to interpret data accurately and create meaningful predictions.',
 '/assets/images/courses/pic3.jpg',
 2,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 'Public'),

('Tips for Efficient Web Development', 
 'Web development is a constantly evolving field, and staying up to date with best practices is essential for building modern, efficient websites. One of the first tips for efficient web development is to ensure that your website is responsive. A responsive design adjusts the layout of the website to look great on any device, whether it s a desktop, tablet, or mobile phone. Another important practice is code optimization. Minimizing CSS and JavaScript files, reducing image sizes, and utilizing techniques like lazy loading can significantly improve website performance. Additionally, a clean and well-organized codebase is crucial for long-term maintainability. Developers should use version control systems like Git, follow naming conventions, and ensure that they write modular and reusable code.',
 '/assets/images/courses/pic4.jpg',
 3,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 'Public'),

('Mobile App Development for Beginners', 
 'Mobile app development is a rapidly growing area in the tech world, with millions of apps being developed for platforms like iOS and Android every year. For beginners, it is essential to start by understanding the basics of mobile app development. Both iOS and Android apps are typically built using specific programming languages: Swift or Objective-C for iOS, and Java or Kotlin for Android. Additionally, developers should learn about integrated development environments (IDEs) like Xcode for iOS and Android Studio for Android. Building a simple app, such as a calculator or a to-do list, is a great way to get started. After that, you can progress to more complex projects, such as social media apps or e-commerce platforms. Understanding UI/UX design principles is also important for creating user-friendly mobile applications.',
 '/assets/images/courses/pic5.jpg',
 4,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 'Public'),

('Best Practices in Cybersecurity', 
 'In today s digital age, cybersecurity is more important than ever. As more businesses and individuals rely on the internet for daily activities, the risk of cyberattacks continues to rise. Best practices in cybersecurity include ensuring strong password management, using multi-factor authentication (MFA), and regularly updating software to protect against vulnerabilities. Additionally, organizations should conduct regular security audits, implement firewalls, and use encryption to secure sensitive data. Employees should also be trained on recognizing phishing attempts and suspicious activities. Cybersecurity is not just about preventing attacks but also about preparing for potential breaches and having a robust recovery plan in place.',
 '/assets/images/courses/pic6.jpg',
 5,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 'Public'),

('How to Learn Programming Effectively', 
 'Learning to code can seem like a daunting task, especially for beginners, but with the right strategies, anyone can become proficient in programming. The first step is to choose the right programming language. Popular languages for beginners include Python, JavaScript, and Ruby, as they are versatile and widely used. Once a language is chosen, beginners should focus on understanding the basic concepts such as variables, loops, functions, and conditionals. Practicing regularly by building small projects is key to solidifying concepts. Additionally, online tutorials, coding bootcamps, and community forums can provide valuable resources and support. The key to success is consistency setting aside time every day to practice and solve coding challenges will lead to steady improvement.',
 '/assets/images/courses/pic7.jpg',
 6,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 'Public'),
('Backend Node.js', 
 'Node.js has matured into a robust platform for building scalable backend applications. The event-driven, non-blocking I/O model makes Node.js particularly well-suited for handling concurrent connections efficiently. Express.js remains the most popular framework, providing a minimal yet powerful foundation for building web applications and APIs. Modern Node.js development emphasizes architectural patterns like Clean Architecture and Domain-Driven Design for building maintainable applications. Authentication and authorization implementations have evolved, with JSON Web Tokens (JWT) and OAuth becoming standard practices. Database integration options have expanded, with ORMs like Prisma and TypeORM offering type-safe database access. Error handling strategies have matured, incorporating proper logging, monitoring, and error reporting practices. Performance optimization includes clustering, caching strategies, and proper memory management. Security best practices encompass input validation, rate limiting, and protection against common vulnerabilities. Microservices architecture in Node.js often utilizes message queues and service discovery mechanisms. Testing strategies incorporate unit tests, integration tests, and end-to-end testing using frameworks like Jest and Supertest.',
 '/assets/images/courses/pic4.jpg',
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 (SELECT UserID FROM Account WHERE Email = 'expert4@onlinelearning.com'),
 'Public'),

('backend Java', 
 'Enterprise Java development has evolved significantly with Spring Boot and modern Java features leading the way. Microservices architecture has become the standard for building scalable enterprise applications, with Spring Cloud providing essential distributed system patterns. Modern Java backend development emphasizes reactive programming for building responsive and resilient systems. Security implementations have become more sophisticated, incorporating OAuth2, OpenID Connect, and fine-grained authorization. Database access patterns have evolved with Spring Data JPA, R2DBC for reactive database access, and advanced caching strategies. API design focuses on REST best practices, GraphQL integration, and proper documentation using OpenAPI/Swagger. Monitoring and observability are crucial, with tools like Micrometer, Prometheus, and ELK stack becoming standard. Testing strategies incorporate unit tests, integration tests, and contract tests for microservices. Deployment practices emphasize containerization with Docker and orchestration with Kubernetes. Performance optimization includes proper connection pooling, caching strategies, and efficient resource utilization. Understanding transaction management, message queuing, and distributed tracing is essential for building robust enterprise applications.',
 '/assets/images/courses/pic6.jpg',
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 (SELECT UserID FROM Account WHERE Email = 'expert5@onlinelearning.com'),
 'Private');

  -- Insert Package data

INSERT INTO Packages (Name, Description, CourseID, Status)
VALUES
-- Java & SQL (2 packages)
('Java & SQL Beginner Package', 'Learn Java and SQL from scratch.', 
 (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery'), 1),
('Java & SQL Advanced Package', 'Advanced Java and SQL development.', 
 (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery'), 1),

-- Data Structure and Algorithms (2 packages)
('Data Structures Basics', 'Introduction to data structures and algorithms.', 
 (SELECT CourseID FROM Course WHERE Title = 'Comprehensive Data Structures & Algorithms'), 1),
('Data Structures Advanced', 'Advanced problem-solving techniques.', 
 (SELECT CourseID FROM Course WHERE Title = 'Comprehensive Data Structures & Algorithms'), 1),

-- C++ (2 packages)
('C++ Programming Basics', 'Learn fundamental C++ programming concepts.', 
 (SELECT CourseID FROM Course WHERE Title = 'Complete C++ Programming: From Beginner to Advanced'), 1),
('C++ Advanced Topics', 'Deep dive into advanced C++ programming.', 
 (SELECT CourseID FROM Course WHERE Title = 'Complete C++ Programming: From Beginner to Advanced'), 1),

-- Frontend ReactJS (2 packages)
('ReactJS Beginner', 'Introduction to React fundamentals.', 
 (SELECT CourseID FROM Course WHERE Title = 'Modern Frontend Development with React.js'), 1),
('ReactJS Advanced', 'Advanced React concepts like Redux.', 
 (SELECT CourseID FROM Course WHERE Title = 'Modern Frontend Development with React.js'), 1),

-- Frontend HTML/CSS (2 packages)
('HTML & CSS Basics', 'Master HTML and CSS for web development.', 
 (SELECT CourseID FROM Course WHERE Title = 'Frontend Web Development with HTML & CSS'), 1),
('HTML & CSS Advanced', 'Advanced responsive design techniques.', 
 (SELECT CourseID FROM Course WHERE Title = 'Frontend Web Development with HTML & CSS'), 1),

-- Frontend JavaScript (2 packages)
('JavaScript Fundamentals', 'Introduction to modern JavaScript.', 
 (SELECT CourseID FROM Course WHERE Title = 'Advanced JavaScript & Frontend Development'), 1),
('JavaScript Advanced Topics', 'Advanced JavaScript including frameworks.', 
 (SELECT CourseID FROM Course WHERE Title = 'Advanced JavaScript & Frontend Development'), 1),

-- Backend Node.js (2 packages)
('Node.js Basics', 'Learn backend development with Node.js.', 
 (SELECT CourseID FROM Course WHERE Title = 'Backend Web Development with Node.js & Express'), 1),
('Node.js Advanced', 'Master Node.js with microservices.', 
 (SELECT CourseID FROM Course WHERE Title = 'Backend Web Development with Node.js & Express'), 1),

-- Backend Java (2 packages)
('Backend Java Basics', 'Learn Java backend development.', 
 (SELECT CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot'), 1),
('Backend Java Advanced', 'Advanced Java backend concepts.', 
 (SELECT CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot'), 1);

-- Insert lessons for courses
-- Insert additional lessons
-- Insert lessons for each course (at least 2 lessons per course with duration < 30 minutes)
-- Insert statements for Lesson

INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status, CreatedAt, PackageID)
VALUES
('Lesson 1 - Introduction to Java', 'Learn the basics of Java programming.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=29', NULL, 25, 1, 1, 1, GETDATE(), 1),
('Lesson 2 (Part 1) - Java Syntax & Variables', 'Learn about Java syntax, data types, and variables.', 'Basic', 'https://www.youtube.com/watch?v=Fw2OXhXdkSE&index=28', NULL, 25, 1, 1, 1, GETDATE(), 1),
('Lesson 2 (Part 2) - Java Syntax & Variables', 'Continue learning about Java syntax, variables, and basic operations.', 'Basic', 'https://www.youtube.com/watch?v=Umhisw5X8_Y&index=27', NULL, 25, 1, 1, 1, GETDATE(), 1),
('Lesson 3 (Part 1) - Control Flow in Java', 'Learn about conditional statements and loops in Java.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=26', NULL, 25, 1, 1, 1, GETDATE(), 1),
('Lesson 3 (Part 2) - Control Flow in Java', 'Continue exploring if-else statements, switch cases, and loops.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=25', NULL, 25, 1, 1, 1, GETDATE(), 1),
('Lesson 4 - Java Methods & Functions', 'Learn how to define and use methods in Java.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=24', NULL, 25, 1, 1, 1, GETDATE(), 1),
('Lesson 5 - Object-Oriented Programming in Java', 'Introduction to OOP concepts: classes, objects, and encapsulation.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=23', NULL, 25, 1, 1, 1, GETDATE(), 1),
('Lesson 6 - Inheritance & Polymorphism', 'Understanding inheritance, method overriding, and polymorphism in Java.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=22', NULL, 25, 1, 1, 1, GETDATE(), 2),
('Lesson 7 - Java Collections Framework', 'Learn about lists, sets, maps, and other collection utilities in Java.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=21', NULL, 25, 1, 1, 1, GETDATE(), 2),
('Lesson 8 - Exception Handling in Java', 'Handling errors and exceptions using try-catch-finally.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=20', NULL, 25, 1, 1, 1, GETDATE(), 2),
('Lesson 9 - File Handling in Java', 'Reading and writing files in Java.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=19', NULL, 25, 1, 1, 1, GETDATE(), 2),
('Lesson 10 - Java & SQL Integration', 'Connecting Java applications to SQL databases using JDBC.', 'Basic', 'https://www.youtube.com/watch?v=ClLW1azK8gE&index=18', NULL, 25, 1, 1, 1, GETDATE(), 2);


INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status, CreatedAt, PackageID)
VALUES
('Lesson 1 - Introduction to Data Structures & Algorithms', 'Overview of Data Structures & Algorithms, their importance, and applications.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=1', NULL, 25, 1, 2, 1, GETDATE(), 3),
('Lesson 2 - Time Complexity & Big-O Notation', 'Understanding time complexity, Big-O notation, and performance analysis.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=2', NULL, 25, 1, 2, 1, GETDATE(), 3),
('Lesson 3 - Arrays & Linked Lists', 'Introduction to arrays and linked lists, their operations, and differences.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=3', NULL, 25, 1, 2, 1, GETDATE(), 3),
('Lesson 4 - Stacks & Queues', 'Understanding stacks and queues, LIFO & FIFO principles, and their applications.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=4', NULL, 25, 1, 2, 1, GETDATE(), 3),
('Lesson 5 - Recursion & Backtracking', 'Exploring recursion, its implementation, and backtracking techniques.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=5', NULL, 25, 1, 2, 1, GETDATE(), 3),
('Lesson 6 - Searching Algorithms', 'Overview of searching algorithms: linear search, binary search, and their complexities.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=6', NULL, 25, 1, 2, 1, GETDATE(), 3),
('Lesson 7 - Sorting Algorithms (Part 1)', 'Introduction to sorting algorithms: bubble sort, selection sort, and insertion sort.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=7', NULL, 25, 1, 2, 1, GETDATE(), 3),
('Lesson 8 - Sorting Algorithms (Part 2)', 'Exploring quicksort, merge sort, and their efficiencies.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=8', NULL, 25, 1, 2, 1, GETDATE(), 3),
('Lesson 9 - Hash Tables & Hashing', 'Understanding hash functions, hash tables, and collision handling techniques.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=9', NULL, 25, 1, 2, 1, GETDATE(), 3),
('Lesson 10 - Trees & Binary Search Trees', 'Introduction to trees, binary trees, and binary search trees (BST).', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=10', NULL, 25, 1, 2, 1, GETDATE(), 4),
('Lesson 11 - Tree Traversal Techniques', 'In-depth look at tree traversal algorithms: inorder, preorder, and postorder.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=11', NULL, 25, 1, 2, 1, GETDATE(), 4),
('Lesson 12 - Heaps & Priority Queues', 'Understanding heaps, priority queues, and their applications.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=12', NULL, 25, 1, 2, 1, GETDATE(), 4),
('Lesson 13 - Graphs & Graph Representations', 'Introduction to graphs, adjacency lists, adjacency matrices, and graph types.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=13', NULL, 25, 1, 2, 1, GETDATE(), 4),
('Lesson 14 - Graph Traversal Algorithms', 'Exploring BFS (Breadth-First Search) and DFS (Depth-First Search) algorithms.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=14', NULL, 25, 1, 2, 1, GETDATE(), 4),
('Lesson 15 - Shortest Path Algorithms', 'Dijkstra’s Algorithm, Bellman-Ford Algorithm, and Floyd-Warshall Algorithm.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=15', NULL, 25, 1, 2, 1, GETDATE(), 4),
('Lesson 16 - Dynamic Programming', 'Introduction to dynamic programming, memoization, and tabulation techniques.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=16', NULL, 25, 1, 2, 1, GETDATE(), 4),
('Lesson 17 (Part 1) - Greedy Algorithms', 'Understanding greedy algorithms and their applications.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=17', NULL, 25, 1, 2, 1, GETDATE(), 4),
('Lesson 17 (Part 2) - Greedy Algorithms', 'Exploring practical greedy algorithms such as Huffman coding and activity selection.', 'Basic', 'https://www.youtube.com/watch?v=mMcpAiosYdE&index=18', NULL, 25, 1, 2, 1, GETDATE(), 4);

INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status, CreatedAt, PackageID)
VALUES
('Lesson 1 - Introduction to C++', 'Overview of C++ programming, features, and applications.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=1', NULL, 25, 1, 3, 1, GETDATE(), 5),
('Lesson 2 - C++ Syntax & Data Types', 'Learn about C++ syntax, variables, and data types.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=2', NULL, 25, 1, 3, 1, GETDATE(), 5),
('Lesson 3 - Operators & Expressions', 'Understanding arithmetic, relational, and logical operators in C++.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=3', NULL, 25, 1, 3, 1, GETDATE(), 5),
('Lesson 4 - Control Flow Statements', 'Exploring if-else, switch-case, loops (for, while, do-while).', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=4', NULL, 25, 1, 3, 1, GETDATE(), 5),
('Lesson 5 - Functions in C++', 'Understanding function declaration, definition, and call by value/reference.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=5', NULL, 25, 1, 3, 1, GETDATE(), 5),
('Lesson 6 (Part 1) - Pointers & Memory Management', 'Introduction to pointers, dynamic memory allocation, and deallocation.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=6', NULL, 25, 1, 3, 1, GETDATE(), 5),
('Lesson 6 (Part 2) - Advanced Pointer Operations', 'Pointer arithmetic, pointers to arrays, and function pointers.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=10', NULL, 25, 1, 3, 1, GETDATE(), 5),
('Lesson 7 - Object-Oriented Programming (OOP) in C++', 'Introduction to classes, objects, and encapsulation.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=7', NULL, 25, 1, 3, 1, GETDATE(), 5),
('Lesson 8 - Constructors & Destructors', 'Understanding how constructors and destructors work in C++.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=8', NULL, 25, 1, 3, 1, GETDATE(), 6),
('Lesson 9 - Inheritance in C++', 'Exploring single, multiple, and hybrid inheritance in OOP.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=9', NULL, 25, 1, 3, 1, GETDATE(), 6),
('Lesson 10 - Polymorphism & Function Overriding', 'Understanding function overloading, operator overloading, and virtual functions.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=11', NULL, 25, 1, 3, 1, GETDATE(), 6),
('Lesson 11 - File Handling in C++', 'Reading from and writing to files using fstream, ifstream, and ofstream.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=12', NULL, 25, 1, 3, 1, GETDATE(), 6),
('Lesson 12 - Exception Handling in C++', 'Using try, catch, and throw for error handling.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=13', NULL, 25, 1, 3, 1, GETDATE(), 6),
('Lesson 13 - Standard Template Library (STL)', 'Understanding vectors, lists, queues, and stacks in STL.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=14', NULL, 25, 1, 3, 1, GETDATE(), 6),
('Lesson 14 - Searching & Sorting Algorithms', 'Implementation of binary search, bubble sort, quick sort, and merge sort.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=15', NULL, 25, 1, 3, 1, GETDATE(), 6),
('Lesson 15 - Linked Lists in C++', 'Singly linked lists, doubly linked lists, and circular linked lists.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=16', NULL, 25, 1, 3, 1, GETDATE(), 6),
('Lesson 16 - Graphs & Trees', 'Introduction to graphs, trees, and traversal algorithms (DFS & BFS).', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=17', NULL, 25, 1, 3, 1, GETDATE(), 6),
('Lesson 17 - Advanced Data Structures in C++', 'Exploring heaps, hash tables, and tries.', 'Basic', 'https://www.youtube.com/watch?v=AieQhw4kblc&index=18', NULL, 25, 1, 3, 1, GETDATE(), 6);

INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status, CreatedAt, PackageID)
VALUES
('Lesson 1 - Introduction to ReactJS', 'Overview of ReactJS, its features, and why it is popular.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=1', NULL, 25, 1, 4, 1, GETDATE(), 7),
('Lesson 2 - JSX & Components', 'Understanding JSX and how to create React components.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=2', NULL, 25, 1, 4, 1, GETDATE(), 7),
('Lesson 3 - Props & State Management', 'Managing component state and passing data using props.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=3', NULL, 25, 1, 4, 1, GETDATE(), 7),
('Lesson 4 - Handling Events in React', 'Handling user interactions using event listeners in React.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=4', NULL, 25, 1, 4, 1, GETDATE(), 7),
('Lesson 5 - React Hooks (useState & useEffect)', 'Using React hooks to manage state and side effects.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=5', NULL, 25, 1, 4, 1, GETDATE(), 7),
('Lesson 6 - React Forms & Controlled Components', 'Handling form inputs and controlled/uncontrolled components.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=6', NULL, 25, 1, 4, 1, GETDATE(), 7),
('Lesson 7 - React Router: Navigation & Routing', 'Implementing navigation in React applications using React Router.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=7', NULL, 25, 1, 4, 1, GETDATE(), 7),
('Lesson 8 - Conditional Rendering in React', 'Understanding how to conditionally render components.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=8', NULL, 25, 1, 4, 1, GETDATE(), 7),
('Lesson 9 - React Context API & State Management', 'Using the Context API for global state management.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=9', NULL, 25, 1, 4, 1, GETDATE(), 7),
('Lesson 10 - Fetching Data with API Calls', 'Fetching and displaying data using Axios and Fetch API.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=10', NULL, 25, 1, 4, 1, GETDATE(), 8),
('Lesson 11 - React Performance Optimization', 'Optimizing React apps using memoization, lazy loading, and React.memo.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=11', NULL, 25, 1, 4, 1, GETDATE(), 8),
('Lesson 12 - React Testing with Jest & React Testing Library', 'Introduction to unit testing in React.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=12', NULL, 25, 1, 4, 1, GETDATE(), 8),
('Lesson 13 - Redux: State Management for Large Apps', 'Managing state in complex React apps using Redux.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=13', NULL, 25, 1, 4, 1, GETDATE(), 8),
('Lesson 14 - React & TypeScript', 'Using TypeScript with React for type-safe development.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=14', NULL, 25, 1, 4, 1, GETDATE(), 8),
('Lesson 15 - Deploying React Apps', 'Deploying React applications to Vercel, Netlify, and Firebase.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=15', NULL, 25, 1, 4, 1, GETDATE(), 8),
('Lesson 16 - Authentication in React', 'Implementing authentication using Firebase Authentication and JWT.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=16', NULL, 25, 1, 4, 1, GETDATE(), 8),
('Lesson 17 - Real-World Project: Building a React App', 'Applying everything learned to build a real-world project.', 'Basic', 'https://www.youtube.com/watch?v=1p0QJKbqaEs&index=17', NULL, 25, 1, 4, 1, GETDATE(), 8);

INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status, CreatedAt, PackageID)
VALUES
('Lesson 1 - Introduction to HTML & CSS', 'Overview of HTML, CSS, and their importance in web development.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=1', NULL, 25, 1, 5, 1, GETDATE(), 9),
('Lesson 2 - HTML Basics', 'Understanding HTML structure, elements, and attributes.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=2', NULL, 25, 1, 5, 1, GETDATE(), 9),
('Lesson 3 - Working with CSS', 'Introduction to CSS syntax, selectors, and styling HTML elements.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=3', NULL, 25, 1, 5, 1, GETDATE(), 9),
('Lesson 4 - CSS Box Model', 'Understanding margins, padding, borders, and content in CSS.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=4', NULL, 25, 1, 5, 1, GETDATE(), 9),
('Lesson 5 - CSS Flexbox & Grid', 'Using modern layout techniques to structure web pages.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=5', NULL, 25, 1, 5, 1, GETDATE(), 9),
('Lesson 6 - Responsive Design', 'Making websites mobile-friendly using media queries.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=6', NULL, 25, 1, 5, 1, GETDATE(), 9),
('Lesson 7 - Advanced CSS Effects', 'Using transitions, animations, and pseudo-elements in CSS.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=7', NULL, 25, 1, 5, 1, GETDATE(), 9),
('Lesson 8 - HTML Forms & Inputs', 'Creating interactive forms with different input types.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=8', NULL, 25, 1, 5, 1, GETDATE(), 9),
('Lesson 9 - CSS Positioning & Z-Index', 'Using relative, absolute, fixed, and sticky positioning.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=9', NULL, 25, 1, 5, 1, GETDATE(), 9),
('Lesson 10 - Building a Simple Web Page', 'Combining HTML & CSS to build a fully styled webpage.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=10', NULL, 25, 1, 5, 1, GETDATE(), 10),
('Lesson 11 - Introduction to Media Queries', 'Adapting layouts for different screen sizes.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=11', NULL, 25, 1, 5, 1, GETDATE(), 10),
('Lesson 12 - CSS Grid Layouts', 'Creating flexible and responsive web layouts using CSS Grid.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=12', NULL, 25, 1, 5, 1, GETDATE(), 10),
('Lesson 13 - Typography & Web Fonts', 'Using Google Fonts, system fonts, and typography principles.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=13', NULL, 25, 1, 5, 1, GETDATE(), 10),
('Lesson 14 - CSS Variables', 'Defining and using CSS custom properties (variables).', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=14', NULL, 25, 1, 5, 1, GETDATE(), 10),
('Lesson 15 - CSS Transitions & Animations', 'Making web pages interactive with animations.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=15', NULL, 25, 1, 5, 1, GETDATE(), 10),
('Lesson 16 - Creating a Navigation Menu', 'Designing a functional and stylish navigation bar.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=16', NULL, 25, 1, 5, 1, GETDATE(), 10),
('Lesson 17 - Final Project: Portfolio Website', 'Combining HTML & CSS to create a personal portfolio site.', 'Basic', 'https://www.youtube.com/watch?v=lsYjDGPoQyI&index=17', NULL, 25, 1, 5, 1, GETDATE(), 10);

INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status, CreatedAt, PackageID)
VALUES
('Lesson 1 (Part 1) - Introduction to JavaScript', 'Overview of JavaScript, its role in web development, and basic syntax.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=1', NULL, 25, 1, 6, 1, GETDATE(), 11),
('Lesson 1 (Part 2) - JavaScript Variables & Data Types', 'Understanding let, const, var, and primitive data types.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=2', NULL, 25, 1, 6, 1, GETDATE(), 11),
('Lesson 1 (Part 3) - Operators & Expressions', 'Exploring arithmetic, logical, and comparison operators.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=3', NULL, 25, 1, 6, 1, GETDATE(), 11),
('Lesson 2 - JavaScript Functions & Scope', 'Defining functions, function expressions, and understanding variable scope.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=4', NULL, 25, 1, 6, 1, GETDATE(), 11),
('Lesson 3 - JavaScript Arrays & Loops', 'Working with arrays, for-loops, while-loops, and array methods.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=5', NULL, 25, 1, 6, 1, GETDATE(), 11),
('Lesson 4 - JavaScript Objects & Prototypes', 'Understanding objects, object methods, and the prototype chain.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=8', NULL, 25, 1, 6, 1, GETDATE(), 11),
('Lesson 5 - DOM Manipulation', 'Interacting with the Document Object Model (DOM).', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=6', NULL, 25, 1, 6, 1, GETDATE(), 11),
('Lesson 6 - JavaScript Events', 'Handling user interactions with event listeners.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=7', NULL, 25, 1, 6, 1, GETDATE(), 12),
('Lesson 8 (Part 1) - ES6 Features', 'Introduction to ES6 syntax, including let/const, arrow functions, and template literals.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=9', NULL, 25, 1, 6, 1, GETDATE(), 12),
('Lesson 8 (Part 2) - ES6 Modules & Destructuring', 'Understanding ES6 modules, import/export, and object/array destructuring.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=14', NULL, 25, 1, 6, 1, GETDATE(), 12),
('Lesson 9 - Asynchronous JavaScript (Promises & Async/Await)', 'Working with Promises, async/await, and handling asynchronous operations.', 'Advanced', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=10', NULL, 25, 1, 6, 1, GETDATE(), 12),
('Lesson 10 - JavaScript Fetch API', 'Fetching data from APIs using fetch(), handling responses and errors.', 'Advanced', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=11', NULL, 25, 1, 6, 1, GETDATE(), 12),
('Lesson 11 - JavaScript Local Storage & Session Storage', 'Storing data in the browser using localStorage and sessionStorage.', 'Advanced', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=12', NULL, 25, 1, 6, 1, GETDATE(), 12),
('Lesson 12 - JavaScript Closures & Higher-Order Functions', 'Understanding closures, callbacks, and functional programming.', 'Advanced', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=13', NULL, 25, 1, 6, 1, GETDATE(), 12),
('Lesson 13 - JavaScript Error Handling & Debugging', 'Using try/catch, debugging tools, and handling common JavaScript errors.', 'Advanced', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=15', NULL, 25, 1, 6, 1, GETDATE(), 12);

INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status, CreatedAt, PackageID)
VALUES
('Lesson 1 - Introduction to Node.js', 'Understanding the basics of Node.js and its runtime environment.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=65', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 2 - Installing Node.js and NPM', 'How to install Node.js and manage dependencies with NPM.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=64', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 3 - Creating a Simple Server with HTTP Module', 'Building a basic HTTP server using Node.js core modules.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=63', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 4 - Node.js File System Module', 'Reading and writing files with the fs module.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=62', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 5 - Node.js Modules & CommonJS', 'Understanding CommonJS, module.exports, and require().', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=61', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 6 - Event Loop & Asynchronous Programming', 'How Node.js handles async operations using the event loop.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=60', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 7 - Express.js Introduction', 'Setting up an Express.js server and routing.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=59', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 8 - Middleware in Express.js', 'Understanding middleware functions and how to use them.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=58', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 9 - Handling HTTP Requests & Responses', 'Processing GET, POST, PUT, DELETE requests.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=57', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 10 - Express Router', 'Organizing routes using the Express Router.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=56', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 11 - Connecting to MongoDB with Mongoose', 'Setting up MongoDB and interacting with it using Mongoose.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=55', NULL, 25, 1, 7, 1, GETDATE(), 13),
('Lesson 12 - CRUD Operations with MongoDB', 'Performing Create, Read, Update, Delete operations.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=54', NULL, 25, 1, 7, 1, GETDATE(), 14),
('Lesson 13 - User Authentication with JWT', 'Implementing JSON Web Tokens for authentication.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=53', NULL, 25, 1, 7, 1, GETDATE(), 14),
('Lesson 14 - Protecting Routes with Middleware', 'Securing API endpoints using authentication middleware.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=52', NULL, 25, 1, 7, 1, GETDATE(), 14),
('Lesson 15 - Error Handling in Express.js', 'Using try/catch and error-handling middleware.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=51', NULL, 25, 1, 7, 1, GETDATE(), 14),
('Lesson 16 - Environment Variables & Configuration', 'Using dotenv for managing environment variables.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=50', NULL, 25, 1, 7, 1, GETDATE(), 14),
('Lesson 17 - File Uploads with Multer', 'Handling file uploads in a Node.js application.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=49', NULL, 25, 1, 7, 1, GETDATE(), 14),
('Lesson 18 - Real-Time Communication with WebSockets', 'Implementing WebSocket communication using Socket.IO.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=48', NULL, 25, 1, 7, 1, GETDATE(), 14),
('Lesson 19 - Deploying Node.js Applications', 'Deploying Node.js apps to production environments.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=47', NULL, 25, 1, 7, 1, GETDATE(), 14),
('Lesson 20 - Best Practices for Node.js', 'Optimizing performance and security in Node.js applications.', 'Basic', 'https://www.youtube.com/watch?v=NsC1_IYaKGg&index=46', NULL, 25, 1, 7, 1, GETDATE(), 14);
INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status, CreatedAt, PackageID)
VALUES
('Lesson 1 - Introduction to Java Backend', 'Overview of Java backend development, setup, and tools.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=1', NULL, 25, 1, 8, 1, GETDATE(), 15),
('Lesson 2 - Setting Up Java Environment', 'Installing JDK, setting up IntelliJ IDEA, and understanding JVM.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=2', NULL, 25, 1, 8, 1, GETDATE(), 15),
('Lesson 3 - Java Fundamentals for Backend', 'Understanding OOP principles, classes, and objects in Java.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=3', NULL, 25, 1, 8, 1, GETDATE(), 15),
('Lesson 4 - Exception Handling', 'Learning about exceptions, try-catch blocks, and error handling.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=4', NULL, 25, 1, 8, 1, GETDATE(), 15),
('Lesson 5 - Working with Java Collections', 'Understanding List, Set, and Map in Java.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=5', NULL, 25, 1, 8, 1, GETDATE(), 15),
('Lesson 6 - Java Streams API', 'Processing data efficiently using Java Streams.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=6', NULL, 25, 1, 8, 1, GETDATE(), 15),
('Lesson 7 - Introduction to Spring Boot', 'Setting up a Spring Boot project and understanding its components.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=7', NULL, 25, 1, 8, 1, GETDATE(), 15), 
('Lesson 8 - REST API with Spring Boot', 'Creating a simple REST API using Spring Boot.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=8', NULL, 25, 1, 8, 1, GETDATE(), 15),
('Lesson 9 - Dependency Injection in Spring', 'Understanding IoC and DI in Spring Boot.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=9', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 10 - Spring Boot Controllers', 'How to create and manage controllers in Spring Boot.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=10', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 11 - Connecting to Databases with JPA', 'Using Spring Data JPA to connect with databases.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=11', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 12 - CRUD Operations with JPA', 'Implementing Create, Read, Update, and Delete operations.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=12', NULL, 25, 1, 8, 1, GETDATE(), 16),  
('Lesson 13 - User Authentication with Spring Security', 'Adding authentication using Spring Security.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=13', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 14 - JWT Authentication', 'Implementing JWT authentication for secure APIs.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=14', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 15 - Role-Based Access Control', 'Implementing role-based access in a Spring Boot application.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=15', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 16 - Global Exception Handling', 'Handling exceptions at a global level in Spring Boot.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=16', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 17 - Logging and Monitoring', 'Using logging frameworks and monitoring application performance.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=20', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 18 - Deploying Spring Boot Applications', 'Deploying Spring Boot apps on cloud and containerized environments.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=17', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 19 - Microservices with Spring Boot', 'Building microservices using Spring Boot.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=18', NULL, 25, 1, 8, 1, GETDATE(), 16),
('Lesson 20 - Best Practices in Spring Boot', 'Optimizing performance, security, and scalability in Spring Boot.', 'Basic', 'https://www.youtube.com/watch?v=4bSzYhCHFDE&index=19', NULL, 25, 1, 8, 1, GETDATE(), 16);

-- Insert quizzes for courses
INSERT INTO Quiz (Name, Description, Duration, PassRate, TotalQuestion, CourseID, PackageID, Status, CreatedAt) 
VALUES 
    -- Java & SQL Quizzes
    ('Java Fundamentals Quiz', 'Test your understanding of Java basics.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery')),
     1, GETDATE()),

    ('Advanced Java Quiz', 'Test your knowledge of advanced Java concepts.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery')),
     1, GETDATE()),

    ('SQL Basics Quiz', 'Test your SQL knowledge and query writing skills.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery')),
     1, GETDATE()),

    ('SQL Advanced Queries Quiz', 'Test your ability to write complex SQL queries.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery')),
     1, GETDATE()),

    -- Data Structures & Algorithms Quizzes
    ('Data Structures Quiz', 'Test your knowledge of basic data structures.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Comprehensive Data Structures & Algorithms'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Comprehensive Data Structures & Algorithms')),
     1, GETDATE()),

    ('Algorithms Quiz', 'Test your understanding of common algorithms.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Comprehensive Data Structures & Algorithms'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Comprehensive Data Structures & Algorithms')),
     1, GETDATE()),

    ('Sorting & Searching Quiz', 'Evaluate your knowledge on sorting and searching algorithms.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Comprehensive Data Structures & Algorithms'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Comprehensive Data Structures & Algorithms')),
     1, GETDATE()),

    -- Frontend Development Quizzes
    ('React Fundamentals Quiz', 'Test your React.js knowledge.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Modern Frontend Development with React.js'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Modern Frontend Development with React.js')),
     1, GETDATE()),

    ('JavaScript Basics Quiz', 'Test your JavaScript fundamentals.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Modern Frontend Development with React.js'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Modern Frontend Development with React.js')),
     1, GETDATE()),

    ('HTML & CSS Quiz', 'Test your knowledge of HTML & CSS basics.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Modern Frontend Development with React.js'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Modern Frontend Development with React.js')),
     1, GETDATE()),

    -- Backend Development Quizzes
    ('Node.js Fundamentals Quiz', 'Test your understanding of backend development with Node.js.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Backend Web Development with Node.js & Express'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Backend Web Development with Node.js & Express')),
     1, GETDATE()),

    ('Spring Boot Quiz', 'Test your knowledge of backend development using Java Spring Boot.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot')),
     1, GETDATE()),

    ('REST API Quiz', 'Test your understanding of RESTful API design principles.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot')),
     1, GETDATE()),

    ('Microservices Quiz', 'Test your knowledge of microservices architecture and design.', 30, 70, 5,
     (SELECT CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot'),
     (SELECT TOP 1 PackageID FROM Packages WHERE CourseID = (SELECT CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot')),
     1, GETDATE());

-- Insert questions for each quiz
INSERT INTO Question (Content, PointPerQuestion, QuizID, Status, CreatedAt, UpdatedAt) VALUES
-- Java Questions
( N'What is the main difference between ArrayList and LinkedList in Java?', 1, 1, 1, GETDATE(), GETDATE()),
( N'What is the purpose of the "static" keyword in Java?', 1, 1, 1, GETDATE(), GETDATE()),
( N'How does garbage collection work in Java?', 1, 1, 1, GETDATE(), GETDATE()),
( N'What are the access modifiers available in Java?', 1, 1, 1, GETDATE(), GETDATE()),
( N'What is method overloading in Java?', 1, 1, 1, GETDATE(), GETDATE()),
( N'What is the difference between INNER JOIN and LEFT JOIN?', 1, 2, 1, GETDATE(), GETDATE()),
( N'How to use GROUP BY with HAVING clause?', 1, 2, 1, GETDATE(), GETDATE()),
( N'What are the different types of SQL constraints?', 1, 2, 1, GETDATE(), GETDATE()),
( N'Explain the purpose of SQL indexes', 1, 2, 1, GETDATE(), GETDATE()),
( N'What is a stored procedure in SQL?', 1, 2, 1, GETDATE(), GETDATE()),

-- Data Structures Questions
( N'What is the time complexity of binary search?', 1, 3, 1, GETDATE(), GETDATE()),
( N'Explain the difference between Stack and Queue', 1, 3, 1, GETDATE(), GETDATE()),
( N'What is a binary tree?', 1, 3, 1, GETDATE(), GETDATE()),
( N'How does a hash table work?', 1, 3, 1, GETDATE(), GETDATE()),
( N'What is the purpose of a linked list?', 1, 3, 1, GETDATE(), GETDATE()),
( N'What is the time complexity of QuickSort?', 1, 4, 1, GETDATE(), GETDATE()),
( N'Explain how Dijkstra''s algorithm works', 1, 4, 1, GETDATE(), GETDATE()),
( N'What is dynamic programming?', 1, 4, 1, GETDATE(), GETDATE()),
( N'How does merge sort work?', 1, 4, 1, GETDATE(), GETDATE()),
( N'What is the difference between DFS and BFS?', 1, 4, 1, GETDATE(), GETDATE()),

-- React Questions
( N'What is JSX in React?', 1, 5, 1, GETDATE(), GETDATE()),
( N'Explain the concept of React components', 1, 5, 1, GETDATE(), GETDATE()),
( N'What is the purpose of useState hook?', 1, 5, 1, GETDATE(), GETDATE()),
( N'How does React handle routing?', 1, 5, 1, GETDATE(), GETDATE()),
( N'What is the virtual DOM in React?', 1, 5, 1, GETDATE(), GETDATE()),

-- JavaScript Questions
( N'What is the difference between let and var?', 1, 6, 1, GETDATE(), GETDATE()),
( N'Explain how promises work in JavaScript', 1, 6, 1, GETDATE(), GETDATE()),
( N'What is event bubbling?', 1, 6, 1, GETDATE(), GETDATE()),
( N'How does JavaScript handle asynchronous operations?', 1, 6, 1, GETDATE(), GETDATE()),
( N'What are closures in JavaScript?', 1, 6, 1, GETDATE(), GETDATE()),

-- C++ Basic Questions (QuizID = 7)
( N'What is the difference between stack and heap memory in C++?', 1, 7, 1, GETDATE(), GETDATE()),
( N'Explain the concept of references in C++', 1, 7, 1, GETDATE(), GETDATE()),
( N'What are the access specifiers in C++?', 1, 7, 1, GETDATE(), GETDATE()),
( N'What is function overloading in C++?', 1, 7, 1, GETDATE(), GETDATE()),
( N'Explain the concept of constructors in C++', 1, 7, 1, GETDATE(), GETDATE()),

-- C++ Advanced Questions (QuizID = 8)
( N'What is template metaprogramming?', 1, 8, 1, GETDATE(), GETDATE()),
( N'Explain smart pointers in C++', 1, 8, 1, GETDATE(), GETDATE()),
( N'What is RAII in C++?', 1, 8, 1, GETDATE(), GETDATE()),
( N'How does virtual inheritance work?', 1, 8, 1, GETDATE(), GETDATE()),
( N'Explain move semantics in C++', 1, 8, 1, GETDATE(), GETDATE()),

-- HTML Basic Questions (QuizID = 9)
( N'What are semantic HTML elements?', 1, 9, 1, GETDATE(), GETDATE()),
( N'Explain the difference between <div> and <span>', 1, 9, 1, GETDATE(), GETDATE()),
( N'What is the purpose of the alt attribute?', 1, 9, 1, GETDATE(), GETDATE()),
( N'What are HTML forms used for?', 1, 9, 1, GETDATE(), GETDATE()),
( N'Explain the difference between GET and POST methods', 1, 9, 1, GETDATE(), GETDATE()),

-- CSS Layout Questions (QuizID = 10)
( N'What is the CSS Box Model?', 1, 10, 1, GETDATE(), GETDATE()),
( N'Explain CSS Flexbox', 1, 10, 1, GETDATE(), GETDATE()),
( N'What is CSS Grid?', 1, 10, 1, GETDATE(), GETDATE()),
( N'How do media queries work?', 1, 10, 1, GETDATE(), GETDATE()),
( N'What are CSS positioning types?', 1, 10, 1, GETDATE(), GETDATE()),

-- Node.js Basic Questions (QuizID = 11)
( N'What is the Event Loop in Node.js?', 1, 11, 1, GETDATE(), GETDATE()),
( N'Explain callback functions in Node.js', 1, 11, 1, GETDATE(), GETDATE()),
( N'What is npm in Node.js?', 1, 11, 1, GETDATE(), GETDATE()),
( N'How does Node.js handle multiple requests?', 1, 11, 1, GETDATE(), GETDATE()),
( N'What is middleware in Express.js?', 1, 11, 1, GETDATE(), GETDATE()),

-- Node.js Advanced Questions (QuizID = 12)
( N'Explain clustering in Node.js', 1, 12, 1, GETDATE(), GETDATE()),
( N'What are Streams in Node.js?', 1, 12, 1, GETDATE(), GETDATE()),
( N'How does Node.js handle authentication?', 1, 12, 1, GETDATE(), GETDATE()),
( N'Explain microservices architecture', 1, 12, 1, GETDATE(), GETDATE()),
( N'What is WebSocket in Node.js?', 1, 12, 1, GETDATE(), GETDATE()),

-- Java Backend Basic Questions (QuizID = 13)
( N'What is Spring Framework?', 1, 13, 1, GETDATE(), GETDATE()),
( N'Explain Dependency Injection', 1, 13, 1, GETDATE(), GETDATE()),
( N'What is Spring Boot?', 1, 13, 1, GETDATE(), GETDATE()),
( N'Explain Spring MVC architecture', 1, 13, 1, GETDATE(), GETDATE()),
( N'What are Spring Boot Starters?', 1, 13, 1, GETDATE(), GETDATE()),

-- Enterprise Java Questions (QuizID = 14)
( N'What is Spring Security?', 1, 14, 1, GETDATE(), GETDATE()),
( N'Explain Spring Cloud components', 1, 14, 1, GETDATE(), GETDATE()),
( N'What is JPA in Spring?', 1, 14, 1, GETDATE(), GETDATE()),
( N'How does Spring handle transactions?', 1, 14, 1, GETDATE(), GETDATE()),
( N'Explain Microservices with Spring Cloud', 1, 14, 1, GETDATE(), GETDATE());

-- Insert answers for questions
INSERT INTO Answer (Content, IsCorrect, Explanation, QuestionID) VALUES
-- Java Answers
('ArrayList uses dynamic array, LinkedList uses doubly linked list', 1, 'ArrayList provides fast random access while LinkedList excels at insertions/deletions', 1),
('ArrayList is faster for searching', 0, 'This is only true for random access', 1),
('LinkedList uses less memory', 0, 'LinkedList actually uses more memory due to storing node references', 1),
('They are exactly the same', 0, 'They have different implementations and use cases', 1),

('Belongs to the class rather than instance', 1, 'Static members are shared across all instances', 2),
('Makes method run faster', 0, 'Static is not related to performance', 2),
('Creates multiple copies', 0, 'Static actually ensures single copy', 2),
('Only used in main method', 0, 'Static can be used with any method or variable', 2),

-- SQL Answers
('INNER JOIN returns matching rows, LEFT JOIN returns all left table rows', 1, 'LEFT JOIN preserves all records from the left table', 6),
('They are the same', 0, 'They have different behaviors', 6),
('RIGHT JOIN is faster', 0, 'Join type does not affect performance significantly', 6),
('INNER JOIN is always better', 0, 'Each join type has its use case', 6),

('Filters grouped data like WHERE clause for groups', 1, 'HAVING works with aggregated data after GROUP BY', 7),
('Replaces WHERE clause', 0, 'HAVING is used in addition to WHERE', 7),
('Groups columns together', 0, 'That is what GROUP BY does', 7),
('Sorts the result', 0, 'That is what ORDER BY does', 7),

-- Data Structures Answers
('O(log n)', 1, 'Binary search divides the search space in half each time', 11),
('O(n)', 0, 'This is linear search complexity', 11),
('O(1)', 0, 'Constant time is not possible for search in unsorted array', 11),
('O(n^2)', 0, 'This is too high for binary search', 11),

('Stack is LIFO, Queue is FIFO', 1, 'Stack: Last In First Out, Queue: First In First Out', 12),
('They are the same', 0, 'They have different access patterns', 12),
('Stack is always faster', 0, 'Performance depends on implementation', 12),
('Queue is only for sorting', 0, 'Queue has many use cases beyond sorting', 12),

-- React Answers
('JSX allows writing HTML-like code in JavaScript', 1, 'JSX is a syntax extension for JavaScript', 21),
('JSX is a new programming language', 0, 'JSX is just a syntax extension', 21),
('JSX only works with CSS', 0, 'JSX is for HTML-like structures', 21),
('JSX is the same as HTML', 0, 'JSX has some differences from HTML', 21),

('Hook for managing state in functional components', 1, 'useState is a React Hook for state management', 23),
('Used for routing only', 0, 'useState is for state management', 23),
('Replaces components', 0, 'useState is used within components', 23),
('Only for class components', 0, 'useState is for functional components', 23),

-- JavaScript Answers
('let has block scope, var has function scope', 1, 'let provides better scoping control', 26),
('They are identical', 0, 'They have different scoping rules', 26),
('var is newer than let', 0, 'let was introduced in ES6', 26),
('let is only for numbers', 0, 'let can be used for any type', 26),

('Promises handle asynchronous operations', 1, 'Promises provide a way to handle async code', 27),
('Promises are only for errors', 0, 'Promises handle both success and error cases', 27),
('Promises make code slower', 0, 'Promises do not affect performance significantly', 27),
('Promises are deprecated', 0, 'Promises are a fundamental part of modern JavaScript', 27),

-- C++ Basic Answers
('Stack is automatic, heap is manual memory management', 1, 'Stack memory is automatically managed while heap requires manual allocation/deallocation', 31),
('Both are the same', 0, 'Stack and heap have different memory management approaches', 31),
('Heap is faster than stack', 0, 'Stack is actually faster than heap memory', 31),
('Stack has unlimited memory', 0, 'Stack has limited memory compared to heap', 31),

('References are aliases for existing variables', 1, 'References provide an alternative name for a variable', 32),
('References are pointers', 0, 'References are different from pointers', 32),
('References can be null', 0, 'References must be initialized and cannot be null', 32),
('References can change target', 0, 'References cannot be reassigned after initialization', 32),

-- HTML Basic Answers
('Semantic elements describe their meaning', 1, 'Semantic HTML provides meaning to the content structure', 41),
('Semantic elements are for styling', 0, 'Semantics are about meaning, not style', 41),
('Semantic elements are obsolete', 0, 'Semantic HTML is modern and important', 41),
('All HTML elements are semantic', 0, 'Not all elements have semantic meaning', 41),

('div is block-level, span is inline', 1, 'This defines their default display behavior', 42),
('They are the same', 0, 'div and span have different display properties', 42),
('span is block-level', 0, 'span is an inline element', 42),
('div is inline', 0, 'div is a block-level element', 42),

-- Node.js Basic Answers
('Event Loop handles async operations', 1, 'Event Loop manages asynchronous execution in Node.js', 51),
('Event Loop is for UI only', 0, 'Event Loop handles all async operations, not just UI', 51),
('Event Loop is optional', 0, 'Event Loop is a core part of Node.js', 51),
('Event Loop runs in multiple threads', 0, 'Event Loop runs in a single thread', 51),

('Package manager for Node.js', 1, 'npm is the default package manager for Node.js', 53),
('Network protocol manager', 0, 'npm is not a protocol manager', 53),
('Node process monitor', 0, 'npm is not a process monitor', 53),
('Node programming method', 0, 'npm is a package manager, not a programming method', 53),

-- Java Backend Answers
('Framework for Java applications', 1, 'Spring is a comprehensive framework for Java development', 61),
('Database management system', 0, 'Spring is not a database system', 61),
('Java compiler', 0, 'Spring is not a compiler', 61),
('Testing framework', 0, 'Spring is not primarily a testing framework', 61),

('Automatic dependency management', 1, 'DI is about managing object dependencies automatically', 62),
('Database injection', 0, 'DI is not related to databases', 62),
('Direct implementation', 0, 'DI is about loose coupling, not direct implementation', 62),
('Data integration', 0, 'DI is about dependency management, not data integration', 62);

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student1@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Java Programming & SQL Database Mastery'), 
 2800000, 'active', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student2@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Comprehensive Data Structures & Algorithms'), 
 2000000, 'pending', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student3@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Modern Frontend Development with React.js'), 
 6400000, 'active', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student1@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Frontend Web Development with HTML & CSS'), 
 6000000, 'active', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student2@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Advanced JavaScript & Frontend Development'), 
 7000000, 'active', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student3@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Backend Web Development with Node.js & Express'), 
 7000000, 'pending', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student1@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Backend Web Development with Node.js & Express'), 
 7000000, 'active', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student2@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot'), 
 7000000, 'active', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student3@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Java Backend Development with Spring Boot'), 
 7000000, 'active', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());

INSERT INTO Registration (UserID, CourseID, Price, Status, Progress, ValidFrom, ValidTo, CreatedAt) 
VALUES 
((SELECT TOP 1 UserID FROM Account WHERE Email = 'student2@onlinelearning.com'), 
 (SELECT TOP 1 CourseID FROM Course WHERE Title = 'Complete C++ Programming: From Beginner to Advanced'), 
 2750000, 'active', 0, GETDATE(), DATEADD(MONTH, 1, GETDATE()), GETDATE());
