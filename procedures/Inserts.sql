--Flush procedures
IF OBJECT_ID ( 'addLoc', 'P' ) IS NOT NULL
    drop procedure addLoc;
go

IF OBJECT_ID ( 'addCategory', 'P' ) IS NOT NULL
    drop procedure addCategory;
go

IF OBJECT_ID ( 'addTag', 'P' ) IS NOT NULL
    drop procedure addTag;
go

IF OBJECT_ID ( 'addPrivacy', 'P' ) IS NOT NULL
    drop procedure addPrivacy;
go

IF OBJECT_ID ( 'addUser', 'P' ) IS NOT NULL
    drop procedure addUser;
go

if OBJECT_ID ('addPost', 'P') is not null
	drop procedure addPost;
go

--Create procedures
CREATE PROCEDURE addCategory
    @categorieName NVARCHAR(255)
AS
begin try
    if exists (select * from tblCategories where title=@categorieName)
		raiserror ('Taki projekt już istnieje', 11,1)
	else
        begin
			INSERT INTO tblCategories VALUES(@categorieName)
        end
end try
    begin catch
        SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
    end catch
go

CREATE proc addLoc
	@zipCode char(6),
    @city nvarchar(50),
    @state nvarchar(50),
    @country nvarchar(30)
	as
	begin try
		if @zipCode not in (select zipCode from tblLocations)
			begin
				INSERT INTO tblLocations VALUES(@zipCode,@city,@state,@country)
			end
		else
			 raiserror ('Dana lokalizacja nie istnieje', 11,1,666,777)
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
		return
	end catch
go

CREATE PROCEDURE addTag
    @tagName NVARCHAR(255),
	@catId int
AS
begin try
    if  exists (select * from tblTags where title=@tagName)
		raiserror ('Taki tag już istnieje', 11,1)
	else
        begin
		      INSERT INTO tblTags VALUES(@tagName,@catId)
        end
end try
begin catch
         SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
go

CREATE PROCEDURE addPrivacy
        @status NVARCHAR(MAX),
		@description NVARCHAR(MAX)
AS
begin try
        if exists (select * from tblPrivacy where status=@status)
		  raiserror ('Taki status już istnieje', 11,1)
		else
        begin
			INSERT INTO tblPrivacy VALUES(@status,@description)
        end
end try
begin catch
           SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
go

create proc addUser
    @name nvarchar(50),
    @surname nvarchar(50),
    @email varchar(30),
    @password varchar(255),
    @phone varchar(15),
    @gender char(1),
    @location_ID char(6)
	as
	begin try
		if not exists ( select * from tblLocations where zipCode=@location_ID)
			raiserror ('Brak podanej lokalizacji w bazie, dodaj ja i sproboj ponownie', 11,1)
		if not exists (select * from tblUsers where email=@email)
			insert into tblUsers values (@name,@surname,@email,@password,@phone,@gender,DEFAULT,@location_ID)
		else
			raiserror ('Użytkownik z takim mailem juz istnieje', 11,1)
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
		return
	end catch
go

create proc addPost
    @title nvarchar(255),
    @content NTEXT,
    @authorID int, --references tblUsers(id),
    @privacyID int --references tblPrivacy(id)
	as
	begin try
		if not exists (select * from tblUsers where id=@authorID)
		begin
			declare @msg nvarchar(max)
			set @msg = 'Uzytkownik z id: '+@authorID+' nie istnieje'
			raiserror(@msg,1,1)
		end
		if not exists (select * from tblPrivacy where id=@privacyID)
			raiserror('Privacy o podanym id nie istnieje',1,1)
		insert into tblPosts values (DEFAULT,@title,@content,@authorID,@privacyID);
	end try
	begin catch
		select ERROR_MESSAGE() as 'Komunikat'
		return
	end catch
go

-- Execute procedures
exec addLoc '62-654','Leszno','Pakistan','Kantry'
Exec addCategory "hodowla kotów"
Exec addTag koparka,1
Exec addPrivacy Visible,"Visible for all users"
exec addUser 'Dominika','AllahAkhbar','adam@op.pl','1231231','1232',0,'49-654'
exec addUser 'Dominika','AllahAkhbar','horny@op.pl','1231231','1232',0,'49-654'
exec addUser 'Dominika','AllahAkhbar','horny@op.pl','1231231','1232',0,'62-654'
exec addPost 'Tytul Postu','Zawartosc',1,1