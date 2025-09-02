table 50120 problems
{
    DataClassification = ToBeClassified;

    fields
    {
        field(9; entryno; integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(1; cust_id; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            Editable = false;

        }
        field(2; cust_name; Text[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; phone_no; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; problems; Enum problems)
        {
            DataClassification = ToBeClassified;

        }
        field(5; description; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(6; tech_id; Code[20])
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(PK; entryno)
        {
            Clustered = true;
        }
    }

    // fieldgroups
    // {
    //     // Add changes to field groups here
    // }

    // var
    //     myInt: Integer;

    // trigger OnInsert()
    // begin

    // end;

    // trigger OnModify()
    // begin

    // end;

    // trigger OnDelete()
    // begin

    // end;

    // trigger OnRename()
    // begin

    // end;

}



