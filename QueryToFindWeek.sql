--This query returns work week range between date ranges. Holidays are not excluded. Only Saturday and Sunday are excluded.
Declare @BeginDate date = '01/01/2019';
Declare @EndDate date = '12/31/2020';

WITH CTE as (Select   @BeginDate AS [Date]
               union all
              Select  DATEADD(DAY, 1, [Date])
                from  CTE
               where  [Date] < @EndDate )
   ,CTE2 as (Select [Date],DATEPART(WEEK,Date) as WeekNo
               from CTE 
              Where DATENAME(WEEKDAY,[Date]) not in ('Saturday','Sunday'))

  Select FORMAT(MIN([Date]),'dd MMM yyyy') +' - '+FORMAT(MAX([Date]),'dd MMM yyyy') as [Week Day Range], Concat('Week - ',WeekNo) as WeekNo
    from CTE2
Group by Year([Date]),WeekNo
Order by Year([Date]),cast(WeekNo as int)
  Option (MAXRECURSION 0)