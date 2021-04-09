
IF OBJECT_ID(N'tempdb..#SentEmails') IS NOT NULL
BEGIN
DROP TABLE #SentEmails
END

IF OBJECT_ID(N'tempdb..#UnSentEmails') IS NOT NULL
BEGIN
DROP TABLE #UnSentEmails
END


IF OBJECT_ID(N'tempdb..#DBMailProcess') IS NOT NULL
BEGIN
DROP TABLE #DBMailProcess
END

CREATE TABLE #DBMailProcess
(
    DBProcess VARCHAR(200)
);

IF OBJECT_ID(N'tempdb..#DBMailQueueStatus') IS NOT NULL
BEGIN
DROP TABLE #DBMailQueueStatus
END

CREATE TABLE #DBMailQueueStatus
(
    QueueType VARCHAR(100),
    [Length] BIGINT,
    [State] VARCHAR(200),
    last_Empty_Rowset_Time DATETIME,
    last_activated_time DATETIME
);


IF (SELECT value_in_use
    FROM sys.configurations
    WHERE name LIKE 'Database Mail XPs')=1 
BEGIN


INSERT INTO #DBMailProcess
(
    DBProcess
)
EXECUTE msdb.dbo.sysmail_help_status_sp;
END;

IF (SELECT value_in_use
    FROM sys.configurations
    WHERE name LIKE 'Database Mail XPs')=1 

BEGIN


INSERT INTO #DBMailQueueStatus
(
    QueueType,
    [Length],
    [State],
    last_Empty_Rowset_Time,
    last_activated_time
)
EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'mail';

END;

SELECT COUNT(*) AS [No of Sent Emails],MAX(sent_date) AS [Last Sent At]
INTO #SentEmails
FROM msdb.dbo.sysmail_mailitems
WHERE sent_status=1

SELECT COUNT(*) AS [No of Unsent Emails],MAX(send_request_date) AS [Last Unsent At]
INTO #UnsentEmails
FROM msdb.dbo.sysmail_mailitems
WHERE sent_status=0

SELECT CAST(@@SERVERNAME AS VARCHAR(200)) AS [Server Name],
       CAST(A.value_in_use  AS VARCHAR(200)) AS [DB Mail Enabled],
	   CAST(B.DBProcess  AS VARCHAR(200))  AS [Process],
	   CAST([length] AS VARCHAR(200)) AS [Mail Queue Length],
	   CAST([State]  AS VARCHAR(200)) AS [Mail Process State],
	   [D].[No of Sent Emails],
	   D.[Last Sent At],
	   E.[No of Unsent Emails],
	   E.[Last Unsent At],
	   GETDATE() AS Logdate
FROM
(
    SELECT value_in_use
    FROM sys.configurations
    WHERE name LIKE 'Database Mail XPs'
) A 
FULL OUTER JOIN #DBMailProcess B ON 1=1
FULL OUTER JOIN #DBMailQueueStatus C ON 1=1
FULL OUTER JOIN #SentEmails D ON 1=1
FULL OUTER JOIN #UnSentEmails E ON 1=1

