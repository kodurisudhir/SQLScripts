---List all backups taken in the last 7 days
Select A.database_name as [DB Name],
       A.backup_start_date as [Backup Start Date],
       A.backup_finish_date as [Backup Finish Date], 
       DateDiff(minute,A.backup_start_date,A.backup_finish_date) as [Time Taken in Minutes],
       Case Type when 'D' then 'Full' 
	         when 'L' then 'Log' 
	         when 'I' then 'Differential' else Type end as [Backup Type],
       Cast(compressed_backup_size/1073741824.00 as decimal(30,3)) as [Compressed Backup Size in MBytes],
       STUFF((Select ','+physical_device_name
	        from msdb.dbo.backupmediafamily B
	       where A.media_set_id=B.media_set_id Order by family_sequence_number
		 FOR XML PATH('')),1,1,'') as [Backup Location]
  from msdb.dbo.backupset A
 Where is_snapshot=0 and
       backup_start_date>=DateAdd(Day,-7,cast(getdate() as date))