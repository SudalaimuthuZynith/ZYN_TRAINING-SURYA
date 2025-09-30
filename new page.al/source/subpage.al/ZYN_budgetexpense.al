page 50188 BudgetPage
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNBudgetTable;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("From Date"; Rec."From Date") { }
                field("To Date"; Rec."To Date") { }
                field("Catagory Name"; Rec."Catagory Name") { }
                field(Amount; Rec.Amount) { }
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
    trigger OnOpenPage()
    var
        start: Date;
        endin: Date;
    begin
        start := CalcDate('<-CM>', WorkDate());
        endin := CalcDate('<CM>', WorkDate());
        Rec.SetRange("From Date", start, endin);
    end;

    var
        myInt: Integer;
}