page 50127 "Field Selection Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTableTemporary = true;
    SourceTable = "Field Buffer Storage";

    layout
    {
        area(Content)
        {
            group(tables)
            {
                field(Tablename; Tablename)
                {
                    ApplicationArea = All;
                    TableRelation = "AllObjWithCaption"."Object ID" where("Object Type" = const(Table));
                }

                field(RecordField; RecordField)
                {
                    ApplicationArea = All;
                    TableRelation = "Field Buffer Storage"."Field Name";
                }
                field(Value; Value)
                {
                    ApplicationArea = All;
                    TableRelation = "Field Value Buffer"."Field Value";
                }
                field(newvalue; newvalue)
                {
                    ApplicationArea = all;

                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(refresh)
            {
                action(RefreshValues)
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        fieldbuff();
                    end;
                }
                action(Refreshfields)
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        fieldbuff();
                        PopulateFieldValueBuffer();
                    end;
                }
                action(UpdateFieldValue)
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        fieldbuff();
                        PopulateFieldValueBuffer();
                        modifyvalue();
                    end;
                }
            }
        }
    }
    var
        Tablename: Integer;
        RecordField: Text[250];
        Value: Text[1000];
        id: Integer;
        recordid: RecordId;
        recordvalue: RecordId;
        newvalue: Text[1000];
    procedure fieldbuff()
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        i: Integer;
        FieldStorage: Record "Field Buffer Storage";
    begin
        FieldStorage.DeleteAll();
        RecRef.Open(Tablename);
        for i := 1 to RecRef.FieldCount do begin
            FieldRef := RecRef.FieldIndex(i);
            if FieldRef.Name <> '' then begin
                FieldStorage.Init();
                FieldStorage."Field Name" := FieldRef.Name;
                FieldStorage.Insert(true);
            end;
            if FieldRef.Name = RecordField then begin
                id := FieldRef.Number;
                exit;
            end
        end;
        RecRef.Close();
    end;
    procedure PopulateFieldValueBuffer()
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValueBuffer: Record "Field Value Buffer";
    begin
        FieldValueBuffer.DeleteAll();
        RecRef.Open(Tablename);
        if RecRef.FindSet() then begin
            repeat
                FieldRef := RecRef.Field(id);
                if Format(FieldRef.Value) <> '' then begin
                    FieldValueBuffer.Init();
                    FieldValueBuffer."Field Value" := Format(FieldRef.Value);
                    FieldValueBuffer.recordid := RecRef.RecordId;
                    FieldValueBuffer.Insert(true);
                end;
                if Format(FieldRef.Value) = Value then begin
                    recordvalue := FieldValueBuffer.recordid;
                    exit;
                end
            until RecRef.Next() = 0;
        end;
        RecRef.Close();
    end;
    procedure modifyvalue()
    var
        recref: RecordRef;
        fieldref: FieldRef;
    begin
        recref.Open(Tablename);
        if (recref.Get(recordvalue)) then begin
            fieldref := recref.Field(id);
            fieldref.Value := newvalue;
            recref.Modify();
            exit;
        end;
        recref.Close();
    end;
}
















// procedure SetFieldID()
// var
//     RecRef: RecordRef;
//     FieldRef: FieldRef;
//     i: Integer;
// begin
//     RecRef.Open(Tablename);
//     for i := 1 to RecRef.FieldCount do begin
//         FieldRef := RecRef.FieldIndex(i);
//         if FieldRef.Name = RecordField then begin
//             id := FieldRef.Number;
//             exit;
//         end;
//     end;
//     RecRef.Close();
// end;




// procedure ModifyFieldValue(OldValue: Text[1000]; NewValue: Text[1000])
//     var
//         RecRef: RecordRef;
//         FieldRef: FieldRef;
//     begin
//         RecRef.Open(Tablename);
//         if RecRef.FindSet() then begin
//             repeat
//                 FieldRef := RecRef.Field(id);
//                 if Format(FieldRef.Value) = OldValue then begin
//                     FieldRef.Value := NewValue;
//                     RecRef.Modify();
//                 end;
//             until RecRef.Next() = 0;
//         end;
//         RecRef.Close();
//     end;