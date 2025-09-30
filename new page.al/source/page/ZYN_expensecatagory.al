page 50106 ZYNExpenseCatagory
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = ZYNExpenseCatagory;
    Caption='Expense Catagory List';

    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(Name; Rec.Name)
                {
                }
                field(Description; Rec.Description)
                {
                }
            }

        }
        area(FactBoxes)
        {
            part(ExpenseFactboxPage; ExpenseFactboxPage)
            {
                SubPageLink = Name = field(Name);
            }
            part(BudgetFactboxPage; BudgetFactboxPage)
            {
                ApplicationArea = all;
                SubPageLink = "Catagory Name" = field(Name);
            }
        }
    }
}