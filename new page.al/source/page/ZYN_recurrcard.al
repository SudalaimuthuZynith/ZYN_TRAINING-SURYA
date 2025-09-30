page 50189 ZYNRecurrCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNRecurringExpense;
    Caption = 'Recurring Card';

    layout
    {
        area(Content)
        {
            group(Recurr)
            {
                field("Recurring ID"; Rec."Recurring ID")
                {
                }
                field(Catagory; Rec.Catagory)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(Period; Rec.Period) 
                { 
                }
                field(" StarDate"; Rec." StarDate")
                {
                }
                field("Next Cycle Date"; Rec."Next Cycle Date")
                {
                }
            }
        }
    }
}