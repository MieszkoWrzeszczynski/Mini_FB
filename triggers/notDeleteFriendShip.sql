if object_id('notDeleteFriendShip','TR') is not null
	drop trigger notDeleteFriendShip;
go

create trigger notDeleteFriendShip
on tblFriendships
instead of delete
as
	begin
		Update tblFriendships
		set tblFriendships.relationID = 3 -- id = 3 it means -> 'byli znajomi'
		FROM deleted d
		where d.id = tblFriendships.id
	end

go

-- execute
Select * FROM  tblFriendships  WHERE id = 2
DELETE FROM tblFriendships  WHERE id = 2
Select * FROM  tblFriendships  WHERE id = 2
