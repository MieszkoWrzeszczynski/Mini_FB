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
						insert into tblPosts values (DEFAULT,@title,@content,@authorID,@privacyID);
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
exec addPost 'Tytul Postu1','Zawartosc2',1,654
exec addPost 'Tytul Postu3','Zawartosc3',1,1
