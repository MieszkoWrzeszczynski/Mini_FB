IF object_id(N'searchPostsWithTag', N'TF') IS NOT NULL
    DROP FUNCTION searchPostsWithTag
GO

create function searchPostsWithTag
        (@tag varchar(MAX))
        returns @posts table
                (id int ,title nvarchar(255) , content NTEXT)
as
begin
        declare @tagID int
		set @tagID = (select id from tblTags WHERE title = @tag)

		DECLARE @postsID TABLE
			(
			  id int
			)

        INSERT INTO @postsID  select postID from tblPostTags where tagID = @tagID

		insert into @posts
		select id,title,content from tblPosts where id in (Select id FROM @postsID )
return
end

go

-- wywolanie:
select * from searchPostsWithTag('zupa')
select * from searchPostsWithTag('C++')