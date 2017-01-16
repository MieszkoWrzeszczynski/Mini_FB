IF OBJECT_ID ( 'addPrivacy', 'P' ) IS NOT NULL
    drop procedure addPrivacy;
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

--addPrivacy check
exec addPrivacy Visible,"Visible for all users"
exec addPrivacy Visible,"Visible for all users"