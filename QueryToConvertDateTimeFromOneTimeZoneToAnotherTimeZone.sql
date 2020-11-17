CREATE OR ALTER FUNCTION dbo.udf_ConvertTimeZone
( 
    @InputDateTime DATETIME2(7),
    @InputTimeZone VARCHAR(50),
	@OutputTimeZone VARCHAR(50)
)
RETURNS VARCHAR(100)
AS
BEGIN
 	  DECLARE @ResultEnterDate VARCHAR(100) = 'Enter valid time zone. Please refer sys.time_zone_info table for valid time zones.'
	  DECLARE @ValidInputTimeZone BIT = 1;
	  DECLARE @ValidOutputTimeZone BIT = 1;

	  IF NOT EXISTS (SELECT 1 FROM sys.time_zone_info WHERE [Name] = @InputTimeZone)
	  BEGIN
	  SELECT @ValidInputTimeZone=0;
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.time_zone_info WHERE [Name] = @OutputTimeZone)
	  BEGIN
	  SELECT @ValidOutputTimeZone=0;
	  END

      IF (@ValidInputTimeZone=1 and @ValidOutputTimeZone=1)
	  BEGIN
      SELECT @ResultEnterDate = CAST(@InputDateTime as DATETIME2(7)) AT TIME ZONE @InputTimeZone AT TIME ZONE @OutputTimeZone
      END

	  RETURN @ResultEnterDate

END
GO
/*
The first parameter is the input datetime that needs to be converted.
The second parameter is the time zone to which the input falls under.
The third parameter is the time zone into which the input will be converted.
*/
Select dbo.udf_ConvertTimeZone('2020-02-26 16:28:36','UTC','Eastern Standard Time') as [DateTime In EST]

Select dbo.udf_ConvertTimeZone('2020-12-16 04:22:27','UTC','Central Standard Time') as [DateTime In CST]


