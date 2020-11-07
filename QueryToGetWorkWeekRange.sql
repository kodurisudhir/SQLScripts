--This query returns work week range between a date range. Holidays are not excluded. Only Saturday and Sunday are excluded.
Declare @BeginDate date = '01/01/2019';
Declare @EndDate date = '12/31/2020';

WITH CTE as (Select   @BeginDate AS [Date]
               union all
              Select  DateAdd(DAY, 1, [Date])
                from  CTE
               where  [Date] < @EndDate )
   ,CTE2 as (Select [Date],DatePart(Week,[Date]) as WeekNo
               from CTE 
              Where DateName(WeekDay,[Date]) not in ('Saturday','Sunday'))

  Select Format(Min([Date]),'dd MMM yyyy') +' - '+Format(Max([Date]),'dd MMM yyyy') as [Week Day Range], Concat('Week - ',WeekNo) as WeekNo
    from CTE2
Group by Year([Date]),WeekNo
Order by Year([Date]),Cast(WeekNo as int)
  Option (MAXRECURSION 0)