page 50187 ZYNLeaveRequestList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = ZYNLeaveRequestCard;
    SourceTable = ZYNLeaveRequest;
    Editable = false;
    Caption = 'Leave Request List';

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
                field(Catagory; Rec.Catagory)
                {
                }
                field(Reason; Rec.Reason)
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("total days"; Rec."total days")
                {
                }
                field("Remaining leave days"; Rec."Remaining leave days")
                {
                }
                field(Status; Rec.Status)
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
}