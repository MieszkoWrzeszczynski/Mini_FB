IF OBJECT_ID ( 'addUser', 'P' ) IS NOT NULL
    drop procedure addUser;
go

create procedure addUser
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


--addUser check
exec addUser 'Dominika','Jassem','adam@op.pl','1231231','1232',0,'49-654'
exec addUser 'Dominika','Jassem','hmery@op.pl','1231231','1232',0,'66-400'
exec addUser 'Dominika','Jassem','hmery@op.pl','1231231','1232',0,'66-400'
