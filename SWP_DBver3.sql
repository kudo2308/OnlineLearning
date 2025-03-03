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
    Description NVARCHAR(250) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(100) Null,
    Image NVARCHAR(100) Null,
    Address NVARCHAR(100) Null,
    GenderID NVARCHAR(50) NULL, 
    DOB DATE NOT NULL,
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

CREATE TABLE Outcome(
	CourseID INT PRIMARY KEY,
	Content NVARCHAR(255) NOT NULL,
	FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

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
    LessonType NVARCHAR(50) CHECK (LessonType IN ('video', 'document', 'file')) NOT NULL,
    VideoUrl NVARCHAR(MAX) NULL,
    DocumentUrl NVARCHAR(MAX) NULL,
    Duration INT, -- in minutes
    OrderNumber INT,
    CourseID INT,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    PackageID INT NULL,
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
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
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
	ImageUrl NVARCHAR(255),
	CategoryID INT,
    AuthorID INT,  -- ID of the author (referencing Account table)
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    Status BIT DEFAULT 1, -- 1 for active, 0 for inactive
    FOREIGN KEY (AuthorID) REFERENCES Account(UserID),
	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
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
INSERT INTO Account (FullName, Description, Password, Email, RoleID, DOB, Image, Status) 
VALUES
('System Admin', 'Administrator account', 'VmszaVktKzZlKmRlJHMuYWRtaW4xMjM=', 'admin@onlinelearning.com', 1, '1990-01-01', '/assets/images/avatar/pic1.jpg', 1);

-- Insert a sample expert account (password: expert123)
INSERT INTO Account (FullName, Description, Password, Email, RoleID, DOB, Image, Status) 
VALUES
('John Expert', 'Expert account', 'VmszaVktKzZlKmRlJHMuZXhwZXJ0MTIz', 'expert1@onlinelearning.com', 2, '1985-05-12', '/assets/images/avatar/pic2.jpg', 1);

-- Insert a sample student account (password: student123)
INSERT INTO Account (FullName, Description, Password, Email, RoleID, DOB, Image, Status) 
VALUES
('Jane Student', 'Student account', 'VmszaVktKzZlKmRlJHMu', 'student1@onlinelearning.com', 3, '1995-11-23', '/assets/images/avatar/pic1.jpg', 1);



-- Insert sample course
INSERT INTO Course (Title, Description, ExpertID, CategoryID, ImageUrl, TotalLesson, Price) VALUES
('Java Programming Fundamentals', 
 'Learn the basics of Java programming language including syntax, OOP concepts, and practical applications',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic1.jpg',
 10,
 120000),
('Advanced Java Programming', 
 'This course will take you beyond the basics of Java, exploring advanced topics such as multithreading, concurrency, design patterns, and Java s ecosystem for building scalable applications.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/assets/images/courses/pic2.jpg',
 15,
 150000),

('Full Stack Web Development', 
 'Master both front-end and back-end web development. This course covers HTML, CSS, JavaScript, React, Node.js, and database integration. You will also learn how to deploy your full-stack applications.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Web Development'),
 '/assets/images/courses/pic3.jpg',
 20,
 200000),

('Introduction to Databases and SQL', 
 'In this course, you will learn the fundamentals of relational databases, SQL syntax, and how to work with databases. It covers topics such as database normalization, indexing, and optimization.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Database'),
 '/assets/images/courses/pic4.jpg',
 10,
 100000),

('Networking Fundamentals', 
 'This course provides an in-depth understanding of networking concepts including IP addressing, subnetting, TCP/IP protocols, routing, and network security.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Networking'),
 '/assets/images/courses/pic5.jpg',
 12,
 120000),

('Mobile App Development with Flutter', 
 'Learn how to build mobile applications for both iOS and Android using Flutter. This course will guide you through the entire process from setting up the environment to deploying your first app.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Mobile Development'),
 '/assets/images/courses/pic6.jpg',
 18,
 180000),

