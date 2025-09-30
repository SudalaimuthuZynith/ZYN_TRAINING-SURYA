page 50169 ZYNBudgetList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = ZYNBudgetCard;
    SourceTable = ZYNBudgetTable;
    Editable = false;
    Caption = 'Budget List';
    
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("Catagory Name"; Rec."Catagory Name")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(BudgetFactboxPage; BudgetFactboxPage)
            {
                ApplicationArea = all;
                SubPageLink = "Catagory Name" = field("Catagory Name"), "From Date" = field("From Date");
            }
        }
    }
}