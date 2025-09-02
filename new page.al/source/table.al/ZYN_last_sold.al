table 50112 "last sold"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Item No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Item Price"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "document no"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; entryno; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Pk; "Customer No", "Item No")
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