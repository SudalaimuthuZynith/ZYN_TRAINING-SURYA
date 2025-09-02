page 50124 ExpenseCardPage
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = Expenses;

    layout
    {
        area(Content)
        {
            group(general)
            {
                field("Expense ID"; Rec."Expense ID") { }
                field(Description; Rec.Description) { }

                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    // trigger OnValidate()
                    // begin
                    //     UpdateRemaining();
                    // end;
                }
                field(Catagory; Rec.Catagory)
                {
                    ApplicationArea = All;
                    // trigger OnValidate()
                    // begin
                    //     UpdateRemaining();
                    // end;
                }
                field("Remaining Budget"; Rec."Remaining Budget") { }
                field(Amount; Rec.Amount) { }
                // field("Remaining Budget"; RemainingBudget)
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                // field("Budget Amount"; Rec."Budget Amount")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                // field("Spent This Month"; Rec."Spent This Period")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;

    //     trigger OnAfterGetRecord()
    //     var
    //         budget: Record BudgetTable;
    //         start: Date;
    //         endin: Date;
    //         expense: Record Expenses;
    //         totalexpense: Decimal;
    //     begin
    //         start := CalcDate('<-CM>', WorkDate());
    //         endin := CalcDate('<CM>', WorkDate());
    //         expense.Reset();
    //         expense.SetRange(Catagory, Rec.Catagory);
    //         expense.SetRange(Date, start, endin);
    //         if expense.FindSet() then
    //             repeat
    //                 totalexpense += expense.Amount;
    //             until expense.Next() = 0
    //         else
    //             totalexpense := 0;
    //         budget.Reset();
    //         budget.SetRange("Catagory Name",Rec.Catagory);
    //         budget.SetRange("From Date",start,endin);
    //         if budget.FindSet() then
    //             Rec."Remaining Budget" := budget.Amount - totalexpense
    //         else
    //             Rec."Remaining Budget" := -totalexpense;

    //    end;
    // trigger OnAfterGetRecord()
    // var
    //     startDate: Date;
    //     endDate: Date;
    // begin

    //     startDate := CalcDate('<-CM>', WorkDate());
    //     endDate := CalcDate('<CM>', WorkDate());
    //     Rec.SetRange(Date, startDate, endDate);
    //     Rec.CalcFields("Remaining Budget");
    // end;
    // var
    //     RemainingBudget: Decimal;

    // trigger OnAfterGetRecord()
    // begin
    //     UpdateRemaining();
    // end;

    // local procedure UpdateRemaining()
    // begin
    //     // Ensure FlowFields are (re)calculated with the current filter
    //     Rec.SetRange("Date Filter", CalcDate('<-CM>'), CalcDate('<CM>'));
    //     Rec.CalcFields("Budget Amount", "Spent This Period");
    //     RemainingBudget := Rec."Budget Amount" - Rec."Spent This Period";
    // end;
}