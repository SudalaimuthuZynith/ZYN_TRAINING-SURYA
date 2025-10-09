page 50171 ZYN_IncomeFactboxPage
{
    PageType = CardPart;
    ApplicationArea = All; // Page available in all application areas
    SourceTable = ZYN_IncomeCategoryTable;

    layout
    {
        area(Content)
        {
            // Cuegroup showing income summaries
            cuegroup(Income)
            {
                // Current Month income
                field("CurrentMonth"; Rec."Total Amount CurrentMonth")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        Income.Reset();
                        Income.SetRange(Date, CalcDate('<-CM>', WorkDate), CalcDate('<CM>', WorkDate));
                        Income.SetRange(Catagory, Rec.Name);
                        Page.RunModal(Page::ZYN_IncomeList, Income);
                    end;
                }

                // Current Quarter income
                field("CurrentQuarter"; Rec."Total Amount CurrentQuarter")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        Income.Reset();
                        Income.SetRange(Date, CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
                        Income.SetRange(Catagory, Rec.Name);
                        Page.RunModal(Page::ZYN_IncomeList, Income);
                    end;
                }

                // Current Half-Year income
                field("CurrentHalf"; Rec."Total Amount CurrentHalf")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        CurrentYear := Date2DMY(WorkDate, 3);
                        MonthNo := Date2DMY(WorkDate, 2);

                        if MonthNo in [1 .. 6] then begin
                            StartDate := DMY2Date(1, 1, CurrentYear);
                            EndDate := CalcDate('<CM>', DMY2Date(1, 6, CurrentYear)); // last day of June
                        end else begin
                            StartDate := DMY2Date(1, 7, CurrentYear);
                            EndDate := CalcDate('<CM>', DMY2Date(1, 12, CurrentYear)); // last day of December
                        end;

                        Income.Reset();
                        Income.SetRange(Date, StartDate, EndDate);
                        Income.SetRange(Catagory, Rec.Name);
                        Page.RunModal(Page::ZYN_IncomeList, Income);
                    end;
                }

                // Current Year income
                field("CurrentYear"; Rec."Total Amount CurrentYear")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        Income.Reset();
                        Income.SetRange(Date, CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
                        Income.SetRange(Catagory, Rec.Name);
                        Page.RunModal(Page::ZYN_IncomeList, Income);
                    end;
                }
            }
        }
    }

    var
        StartDate: Date;        // Start date for half-year calculations
        EndDate: Date;          // End date for half-year calculations
        MonthNo: Integer;       // Current month number
        CurrentYear: Integer;   // Current year
        Income: Record ZYN_Income;  // Records for Income table

    trigger OnAfterGetRecord()
    begin
        CurrentYear := Date2DMY(WorkDate, 3);
        MonthNo := Date2DMY(WorkDate, 2);

        // Current Month
        Rec.SetRange("Date Filter", CalcDate('<-CM>', WorkDate), CalcDate('<CM>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentMonth" := Rec."Total Amount Filtered";

        // Current Quarter
        Rec.SetRange("Date Filter", CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentQuarter" := Rec."Total Amount Filtered";

        // Current Half-Year
        if MonthNo in [1 .. 6] then begin
            StartDate := DMY2Date(1, 1, CurrentYear);
            EndDate := CalcDate('<CM>', DMY2Date(1, 6, CurrentYear)); // last day of June
        end else begin
            StartDate := DMY2Date(1, 7, CurrentYear);
            EndDate := CalcDate('<CM>', DMY2Date(1, 12, CurrentYear)); // last day of December
        end;

        Rec.SetRange("Date Filter", StartDate, EndDate);
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentHalf" := Rec."Total Amount Filtered";

        // Current Year
        Rec.SetRange("Date Filter", CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentYear" := Rec."Total Amount Filtered";
    end;
}
