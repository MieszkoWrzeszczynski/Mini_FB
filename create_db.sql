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
INSERT INTO tblLocations VALUES('63-300','Poznań','Wielkopolskie','Polska'),('10-005','New York','New York','USA')
INSERT INTO tblLocations VALUES('64-300','Warszawa','Mazowieckie','Polska'),('66-400','Gorzów Wielkopolski','Lubuskie','Polska')
INSERT INTO tblLocations VALUES('12-432','Frankfurt','Oder','Niemcy'),('10-125','Last Vegas','LA 4 Life','USA')
INSERT INTO tblLocations VALUES('02-231','Bangladesz','Alma','Syria'),('98-404','Szczecin','Zachodnio Pomorskie','Polska')

-- USERS
INSERT INTO tblUsers VALUES('Mieszko','Wrzeszczyński','mieszkobor@op.pl','1231231ad','123123123',1,DEFAULT,'63-300')
INSERT INTO tblUsers VALUES('Adam','Domagalski','adam@op.pl','1231231','1232',1,DEFAULT,'66-400'),('Casey','Neistat','ny@beme.com','1231231','1232',1,DEFAULT,'10-005')
INSERT INTO tblUsers VALUES('Filip','Hajzer','synzygmunta@wp.pl','hasuo','693258741',1,DEFAULT,'64-300'),('Krystyna','Czubówna','lubiegadac@gmail.com','zwierzaczkipolaczki','9845636321',0,DEFAULT,'64-300')
INSERT INTO tblUsers VALUES('Paweł','Rajtuz','rajtuz@siema.pl','psw123','456213654',1,DEFAULT,'64-300'),('Natalia','Airduster','powietrze@yahoo.com','sdklhvsaw4234','987546321',0,DEFAULT,'64-300')
INSERT INTO tblUsers VALUES('Diana','Zacna','zacnemidowe@wp.pl','zaqwsx','694328741',0,DEFAULT,'64-300'),('Kasia','Namalowana','rysunek@spamffree.com','324234oij','96456321',0,DEFAULT,'64-300')
INSERT INTO tblUsers VALUES('Maciej','Pokład','wsiadajnapoklad@wp.pl','asdqwe','693258741',1,DEFAULT,'64-300'),('Kazik','Gortat','goryl@grf.com','2341sdfsdf','987546321',1,DEFAULT,'64-300')
INSERT INTO tblUsers VALUES('Łysy','Łysy','łysolyolo@wp.pl','gfh46dfg','876258741',1,DEFAULT,'64-300'),('Mirjan','Mufią','maff@gmail.com','314234afsdf','987546321',0,DEFAULT,'64-300')
INSERT INTO tblUsers VALUES('Babcia','Jadzia','babcia@wp.pl','sdf897s','693678655',0,DEFAULT,'64-300'),('Pafeu','Piotrowski','piotripawel@llfzlthz.com','123123asf','912346321',1,DEFAULT,'64-300')
INSERT INTO tblUsers VALUES('Filip','Klawiatura','kalish@wp.pl','wrwexc9872!','457829403',1,DEFAULT,'64-300'),('Marek','Czarek','pieczarek@pizza.com','213gd!@#','921546321',1,DEFAULT,'64-300')


-- CATEGORIES
INSERT INTO tblCategories VALUES('kuchnia'),('motoryzacja'),('it'),('polityka'),('rozrywka'),('sprzątanie')
INSERT INTO tblCategories VALUES('sport'),('turystyka'),('zakupy'),('praca'),('alkohole'),('społeczeństwo')

