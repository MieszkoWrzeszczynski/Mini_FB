--DROP DATABASE miniFB
IF OBJECT_ID('tblFriendships', 'U') IS NOT NULL
      drop table tblFriendships

IF OBJECT_ID('tblRelationships', 'U') IS NOT NULL
      drop table tblRelationships

IF OBJECT_ID('tblMembers', 'U') IS NOT NULL
      drop table tblMembers

IF OBJECT_ID('tblComments', 'U') IS NOT NULL
      drop table tblComments

IF OBJECT_ID('tblPostGroups', 'U') IS NOT NULL
      drop table tblPostGroups

 IF OBJECT_ID('tblPostTags', 'U') IS NOT NULL
      drop table tblPostTags

IF OBJECT_ID('tblGroups', 'U') IS NOT NULL
      drop table tblGroups

IF OBJECT_ID('tblPosts', 'U') IS NOT NULL
      drop table tblPosts
IF OBJECT_ID('tblTags', 'U') IS NOT NULL
      drop table tblTags

IF OBJECT_ID('tblCategories', 'U') IS NOT NULL
      drop table tblCategories

IF OBJECT_ID('tblPrivacy', 'U') IS NOT NULL
      drop table tblPrivacy

IF OBJECT_ID('tblUsers', 'U') IS NOT NULL
      drop table tblUsers

IF OBJECT_ID('tblLocations', 'U') IS NOT NULL
      drop table tblLocations

--CREATE DATABASE miniFB
--use miniFB

--1 create tblLocation
IF OBJECT_ID('tblLocations','U') IS NULL
CREATE TABLE tblLocations (
    zipCode char(6) not null primary key,
    city nvarchar(50),
    state nvarchar(50),
    country nvarchar(30),
)

--2 Create tblUsers
IF OBJECT_ID('tblUsers','U') IS NULL
CREATE TABLE tblUsers (
    id int IDENTITY(1,1)  primary key,
    name nvarchar(50),
    surname nvarchar(50),
    email varchar(30),
    password varchar(255),
    phone varchar(15),
    gender char(1) CHECK (gender in (1,0)), -- 1: facet 0: kobieta można to zmienić na liste czy coś
    since datetime default CURRENT_TIMESTAMP,
    location_ID char(6) references tblLocations(zipCode)
)

--3 create tblCategories
IF OBJECT_ID('tblCategories','U') IS NULL
    CREATE TABLE tblCategories (
    id int not null IDENTITY(1,1) primary key,
    title nvarchar(255)
)

--4 create tblTags
IF OBJECT_ID('tblTags','U') IS NULL
CREATE TABLE tblTags (
    id int not null IDENTITY(1,1) primary key,
    title nvarchar(255),
    catID int references tblCategories(id)
)



--5 create tblPrivacy
IF OBJECT_ID('tblPrivacy','U') IS NULL
CREATE TABLE tblPrivacy (
    id int  IDENTITY(1,1) primary key,
    status nvarchar(255),
    description nvarchar(255)
)


--6 create tblPosts
IF OBJECT_ID('tblPosts','U') IS NULL
CREATE TABLE tblPosts (
    id int not null IDENTITY(1,1) primary key,
    date datetime default CURRENT_TIMESTAMP,
    title nvarchar(255),
    content NTEXT,
    authorID int references tblUsers(id),
    privacyID int references tblPrivacy(id),

)

--7 create tblPostTags
IF OBJECT_ID('tblPostTags','U') IS NULL
CREATE TABLE tblPostTags (
    id int not null IDENTITY(1,1) primary key,
    postID int references tblPosts(id),
    tagID int references tblTags(id)
)

--8 create tblGroups
IF OBJECT_ID('tblGroups','U') IS NULL
CREATE TABLE tblGroups (
    id int not null IDENTITY(1,1) primary key,
    title nvarchar(255),
    content NTEXT,
    location_ID char(6) references tblLocations(zipCode),
    adminID int references tblUsers(id),
    privacyID int references tblPrivacy(id),
    catID int references tblCategories(id)
)

--9 create tblPostGroups -- tabela łączącax posty z grupami
IF OBJECT_ID('tblPostGroups','U') IS NULL
CREATE TABLE tblPostGroups (
    id int not null IDENTITY(1,1) primary key,
    groupID int references tblGroups(id),
    postID int references tblPosts(id)
)

--10 create tblComments
IF OBJECT_ID('tblComments','U') IS NULL
CREATE TABLE tblComments (
    id int not null IDENTITY(1,1) primary key,
    date  DATETIME NOT NULL DEFAULT(GETDATE()),
    postID int references tblPosts(id),
    authorID int references tblUsers(id),
    content NTEXT
)

