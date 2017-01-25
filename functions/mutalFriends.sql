IF object_id(N'mutalFriends', N'TF') IS NOT NULL
    DROP FUNCTION mutalFriends
go
create function mutalFriends(@usr1 int, @usr2 int)
	returns @arr table( id int, imie nvarchar(50), nazwisko nvarchar(50))
as
begin

	--declare @usr1 int, @usr2 int
	--set @usr1 = 1
	--set @usr2 = 2

	insert into @arr
	select u.id, u.name, u.surname from tblUsers u
	where id in (
					select t.id from (
								select A.receiver as 'id'
								from tblFriendships A where A.senderID=@usr1
								union
								select B.senderID
								from tblFriendships B where B.receiver=@usr1
								union
								select A.receiver
								from tblFriendships A where A.senderID=@usr2
								union
								select B.senderID
								from tblFriendships B where B.receiver=@usr2
							) as t where t.id not in (@usr1,@usr2)
				)
return
end
go

--select * from mutalFriends(1,2)

--select * from mutalFriends(2,1)

select * from mutalFriends(12,17)

