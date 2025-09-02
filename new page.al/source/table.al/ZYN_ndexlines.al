table 50134 IndexLines
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; entryno; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(3; year; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(4; percentage; Decimal)
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(Key1; Code, entryno)
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