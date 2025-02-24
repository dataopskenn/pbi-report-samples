let
    // Define the start and end dates
    StartDate = #date(2018, 1, 1),
    EndDate = DateTime.Date(DateTime.LocalNow()),
    // Calculate the number of days between the start and end dates
    NumberOfDays = Duration.Days(EndDate - StartDate) + 1,
    // Generate a list of dates
    DateList = List.Dates(StartDate, NumberOfDays, #duration(1,0,0,0)),
    // Convert the list into a table
    DateTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
    // Add Year column
    AddYear = Table.AddColumn(DateTable, "Year", each Date.Year([Date]), Int16.Type),
    // Add Month Number column
    AddMonthNumber = Table.AddColumn(AddYear, "Month Number", each Date.Month([Date]), Int8.Type),
    // Add Month Name column
    AddMonthName = Table.AddColumn(AddMonthNumber, "Month Name", each Date.ToText([Date], "MMMM"), type text),
    // Add End of Month column
    AddEndOfMonth = Table.AddColumn(AddMonthName, "End of Month", each Date.EndOfMonth([Date]), type date),
    // Add Quarter column
    AddQuarter = Table.AddColumn(AddEndOfMonth, "Quarter", each "Q" & Number.ToText(Date.QuarterOfYear([Date])), type text),
    // Add Quarter Name column
    AddQuarterName = Table.AddColumn(AddQuarter, "Quarter Name", each "Q" & Number.ToText(Date.QuarterOfYear([Date])) & " " & Date.ToText([Date], "yyyy"), type text),
    // Add Quarter Num column
    AddQuarterNum = Table.AddColumn(AddQuarterName, "Quarter Num", each (Date.Year([Date]) * 100) + Date.QuarterOfYear([Date]), Int16.Type),
    // Add Day of Week Number column (Monday=1, Sunday=7)
    AddDayOfWeekNumber = Table.AddColumn(AddQuarterNum, "Day of Week Number", each Date.DayOfWeek([Date], Day.Monday) + 1, Int8.Type),
    // Add Day of Week Name column
    AddDayOfWeekName = Table.AddColumn(AddDayOfWeekNumber, "Day of Week Name", each Date.ToText([Date], "dddd"), type text),
    // Add Week Number column
    AddWeekNumber = Table.AddColumn(AddDayOfWeekName, "Week Number", each Date.WeekOfYear([Date]), Int16.Type),
    // Add Month-Year column
    AddMonthYear = Table.AddColumn(AddWeekNumber, "Month-Year", each Date.ToText([Date], "MMM yyyy"), type text),
    // Add Fiscal Year column
    AddFiscalYear = Table.AddColumn(AddMonthYear, "Fiscal Year", each "FY" & Date.ToText([Date], "yyyy"), type text),
    // Add Is Working Day column
    AddIsWorkingDay = Table.AddColumn(AddFiscalYear, "Is Working Day", each if Date.DayOfWeek([Date], Day.Monday) < 5 then true else false, type logical)
in
    // Return the final table
    AddIsWorkingDay
