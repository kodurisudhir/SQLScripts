-- Query to find Errors in Database Mail.
Declare @Logdate datetime  = DateAdd(day,-1,getdate())

;WITH Cte as (Select MailItem_id,Max(log_date) as [LogDate]
                from msdb.dbo.sysmail_event_log B
	       where Log_date>@Logdate
               group by MailItem_id)

Select A.MailItem_id,B.[Description] as [Error],C.Subject as [Mail Subject],C.Recipients as [Mail Recipients],Logdate
  from Cte A INNER JOIN
       msdb.dbo.sysmail_event_log B on A.MailItem_id=B.MailItem_id and A.LogDate=B.Log_Date INNER JOIN
       msdb.dbo.sysmail_faileditems C on C.MailItem_id=B.MailItem_id

