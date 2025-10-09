page 50170 ZYN_BudgetFactboxPage
{
    PageType = CardPart;
    ApplicationArea = All; // Page available in all application areas
    SourceTable = ZYNBudgetTable;

    layout
    {
        area(Content)
        {
            cuegroup(expense) // Grouping fields to display budget amounts
            {
                // Field showing total amount for the current month
                field("CurrentMonth"; Rec."Total Amount Current Month")
                {
                    DrillDown = true; // Enable navigation to detailed page
                    trigger OnDrillDown()
                    begin
                        // Reset the record variable and filter for the current month
                        ZYNBudgetTable.Reset();
                        ZYNBudgetTable.SetRange("From Date", CalcDate('<-CM>', WorkDate), CalcDate('<CM>', WorkDate));
                        ZYNBudgetTable.SetRange("Catagory Name", Rec."Catagory Name");
                        // Open detailed budget list page
                        Page.RunModal(Page::ZYNBudgetList, ZYNBudgetTable);
                    end;
                }

                // Field showing total amount for the current quarter
                field("CurrentQuarter"; Rec."Total Amount Current Quarter")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        ZYNBudgetTable.Reset();
                        ZYNBudgetTable.SetRange("From Date", CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
                        ZYNBudgetTable.SetRange("Catagory Name", Rec."Catagory Name");
                        Page.RunModal(Page::ZYNBudgetList, ZYNBudgetTable);
                    end;
                }

                // Field showing total amount for the current half year
                field("CurrentHalf"; Rec."Total Amount Current Half")
                {
                    trigger OnDrillDown()
                    begin
                        // Determine half-year start and end dates
                        if MonthNo in [1 .. 6] then begin
                            StartDate := DMY2Date(1, 1, CurrentYear);
                            EndDate := DMY2Date(30, 6, CurrentYear);
                        end else begin
                            StartDate := DMY2Date(1, 7, CurrentYear);
                            EndDate := DMY2Date(31, 12, CurrentYear);
                        end;

                        ZYNBudgetTable.Reset();
                        ZYNBudgetTable.SetRange("From Date", StartDate, EndDate);
                        ZYNBudgetTable.SetRange("Catagory Name", Rec."Catagory Name");
                        Page.RunModal(Page::ZYNBudgetList, ZYNBudgetTable);
                    end;
                }

                // Field showing total amount for the current year
                field("CurrentYear"; Rec."Total Amount Current Year")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        ZYNBudgetTable.Reset();
                        ZYNBudgetTable.SetRange("From Date", CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
                        ZYNBudgetTable.SetRange("Catagory Name", Rec."Catagory Name");
                        Page.RunModal(Page::ZYNBudgetList, ZYNBudgetTable);
                    end;
                }
            }
        }
    }

    var
        StartDate: Date; // Variable to hold start date of period
        EndDate: Date;   // Variable to hold end date of period
        MonthNo: Integer; // Current month number
        CurrentYear: Integer; // Current year
        ZYNBudgetTable: Record ZYNBudgetTable; // Record variable for drilldown

    trigger OnAfterGetRecord()
    begin
        // Get current year and month
        CurrentYear := Date2DMY(WorkDate, 3);
        MonthNo := Date2DMY(WorkDate, 2);

        // Calculate current month totals
        StartDate := CalcDate('<-CM>', WorkDate);
        EndDate := CalcDate('<CM>', WorkDate);
        Rec.SetRange("Date Filter", StartDate, EndDate);
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount Current Month" := Rec."Total Amount Filtered";

        // Calculate current quarter totals
        Rec.SetRange("Date Filter", CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount Current Quarter" := Rec."Total Amount Filtered";

        // Calculate current half-year totals
        if MonthNo in [1 .. 6] then begin
            StartDate := DMY2Date(1, 1, CurrentYear);
            EndDate := DMY2Date(30, 6, CurrentYear);
        end else begin
            StartDate := DMY2Date(1, 7, CurrentYear);
            EndDate := DMY2Date(31, 12, CurrentYear);
        end;
        Rec.SetRange("Date Filter", StartDate, EndDate);
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount Current Half" := Rec."Total Amount Filtered";

        // Calculate current year totals
        Rec.SetRange("Date Filter", CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount Current Year" := Rec."Total Amount Filtered";
    end;
}