-- TAGS
INSERT INTO tblTags VALUES('zupa',1),('szybkiedanie',1),('azjatykca',1),('europejska',1),('desery',1),('dieta',1)
INSERT INTO tblTags VALUES('motor',2),('auto',2),('BMW',2),('AUDI',2),('opony',2),('prędkość',2),('adrenalina',2)
INSERT INTO tblTags VALUES('python',3),('C++',3),('T-SQL',3),('webdev',3),('bash',3),('linux',3),('windows',3)
INSERT INTO tblTags VALUES('lewactwo',4),('PO',4),('PiS',4),('Trump',4),('500+',4),('cotusiedzieje',4),('masakra',4)
INSERT INTO tblTags VALUES('muzyka',5),('film',5),('joemonser',5),('kabaret',5),('youtube',5),('gry',5),('MMA',5)
INSERT INTO tblTags VALUES('ciff',6),('papierrecznikowy',6),('recznikpapierowy',6),('kret',6),('płynnaślimaki',6)
INSERT INTO tblTags VALUES('bieganie',7),('siłownia',7),('rower',7),('pływanie',7),('nordickwalkingxD',7),('tenis',7)
INSERT INTO tblTags VALUES('grecja',8),('turcja',8),('hiszpania',8),('tajlandia',8),('UK',8),('egipt',8)
INSERT INTO tblTags VALUES('ubrania',9),('spożywka',9),('HiTech',9),('cebuladeals',9),('aliexpress',9),('allegro',9)
INSERT INTO tblTags VALUES('konsultant',10),('sprzedawczyk',10),('sprzątaczka',10),('kierowca',10),('leń',10)
INSERT INTO tblTags VALUES('whisky',11),('vodka',11),('piwo',11),('wino',11),('drinki',11),('bimberniebiber',11)
INSERT INTO tblTags VALUES('snapchat',12),('facebook',12),('instagram',12),('twitter',12),('linkedln',12),('reddit',12)

-- Relationships
INSERT INTO tblRelationships VALUES('Przyjaciele'),('Wrogowie'),('Byli znajomi'),('Żona'),('Brat'),('Ziomek z przedszkola')
INSERT INTO tblRelationships VALUES('Konfident'),('Znajomy którego nie widziałem na oczy xD'),('Współlokator syfiarz')
-- FREINDSHIPS
INSERT INTO tblFriendships VALUES(1,2,0,1,1,DEFAULT),(1,3,0,1,1,DEFAULT),(1,4,0,1,1,DEFAULT),(1,5,0,1,1,DEFAULT),(1,6,0,1,1,DEFAULT),(1,7,0,1,1,DEFAULT),(1,8,0,1,1,DEFAULT),(1,9,0,1,1,DEFAULT),(1,10,0,1,1,DEFAULT),(1,11,0,1,1,DEFAULT)
INSERT INTO tblFriendships VALUES(2,3,0,1,1,DEFAULT),(2,4,0,1,1,DEFAULT),(2,5,0,1,1,DEFAULT),(2,6,0,1,1,DEFAULT),(2,7,0,1,1,DEFAULT),(2,8,0,1,1,DEFAULT),(2,9,0,1,1,DEFAULT),(2,10,0,1,1,DEFAULT),(11,2,0,1,1,DEFAULT),(12,2,0,1,1,DEFAULT)



--PRIVACY
 INSERT INTO tblPrivacy VALUES(1,'ALL'),(2,'FrOnly')

-- GROUPS
INSERT INTO tblGroups VALUES('fani gotowania','lubimy gotowac','64-300',1,1,1)
INSERT INTO tblGroups VALUES('WALL','Main MiniFb Wall Schabowe z kostki rosołowej wg przepisu Babci Jadzi','64-300',1,1,1)
INSERT INTO tblGroups VALUES('fani szybkiej jazdy','Main MiniFb Wall sprzedam opla','64-300',2,1,2)
INSERT INTO tblGroups VALUES('fani oldskulu','Mercendes benz z 1983roku!!!','64-300',1,1,2)

-- POSTS
INSERT INTO tblPosts VALUES(DEFAULT,'Byłem wczoraj na dworze!','Ale było fajnie!',1,1);
INSERT INTO tblPosts VALUES(DEFAULT,'Kupiłem pralkę!','Fajna ta pralka',2,2);
INSERT INTO tblPosts VALUES(DEFAULT,'C++','Hi guys! How to concatenate strings in C++?',6,2);

-- POSTTAGS
INSERT INTO tblPostTags VALUES(1,1)
INSERT INTO tblPostTags VALUES(2,2)
INSERT INTO tblPostTags VALUES(3,15)


-- Comments
INSERT INTO tblComments VALUES(DEFAULT,1,1,'Hahahahaahaha jak on to zrobił!?'),(DEFAULT,2,2,'Za ile?')
INSERT INTO tblComments VALUES(DEFAULT,1,1,'O matko!'),(DEFAULT,1,1,'Widzisz to Helena?!')

-- POSTTAGS
INSERT INTO tblPostGroups VALUES(1,1)
INSERT INTO tblPostGroups VALUES(1,2)

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
