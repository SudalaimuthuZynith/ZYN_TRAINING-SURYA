page 50124 ZYNExpenseCard
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = Expenses;
    Caption = 'Expense Card';

    layout
    {
        area(Content)
        {
            group(general)
            {
                field("Expense ID"; Rec."Expense ID")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Catagory; Rec.Catagory)
                {
                }
                field("Remaining Budget"; Rec."Remaining Budget")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
            }
        }
    }
}