page 50197 ZYNLeaveRequestCard
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = ZYNLeaveRequest;
    Caption = 'Leave Request Card';

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
            action(Approve)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                trigger OnAction()
                var

                begin
                    Rec.Status := Rec.Status::Approved;
                end;
            }

            action(Reject)
            {
                trigger OnAction()
                var

                begin
                    Rec.Status := Rec.Status::Rejected;
                end;
            }
        }
    }
}