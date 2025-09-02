page 50159 LeaveCatagoryCardPage
{
    PageType = List;
    ApplicationArea = All;
    //UsageCategory = Administration;
    //CardPageId = BudgetCardPage;
    SourceTable = LeaveCatagoryTable;
    //Editable = false;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Catagory Name";Rec."Catagory Name")
                {

                }
                field(Description;Rec.Description)
                {

                }
                field("No of days allowed";Rec."No of days allowed") { }
                //field(Role;Rec.Role) { }
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