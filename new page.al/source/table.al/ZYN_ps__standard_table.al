table 50111 "ExtendedTextTable"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(2; "Document No."; Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(8; "Document Type"; Enum "Sales Document Type")
        {
            DataClassification = SystemMetadata;
        }

        field(3; "Language code"; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(4; Text; Text[1000])
        {
            DataClassification = CustomerContent;
        }

        field(5; "Lino No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; selection; Enum selection)
        {
            DataClassification = ToBeClassified;
        }

        // field(6; HeaderNo; Code[20])
        // {
        //     DataClassification = CustomerContent;
        // }
    }

    keys
    {
        key(PK; "Lino No.", "Document No.", "Language code", "Document Type", selection)
        {
            Clustered = true;
        }
    }
}

enum 50112 selection
{
    value(0; "begin text") { }
    value(1; "end text") { }
}
