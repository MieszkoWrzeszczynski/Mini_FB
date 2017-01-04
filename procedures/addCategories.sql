IF OBJECT_ID ( 'addCategory', 'P' ) IS NOT NULL
    drop procedure addCategory;
go

CREATE PROCEDURE addCategory
        @categorieName NVARCHAR(255)
AS
begin try
    if exists (select * from tblCategories where title=@categorieName)
		  raiserror ('Taki projekt już istnieje', 11,1)
	else
        begin
			INSERT INTO tblCategories VALUES(@categorieName)
        end
end try
    begin catch
        SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
    end catch
go

Exec addCategory "hodowla kotów"

SELECT * FROM tblCategories;