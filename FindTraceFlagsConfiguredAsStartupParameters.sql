--TSQL way to find trace flags configured as startup parameters
Select * from sys.dm_server_registry where Value_name like 'SQLArg%' and cast(value_data as varchar) like '-T%'