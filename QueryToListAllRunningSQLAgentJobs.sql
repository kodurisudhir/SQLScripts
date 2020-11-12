--List all running SQL Agent jobs.
Select @@SERVERNAME as [DBServer],
       C.Name as [JobName], 
	   run_requested_date,
	   start_execution_date,
	   stop_execution_date
  from (Select max(Session_id) as Session_Id from msdb.dbo.syssessions) A INNER JOIN 
       msdb.dbo.sysjobactivity B on A.Session_id=B.Session_ID INNER JOIN 
       msdb.dbo.sysjobs C on B.job_id=C.Job_ID
 where B.stop_execution_date is null AND 
       B.run_requested_date is not null