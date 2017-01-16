if OBJECT_ID ('addPost', 'P') is not null
	drop procedure addPost;
go


create procedure addPost
    @title nvarchar(255),
    @content NTEXT,
    @authorID int, --references tblUsers(id),
    @privacyID int, --references tblPrivacy(id)
	@groupTitle nvarchar(255) = 'WALL'
	as
	begin try
		declare @msg varchar(max)
		if @authorID in (select id from tblUsers)
			begin
				if @privacyID in (select id from tblPrivacy)
					begin
						insert into tblPosts values (DEFAULT,@title,@content,@authorID,@privacyID)
						
						DECLARE @ObjectID int
						SET @ObjectID = SCOPE_IDENTITY()

						DECLARE @gID int
						SET @gID = (select id from tblGroups where title=@groupTitle)
						
						insert into tblPostGroups values (@gID,@ObjectID)		
					end
				else
					begin
						set @msg = 'Privacy id: ' + cast(@privacyID as varchar(max))+' nie istnieje'
						raiserror(@msg,1,1)
					end
			end
		else
			begin
				set @msg = 'Uzytkownik z id: '+cast(@authorID as varchar(max))+' nie istnieje'
				raiserror(@msg,1,1)
			end
		return
	end try
	begin catch
		select ERROR_MESSAGE() as 'Komunikat addPost'
	end catch
go

-- addPost check
exec addPost 'Tytul Postu1','Zawartosc1',786,1
exec addPost 'Tytul Postu2','Zawartosc2',1,654
exec addPost 'Tytul Postu3','Zawartosc3',1,1
exec addPost 'Tytul Postu4','Zawartosc4',2,2,'fani gotowania'

