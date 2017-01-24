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

		declare @postsID int
        set @postsID = (select postID from tblPostTags where tagID in (@tagID))

		insert into @posts
		select id,title,content from tblPosts where id in (@postsID)
return
end

go

-- wywolanie:
select * from searchPostsWithTag('zupa')
select * from searchPostsWithTag('C++')
