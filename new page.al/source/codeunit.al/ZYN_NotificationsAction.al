codeunit 50104 "My Notification Actions"
{
    // Opens the leave request list page
    procedure OpenLeaveBalance(Notification: Notification)
    var
        ZYNLeaveRequestListPage: Page ZYNLeaveRequestList;
    begin
        ZYNLeaveRequestListPage.Run();
    end;
}