('Data Science with Python', 
 'This course teaches you the essentials of Data Science, focusing on Python programming. Topics covered include data cleaning, visualization, and machine learning algorithms using libraries like Pandas, NumPy, and Scikit-Learn.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Data Science'),
 '/assets/images/courses/pic7.jpg',
 22,
 220000),

('Introduction to Cybersecurity', 
 'Learn the basics of cybersecurity, including network security, cryptography, and threat analysis. This course provides essential knowledge to protect systems and data from potential cyber threats.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Security'),
 '/assets/images/courses/pic8.jpg',
 14,
 140000),

('Building Modern DevOps Pipelines', 
 'This course introduces DevOps concepts, including continuous integration, continuous delivery, and the use of tools like Docker, Kubernetes, and Jenkins to automate software development and deployment.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'DevOps'),
 '/assets/images/courses/pic9.jpg',
 16,
 160000),
('Python for Data Analysis', 
 'Learn how to use Python for data analysis. This course covers libraries such as Pandas, NumPy, and Matplotlib for data manipulation and visualization. You will also learn how to clean and prepare data for analysis.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Data Science'),
 '/assets/images/courses/pic1.jpg',
 18,
 180000),

('React Native for Mobile Apps', 
 'This course covers the basics of React Native, an open-source framework for building mobile apps. You will learn how to create cross-platform mobile applications for both iOS and Android using JavaScript and React.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Mobile Development'),
 '/assets/images/courses/pic2.jpg',
 20,
 200000),

('Deep Learning with TensorFlow', 
 'In this course, you will learn the basics of deep learning and how to implement neural networks using TensorFlow. Topics include supervised learning, CNNs, RNNs, and reinforcement learning.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Data Science'),
 '/assets/images/courses/pic3.jpg',
 25,
 250000),

('Introduction to Cloud Computing', 
 'Cloud computing is transforming the way businesses operate. In this course, you will learn the fundamentals of cloud computing, the different cloud service models, and the leading cloud platforms such as AWS, Azure, and Google Cloud.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Networking'),
 '/assets/images/courses/pic4.jpg',
 12,
 120000),

('Advanced Cybersecurity Practices', 
 'This course is designed for those who already have a basic understanding of cybersecurity. You will learn about advanced topics such as penetration testing, incident response, advanced threat protection, and ethical hacking.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Security'),
 '/assets/images/courses/pic5.jpg',
 20,
 200000),

('Agile Project Management', 
 'Agile is a popular project management methodology used in software development and other industries. In this course, you will learn about Agile principles, Scrum framework, and how to manage projects using Agile techniques.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'DevOps'),
 '/assets/images/courses/pic6.jpg',
 15,
 150000),

('Introduction to Internet of Things (IoT)', 
 'The Internet of Things (IoT) is a rapidly growing technology that connects devices to the internet. This course will introduce you to IoT concepts, including sensors, actuators, and cloud computing for managing IoT devices.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Networking'),
 '/assets/images/courses/pic7.jpg',
 18,
 180000),

('Building Scalable Web Applications', 
 'This course will teach you how to build scalable web applications using modern technologies such as microservices, containers, and cloud platforms. You will also learn about API design, load balancing, and database scaling.',
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'),
 (SELECT CategoryID FROM Category WHERE Name = 'Web Development'),
 '/assets/images/courses/pic8.jpg',
 22,
 220000);

 -- Insert multiple blog posts with longer content
INSERT INTO Blog (Title, Content, ImageUrl, CategoryID, AuthorID, Status) 
VALUES
('Understanding SQL Joins', 
 'SQL Joins are fundamental to relational databases and allow us to retrieve data from multiple tables in a single query. There are several types of joins that we can use, such as INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN. Each type serves a different purpose depending on the way we want to combine data from two or more tables. INNER JOIN only returns rows where there is a match in both tables. LEFT JOIN returns all rows from the left table and matching rows from the right table, while RIGHT JOIN returns all rows from the right table and matching rows from the left. FULL OUTER JOIN returns all rows when there is a match in either table. Understanding these joins and when to use them is crucial for writing efficient SQL queries.',
 '/assets/images/courses/pic2.jpg',
 1,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 1),

