--Query reports any schedulers that are marked as OFFLINE.
select * 
from sys.dm_os_schedulers
where Status='Visible Offline'