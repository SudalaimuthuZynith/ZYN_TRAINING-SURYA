page 50174 EmployeeCardPage
{
    PageType = Card;
    ApplicationArea = All;
    //UsageCategory = Administration;
    //CardPageId = BudgetCardPage;
    SourceTable = EmployeeTable;
    //Editable = false;

    layout
    {
        area(Content)
        {
            group(Group)
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
            // action(leaverequest)
            // {

            //     RunObject = page LeaveRequestListPage;
            // }
        }
    }
   

    var
        myInt: Integer;
}