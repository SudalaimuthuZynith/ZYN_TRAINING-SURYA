table 50186 ZYNEmployee
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Department; Enum Department)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Role; Text[100])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Employee ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var
        employeetable: Record ZYNEmployee;

        Lastid: Integer;
    begin
        if "Employee ID" = '' then begin
            if employeetable.FindLast() then
                Evaluate(lastid, CopyStr(employeetable."Employee ID", 4))
            else
                lastid := 0;
            Lastid += 1;
            "Employee ID" := 'Emp' + PadStr(Format(lastid), 3, '0');
        end;

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
enum 50155 Department
{
    value(1; Developer) { }
    value(2; HR) { }
    value(3; Finance) { }
}