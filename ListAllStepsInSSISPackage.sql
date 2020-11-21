Declare @ProjectName Varchar(200)
Declare @PackageName Varchar(200)

--Enter ssis project and package name.
Set @ProjectName=''
Set @PackageName=''

;With CTE as (Select Max(package_id) over (partition by C.Project_id,C.[name]) as LatestPackageId,Package_id,
                     A.[Name] as [FolderName],B.[Name] as [ProjectName],C.[Name] as [PackageName],
					 D.executable_name as ExecutableName,D.Executable_id,Package_path as PackagePath
                from [SSISDB].[Internal].[Folders] A INNER JOIN 
                 	 [SSISDB].[Internal].[Projects] B ON A.folder_id=B.folder_id INNER JOIN 
	                 [SSISDB].[Internal].[Packages] C ON C.project_id=B.project_id INNER JOIN 
	                 [SSISDB].[Internal].[Executables] D ON B.project_id=D.project_id and C.[Name]=D.Package_Name and B.object_version_lsn=D.project_version_lsn
               where B.[Name]=@ProjectName
			         and C.[Name]=@PackageName
                     and D.Package_path not like '\Package')

Select FolderName,ProjectName,PackageName,ExecutableName,PackagePath
  from CTE 
 where [LatestPackageId]=Package_id
Order by Executable_id asc