--11 create tblMembers
IF OBJECT_ID('tblMembers','U') IS NULL
CREATE TABLE tblMembers (
    id int not null IDENTITY(1,1) primary key,
    memberID int references tblUsers(id),
    groupID int references tblGroups(id)
)

--12 create tblRelationships
IF OBJECT_ID('tblRelationships','U') IS NULL
CREATE TABLE tblRelationships (
    id int not null IDENTITY(1,1) primary key,
    title NCHAR(80)
)

--13 create tblFriendships

IF OBJECT_ID('tblFriendships','U') IS NULL
CREATE TABLE tblFriendships (
    id int not null IDENTITY(1,1) primary key,
    senderID int references tblUsers(id),
    receiver int references tblUsers(id),
    blocked char(1) CHECK( blocked in (0,1)), -- true / false
    relationID int references tblRelationships(id),
    accepted char(1) CHECK( accepted in (0,1)), -- true / false nie wiem czy tak ma byc
    since datetime DEFAULT  CURRENT_TIMESTAMP -- dodałem date rozpoczęcia znajomości
)






----------------------- INSERTS

-- LOCATION
INSERT INTO tblLocations VALUES('63-300','Poznań','Wielkopolskie','Polska')
INSERT INTO tblLocations VALUES('64-300','Warszawa','Mazowieckie','Polska'),('66-400','Gorzów Wlkp.','Lubuskie','Polska')

-- USERS
INSERT INTO tblUsers VALUES('Mieszko','Wrzeszczyński','mieszkobor@op.pl','1231231asadsad','123123123',1,DEFAULT,'63-300')
INSERT INTO tblUsers VALUES('Adam','Domagalski','adam@op.pl','1231231','1232',1,DEFAULT,'66-400')
INSERT INTO tblUsers VALUES('Filip','Hajzer','synzygmunta@wp.pl','hasuo','693258741',1,DEFAULT,'64-300'),('Krystyna','Czubówna','lubiegadac@gmail.com','zwierzaczkipolaczki','987546321',0,DEFAULT,'64-300')


-- CATEGORIES

INSERT INTO tblCategories VALUES('gotowanie')
INSERT INTO tblCategories VALUES('sprzątanie')

-- TAGS
INSERT INTO tblTags VALUES('schabowe',1)
INSERT INTO tblTags VALUES('mop',2)
-- Relationships
INSERT INTO tblRelationships VALUES('Przyjaciele'),('Wrogowie'),('Byli znajomi')

-- FREINDSHIPS
INSERT INTO tblFriendships VALUES(1,2,0,1,1,DEFAULT)
INSERT INTO tblFriendships VALUES(1,3,0,1,1,DEFAULT)

--PRIVACY
 INSERT INTO tblPrivacy VALUES(1,'ALL'),(2,'FrOnly')

-- GROUPS
INSERT INTO tblGroups VALUES('fani gotowania','lubimy gotowac','64-300',1,1,1)
INSERT INTO tblGroups VALUES('WALL','Main MiniFb Wall','64-300',1,1,1)
INSERT INTO tblGroups VALUES('fani sprzątania','Main MiniFb Wall','64-300',2,1,2)
INSERT INTO tblGroups VALUES('fani sprzątania','Daj mi tego mopa Janusz!!!','64-300',1,1,2)

-- POSTS
INSERT INTO tblPosts VALUES(DEFAULT,'Byłem wczoraj na dworze!','Ale było fajnie!',1,1);
INSERT INTO tblPosts VALUES(DEFAULT,'Kupiłem pralkę!','Fajna ta pralka',2,2);

-- POSTTAGS
INSERT INTO tblPostTags VALUES(1,1)
INSERT INTO tblPostTags VALUES(2,2)

-- Comments
INSERT INTO tblComments VALUES(DEFAULT,1,1,'Hahahahaahaha jak on to zrobił!?'),(DEFAULT,2,2,'Za ile?')
INSERT INTO tblComments VALUES(DEFAULT,1,1,'O matko!'),(DEFAULT,1,1,'Widzisz to Helena?!')

-- POSTTAGS
INSERT INTO tblPostGroups VALUES(1,1)
INSERT INTO tblPostGroups VALUES(1,2)

select * from tblPostGroups

-- MEMBERS
INSERT INTO tblMembers VALUES(1,1),(2,1)

SELECT * FROM tblUsers;
SELECT * FROM tblLocations;
SELECT * FROM tblGroups;
SELECT * FROM tblPrivacy;
SELECT * FROM tblCategories;
SELECT * FROM tblTags;
SELECT * FROM tblPosts;
SELECT * FROM tblPostTags;
SELECT * FROM tblComments;
SELECT * FROM tblMembers;
SELECT * FROM tblRelationships;
SELECT * FROM tblFriendships;
SELECT * FROM tblPostGroups;
