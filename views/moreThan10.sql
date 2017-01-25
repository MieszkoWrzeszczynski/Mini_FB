if object_id('moreThan10','v') is not null
	drop view moreThan10;
go


Create VIEW moreThan10
AS

select id, sum(counter) as 'counter'
	from
		(
		select senderID as 'id', count(senderID) as 'counter'
		from tblFriendships
		group by senderID
		union
		select receiver as 'id', count(receiver) as 'counter'
		from tblFriendships
		group by receiver
		) as t
		group by id
		having sum(counter) >= 10
go

-- execute view
select * from moreThan10

-- check view
select * from tblFriendships
