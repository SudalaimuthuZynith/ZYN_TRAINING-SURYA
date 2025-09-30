page 50166 ZYNBudgetCard
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = ZYNBudgetTable;
    Caption = 'Budget Card';
    layout
    {
        area(Content)
        {
            group(Group)
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
    }
}