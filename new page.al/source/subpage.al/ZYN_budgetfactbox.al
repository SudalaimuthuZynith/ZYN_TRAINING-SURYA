page 50170 BudgetFactboxPage
{
    PageType = CardPart;
    ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = BudgetTable;

    layout
    {
        area(Content)
        {
            //field("Remaining Budget"; Rec."Remaining Budget") { }
            cuegroup(expense)
            {
                field("CurrentMonth"; Rec."Total Amount CurrentMonth")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        expenses.Reset();
                        expenses.SetRange("From Date", CalcDate('<-CM>', WorkDate), CalcDate('<CM>', WorkDate));
                        expenses.SetRange("Catagory Name", Rec."Catagory Name");
                        Page.RunModal(Page::BudgetListPage, expenses)
                    end;
                }
                field("CurrentQuarter"; Rec."Total Amount CurrentQuarter")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        expenses.Reset();
                        expenses.SetRange("From Date", CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
                        expenses.SetRange("Catagory Name", Rec."Catagory Name");
                        Page.RunModal(Page::BudgetListPage, expenses)
                    end;
                }
                field("CurrentHalf"; Rec."Total Amount CurrentHalf")
                {
                    trigger OnDrillDown()
                    begin
                        if MonthNo in [1 .. 6] then begin
                            StartDate := DMY2Date(1, 1, CurrentYear);
                            EndDate := DMY2Date(30, 6, CurrentYear);
                        end else begin

                            StartDate := DMY2Date(1, 7, CurrentYear);
                            EndDate := DMY2Date(31, 12, CurrentYear);
                        end;
                        expenses.Reset();
                        expenses.SetRange("From Date", StartDate, EndDate);
                        expenses.SetRange("Catagory Name", Rec."Catagory Name");
                        Page.RunModal(Page::BudgetListPage, expenses)
                    end;

                }
                field("CurrentYear"; Rec."Total Amount CurrentYear")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        expenses.Reset();
                        expenses.SetRange("From Date", CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
                        expenses.SetRange("Catagory Name", Rec."Catagory Name");
                        Page.RunModal(Page::BudgetListPage, expenses)
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
        expenses: Record BudgetTable;
        budget: Record BudgetTable;

    trigger OnAfterGetRecord()
    begin
        CurrentYear := Date2DMY(WorkDate, 3);
        MonthNo := Date2DMY(WorkDate, 2);
        StartDate := CalcDate('<-CM>', WorkDate);
        EndDate := CalcDate('<CM>', WorkDate);
        // Rec.SetRange("Date Filter", StartDate, EndDate);
        Rec.SetRange("Date Filter", CalcDate('<-CM>', WorkDate), CalcDate('<CM>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentMonth" := Rec."Total Amount Filtered";
        // budget.Reset();
        // budget.SetRange("Catagory Name", Rec."Catagory Name");
        // budget.SetRange("From Date", StartDate, EndDate);
        // if budget.FindSet() then
        //     Rec."Remaining Budget" := budget.Amount - Rec."Total Amount CurrentMonth"
        // else
        //     Rec."Remaining Budget" -= Rec."Total Amount CurrentMonth";


        // StartDate := CalcDate('<-CQ>', WorkDate);
        // EndDate := CalcDate('<CQ>', WorkDate);
        // Rec.SetRange("Date Filter", StartDate, EndDate);
        Rec.SetRange("Date Filter", CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentQuarter" := Rec."Total Amount Filtered";

        if MonthNo in [1 .. 6] then begin
            StartDate := DMY2Date(1, 1, CurrentYear);
            EndDate := DMY2Date(30, 6, CurrentYear);
        end else begin

            StartDate := DMY2Date(1, 7, CurrentYear);
            EndDate := DMY2Date(31, 12, CurrentYear);
        end;

        Rec.SetRange("Date Filter", StartDate, EndDate);
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentHalf" := Rec."Total Amount Filtered";


        // StartDate := CalcDate('<-CY>', WorkDate);
        // EndDate := CalcDate('<CY>', WorkDate);
        // Rec.SetRange("Date Filter", StartDate, EndDate);
        Rec.SetRange("Date Filter", CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentYear" := Rec."Total Amount Filtered";
    end;
}