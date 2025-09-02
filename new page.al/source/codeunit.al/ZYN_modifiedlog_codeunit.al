codeunit 50123 modifylogt
{
    [EventSubscriber(ObjectType::Table, database::Customer, OnAfterModifyEvent, '', true, true)]
    local procedure checkcall(var Rec: Record Customer; var xRec: Record Customer)
    var
        recref: RecordRef;
        xrecref: RecordRef;
        fieldref: FieldRef;
        xfieldref: FieldRef;
        i: Integer;
        changelog: Record logtable;
        userid: Code[20];
    begin
        recref.GetTable(Rec);
        xrecref.GetTable(xRec);
    
        for i := 1 to recref.FieldCount do begin
            fieldref := recref.FieldIndex(i);
            xfieldref := xrecref.FieldIndex(i);
            if fieldref.Value <> xfieldref.Value then begin
                Clear(changelog);
                changelog.Init();
                changelog.customer_no := Rec."No.";
                changelog.fieldname := CopyStr(fieldref.Name, 1, MaxStrLen(changelog.fieldname));
                changelog.oldvalue := CopyStr(Format(xfieldref.Value), 1, MaxStrLen(changelog.oldvalue));
                changelog.newvalue := CopyStr(Format(fieldref.Value), 1, MaxStrLen(changelog.newvalue));
                changelog.user_id := userid;
                changelog.Insert()
            end;
        end;
    end;
}