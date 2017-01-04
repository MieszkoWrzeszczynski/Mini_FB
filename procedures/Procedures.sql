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

IF OBJECT_ID ( 'addGroup', 'P' ) IS NOT NULL
    drop procedure addGroup;
go

--Create procedures
CREATE PROCEDURE addCategory
    @categorieName NVARCHAR(255)
AS
begin try
    if @categorieName not in (select title from tblCategories)
		begin
			INSERT INTO tblCategories VALUES(@categorieName)
			print('Dodano Kategorie')
		end
	else
        begin
			declare @msg varchar(max) 
			set @msg = 'Kategoria "' + cast(@categorieName as varchar(max))+'" już istnieje'
			raiserror (@msg, 11,1)
			return
        end
end try
    begin catch
        SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addCategory'
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
				INSERT INTO tblLocations VALUES(@zipCode,@city,@state,@country)
		else
			begin
				declare @msg varchar(max) 
				set @msg = 'Lokalizacja o kodzie pocztowym: ' + cast(@zipCode as varchar(max))+' już istnieje w bazie'
				raiserror (@msg, 11,1)
				return
			end
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addLoc'
	end catch
go

CREATE PROCEDURE addTag
    @tagName NVARCHAR(255),
	@catId int
	as
	begin try
		declare @msg varchar(max) 
		if @tagName not in (select title from tblTags)
			if @catId in (select id from tblCategories)
				INSERT INTO tblTags VALUES(@tagName,@catId)
			else
				begin
					set @msg = 'Podana kategoria nie istnieje: ' + cast(@catId as varchar(max))+' w bazie'
					raiserror (@msg, 11,1)
				end
		else
			begin
				set @msg = 'Tag "' + cast(@tagName as varchar(max))+'" już istnieje w bazie'
				raiserror (@msg, 11,1)
			end
		return
	end try
	begin catch
         SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addTag'
	end catch
go

CREATE PROCEDURE addPrivacy
	@status NVARCHAR(MAX),
	@description NVARCHAR(MAX)
	as
	begin try
		if @status not in (select status from tblPrivacy)
			INSERT INTO tblPrivacy VALUES(@status,@description)
		else
			begin
				declare @msg varchar(max)
				set @msg = 'Status "' + cast(@status as varchar(max))+'" już istnieje w bazie'
				raiserror (@msg, 11,1)
			end
		return
	end try
	begin catch
           SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addPrivacy'
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
		declare @msg varchar(max)
		if @location_ID in (select zipCode from tblLocations)
			if @email not in (select email from tblUsers)
				insert into tblUsers values (@name,@surname,@email,@password,@phone,@gender,DEFAULT,@location_ID)
			else
				begin
					set @msg = 'Istnieje juz uzytkownik z mailem: ' + cast(@email as varchar(max))+' w bazie'
					raiserror (@msg, 11,1)
				end
		else
			begin
				set @msg = 'Brak kodu pocztowego: ' + cast(@location_ID as varchar(max))+' w bazie'
				raiserror (@msg, 11,1)
			end
		return
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addUser'
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
		declare @msg varchar(max)
		if @authorID in (select id from tblUsers)
			begin
				if @privacyID in (select id from tblPrivacy)
					begin
						insert into tblPosts values (DEFAULT,@title,@content,@authorID,@privacyID);
					end
				else
					begin
						set @msg = 'Privacy id: ' + cast(@privacyID as varchar(max))+' nie istnieje'
						raiserror(@msg,1,1)
					end
			end
		else
			begin
				set @msg = 'Uzytkownik z id: '+cast(@authorID as varchar(max))+' nie istnieje'
				raiserror(@msg,1,1)
			end
		return
	end try
	begin catch
		select ERROR_MESSAGE() as 'Komunikat addPost'
	end catch
go

-- the admin will be a user if has more than 10 friends
create procedure addGroup
    @title nvarchar(MAX),
    @content NTEXT,
    @locationId varchar(6),
    @adminId int,
    @privacyID int,
    @catId int
	as
	begin try
	    declare @friendsAmount int
	    set @friendsAmount = (Select  COUNT(*) FROM tblFriendships WHERE senderID=@adminId)
		print @friendsAmount

		if exists ( select * from tblGroups where title=@title)
			raiserror ('Grupa o takiej nazwie już istnieje', 11,1)
		else if not exists ( select * from tblLocations where zipCode=@locationId)
			raiserror ('Podana lokalizacja nie istnieje', 11,1)
		else if not exists ( select * from tblPrivacy where id=@privacyID)
			raiserror ('Podane ustawienie widoczności postów nie istnieje', 11,1)
		else if (@friendsAmount <= 10)
			raiserror ('Użytkownik ma za małą liczbę znajomych aby zostać adminem grupy', 11,1)
		else
			INSERT INTO tblGroups VALUES(@title,@content,@locationId,@adminId,@privacyID,@catId)
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addGroup'
		return
	end catch
go


-- Execute procedures

--addCat check
exec addCategory "hodowla kotów"
exec addCategory "hodowla kotów"

--addLoc
exec addLoc '62-654','Leszno','Pakistan','Kantry'
exec addLoc '62-654','Leszno','Pakistan','Kantry'

--addTag check
exec addTag koparka,1
exec addTag okon,678
exec addTag koparka,1

--addPrivacy check
exec addPrivacy Visible,"Visible for all users"
exec addPrivacy Visible,"Visible for all users"

--addUser check
exec addUser 'Dominika','AllahAkhbar','adam@op.pl','1231231','1232',0,'49-654'
exec addUser 'Dominika','AllahAkhbar','hmery@op.pl','1231231','1232',0,'62-654'
exec addUser 'Dominika','AllahAkhbar','hmery@op.pl','1231231','1232',0,'62-654'

-- addPost check
exec addPost 'Tytul Postu1','Zawartosc1',786,1
exec addPost 'Tytul Postu1','Zawartosc2',1,654
exec addPost 'Tytul Postu3','Zawartosc3',1,1

--addGroup check
exec addGroup 'fani kaczora donalda','lubimy donalda','64-300',1,1,1