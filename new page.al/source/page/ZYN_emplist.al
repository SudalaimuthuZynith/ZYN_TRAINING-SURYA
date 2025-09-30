page 50173 ZYNEmployeeList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = ZYNEmployeeCard;
    SourceTable = ZYNEmployee;
    Editable = false;
    Caption = 'Employee List';

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
                field(Department; Rec.Department)
                {
                }
                field(Role; Rec.Role)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(EmployeeAssetsHistoryPage; EmployeeAssetsHistoryPage)
            {
                ApplicationArea = all;
                SubPageLink = Employee = field("Employee ID");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Leavecatagory)
            {
                RunObject = page ZYNLeaveCatagoryList;
            }
            action(leaverequest)
            {
                RunObject = page ZYNLeaveRequestList;
            }
        }
    }
}