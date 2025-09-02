page 50177 LeaveCatagoryListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = LeaveCatagoryCardPage;
    SourceTable = LeaveCatagoryTable;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Catagory Name"; Rec."Catagory Name")
                {

                }
                field(Description; Rec.Description)
                {

                }
                field("No of days allowed"; Rec."No of days allowed") { }
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

    // trigger OnOpenPage()
    // var
    //     emp: Record EmployeeTable;
    //     req: Record LeaveRequestTable;
    //     ee: Record EmpLeaveHiddenTable;
    // begin
    //     ee.DeleteAll();
    //     emp.DeleteAll();
    //     req.DeleteAll();
    //end;
}