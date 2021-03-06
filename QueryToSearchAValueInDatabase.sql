--Enter the value you want to search in the database
--In the below script, we are searching for database table\column that has value 'Toyota'.

Declare @SearchValue varchar(200)
Set @SearchValue = 'Toyota';  ---Search Value

Declare @TableName varchar(50)
Declare @ColumnName varchar(50)
Declare @TableSchema varchar(50)
Declare @SQLString nvarchar(max)
 
Drop Table if exists #Output
Drop Table if exists #Test
Create Table #Output ( [Schema] varchar(50),TableName varchar(50),[Column] varchar(50),ColumnValue varchar(2000))

Select Table_Schema as TableSchema,Table_Name as TableName,Column_Name as ColumnName,
       'Select top 1 '''+Table_Schema+''','''+Table_Name+''','''+Column_Name+''','+quotename(Column_Name)+' as [ColumnValue] '+ 
       +' from '+QUOTENAME(Table_Schema)+'.'+QUOTENAME(TABLE_NAME)+ ' (nolock) where '+quotename(Column_Name)+' like ''%'+@SearchValue+'%''' AS [SQLString]
  into #Test
  from INFORMATION_SCHEMA.COLUMNS
 Where Data_Type IN ('char','varchar','text','nchar','nvarchar','ntext')

Declare db_cursor cursor for
Select TableSchema,TableName,ColumnName,[SQLString]
 From #test

Open db_cursor
Fetch next from db_cursor Into @TableSchema,@TableName, @ColumnName,@SQLString

While @@FETCH_STATUS = 0
Begin

Insert Into #Output
Execute sp_executeSQL @SQLString

Fetch next from db_cursor Into @TableSchema,@TableName, @ColumnName,@SQLString
End

Close db_cursor
Deallocate db_cursor

Select * from #Output

 