('Introduction to Data Science', 
 'Data Science is one of the fastest-growing fields today, revolutionizing how industries analyze and interpret data. At its core, Data Science is about using scientific methods, algorithms, and systems to extract knowledge and insights from structured and unstructured data. The field includes a variety of techniques such as machine learning, data mining, and statistical analysis. One of the key aspects of data science is the ability to work with large datasets, often referred to as Big Data. Data scientists need proficiency in various programming languages such as Python and R, as well as familiarity with tools like Hadoop, Spark, and SQL. Additionally, they must possess a strong foundation in mathematics and statistics to interpret data accurately and create meaningful predictions.',
 '/assets/images/courses/pic3.jpg',
 2,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 1),

('Tips for Efficient Web Development', 
 'Web development is a constantly evolving field, and staying up to date with best practices is essential for building modern, efficient websites. One of the first tips for efficient web development is to ensure that your website is responsive. A responsive design adjusts the layout of the website to look great on any device, whether it s a desktop, tablet, or mobile phone. Another important practice is code optimization. Minimizing CSS and JavaScript files, reducing image sizes, and utilizing techniques like lazy loading can significantly improve website performance. Additionally, a clean and well-organized codebase is crucial for long-term maintainability. Developers should use version control systems like Git, follow naming conventions, and ensure that they write modular and reusable code.',
 '/assets/images/courses/pic4.jpg',
 3,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 1),

('Mobile App Development for Beginners', 
 'Mobile app development is a rapidly growing area in the tech world, with millions of apps being developed for platforms like iOS and Android every year. For beginners, it is essential to start by understanding the basics of mobile app development. Both iOS and Android apps are typically built using specific programming languages: Swift or Objective-C for iOS, and Java or Kotlin for Android. Additionally, developers should learn about integrated development environments (IDEs) like Xcode for iOS and Android Studio for Android. Building a simple app, such as a calculator or a to-do list, is a great way to get started. After that, you can progress to more complex projects, such as social media apps or e-commerce platforms. Understanding UI/UX design principles is also important for creating user-friendly mobile applications.',
 '/assets/images/courses/pic5.jpg',
 4,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 1),

('Best Practices in Cybersecurity', 
 'In today s digital age, cybersecurity is more important than ever. As more businesses and individuals rely on the internet for daily activities, the risk of cyberattacks continues to rise. Best practices in cybersecurity include ensuring strong password management, using multi-factor authentication (MFA), and regularly updating software to protect against vulnerabilities. Additionally, organizations should conduct regular security audits, implement firewalls, and use encryption to secure sensitive data. Employees should also be trained on recognizing phishing attempts and suspicious activities. Cybersecurity is not just about preventing attacks but also about preparing for potential breaches and having a robust recovery plan in place.',
 '/assets/images/courses/pic6.jpg',
 5,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 1),

('How to Learn Programming Effectively', 
 'Learning to code can seem like a daunting task, especially for beginners, but with the right strategies, anyone can become proficient in programming. The first step is to choose the right programming language. Popular languages for beginners include Python, JavaScript, and Ruby, as they are versatile and widely used. Once a language is chosen, beginners should focus on understanding the basic concepts such as variables, loops, functions, and conditionals. Practicing regularly by building small projects is key to solidifying concepts. Additionally, online tutorials, coding bootcamps, and community forums can provide valuable resources and support. The key to success is consistency setting aside time every day to practice and solve coding challenges will lead to steady improvement.',
 '/assets/images/courses/pic7.jpg',
 6,
 (SELECT UserID FROM Account WHERE Email = 'expert1@onlinelearning.com'), 
 1);
