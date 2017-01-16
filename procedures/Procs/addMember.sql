IF OBJECT_ID ( 'addMember', 'P' ) IS NOT NULL
    drop procedure addMember;
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

--addMember check
exec addMember 'fani gotowania','adam@op.pl'
exec addMember 'fani gotowan1ia','adam@op.pl'
exec addMember 'fani gotowania','adam@o1p.pl'