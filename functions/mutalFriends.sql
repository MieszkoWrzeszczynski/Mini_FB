IF object_id(N'mutalFriends', N'TF') IS NOT NULL
    DROP FUNCTION mutalFriends
go
create function mutalFriends(@usr1 int, @usr2 int)
	returns @arr table( id int, imie nvarchar(50), nazwisko nvarchar(50))
as
begin

	insert into @arr
	select id,name,surname
	from tblUsers
	where id in	
				(
				select receiver 
				from tblFriendships
				where senderID=@usr1
				union
				select senderID 
				from tblFriendships
				where receiver=@usr1
				)
			and
		id in
				(
				select receiver 
				from tblFriendships
				where senderID=@usr2
				union
				select senderID 
				from tblFriendships
				where receiver=@usr2
				)

return
end
go

--1 check
select * from mutalFriends(2,1)
select count(*) from mutalFriends(2,1)

select * from mutalFriends(1,2)
select count(*) as 'mutal friends count' from mutalFriends(1,2)

--2 check
select * from mutalFriends(1,11)
select * from mutalFriends(11,2)

--3 should be epty
select * from mutalFriends(13,11)

--All your freinds
select * from mutalFriends(1,1)




