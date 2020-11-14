Select  [Name],
		[Description],
		[Configured Value]=[value],
		[Value currently in effect]=value_in_use

  from sys.configurations
  
  where name in 
		('cost threshold for parallelism',
		'max degree of parallelism',
		'min server memory (MB)',
		'max server memory (MB)',
		'default trace enabled',
		'blocked process threshold (s)',
		'remote admin connections',
		'optimize for ad hoc workloads',
		'contained database authentication',
		'xp_cmdshell',
		'cross db ownership chaining',
		'fill factor (%)',
		'recovery interval (min)',
		'show advanced options',
		'remote query timeout (s)',
		'backup checksum default')
Order by name