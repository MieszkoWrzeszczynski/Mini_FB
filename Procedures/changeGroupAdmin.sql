IF OBJECT_ID ( 'changeGroupAdmin', 'P' ) IS NOT NULL
    drop procedure changeGroupAdmin;
go

CREATE PROCEDURE changeGroupAdmin
    @admin_email NVARCHAR(255),
	@Group_id int
AS
begin try
	declare @admin_id int
	set @admin_id = (select id from tblUsers WHERE email = @admin_email)

    if @admin_id is NULL
		begin
			raiserror ('Nie istnieje taki użytkownik', 11,1)
			return
		end
	else if @Group_id not in (select id FROM tblGroups where id = @Group_id)
        begin
			raiserror ('Nie istnieje grupa o podanym ID', 11,1)
			return
        end
	else if @admin_id in (select adminID FROM tblGroups where adminID = @admin_id)
		begin
			raiserror ('Ten użytkownik jest już adminem tej grupy', 11,1)
			return
		end
	else
		begin
			UPDATE tblGroups SET adminID = @admin_id WHERE id = @Group_id
		end
end try
    begin catch
        SELECT ERROR_MESSAGE() AS 'KOMUNIKAT changeGroupAdmin'
    end catch
go

--changeGroupAdmin check
SELECT * FROM tblGroups;
exec changeGroupAdmin 'synzygmunta@wp.pl',1
SELECT * FROM tblGroups;

--changeGroupAdmin check
SELECT * FROM tblGroups;
exec changeGroupAdmin 'synzygmun1ta@wp.pl',1
SELECT * FROM tblGroups;
