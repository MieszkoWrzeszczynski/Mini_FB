IF OBJECT_ID ( 'addLoc', 'P' ) IS NOT NULL
    drop procedure addLoc;
go

CREATE proc addLoc
	@zipCode char(6),
    @city nvarchar(50),
    @state nvarchar(50),
    @country nvarchar(30)
	as
	begin try
		if @zipCode not in (select zipCode from tblLocations)
				INSERT INTO tblLocations VALUES(@zipCode,@city,@state,@country)
		else
			begin
				declare @msg varchar(max)
				set @msg = 'Lokalizacja o kodzie pocztowym: ' + cast(@zipCode as varchar(max))+' już istnieje w bazie'
				raiserror (@msg, 11,1)
				return
			end
	end try
	begin catch
		SELECT ERROR_MESSAGE() AS 'KOMUNIKAT addLoc'
	end catch
go

--addLoc -- wykonaj sekwencyjnie
exec addLoc '62-654','Leszno','Pakistan','Kantry'
exec addLoc '62-654','Leszno','Pakistan','Kantry'