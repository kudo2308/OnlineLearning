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
    Username NVARCHAR(100) NOT NULL,
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
-- Packages table
CREATE TABLE Packages (
    PackageID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Description NTEXT,
    Duration INT, -- Duration in days
    Price DECIMAL(10,2) NOT NULL,
    DiscountPercent DECIMAL(5,2) DEFAULT 0.00,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- Package_Course table (for mapping courses to packages)
CREATE TABLE Package_Course (
    PackageID INT,
    CourseID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (PackageID, CourseID),
    FOREIGN KEY (PackageID) REFERENCES Packages(PackageID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
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
INSERT INTO Account (FullName, Username, Password, Email, RoleID, DOB, Status) 
VALUES
('System Admin', 'admin', 'admin123', 'admin@onlinelearning.com', 1, '1990-01-01', 1);

-- Insert a sample expert account (password: expert123)
INSERT INTO Account (FullName, Username, Password, Email, RoleID, DOB, Status) 
VALUES
('John Expert', 'expert1', 'expert123', 'expert1@onlinelearning.com', 2, '1985-05-12', 1);

-- Insert a sample student account (password: student123)
INSERT INTO Account (FullName, Username, Password, Email, RoleID, DOB, Status) 
VALUES
('Jane Student', 'student1', 'student123', 'student1@onlinelearning.com', 3, '1995-11-23', 1);


-- Insert sample course
INSERT INTO Course (Title, Description, ExpertID, CategoryID, ImageUrl, TotalLesson, Price) VALUES
('Java Programming Fundamentals', 
 'Learn the basics of Java programming language including syntax, OOP concepts, and practical applications',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/images/courses/java-fundamentals.jpg',
 10,
 120),
('Advanced Java Programming', 
 'This course will take you beyond the basics of Java, exploring advanced topics such as multithreading, concurrency, design patterns, and Java’s ecosystem for building scalable applications.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Programming'),
 '/images/courses/advanced-java.jpg',
 15,
 150),

('Full Stack Web Development', 
 'Master both front-end and back-end web development. This course covers HTML, CSS, JavaScript, React, Node.js, and database integration. You will also learn how to deploy your full-stack applications.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Web Development'),
 '/images/courses/full-stack-web.jpg',
 20,
 200),

('Introduction to Databases and SQL', 
 'In this course, you will learn the fundamentals of relational databases, SQL syntax, and how to work with databases. It covers topics such as database normalization, indexing, and optimization.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Database'),
 '/images/courses/sql-intro.jpg',
 10,
 100),

('Networking Fundamentals', 
 'This course provides an in-depth understanding of networking concepts including IP addressing, subnetting, TCP/IP protocols, routing, and network security.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Networking'),
 '/images/courses/networking-fundamentals.jpg',
 12,
 120),

('Mobile App Development with Flutter', 
 'Learn how to build mobile applications for both iOS and Android using Flutter. This course will guide you through the entire process from setting up the environment to deploying your first app.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Mobile Development'),
 '/images/courses/flutter-mobile-app.jpg',
 18,
 180),

('Data Science with Python', 
 'This course teaches you the essentials of Data Science, focusing on Python programming. Topics covered include data cleaning, visualization, and machine learning algorithms using libraries like Pandas, NumPy, and Scikit-Learn.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Data Science'),
 '/images/courses/data-science-python.jpg',
 22,
 220),

('Introduction to Cybersecurity', 
 'Learn the basics of cybersecurity, including network security, cryptography, and threat analysis. This course provides essential knowledge to protect systems and data from potential cyber threats.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Security'),
 '/images/courses/cybersecurity-intro.jpg',
 14,
 140),

('Building Modern DevOps Pipelines', 
 'This course introduces DevOps concepts, including continuous integration, continuous delivery, and the use of tools like Docker, Kubernetes, and Jenkins to automate software development and deployment.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'DevOps'),
 '/images/courses/devops-pipelines.jpg',
 16,
 160),
