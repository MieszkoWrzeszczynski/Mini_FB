IF OBJECT_ID ( 'addTag', 'P' ) IS NOT NULL
    drop procedure addTag;
go

CREATE PROCEDURE addTag
    @tagName NVARCHAR(255),
	@catId int
	as
	begin try
		declare @msg varchar(max) 
		if @tagName not in (select title from tblTags)
			if @catId in (select id from tblCategories)
				INSERT INTO tblTags VALUES(@tagName,@catId)
			else
				begin
					set @msg = 'Podana kategoria nie istnieje: ' + cast(@catId as varchar(max))+' w bazie'
					raiserror (@msg, 11,1)
					return
				end
		else
			begin
				set @msg = 'Tag "' + cast(@tagName as varchar(max))+'" już istnieje w bazie'
				raiserror (@msg, 11,1)
				return
			end
		return
	end try
	begin catch
         SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addTag'
	end catch
go

--addTag check
exec addTag koparka,1
exec addTag okon,678
exec addTag koparka,1