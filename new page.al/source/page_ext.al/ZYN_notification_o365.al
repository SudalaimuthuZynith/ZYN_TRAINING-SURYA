pageextension 50182 "rolecenter notification" extends "O365 Activities"
{
    
    trigger OnOpenPage()
    var
        MyNotifMgt: Codeunit "My Notification Mgt";
    begin
        MyNotifMgt.ShowLeaveBalanceNotification();
        MyNotifMgt.ShowLeaveRejectNotification();
        MyNotifMgt.ShowLeavePendingNotification();
    end;
}