('Python for Data Analysis', 
 'Learn how to use Python for data analysis. This course covers libraries such as Pandas, NumPy, and Matplotlib for data manipulation and visualization. You will also learn how to clean and prepare data for analysis.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Data Science'),
 '/images/courses/python-data-analysis.jpg',
 18,
 180),

('React Native for Mobile Apps', 
 'This course covers the basics of React Native, an open-source framework for building mobile apps. You will learn how to create cross-platform mobile applications for both iOS and Android using JavaScript and React.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Mobile Development'),
 '/images/courses/react-native-apps.jpg',
 20,
 200),

('Deep Learning with TensorFlow', 
 'In this course, you will learn the basics of deep learning and how to implement neural networks using TensorFlow. Topics include supervised learning, CNNs, RNNs, and reinforcement learning.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Data Science'),
 '/images/courses/deep-learning-tensorflow.jpg',
 25,
 250),

('Introduction to Cloud Computing', 
 'Cloud computing is transforming the way businesses operate. In this course, you will learn the fundamentals of cloud computing, the different cloud service models, and the leading cloud platforms such as AWS, Azure, and Google Cloud.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Networking'),
 '/images/courses/cloud-computing-intro.jpg',
 12,
 120),

('Advanced Cybersecurity Practices', 
 'This course is designed for those who already have a basic understanding of cybersecurity. You will learn about advanced topics such as penetration testing, incident response, advanced threat protection, and ethical hacking.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Security'),
 '/images/courses/advanced-cybersecurity.jpg',
 20,
 200),

('Agile Project Management', 
 'Agile is a popular project management methodology used in software development and other industries. In this course, you will learn about Agile principles, Scrum framework, and how to manage projects using Agile techniques.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'DevOps'),
 '/images/courses/agile-project-management.jpg',
 15,
 150),

('Introduction to Internet of Things (IoT)', 
 'The Internet of Things (IoT) is a rapidly growing technology that connects devices to the internet. This course will introduce you to IoT concepts, including sensors, actuators, and cloud computing for managing IoT devices.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Networking'),
 '/images/courses/iot-introduction.jpg',
 18,
 180),

('Building Scalable Web Applications', 
 'This course will teach you how to build scalable web applications using modern technologies such as microservices, containers, and cloud platforms. You will also learn about API design, load balancing, and database scaling.',
 (SELECT UserID FROM Account WHERE Username = 'expert1'),
 (SELECT CategoryID FROM Category WHERE Name = 'Web Development'),
 '/images/courses/scalable-web-applications.jpg',
 22,
 220);
-- Insert lessons for courses
INSERT INTO Lesson (Title, Content, LessonType, VideoUrl, DocumentUrl, Duration, OrderNumber, CourseID, Status) 
VALUES
('Introduction to Java Programming', 
 'In this lesson, we will cover the basic syntax of Java, including variables, data types, and control structures. By the end of this lesson, you will be able to write simple Java programs.',
 'video', 
 '/videos/java-intro.mp4', 
 NULL, 
 45, 
 1, 
 (SELECT CourseID FROM Course WHERE Title = 'Java Programming Fundamentals'),
 1),

('Object-Oriented Programming in Java', 
 'This lesson introduces the concept of Object-Oriented Programming (OOP). We will discuss classes, objects, inheritance, and polymorphism. OOP is a core concept in Java programming.',
 'video', 
 '/videos/java-oop.mp4', 
 NULL, 
 50, 
 2, 
 (SELECT CourseID FROM Course WHERE Title = 'Java Programming Fundamentals'),
 1),

('Mastering Java Collections', 
 'In this lesson, we will dive into the Java Collections Framework, including lists, sets, and maps. You will learn how to use these collections to store and manipulate data efficiently.',
 'video', 
 '/videos/java-collections.mp4', 
 NULL, 
 60, 
 3, 
 (SELECT CourseID FROM Course WHERE Title = 'Java Programming Fundamentals'),
 1),

