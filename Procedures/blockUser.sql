IF OBJECT_ID ( 'blockUser', 'P' ) IS NOT NULL
    drop procedure blockUser;
go


CREATE PROCEDURE blockUser
    @blocker_email NVARCHAR(255),
	@receiver_email NVARCHAR(255)

AS
begin try
    if (@blocker_email not in (select email from tblUsers)) or (@receiver_email not in (select email from tblUsers))
		begin
			raiserror ('Użytkownik o podanym emailu nie istnieje', 11,1)
		end
	else
        begin
			declare @bl_id int
			set @bl_id = (select id from tblUsers WHERE email = @blocker_email)

			declare @re_id int
			set @re_id = (select id from tblUsers WHERE email = @receiver_email)

			UPDATE tblFriendships SET blocked = 1 WHERE senderID = @bl_id and receiver = @re_id
        end
end try
    begin catch
        SELECT ERROR_MESSAGE() AS 'KOMUNIKAT blockUser'
    end catch
go

--blockUser check
exec blockUser 'mieszko1bor@op.pl','adam@op.pl'
SELECT * FROM tblFriendships

exec blockUser 'mieszkobor@op.pl','adam@op.pl'
SELECT * FROM tblFriendships