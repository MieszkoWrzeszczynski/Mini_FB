IF OBJECT_ID ( 'addGroup', 'P' ) IS NOT NULL
    drop procedure addGroup;
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

--addGroup check
exec addGroup 'fani kaczora donalda','lubimy donalda','64-300',1,1,1