---List all backups taken in the last 7 days
Select A.database_name,A.backup_start_date,A.backup_finish_date, DateDiff(minute,A.backup_start_date,A.backup_finish_date) as [BackupTime_In_Minutes],
       Case Type when 'D' then 'Full' 
	             when 'L' then 'Log' 
				 when 'I' then 'Differential' else Type end as [Backup Type],
	   physical_device_name as [Backup Location],
	   compressed_backup_size as [CompressedBackupSize]
  from msdb.dbo.backupset A INNER JOIN
       msdb.dbo.backupmediafamily B on A.media_set_id=B.media_set_id
 Where is_snapshot=0 and
       backup_start_date>=DateAdd(Day,-7,cast(getdate() as date))

