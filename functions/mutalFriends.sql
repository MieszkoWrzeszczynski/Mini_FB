IF object_id(N'mutalFriends', N'TF') IS NOT NULL
    DROP FUNCTION mutalFriends
GO

create function mutalFriends(@friendOne int, @friendTwo int)
	returns @arr table( imie nvarchar(50), nazwisko nvarchar(50))
as
begin

	

(select A.senderID as 'AS', A.receiver as 'AR' from tblFriendships A
where A.senderID=2 or A.receiver=2 or A.senderID=1 or A.receiver=1)
	
	
	
	
	
	
	
	
	/*
	declare @i int
	declare kur1 scroll cursor for (select id from tblFriendships where senderID=2 or receiver=2)
	open kur1
	fetch next from kur1 into @i
	while @@FETCH_STATUS=0
		begin
			print @i
		fetch next from kur1 into @i
		end
	close kur1
	deallocate kur1 
	*/








	insert into @arr
	select * from tblCategories--tmp

return
end