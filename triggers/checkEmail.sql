if object_id('checkEmail','TR') is not null
	drop trigger checkEmail;
go

create trigger checkEmail
on tblUsers
after update
as begin
	if update(email)
		begin
			if exists(
				select *
				from tblUsers u INNER JOIN Inserted i
				on u.email = i.email
				where u.id <> i.id
				)
				begin
					print('Podany mail jest już zajęty')
					rollback
					
				end
			else if exists(
				select *
				from deleted u INNER JOIN Inserted i
				on u.email = i.email
				where u.id = i.id
				)
				begin
					print('Podałeś ten sam adres mail')
					rollback
					
				end
			else
				print('Mail został zmieniony')
					
		end
	end
go


-- execute
Select * FROM  tblUsers

UPDATE tblUsers SET email = 'adam@op.pl'  WHERE id = 2
UPDATE tblUsers SET email = 'adam@op.pl'  WHERE id = 3
UPDATE tblUsers SET email = 'nowymail@op.pl'  WHERE id = 2



Select * FROM  tblUsers
