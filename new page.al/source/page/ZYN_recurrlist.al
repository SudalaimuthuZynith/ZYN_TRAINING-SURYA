page 50179 RecurrListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = RecurrCardPage;
    SourceTable = recurring_expense;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
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
                field(Period;Rec.Period){}
                field(" StarDate"; Rec." StarDate")
                {

                }
                field("Next Cycle Date"; Rec."Next Cycle Date")
                {

                }
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