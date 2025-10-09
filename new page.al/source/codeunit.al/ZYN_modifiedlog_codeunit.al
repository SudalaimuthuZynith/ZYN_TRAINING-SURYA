codeunit 50123 ModifyLogT
{
    // ======================================
    // Event Subscriber
    // ======================================
    [EventSubscriber(ObjectType::Table, Database::Customer, OnAfterModifyEvent, '', true, true)]
    local procedure CheckCall(var Rec: Record Customer; var xRec: Record Customer)
    begin
        LogCustomerChanges(Rec, xRec);
    end;

    // ======================================
    // Local Procedures
    // ======================================

    // Logs changes between modified Customer record and old record
    local procedure LogCustomerChanges(var Customer: Record Customer; var OldCustomer: Record Customer)
    var
        CustomerRef: RecordRef;
        OldCustomerRef: RecordRef;
        FieldRefCurr: FieldRef;
        FieldRefOld: FieldRef;
        i: Integer;
        ChangeLog: Record ZYNlog;
        UserID: Code[20];
    begin
        // Get record references for field-level comparison
        CustomerRef.GetTable(Customer);
        OldCustomerRef.GetTable(OldCustomer);

        // Loop through each field to detect changes
        for i := 1 to CustomerRef.FieldCount do begin
            FieldRefCurr := CustomerRef.FieldIndex(i);
            FieldRefOld := OldCustomerRef.FieldIndex(i);

            if FieldRefCurr.Value <> FieldRefOld.Value then begin
                // Clear and initialize changelog
                Clear(ChangeLog);
                ChangeLog.Init();
                
                ChangeLog.customer_no := Customer."No.";
                ChangeLog.fieldname := CopyStr(FieldRefCurr.Name, 1, MaxStrLen(ChangeLog.fieldname));
                ChangeLog.oldvalue := CopyStr(Format(FieldRefOld.Value), 1, MaxStrLen(ChangeLog.oldvalue));
                ChangeLog.newvalue := CopyStr(Format(FieldRefCurr.Value), 1, MaxStrLen(ChangeLog.newvalue));
                ChangeLog.user_id := UserID;

                ChangeLog.Insert();
            end;
        end;
    end;
}
