IF OBJECT_ID ( 'dropCategory', 'P' ) IS NOT NULL
    drop procedure dropCategory;
go


CREATE PROCEDURE dropCategory
    @categorieName NVARCHAR(255)
AS
begin try
    if @categorieName not in (select title from tblCategories)
		begin
			raiserror ('Podana kategoria nie istnieje', 11,1)
		end
	else
        begin
			declare @id int
			set @id = (select id from tblCategories WHERE title = @categorieName )
			DELETE FROM tblCategories WHERE id = @id;
        end
end try
    begin catch
        SELECT ERROR_MESSAGE() AS 'KOMUNIKAT dropCategory'
    end catch
go

--dropCat check
exec addCategory 'testowa kategoria'
SELECT * FROM tblCategories

exec dropCategory 'testowa kategoria'

SELECT * FROM tblCategories

exec dropCategory 'testowa kategoria'