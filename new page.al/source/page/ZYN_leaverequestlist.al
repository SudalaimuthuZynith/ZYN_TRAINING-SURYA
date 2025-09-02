page 50187 LeaveRequestListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = LeaveRequestCardPage;
    SourceTable = LeaveRequestTable;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee ID"; Rec."Employee ID")
                {

                }
                field("Employee Name"; Rec."Employee Name")
                {

                }
                field(Catagory; Rec.Catagory) { }
                field(Reason; Rec.Reason) { }
                field("Start Date"; Rec."Start Date") { }
                field("End Date"; Rec."End Date") { }
                field("total days"; Rec."total days") { }
                field("Remaining leave days"; Rec."Remaining leave days") { }
                field(Status; Rec.Status) { }
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