-- Insert lessons for courses
-- Insert additional lessons
-- Insert lessons for each course (at least 2 lessons per course with duration < 30 minutes)
-- Insert statements for Lesson
INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status, CreatedAt)
VALUES
('Introduction to Java', 'Learn the basics of Java programming.', 'video', '/videos/java-intro.mp4', NULL, 25, 1, (SELECT CourseID FROM Course WHERE Title = 'Java Programming Fundamentals'), 1, GETDATE()),
('Object-Oriented Programming in Java', 'Understand OOP principles in Java.', 'document', NULL, '/docs/java-oop.pdf', 20, 2, (SELECT CourseID FROM Course WHERE Title = 'Java Programming Fundamentals'), 1, GETDATE()),
('Multithreading Basics', 'Learn about threads and concurrency in Java.', 'video', '/videos/java-multithreading.mp4', NULL, 28, 1, (SELECT CourseID FROM Course WHERE Title = 'Advanced Java Programming'), 1, GETDATE()),
('Design Patterns Overview', 'Introduction to common design patterns.', 'document', NULL, '/docs/java-design-patterns.pdf', 22, 2, (SELECT CourseID FROM Course WHERE Title = 'Advanced Java Programming'), 1, GETDATE()),
('HTML & CSS Basics', 'Learn HTML structure and CSS styling.', 'video', '/videos/html-css-intro.mp4', NULL, 27, 1, (SELECT CourseID FROM Course WHERE Title = 'Full Stack Web Development'), 1, GETDATE()),
('JavaScript Introduction', 'Fundamentals of JavaScript programming.', 'document', NULL, '/docs/js-intro.pdf', 25, 2, (SELECT CourseID FROM Course WHERE Title = 'Full Stack Web Development'), 1, GETDATE()),
('SQL Fundamentals', 'Learn SQL syntax and queries.', 'video', '/videos/sql-fundamentals.mp4', NULL, 26, 1, (SELECT CourseID FROM Course WHERE Title = 'Introduction to Databases and SQL'), 1, GETDATE()),
('Normalization & Indexing', 'Understanding database optimization.', 'file', NULL, '/files/advanced_sql_queries.pdf', 23, 2, (SELECT CourseID FROM Course WHERE Title = 'Introduction to Databases and SQL'), 1, GETDATE()),
('Networking Basics', 'Learn about networking models and protocols.', 'video', '/videos/networking-basics.mp4', NULL, 24, 1, (SELECT CourseID FROM Course WHERE Title = 'Networking Fundamentals'), 1, GETDATE()),
('Network Security Essentials', 'Basic security practices in networking.', 'document', NULL, '/docs/network-security.pdf', 26, 2, (SELECT CourseID FROM Course WHERE Title = 'Networking Fundamentals'), 1, GETDATE()),
('Getting Started with Flutter', 'Setup Flutter and first app.', 'video', '/videos/flutter-intro.mp4', NULL, 27, 1, (SELECT CourseID FROM Course WHERE Title = 'Mobile App Development with Flutter'), 1, GETDATE()),
('State Management in Flutter', 'Managing app states in Flutter.', 'document', NULL, '/docs/flutter-state.pdf', 25, 2, (SELECT CourseID FROM Course WHERE Title = 'Mobile App Development with Flutter'), 1, GETDATE()),
('Python for Data Science', 'Introduction to Python for analysis.', 'video', '/videos/python-datascience.mp4', NULL, 28, 1, (SELECT CourseID FROM Course WHERE Title = 'Data Science with Python'), 1, GETDATE()),
('Data Visualization with Pandas', 'Using Pandas for data analysis.', 'document', NULL, '/docs/pandas-visualization.pdf', 26, 2, (SELECT CourseID FROM Course WHERE Title = 'Data Science with Python'), 1, GETDATE()),
('Cybersecurity Overview', 'Basic principles of cybersecurity.', 'video', '/videos/cybersecurity-overview.mp4', NULL, 27, 1, (SELECT CourseID FROM Course WHERE Title = 'Introduction to Cybersecurity'), 1, GETDATE()),
('Encryption Methods', 'Introduction to encryption and cryptography.', 'document', NULL, '/docs/encryption-methods.pdf', 25, 2, (SELECT CourseID FROM Course WHERE Title = 'Introduction to Cybersecurity'), 1, GETDATE()),
('What is DevOps?', 'Understanding DevOps principles.', 'video', '/videos/devops-intro.mp4', NULL, 28, 1, (SELECT CourseID FROM Course WHERE Title = 'Building Modern DevOps Pipelines'), 1, GETDATE()),
('Continuous Integration', 'Basics of CI/CD pipelines.', 'file', NULL, '/files/cloud_deployment_strategies.pdf', 26, 2, (SELECT CourseID FROM Course WHERE Title = 'Building Modern DevOps Pipelines'), 1, GETDATE()),
('Java Data Types', 'Understanding primitive and non-primitive data types in Java.', 'video', '/videos/java-data-types.mp4', '', 30, 3, 1, 1, GETDATE()),
('Java Control Statements', 'Learn about if-else, loops, and switch statements in Java.', 'document', '', '/docs/java-control-statements.pdf', 28, 4, 1, 1, GETDATE()),
('Java Methods and Functions', 'How to define and use methods in Java.', 'video', '/videos/java-methods.mp4', '', 32, 5, 1, 1, GETDATE()),
('Java Arrays', 'Introduction to arrays and array operations in Java.', 'document', '', '/docs/java-arrays.pdf', 26, 6, 1, 1, GETDATE()),
('Java Exception Handling', 'Learn how to handle exceptions in Java.', 'video', '/videos/java-exceptions.mp4', '', 34, 7, 1, 1, GETDATE()),
('Java Collections Framework', 'Introduction to ArrayList, HashMap, and other collections.', 'document', '', '/docs/java-collections.pdf', 30, 8, 1, 1, GETDATE()),
('File Handling in Java', 'Reading and writing files using Java IO and NIO.', 'video', '/videos/java-file-handling.mp4', '', 33, 9, 1, 1, GETDATE()),
('Multithreading in Java', 'Learn how to use threads and concurrency in Java.', 'document', '', '/docs/java-multithreading.pdf', 29, 10, 1, 1, GETDATE()),
('Lambda Expressions in Java', 'Understanding functional programming in Java.', 'video', '/videos/java-lambda.mp4', '', 35, 11, 1, 1, GETDATE()),
('Spring Boot Basics', 'Introduction to Spring Boot framework.', 'document', '', '/docs/java-spring-boot.pdf', 27, 12, 1, 1, GETDATE());
-- Insert quizzes for courses
INSERT INTO Quiz (Name, Description, Duration, PassRate, TotalQuestion, CourseID, Status, CreatedAt) 
VALUES 
    ('Java Basics Quiz', 'A quiz to test Java fundamentals.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Java Programming Fundamentals'), 1, GETDATE()),
    ('React Development Quiz', 'Test your knowledge on React development.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Full Stack Web Development'), 1, GETDATE()),
    ('SQL Proficiency Quiz', 'Assess your SQL and database management skills.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Introduction to Databases and SQL'), 1, GETDATE()),
    ('Cybersecurity Basics Quiz', 'Evaluate your understanding of cybersecurity principles.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Introduction to Cybersecurity'), 1, GETDATE()),
    ('Python Fundamentals Quiz', 'Test your knowledge on Python programming basics.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Python for Data Analysis'), 1, GETDATE()),
    ('Machine Learning Quiz', 'Evaluate your understanding of machine learning concepts.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Data Science with Python'), 1, GETDATE()),
    ('Cloud Computing Quiz', 'Assess your knowledge on cloud computing principles.', 30, 70, 5, 
     (SELECT CourseID FROM Course WHERE Title = 'Introduction to Cloud Computing'), 1, GETDATE());

