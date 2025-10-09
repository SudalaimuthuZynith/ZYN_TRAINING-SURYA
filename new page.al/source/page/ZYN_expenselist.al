page 50137 ZYNExpenseList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_Expenses;
    CardPageId = ZYNExpenseCard;
    InsertAllowed = false;
    Editable = false;
    Caption = 'Expense List';

    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field("Expense ID"; Rec."Expense ID")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("Category Name"; Rec.Category)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(BudgetPage; ZYN_Budget)
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
                RunObject = page ZYNExpenseCatagory;
            }
            action(ExportReport)
            {
                RunObject = report ZYN_ExpenseExcelReport;
            }
        }
    }
}


