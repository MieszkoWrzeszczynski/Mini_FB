if OBJECT_ID ('addComments', 'P') is not null
	drop procedure addComments;
go

create procedure addComments
	@pID int,
	@uID int,
	@cont nvarchar(max)
	as
	begin try
		declare @msg varchar(max)
		if @pID in (select id from tblPosts)
			begin					
				if @uID in (select id from tblUsers)
					begin
						insert into tblComments values (DEFAULT,@pID,@uID,@cont);
					end				
				else
					begin
						set @msg = 'Uzytkownik z id: '+cast(@uID as varchar(max))+' nie istnieje'
						raiserror(@msg,1,1)
						return
					end
			end
		else
			begin
					set @msg = 'Post z id: '+cast(@pID as varchar(max))+' nie istnieje'
					raiserror(@msg,1,1)
					return
			end		
	end try
	begin catch
		select ERROR_MESSAGE() as 'Komunikat addComments'
	end catch
go

--addComments check
exec addComments 1,1,'Komentarz wprowadzony z klawiatury'
exec addComments 4000,1,'Komentarz wprowadzony z klawiatury'
exec addComments 1,4000,'Komentarz wprowadzony z klawiatury'

