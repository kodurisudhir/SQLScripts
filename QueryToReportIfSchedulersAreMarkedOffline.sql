--Query reports any Schedulers that marked as OFFLINE.
select * 
from sys.dm_os_schedulers
where Status='Visible Offline'