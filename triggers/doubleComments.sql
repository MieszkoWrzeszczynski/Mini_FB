if object_id('doubleComment','TR') is not null
	drop trigger doubleComment;
go

create trigger doubleComment
on tblComments
after insert
as begin
		if exists(
			select authorID
			from tblComments
		)
		begin
			print('Ten post został już przez Ciebie skomentowany')
			rollback
		end

	end
go


-- execute
Select * FROM  tblComments

INSERT INTO tblComments VALUES(DEFAULT,1,3,'Pięknie wyglądasz Januszu w tym szaliku :)'),
(DEFAULT,1,3,'i w tej czapce!')

Select * FROM  tblComments