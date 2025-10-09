page 50106 ZYNExpenseCatagory
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "ZYN Expense Category";
    Caption = 'Expense Catagory List';

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
            part(ExpenseFactboxPage; ZYN_ExpenseFactboxPage)
            {
                SubPageLink = Name = field(Name);
            }
            part(BudgetFactboxPage; ZYN_BudgetFactboxPage)
            {
                ApplicationArea = all;
                SubPageLink = "Catagory Name" = field(Name);
            }
        }
    }
}