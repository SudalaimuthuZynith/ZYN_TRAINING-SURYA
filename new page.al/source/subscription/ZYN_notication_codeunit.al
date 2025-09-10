codeunit 50233 ZYN_notifysubscriptionrenewal
{
    Subtype = Normal;

    trigger OnRun()
    var
        Sub: Record ZYN_PlanSubscriptionTable;
        Plan: Record ZYN_PlanTable;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NextDate: Date;
        notification: Notification;
    begin
        Sub.SetRange("Remainder Date", WorkDate());

        if Sub.FindSet() then
            repeat
                Sub."Remainder send" := true;
                Sub.Modify(true);
                Clear(Notification);
                Notification.Id := CreateGuid();
                //Notification.Id := 'CDEF7890-ABCD-0123-1234-567890ABCDEF';
                Notification.Scope := NotificationScope::LocalScope;
                Notification.Message :=
                    StrSubstNo('subscriptions remainder for %1', Sub."Subscription ID");
                Notification.Send();
            until Sub.Next() = 0
        else begin
            Clear(Notification);

            Notification.Id := 'CDEF7890-ABCD-0123-1234-567890ABCDEF';
            Notification.Scope := NotificationScope::LocalScope;
            Notification.Message := 'No subscriptions';
            Notification.Send();
        end;
    end;
}
