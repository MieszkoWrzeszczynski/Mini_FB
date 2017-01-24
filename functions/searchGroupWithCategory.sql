IF object_id(N'searchGroupWithCategory', N'TF') IS NOT NULL
    DROP FUNCTION searchGroupWithCategory
GO

create function searchGroupWithCategory
        (@category varchar(MAX))
        returns @Groups table
                (id int ,title nvarchar(255) , content NTEXT)
as
begin
        declare @catID int
		set @catID = (select id from tblCategories WHERE title = @category)

		insert into @Groups
        select id, title, content from tblGroups where catID in (@catID)
return
end

go

-- wywolanie:
select * from searchGroupWithCategory('kuchnia')
select * from searchGroupWithCategory('motoryzacja')
