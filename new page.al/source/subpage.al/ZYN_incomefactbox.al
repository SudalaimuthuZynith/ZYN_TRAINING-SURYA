page 50171 IncomeFactboxPage
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = IncomeCatagoryTable;

    layout
    {
        area(Content)
        {
            cuegroup(income)
            {
                field("CurrentMonth"; Rec."Total Amount CurrentMonth")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        income.Reset();
                        income.SetRange(Date, CalcDate('<-CM>', WorkDate), CalcDate('<CM>', WorkDate));
                        income.SetRange(Catagory, Rec.Name);  // Ensure spelling matches table field
                        Page.RunModal(Page::IncomeListPage, income);
                    end;
                }

                field("CurrentQuarter"; Rec."Total Amount CurrentQuarter")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        income.Reset();
                        income.SetRange(Date, CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
                        income.SetRange(Catagory, Rec.Name);
                        Page.RunModal(Page::IncomeListPage, income);
                    end;
                }

                field("CurrentHalf"; Rec."Total Amount CurrentHalf")
                {
                    ApplicationArea = All;
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

                        income.Reset();
                        income.SetRange(Date, StartDate, EndDate);
                        income.SetRange(Catagory, Rec.Name);
                        Page.RunModal(Page::IncomeListPage, income);
                    end;
                }

                field("CurrentYear"; Rec."Total Amount CurrentYear")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        income.Reset();
                        income.SetRange(Date, CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
                        income.SetRange(Catagory, Rec.Name);
                        Page.RunModal(Page::IncomeListPage, income);
                    end;
                }
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        MonthNo: Integer;
        CurrentYear: Integer;
        income: Record Income;

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

        // Current Half Year
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
