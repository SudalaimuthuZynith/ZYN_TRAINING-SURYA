page 50184 ZYNIncomeCard
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = income;
    Caption = 'Income Card';
    layout
    {
        area(Content)
        {
            group(general)
            {
                field("Expense ID"; Rec."Income ID")
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
                field(Catagory; Rec.Catagory)
                {
                }
            }
        }
    }
}