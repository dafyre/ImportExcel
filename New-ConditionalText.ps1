function New-ConditionalText {
    <#
      .SYNOPSIS
        Creates an object which describes a conditional formatting rule for single valued rules
      .DESCRIPTION
        Some Conditional formatting rules don't apply styles to a cell (IconSets and Databars)
        Some take two parameters (Between)
        Some take none (ThisWeek , containsErrors, AboveAverage etc.)
        The others take a single paramter (top, BottomPercent, GreaterThan, Contains etc)
        This command  creates an object to describe the last two categories, which can be passed to Export-Excel
      .PARAMETER Range
        The range of cells that the conditional format applies to; if none is specified the range will be apply to all the data in the sheet
      .PARAMETER ConditionalType
        One the supported rules by default - "ContainsText" is selected
      .PARAMETER Text
        The text (or other value) to use in the rule. Not that Equals, GreaterThan/LessThan rules require text to wrapped in double quotes
      .PARAMETER ConditionalTextColor
        The font color for the cell - by default: Dark red
      .PARAMETER BackgroundColor
        The fill color for the cell - by default: light pink
      .PARAMETER PatternType
        The Background pattern for the cell - by deault: Solid
      .EXAMPLE
        $ct = New-ConditionalText -Text  'Ferrari'
        Export-Excel -ExcelPackage $excel -ConditionalTest $ct -show

        The first line creates a definition object which will highlight the word "Ferrari" in any cell.
        and the secind uses Export-Excel with an open package to apply the format and save and open the file.
      .EXAMPLE
        $ct  = New-ConditionalText -Text "Ferrari"
        $ct2 = New-ConditionalText -Range $worksheet.Names["FinishPosition"].Address -ConditionalType LessThanOrEqual -Text 3 -ConditionalTextColor Red -BackgroundColor White
        Export-Excel -ExcelPackage $excel -ConditionalText $ct,$ct2 -show

        This builds on the previous example, and specifies a condition of <=3 with a format of Red text on a white background; this applies to a named range "Finish Position"
        the range could be written "C:C" to specify a named column, or "C2:C102" to specify certain cells in the column.
    #>
    [cmdletbinding()]
    param(
        #[Parameter(Mandatory=$true)]
        [Alias("ConditionValue")]
        $Text,
        [Alias("ForeGroundColor")]
        [System.Drawing.Color]$ConditionalTextColor="DarkRed",
        [System.Drawing.Color]$BackgroundColor="LightPink",
        [String]$Range,
        [OfficeOpenXml.Style.ExcelFillStyle]$PatternType=[OfficeOpenXml.Style.ExcelFillStyle]::Solid,
        [ValidateSet(
            "LessThan",        "LessThanOrEqual",      "GreaterThan",    "GreaterThanOrEqual",
            "Equal",           "NotEqual",
            "Top",             "TopPercent",           "Bottom",         "BottomPercent",
            "ContainsText",    "NotContainsText",      "BeginsWith",     "EndsWith",
            "ContainsBlanks",  "NotContainsBlanks",    "ContainsErrors", "NotContainsErrors",
            "DuplicateValues", "UniqueValues",
            "Tomorrow",        "Today",                "Yesterday",      "Last7Days",
            "NextWeek",        "ThisWeek",             "LastWeek",
            "NextMonth",       "ThisMonth",            "LastMonth",
            "AboveAverage",    "AboveOrEqualAverage",  "BelowAverage",  "BelowOrEqualAverage"
        )]
        [Alias("RuleType")]
        $ConditionalType="ContainsText"
    )

    $obj = [PSCustomObject]@{
        Text                 = $Text
        ConditionalTextColor = $ConditionalTextColor
        ConditionalType      = $ConditionalType
        PatternType          = $PatternType
        Range                = $Range
        BackgroundColor      = $BackgroundColor
    }

    $obj.pstypenames.Clear()
    $obj.pstypenames.Add("ConditionalText")
    $obj
}