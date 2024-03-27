User
Refund_Request
Wallet
Transaction
Story_Read
Story_Follow_Like
Story_Owned
Story
Story_Interaction
Category
Story_Category
Volume
Chapter
Chapter_Owned
Chapter_Liked
Comment
ReportType
ReportContent
Review
Ticket



[dbo].[Story] ([story_id] ,[story_title],
 [author_id], [story_price], [story_sale],
  [story_image], [story_description],
   [story_description_markdown],
    [story_description_html],[create_time]
    , [update_time], [status])
	

[Chapter]([chapter_id],
[chapter_number],[story_id]
,[volume_id],[chapter_price],
[chapter_title],[create_time]
,[update_time],[status],
[chapter_content_html]) 
