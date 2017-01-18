if object_id('checkEmail','TR') is not null
	drop trigger checkEmail;
go

create trigger checkEmail
on tblUsers
for update
as
			IF EXISTS
			( select u.email
			FROM tblUsers u, inserted i
			Where u.email = i.email
			)
	
			begin
			print('Taki email istnieje już w bazie');
			rollback
			--Update tblUsers
			--set email = d.email
			--FROM deleted d
			--where d.id = tblUsers.id

		end
go


-- execute
Select * FROM  tblUsers
UPDATE tblUsers SET email = 'synzyaagmu1nta@op.pl'  WHERE id = 4
Select * FROM  tblUsers
