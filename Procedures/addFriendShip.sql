IF OBJECT_ID ( 'addFriendShip', 'P' ) IS NOT NULL
    drop procedure addFriendShip;
go

-- addFriendShip
create procedure addFriendShip
    @senderID int,
    @receiverID int,
	@relationID int
	as
	begin try
		if not exists (Select * FROM tblUsers WHERE id = @senderID)
			raiserror ('Osoba zapraszająca nie istnieje w bazie danych', 11,1)
		else if not exists (Select * FROM tblUsers WHERE id = @receiverID)
			raiserror ('Osoba zapraszana nie istnieje w bazie', 11,1)
		else if not exists (Select * FROM tblFriendships WHERE senderID = @senderID and receiver = @receiverID)
			raiserror ('Ci użytkownicy są już znajomymi', 11,1)
		else if not exists (Select * FROM tblRelationships WHERE id = @relationID)
			raiserror ('Nie istnieje podany rodzaj znajomości', 11,1)
		else
			INSERT INTO tblFriendships VALUES(@senderID,@receiverID,0,@relationID,0,DEFAULT)
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addFriendShip'
		return
	end catch
go

--addFriendShip check
exec addFriendShip 1,1,1
exec addFriendShip 1,20,1
exec addFriendShip 1,2,13
exec addFriendShip 100,2,13