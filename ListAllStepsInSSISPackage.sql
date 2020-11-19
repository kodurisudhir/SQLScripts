Declare @ProjectName Varchar(200)
Declare @PackageName Varchar(200)

--Enter ssis project and package name.
Set @ProjectName=''
Set @PackageName=''

;With CTE as (Select Max(package_id) over (partition by C.Project_id,C.[name]) as LatestPackageId,Package_id,
                      A.name as [FolderName],B.name as [ProjectName],C.name as [PackageName],D.executable_name as ExecutableName,D.Executable_id 
                from [ssisdb].[Internal].[folders] A INNER JOIN 
                 	 [ssisdb].[Internal].[projects] B ON A.folder_id=B.folder_id INNER JOIN 
	                 [ssisdb].[Internal].[packages] C on C.project_id=B.project_id INNER JOIN 
	                 [ssisdb].[internal].[executables] D on B.project_id=D.project_id and C.[Name]=D.Package_Name
               where B.[Name]=@ProjectName and 
			         C.[Name]=@PackageName and
                     D.Package_path not like '\Package')

Select FolderName,ProjectName,PackageName,ExecutableName
  from CTE where [LatestPackageId]=Package_id
Order by Executable_id asc