-- Insert questions for each quiz
INSERT INTO Question (Content, PointPerQuestion, QuizID, Status, CreatedAt) 
VALUES 
    ('What is the default value of an int variable in Java?', 1, 
     (SELECT QuizID FROM Quiz WHERE Name = 'Java Basics Quiz'), 1, GETDATE()),
    ('Which React hook is used for managing state in a functional component?', 1, 
     (SELECT QuizID FROM Quiz WHERE Name = 'React Development Quiz'), 1, GETDATE()),
    ('What SQL clause is used to filter records based on a condition?', 1, 
     (SELECT QuizID FROM Quiz WHERE Name = 'SQL Proficiency Quiz'), 1, GETDATE()),
    ('What is the primary function of a firewall in cybersecurity?', 1, 
     (SELECT QuizID FROM Quiz WHERE Name = 'Cybersecurity Basics Quiz'), 1, GETDATE()),
    ('Which keyword is used to define a function in Python?', 1, 
     (SELECT QuizID FROM Quiz WHERE Name = 'Python Fundamentals Quiz'), 1, GETDATE()),
    ('What is supervised learning in machine learning?', 1, 
     (SELECT QuizID FROM Quiz WHERE Name = 'Machine Learning Quiz'), 1, GETDATE()),
    ('What does IaaS stand for in cloud computing?', 1, 
     (SELECT QuizID FROM Quiz WHERE Name = 'Cloud Computing Quiz'), 1, GETDATE());

