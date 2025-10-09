page 50168 ZYN_ExpenseFactboxPage
{
    PageType = CardPart;
    ApplicationArea = All; // Page available in all application areas
    SourceTable = "ZYN Expense Category";

    layout
    {
        area(Content)
        {
            // Remaining budget field
            field("Remaining Budget"; Rec."Remaining Budget") { }

            // Expense summary cuegroup
            cuegroup(Expense)
            {
                // Total amount for current month
                field("CurrentMonth"; Rec."Total Amount CurrentMonth")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        Expenses.Reset();
                        Expenses.SetRange(Date, CalcDate('<-CM>', WorkDate), CalcDate('<CM>', WorkDate));
                        Expenses.SetRange(Category, Rec.Name);
                        Page.RunModal(Page::ZYNExpenseList, Expenses);
                    end;
                }

                // Total amount for current quarter
                field("CurrentQuarter"; Rec."Total Amount CurrentQuarter")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        Expenses.Reset();
                        Expenses.SetRange(Date, CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
                        Expenses.SetRange(Category, Rec.Name);
                        Page.RunModal(Page::ZYNExpenseList, Expenses);
                    end;
                }

                // Total amount for current half-year
                field("CurrentHalf"; Rec."Total Amount CurrentHalf")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        if MonthNo in [1 .. 6] then begin
                            StartDate := DMY2Date(1, 1, CurrentYear);
                            EndDate := DMY2Date(30, 6, CurrentYear);
                        end else begin
                            StartDate := DMY2Date(1, 7, CurrentYear);
                            EndDate := DMY2Date(31, 12, CurrentYear);
                        end;

                        Expenses.Reset();
                        Expenses.SetRange(Date, StartDate, EndDate);
                        Expenses.SetRange(Category, Rec.Name);
                        Page.RunModal(Page::ZYNExpenseList, Expenses);
                    end;
                }

                // Total amount for current year
                field("CurrentYear"; Rec."Total Amount CurrentYear")
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        Expenses.Reset();
                        Expenses.SetRange(Date, CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
                        Expenses.SetRange(Category, Rec.Name);
                        Page.RunModal(Page::ZYNExpenseList, Expenses);
                    end;
                }
            }
        }
    }

    var
        StartDate: Date; // Start date for period calculations
        EndDate: Date;   // End date for period calculations
        MonthNo: Integer; // Current month number
        CurrentYear: Integer; // Current year
        Expenses: Record ZYN_Expenses; // Expenses records
        ZYNBudgetTable: Record ZYNBudgetTable; // Budget table records

    trigger OnAfterGetRecord()
    begin
        // Set current year and month
        CurrentYear := Date2DMY(WorkDate, 3);
        MonthNo := Date2DMY(WorkDate, 2);

        // Calculate current month totals and remaining budget
        StartDate := CalcDate('<-CM>', WorkDate);
        EndDate := CalcDate('<CM>', WorkDate);
        Rec.SetRange("Date Filter", StartDate, EndDate);
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentMonth" := Rec."Total Amount Filtered";

        ZYNBudgetTable.Reset();
        ZYNBudgetTable.SetRange("Catagory Name", Rec.Name);
        ZYNBudgetTable.SetRange("From Date", StartDate, EndDate);

        if ZYNBudgetTable.FindSet() then
            Rec."Remaining Budget" := ZYNBudgetTable.Amount - Rec."Total Amount CurrentMonth"
        else
            Rec."Remaining Budget" -= Rec."Total Amount CurrentMonth";

        // Calculate current quarter totals
        Rec.SetRange("Date Filter", CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentQuarter" := Rec."Total Amount Filtered";

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
        Rec."Total Amount CurrentHalf" := Rec."Total Amount Filtered";

        // Calculate current year totals
        Rec.SetRange("Date Filter", CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
        Rec.CalcFields("Total Amount Filtered");
        Rec."Total Amount CurrentYear" := Rec."Total Amount Filtered";
    end;
}


// cuegroup(budget)
// {
//     field("Amount CurrentMonth";Rec."Amount CurrentMonth")
//     {
//         DrillDown = true;
//         trigger OnDrillDown()
//         begin
//             expenses.Reset();
//             expenses.SetRange(Date, CalcDate('<-CM>', WorkDate), CalcDate('<CM>', WorkDate));
//             expenses.SetRange(Catagory, Rec.Name);
//             Page.RunModal(Page::ExpenseListPage, expenses)
//         end;
//     }
//     field("Amount CurrentQuarter";Rec."Amount CurrentQuarter")
//     {
//         DrillDown = true;
//         trigger OnDrillDown()
//         begin
//             expenses.Reset();
//             expenses.SetRange(Date, CalcDate('<-CQ>', WorkDate), CalcDate('<CQ>', WorkDate));
//             expenses.SetRange(Catagory, Rec.Name);
//             Page.RunModal(Page::ExpenseListPage, expenses)
//         end;
//     }
//     field("Amount CurrentHalf";Rec."Amount CurrentHalf")
//     {
//         trigger OnDrillDown()
//         begin
//             if MonthNo in [1 .. 6] then begin
//                 StartDate := DMY2Date(1, 1, CurrentYear);
//                 EndDate := DMY2Date(30, 6, CurrentYear);
//             end else begin

//                 StartDate := DMY2Date(1, 7, CurrentYear);
//                 EndDate := DMY2Date(31, 12, CurrentYear);
//             end;
//             expenses.Reset();
//             expenses.SetRange(Date, StartDate, EndDate);
//             expenses.SetRange(Catagory, Rec.Name);
//             Page.RunModal(Page::ExpenseListPage, expenses)
//         end;

//     }
//     field("Amount CurrentYear";Rec."Amount CurrentYear")
//     {
//         DrillDown = true;
//         trigger OnDrillDown()
//         begin
//             expenses.Reset();
//             expenses.SetRange(Date, CalcDate('<-CY>', WorkDate), CalcDate('<CY>', WorkDate));
//             expenses.SetRange(Catagory, Rec.Name);
//             Page.RunModal(Page::ExpenseListPage, expenses)
//         end;
//     }
// }