('Introduction to HTML and CSS', 
 'This lesson will teach you the fundamentals of web development, focusing on HTML and CSS. You will learn how to structure a webpage with HTML and style it using CSS.',
 'video', 
 '/videos/html-css-intro.mp4', 
 NULL, 
 40, 
 1, 
 (SELECT CourseID FROM Course WHERE Title = 'Full Stack Web Development'),
 1),

('JavaScript Basics', 
 'In this lesson, we will explore the fundamentals of JavaScript, including variables, functions, and loops. JavaScript is a key language for front-end development.',
 'video', 
 '/videos/javascript-basics.mp4', 
 NULL, 
 50, 
 2, 
 (SELECT CourseID FROM Course WHERE Title = 'Full Stack Web Development'),
 1),

('Building Your First React App', 
 'This lesson teaches you how to create your first React application. You will learn about React components, JSX, and how to manage state in a React app.',
 'video', 
 '/videos/react-first-app.mp4', 
 NULL, 
 55, 
 3, 
 (SELECT CourseID FROM Course WHERE Title = 'Full Stack Web Development'),
 1),

('SQL Basics', 
 'In this lesson, you will learn the basics of SQL, including SELECT, INSERT, UPDATE, and DELETE queries. SQL is essential for interacting with relational databases.',
 'document', 
 NULL, 
 '/documents/sql-basics.pdf', 
 30, 
 1, 
 (SELECT CourseID FROM Course WHERE Title = 'Introduction to Databases and SQL'),
 1),

('Database Normalization', 
 'This lesson covers the concept of database normalization, which helps to eliminate redundancy and improve the efficiency of a database design.',
 'document', 
 NULL, 
 '/documents/database-normalization.pdf', 
 45, 
 2, 
 (SELECT CourseID FROM Course WHERE Title = 'Introduction to Databases and SQL'),
 1),

('Networking Essentials', 
 'This lesson will introduce the fundamentals of networking, including the OSI model, IP addressing, and subnetting. Networking is crucial for understanding how devices communicate over a network.',
 'video', 
 '/videos/networking-essentials.mp4', 
 NULL, 
 50, 
 1, 
 (SELECT CourseID FROM Course WHERE Title = 'Networking Fundamentals'),
 1),

('Routing and Switching Concepts', 
 'In this lesson, you will learn about routing and switching protocols, including RIP, OSPF, and VLANs. This knowledge is essential for configuring and managing networks.',
 'video', 
 '/videos/routing-switching.mp4', 
 NULL, 
 55, 
 2, 
 (SELECT CourseID FROM Course WHERE Title = 'Networking Fundamentals'),
 1),

('Introduction to Mobile Development with Flutter', 
 'This lesson introduces Flutter, a popular framework for mobile app development. You will learn how to build a simple mobile application using Flutter.',
 'video', 
 '/videos/flutter-intro.mp4', 
 NULL, 
 45, 
 1, 
 (SELECT CourseID FROM Course WHERE Title = 'Mobile App Development with Flutter'),
 1),

('Flutter Widgets and Layouts', 
 'This lesson covers Flutter widgets and layouts. You will learn how to use various widgets to build responsive mobile applications.',
 'video', 
 '/videos/flutter-widgets.mp4', 
 NULL, 
 50, 
 2, 
 (SELECT CourseID FROM Course WHERE Title = 'Mobile App Development with Flutter'),
 1),

('Data Cleaning with Pandas', 
 'In this lesson, you will learn how to clean and preprocess data using the Pandas library in Python. Data cleaning is a crucial step before performing any analysis.',
 'document', 
 NULL, 
 '/documents/data-cleaning-pandas.pdf', 
 40, 
 1, 
 (SELECT CourseID FROM Course WHERE Title = 'Data Science with Python'),
 1);

