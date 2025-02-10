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
    Price Float DEFAULT 0.00,
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

CREATE TABLE Blog (
    BlogID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Content NTEXT NOT NULL,
    AuthorID INT,  -- ID of the author (referencing Account table)
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    Status BIT DEFAULT 1, -- 1 for active, 0 for inactive
    FOREIGN KEY (AuthorID) REFERENCES Account(UserID)
);

-- Insert multiple blog posts with longer content
INSERT INTO Blog (Title, Content, AuthorID, Status) 
VALUES
('Understanding SQL Joins', 
 'SQL Joins are fundamental to relational databases and allow us to retrieve data from multiple tables in a single query. There are several types of joins that we can use, such as INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN. Each type serves a different purpose depending on the way we want to combine data from two or more tables. INNER JOIN only returns rows where there is a match in both tables. LEFT JOIN returns all rows from the left table and matching rows from the right table, while RIGHT JOIN returns all rows from the right table and matching rows from the left. FULL OUTER JOIN returns all rows when there is a match in either table. Understanding these joins and when to use them is crucial for writing efficient SQL queries.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'), 
 1),

('Introduction to Data Science', 
 'Data Science is one of the fastest-growing fields today, revolutionizing how industries analyze and interpret data. At its core, Data Science is about using scientific methods, algorithms, and systems to extract knowledge and insights from structured and unstructured data. The field includes a variety of techniques such as machine learning, data mining, and statistical analysis. One of the key aspects of data science is the ability to work with large datasets, often referred to as Big Data. Data scientists need proficiency in various programming languages such as Python and R, as well as familiarity with tools like Hadoop, Spark, and SQL. Additionally, they must possess a strong foundation in mathematics and statistics to interpret data accurately and create meaningful predictions.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'), 
 1),

('Tips for Efficient Web Development', 
 'Web development is a constantly evolving field, and staying up to date with best practices is essential for building modern, efficient websites. One of the first tips for efficient web development is to ensure that your website is responsive. A responsive design adjusts the layout of the website to look great on any device, whether it’s a desktop, tablet, or mobile phone. Another important practice is code optimization. Minimizing CSS and JavaScript files, reducing image sizes, and utilizing techniques like lazy loading can significantly improve website performance. Additionally, a clean and well-organized codebase is crucial for long-term maintainability. Developers should use version control systems like Git, follow naming conventions, and ensure that they write modular and reusable code.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'), 
 1),

('Mobile App Development for Beginners', 
 'Mobile app development is a rapidly growing area in the tech world, with millions of apps being developed for platforms like iOS and Android every year. For beginners, it is essential to start by understanding the basics of mobile app development. Both iOS and Android apps are typically built using specific programming languages: Swift or Objective-C for iOS, and Java or Kotlin for Android. Additionally, developers should learn about integrated development environments (IDEs) like Xcode for iOS and Android Studio for Android. Building a simple app, such as a calculator or a to-do list, is a great way to get started. After that, you can progress to more complex projects, such as social media apps or e-commerce platforms. Understanding UI/UX design principles is also important for creating user-friendly mobile applications.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'), 
 1),

('Best Practices in Cybersecurity', 
 'In today’s digital age, cybersecurity is more important than ever. As more businesses and individuals rely on the internet for daily activities, the risk of cyberattacks continues to rise. Best practices in cybersecurity include ensuring strong password management, using multi-factor authentication (MFA), and regularly updating software to protect against vulnerabilities. Additionally, organizations should conduct regular security audits, implement firewalls, and use encryption to secure sensitive data. Employees should also be trained on recognizing phishing attempts and suspicious activities. Cybersecurity is not just about preventing attacks but also about preparing for potential breaches and having a robust recovery plan in place.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'), 
 1),

('How to Learn Programming Effectively', 
 'Learning to code can seem like a daunting task, especially for beginners, but with the right strategies, anyone can become proficient in programming. The first step is to choose the right programming language. Popular languages for beginners include Python, JavaScript, and Ruby, as they are versatile and widely used. Once a language is chosen, beginners should focus on understanding the basic concepts such as variables, loops, functions, and conditionals. Practicing regularly by building small projects is key to solidifying concepts. Additionally, online tutorials, coding bootcamps, and community forums can provide valuable resources and support. The key to success is consistency—setting aside time every day to practice and solve coding challenges will lead to steady improvement.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'), 
 1);


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