// pageextension 50153 BusinessManagerRC_Headline extends "Business Manager Role Center"
// {
//     layout
//     {
//         addfirst(RoleCenter)
//         {
//             part(LeaveHeadline; LeaveHeadlinePart)
//             {
//                 ApplicationArea = All;
//             }
//         }
//     }
// }

// page 50154 LeaveHeadlinePart
// {
//     PageType = HeadlinePart;
//     ApplicationArea = All;
//     SourceTable = LeaveNotification;

//     layout
//     {
//         area(content)
//         {
//             group(Headlines)
//             {
//                 field(ApprovedLeavesMsg; GetApprovedLeavesMsg())
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     local procedure GetApprovedLeavesMsg(): Text
//     var
//         notifyRec: Record LeaveNotification;
//         countApproved: Integer;
//     begin
//         notifyRec.Reset();
//         notifyRec.SetRange(Status, notifyRec.Status::Approved);
//         countApproved := notifyRec.Count();

//         if countApproved = 0 then
//             exit('No approved leaves yet.')
//         else
//             exit(Format(countApproved) + ' leaves have been approved.');
//     end;
// }
pageextension 50153 BusinessManagerRC_Ext extends "Business Manager Role Center"
{
    layout
    {
        addlast(RoleCenter)
        {
            part(LeaveHeadline; "LeaveHeadlinePart")
            {
                ApplicationArea = All;
            }
        }
    }
}
page 50154 "LeaveHeadlinePart"
{
    PageType = HeadlinePart;
    ApplicationArea = All;
    SourceTable = LeaveRequestTable;

    layout
    {
        area(content)
        {
            group(LeaveRequestsHeadline)
            {
                Caption = 'Leave Notifications';

                // Pending requests
                field(Pending; GetPendingCount())
                {
                    Caption = 'Pending Requests';
                    ApplicationArea = All;
                    DrillDownPageId = LeaveRequestListPage;
                }

                // Approved requests
                field(Approved; GetApprovedCount())
                {
                    Caption = 'Approved Requests';
                    ApplicationArea = All;
                    DrillDownPageId = LeaveRequestListPage;
                }
            }
        }
    }

    local procedure GetPendingCount(): Integer
    var
        LReq: Record LeaveRequestTable;
    begin
        LReq.SetRange(Status, LReq.Status::Pending);
        exit(LReq.Count);
    end;

    local procedure GetApprovedCount(): Integer
    var
        LReq: Record LeaveRequestTable;
    begin
        LReq.SetRange(Status, LReq.Status::Pending);
        exit(LReq.Count);
    end;
}
