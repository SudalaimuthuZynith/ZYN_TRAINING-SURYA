table 50188 EmployeeAssetListTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee"; Code[200])
        {
            DataClassification = ToBeClassified;
            TableRelation = EmployeeTable."Employee ID";
        }
        field(2; "serial no"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = AssetsListTable."Serial No";
            trigger OnValidate()
            var
                emp: Record AssetsListTable;
            begin

                emp.SetRange("Serial No", Rec."serial no");
                if emp.FindFirst() then
                    Rec."Asset Type" := emp."Asset type";
            end;
        }
        field(55; "Asset Type"; Text[30])
        {
            DataClassification = ToBeClassified;

        }

        field(3; status; Enum assetstatus)
        {
            DataClassification = SystemMetadata;
            trigger OnValidate()
            begin

            end;
        }
        field(4; "Assigned date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Returned date date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Lost date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Employee, "serial no",status)
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
    begin

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
enum 50169 "assetstatus"
{
    value(1; assigned) { }
    value(2; returned) { }
    value(3; lost) { }
}
