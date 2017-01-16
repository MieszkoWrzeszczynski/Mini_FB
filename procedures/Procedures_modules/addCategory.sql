IF OBJECT_ID ( 'addCategory', 'P' ) IS NOT NULL
    drop procedure addCategory;
go


CREATE PROCEDURE addCategory
    @categorieName NVARCHAR(255)
AS
begin try
    if @categorieName not in (select title from tblCategories)
		begin
			INSERT INTO tblCategories VALUES(@categorieName)
			print('Dodano Kategorie')
		end
	else
        begin
			declare @msg varchar(max) 
			set @msg = 'Kategoria "' + cast(@categorieName as varchar(max))+'" już istnieje'
			raiserror (@msg, 11,1)
			return
        end
end try
    begin catch
        SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addCategory'
    end catch
go

--addCat check
exec addCategory "hodowla kotów"
exec addCategory "hodowla kotów"
