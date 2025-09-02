page 50173 EmployeeListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = EmployeeCardPage;
    SourceTable = EmployeeTable;
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
                field(Department; Rec.Department) { }
                field(Role; Rec.Role) { }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(Leavecatagory)
            {

                RunObject = page LeaveCatagoryListPage;
            }
            action(leaverequest)
            {

                RunObject = page LeaveRequestListPage;
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