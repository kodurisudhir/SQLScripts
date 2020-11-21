--Query to get SSIS package execution metrics based on executionID.

Declare @ExecutionId bigint
Set @ExecutionId = 

Select [Folder_Name],Project_name,package_name,Execution_Path,
       Start_Time,End_Time,Execution_Duration,Execution_Result
  from [Internal].[Executions] A INNER JOIN 
       [Internal].[Executable_statistics] B on A.Execution_id=B.Execution_Id
 where A.Execution_id=@ExecutionId
 Order by Start_time asc
