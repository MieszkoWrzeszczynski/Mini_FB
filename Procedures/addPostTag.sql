IF OBJECT_ID ( 'addPostTag', 'P' ) IS NOT NULL
    drop procedure addPostTag;
go

create procedure addPostTag
    @new_postId int,
	@new_tagId int
	as
	begin try
	   	declare @postIdToCheck int
	    set @postIdToCheck = (Select id FROM tblPosts WHERE id=@new_postId)

		declare @tagIdToCheck int
	    set @tagIdToCheck = (Select id FROM tblTags WHERE id=@new_tagId)

		if @postIdToCheck is NULL
			raiserror ('Post o takim id nie istnieje', 11,1)
		else if @tagIdToCheck is NULL
			raiserror ('Podany tag nie istnieje', 11,1)
		else if exists (Select id FROM tblPostTags WHERE tagID=@new_tagId)
			raiserror ('Podany tag już istnieje w bazie', 11,1)
		else
			INSERT INTO tblPostTags VALUES(@new_postId,@new_tagId)
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addPostTags'
		return
	end catch
go

-- addPostTag
exec addPostTag 100,1
exec addPostTag 1,10
exec addPostTag 1,1