page 50137 ExpenseListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Expenses;
    CardPageId = ExpenseCardPage;
    InsertAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field("Expense ID"; Rec."Expense ID") { }
                field(Description; Rec.Description) { }
                field(Amount; Rec.Amount) { }
                field(Date; Rec.Date) { }
                field("Category Name"; Rec.Catagory)
                {

                }
            }

        }
        area(FactBoxes)
        {
            part(BudgetPage; BudgetPage)
            {
                ApplicationArea = All;
            }
            
        }
    }

    actions
    {
        area(Processing)
        {
            action(catagories)
            {

                RunObject = page ExpenseCatagoryPage;
            }
            action(ExportReport)
            {
                RunObject = report "Expense Excel Report";
            }
        }

    }

    var
        myInt: Decimal;
}


