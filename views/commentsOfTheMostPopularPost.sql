if object_id('commentsOfTheMostPopularPost','v') is not null
	drop view commentsOfTheMostPopularPost;
go

Create VIEW commentsOfTheMostPopularPost
AS
Select content FROM tblComments Where postID in
(SELECT TOP 1 postID FROM tblComments GROUP BY postID ORDER BY count(postID) DESC);
go

-- execute view
select * from commentsOfTheMostPopularPost

-- check view
select * from tblPosts
select * from tblComments