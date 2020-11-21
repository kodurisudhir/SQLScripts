--Query to get batch requests per second.
Declare @IntervalValue1 bigint
Declare @IntervalValue2 bigint

select @IntervalValue1=cntr_value 
  from sys.dm_os_performance_counters 
  where counter_name like '%batch%request%sec%'

Waitfor Delay '00:00:10'

select @IntervalValue2=cntr_value 
  from sys.dm_os_performance_counters 
 where counter_name like '%batch%request%sec%'

select @@SERVERNAME as [ServerName],(@IntervalValue2-@IntervalValue1)/10 as [Batch Requests per Second],GetDate() as LogDate