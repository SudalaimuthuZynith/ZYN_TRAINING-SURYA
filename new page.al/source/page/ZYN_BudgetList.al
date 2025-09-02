page 50169 BudgetListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = BudgetCardPage;
    SourceTable = BudgetTable;
    Editable = false;

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
                field("Catagory Name"; Rec."Catagory Name") { }
                field(Amount; Rec.Amount) { }
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
    // trigger OnOpenPage()
    // var
    //     budget: Record BudgetTable;
    // begin
    //     budget."From Date" := CalcDate('<-CM>', WorkDate);
    //     budget."To Date" := CalcDate('<-CM>', WorkDate);
    // end;

    var
        myInt: Integer;
}