if object_id('showAdmins','v') is not null
	drop view showAdmins;
go

Create VIEW showAdmins AS
Select name, surname FROM tblUsers WHERE id in (SELECT adminID FROM tblGroups)
go
-- execute view
select * from showAdmins

-- check view
select * from tblGroups
select * from tblUsers