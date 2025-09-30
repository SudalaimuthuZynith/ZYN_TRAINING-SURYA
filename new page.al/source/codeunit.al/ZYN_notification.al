codeunit 50104 "My Notification Actions"
{
    procedure OpenLeaveBalance(Notification: Notification)
    var
        LeavePage: Page ZYNLeaveRequestList;
    begin
        LeavePage.Run();
    end;
}
codeunit 50105 "My Notification Mgt"
{
  
    procedure ShowLeaveBalanceNotification()
    var
        Notification: Notification;
        LeaveReq: Record ZYNLeaveRequest;
        remaining: integer;
    begin
        LeaveReq.Reset();
        LeaveReq.SetRange(Status, LeaveReq.Status::Approved);
        LeaveReq.SetCurrentKey(SystemModifiedAt);
        LeaveReq.SetAscending(SystemModifiedAt, true);
 
        Clear(Notification);
        Notification.Id := 'CDEF7890-ABCD-0123-1234-567890ABCDEF';
        Notification.Scope := NotificationScope::LocalScope;
 
        if LeaveReq.FindLast() then
            Notification.Message :=
                StrSubstNo('Last approved request: %1 for %2 days.',
                           LeaveReq."Employee ID", LeaveReq."End Date" - LeaveReq."Start Date" + 1)
        else
            Notification.Message := 'No approved leave requests found!';
 
        Notification.Send();
    end;
 
   
    procedure ShowLeaveRejectNotification()
    var
        Notification: Notification;
        LeaveReq: Record ZYNLeaveRequest;
        leaveBal: page ZYNLeaveRequestCard;
        remaining: integer;
    begin
        LeaveReq.Reset();
        LeaveReq.SetRange(Status, LeaveReq.Status::Rejected);
        LeaveReq.SetCurrentKey(SystemModifiedAt);
        LeaveReq.SetAscending(SystemModifiedAt, true);
 
        Clear(Notification);
        Notification.Id := 'CDEF7880-ABCD-0123-1234-567890ABCDEF';
        Notification.Scope := NotificationScope::LocalScope;
 
        if LeaveReq.FindLast() then
            Notification.Message :=
                StrSubstNo('Last Rejected request: %1 for %2 days.',
                           LeaveReq."Employee ID", LeaveReq."End Date" - LeaveReq."Start Date" + 1)
        else
            Notification.Message := 'No rejected leave requests found!';
 
        Notification.Send();
    end;
 
    procedure ShowLeavePendingNotification()
    var
        Notification: Notification;
        LeaveReq: Record ZYNLeaveRequest;
        leaveBal: page ZYNLeaveRequestCard;
        remaining: integer;
        pending: integer;
    begin
        LeaveReq.Reset();
        LeaveReq.SetRange(Status, LeaveReq.Status::Pending);
        LeaveReq.SetCurrentKey(SystemModifiedAt);
        LeaveReq.SetAscending(SystemModifiedAt, true);
 
        Clear(Notification);
        Notification.Id := 'CDEF7870-ABCD-0123-1234-567890ABCDEF';
        Notification.Scope := NotificationScope::LocalScope;
        pending := LeaveReq.Count;
 
        if LeaveReq.FindSet() then
            Notification.Message :=
                StrSubstNo('Pending requests: %1',pending)
        else
            Notification.Message := 'No approved leave requests found!';
 
        Notification.Send();
    end;
 
}
 
 