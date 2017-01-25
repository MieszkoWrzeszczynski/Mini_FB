IF OBJECT_ID ( 'dropUser', 'P' ) IS NOT NULL
    drop procedure dropUser;
go


CREATE PROCEDURE dropUser
    @userEmail NVARCHAR(255)
AS
begin try
    if @userEmail not in (select email from tblUsers)
		begin
			raiserror ('Użytkownik o podanym emailu nie istnieje', 11,1)
		end
	else
        begin
			declare @id int
			set @id = (select id from tblUsers WHERE email = @userEmail )
			DELETE FROM tblUsers WHERE id = @id;
        end
end try
    begin catch
        SELECT ERROR_MESSAGE() AS 'KOMUNIKAT dropUser'
    end catch
go

--dropUser check
exec addUser 'Dominika','AllahAkhbar','adam1@op.pl','1231231','1232',0,'63-300'

SELECT * FROM tblUsers

exec dropUser 'adam1@op.pl'

SELECT * FROM tblUsers

exec dropUser 'adam1@op.pl'