-- Insert answers for each question (4 options per question, one correct answer)
INSERT INTO Answer (content, isCorrect, Explanation, questionID) 
SELECT '0', 1, 'In Java, the default value of an int is 0.', QuestionID FROM Question WHERE CAST(Content AS NVARCHAR(MAX)) = 'What is the default value of an int variable in Java?'
UNION ALL
SELECT '1', 0, 'Incorrect, as Java does not assign 1 as a default value.', QuestionID FROM Question WHERE CAST(Content AS NVARCHAR(MAX)) = 'What is the default value of an int variable in Java?'
UNION ALL
SELECT 'null', 0, 'Incorrect, int is a primitive type and cannot be null.', QuestionID FROM Question WHERE CAST(Content AS NVARCHAR(MAX)) = 'What is the default value of an int variable in Java?'
UNION ALL
SELECT 'undefined', 0, 'Incorrect, Java does not use undefined like JavaScript.', QuestionID FROM Question WHERE CAST(Content AS NVARCHAR(MAX)) = 'What is the default value of an int variable in Java?';

INSERT INTO Answer (content, isCorrect, Explanation, questionID) 
VALUES 
    ('useState', 1, 'useState is used for managing state in functional components.', 2),
    ('useEffect', 0, 'useEffect is used for handling side effects.', 2),
    ('useContext', 0, 'useContext is used for consuming context.', 2),
    ('useReducer', 0, 'useReducer is used for complex state logic.', 2),
    ('WHERE', 1, 'WHERE clause filters records based on a condition.', 3),
    ('GROUP BY', 0, 'GROUP BY groups rows sharing a property.', 3),
    ('ORDER BY', 0, 'ORDER BY sorts query results.', 3),
    ('HAVING', 0, 'HAVING filters grouped results.', 3),
    ('To block unauthorized access', 1, 'Firewalls prevent unauthorized access.', 4),
    ('To scan for viruses', 0, 'Antivirus scans for viruses, not firewalls.', 4),
    ('To encrypt data', 0, 'Encryption secures data, not firewalls.', 4),
    ('To create backups', 0, 'Backups store copies, not firewalls.', 4),
    ('def', 1, 'def is used to define a function in Python.', 5),
    ('func', 0, 'func is not a valid Python keyword.', 5),
    ('lambda', 0, 'lambda is used for anonymous functions.', 5),
    ('define', 0, 'define is not a Python keyword.', 5),
    ('Supervised learning uses labeled data', 1, 'Supervised learning is based on labeled training data.', 6),
    ('Unsupervised learning uses labeled data', 0, 'Unsupervised learning does not use labeled data.', 6),
    ('Supervised learning finds patterns without labels', 0, 'This describes unsupervised learning.', 6),
    ('Reinforcement learning uses labels directly', 0, 'Reinforcement learning is reward-based.', 6),
    ('Infrastructure as a Service', 1, 'IaaS stands for Infrastructure as a Service.', 7),
    ('Internet as a Service', 0, 'Incorrect, IaaS relates to infrastructure.', 7),
    ('Integration as a Service', 0, 'Incorrect, this is not a standard cloud model.', 7),
    ('Information as a Service', 0, 'Incorrect, cloud computing does not use this term.', 7);


