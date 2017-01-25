if object_id('doubleComment','TR') is not null
	drop trigger doubleComment;
go

create trigger doubleComment
on tblComments
after insert
as begin
		if exists(
		select   u.authorID
				from tblComments u INNER JOIN INSERTED i
				on u.authorID = i.authorID and u.postID = i.postID
				GROUP BY u.authorID
				HAVING (count(u.authorID)) > 1
	    )
		begin
			print('Ten post został już przez Ciebie skomentowany')
			rollback
		end

	end
go


-- execute
-- wykonac sekwencyjnie linia po lini (trigger pierwszy)
Select * FROM  tblComments

INSERT INTO tblComments VALUES(DEFAULT,1,3,'Pięknie wyglądasz Januszu w tym szaliku :)')

Select * FROM  tblComments

INSERT INTO tblComments VALUES(DEFAULT,1,3,'i w tej czapce!')