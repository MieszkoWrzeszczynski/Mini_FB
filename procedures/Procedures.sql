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

IF OBJECT_ID ( 'addMember', 'P' ) IS NOT NULL
    drop procedure addMember;
go

IF OBJECT_ID ( 'addPost', 'P' ) IS NOT NULL
    drop procedure addPost;
go

IF OBJECT_ID ( 'addPostTag', 'P' ) IS NOT NULL
    drop procedure addPostTag;
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
					return
				end
		else
			begin
				set @msg = 'Tag "' + cast(@tagName as varchar(max))+'" już istnieje w bazie'
				raiserror (@msg, 11,1)
				return
			end
		return
	end try
	begin catch
         SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addTag'
	end catch
go


--add PostTag
create proc addPostTag
    @new_postId int,
	@new_tagId int
	as
	begin try
	   	declare @postIdToCheck int
	    set @postIdToCheck = (Select id FROM tblPosts WHERE id=@new_postId)

		declare @tagIdToCheck int
	    set @tagIdToCheck = (Select id FROM tblTags WHERE id=@new_tagId)

		if @postIdToCheck is NULL
			raiserror ('Post o takim id nie istnieje', 11,1)
		else if @tagIdToCheck is NULL
			raiserror ('Podany tag nie istnieje', 11,1)
		else if exists (Select id FROM tblPostTags WHERE tagID=@new_tagId)
			raiserror ('Podany tag już istnieje w bazie', 11,1)
		else
			INSERT INTO tblPostTags VALUES(@new_postId,@new_tagId)
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addPostTags'
		return
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
    @privacyID int, --references tblPrivacy(id)
	@groupTitle nvarchar(255) = 'WALL'
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

create procedure addComments
	@pID int,
	@uID int,
	@cont nvarchar(max)
	as
	begin try
		declare @msg varchar(max)
		if @pID in (select id from tblPosts)
			begin					
				if @uID in (select id from tblUsers)
					begin
						insert into tblComments values (DEFAULT,@pID,@uID,@cont);
					end				
				else
					begin
						set @msg = 'Uzytkownik z id: '+cast(@uID as varchar(max))+' nie istnieje'
						raiserror(@msg,1,1)
						return
					end
			end
		else
			begin
					set @msg = 'Post z id: '+cast(@pID as varchar(max))+' nie istnieje'
					raiserror(@msg,1,1)
					return
			end










		
	end try
	begin catch
		select ERROR_MESSAGE() as 'Komunikat addComments'
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

-- add Member
create procedure addMember
    @groupName nvarchar(MAX),
    @email nvarchar(MAX)
	as
	begin try
	    declare @groupID int
	    set @groupID = (Select id FROM tblGroups WHERE title=@groupName)

		declare @userID int
	    set @userID = (Select id FROM tblUsers WHERE email=@email)


		if @groupID IS NULL
			raiserror ('Grupa o takiej nazwie nie istnieje', 11,1)
		else if @userID IS NULL
			raiserror ('Użytkownik o takiej nazwie nie istnieje', 11,1)
		else if exists (Select * FROM tblMembers WHERE memberID=@userID)
			raiserror ('Użytkownik o takiej nazwie już został dodany do grupy', 11,1)
		else
			INSERT INTO tblMembers VALUES(@userID,@groupID)
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addMember'
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


--addPost check
exec addComments 1,1,'Komentarz wprowadzony z klawiatury'
exec addComments 4000,1,'Komentarz wprowadzony z klawiatury'
exec addComments 1,4000,'Komentarz wprowadzony z klawiatury'

--addMember check
exec addMember 'fani gotowania','adam@op.pl'
exec addMember 'fani gotowan1ia','adam@op.pl'
exec addMember 'fani gotowania','adam@o1p.pl'

-- addPostTag
exec addPostTag 100,1
exec addPostTag 1,10
exec addPostTag 1,1

-- to do : spytaj anki czy return musi byc po raise error w procedurze
