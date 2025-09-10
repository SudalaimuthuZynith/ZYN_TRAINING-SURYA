pageextension 50182 "rolecenter notification" extends "O365 Activities"
{

    trigger OnOpenPage()
    var
        MyNotifMgt: Codeunit "My Notification Mgt";
        mynotify: Codeunit ZYN_notifysubscriptionrenewal;
    begin
        MyNotifMgt.ShowLeaveBalanceNotification();
        MyNotifMgt.ShowLeaveRejectNotification();
        MyNotifMgt.ShowLeavePendingNotification();
        mynotify.Run();
    end;
}
