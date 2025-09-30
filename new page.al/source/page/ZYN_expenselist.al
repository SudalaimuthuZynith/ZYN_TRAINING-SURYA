page 50137 ZYNExpenseList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Expenses;
    CardPageId = ZYNExpenseCard;
    InsertAllowed = false;
    Editable = false;
    Caption='Expense List';

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
                RunObject = page ZYNExpenseCatagory;
            }
            action(ExportReport)
            {
                RunObject = report "Expense Excel Report";
            }
        }
    }
}


