codeunit 50105 "My Notification Mgt"
{
    // ======================================
    // Show notification for last approved leave
    // ======================================
    procedure ShowLeaveBalanceNotification()
    var
        Notification: Notification;
        LeaveReq: Record ZYNLeaveRequest;
        LeaveDays: Integer;
    begin
        LeaveReq.Reset();
        LeaveReq.SetRange(Status, LeaveReq.Status::Approved);
        LeaveReq.SetCurrentKey(SystemModifiedAt);
        LeaveReq.SetAscending(SystemModifiedAt, true);

        Clear(Notification);
        Notification.Id := 'CDEF7890-ABCD-0123-1234-567890ABCDEF';
        Notification.Scope := NotificationScope::LocalScope;

        if LeaveReq.FindLast() then begin
            LeaveDays := LeaveReq."End Date" - LeaveReq."Start Date" + 1;
            Notification.Message := StrSubstNo(
                'Last approved request: %1 for %2 days.',
                LeaveReq."Employee ID", LeaveDays
            );
        end else
            Notification.Message := 'No approved leave requests found!';

        Notification.Send();
    end;

    // ======================================
    // Show notification for last rejected leave
    // ======================================
    procedure ShowLeaveRejectNotification()
    var
        Notification: Notification;
        LeaveReq: Record ZYNLeaveRequest;
        LeaveDays: Integer;
    begin
        LeaveReq.Reset();
        LeaveReq.SetRange(Status, LeaveReq.Status::Rejected);
        LeaveReq.SetCurrentKey(SystemModifiedAt);
        LeaveReq.SetAscending(SystemModifiedAt, true);

        Clear(Notification);
        Notification.Id := 'CDEF7880-ABCD-0123-1234-567890ABCDEF';
        Notification.Scope := NotificationScope::LocalScope;

        if LeaveReq.FindLast() then begin
            LeaveDays := LeaveReq."End Date" - LeaveReq."Start Date" + 1;
            Notification.Message := StrSubstNo(
                'Last rejected request: %1 for %2 days.',
                LeaveReq."Employee ID", LeaveDays
            );
        end else
            Notification.Message := 'No rejected leave requests found!';

        Notification.Send();
    end;

    // ======================================
    // Show notification for pending leaves
    // ======================================
    procedure ShowLeavePendingNotification()
    var
        Notification: Notification;
        LeaveReq: Record ZYNLeaveRequest;
        PendingCount: Integer;
    begin
        LeaveReq.Reset();
        LeaveReq.SetRange(Status, LeaveReq.Status::Pending);
        LeaveReq.SetCurrentKey(SystemModifiedAt);
        LeaveReq.SetAscending(SystemModifiedAt, true);

        Clear(Notification);
        Notification.Id := 'CDEF7870-ABCD-0123-1234-567890ABCDEF';
        Notification.Scope := NotificationScope::LocalScope;

        PendingCount := LeaveReq.Count;

        if LeaveReq.FindSet() then
            Notification.Message := StrSubstNo('Pending requests: %1', PendingCount)
        else
            Notification.Message := 'No pending leave requests found!';

        Notification.Send();
    end;
}
