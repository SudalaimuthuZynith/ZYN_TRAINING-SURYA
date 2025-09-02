page 50184 IncomeCardPage
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = income;

    layout
    {
        area(Content)
        {
            group(general)
            {
                field("Expense ID"; Rec."Income ID") { }
                field(Description; Rec.Description) { }
                field(Amount; Rec.Amount) { }
                field(Date; Rec.Date) { }
                field(Catagory; Rec.Catagory) { }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}