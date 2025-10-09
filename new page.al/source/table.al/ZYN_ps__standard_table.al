table 50111 ZYN_ExtendedTextTable
{
    Caption = 'Extended Text Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Tooltip = 'Specifies the document number associated with this text entry.';
            DataClassification = SystemMetadata;
        }

        field(8; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            Tooltip = 'Specifies the type of the sales document.';
            DataClassification = SystemMetadata;
        }

        field(3; "Language code"; Code[20])
        {
            Caption = 'Language Code';
            Tooltip = 'Specifies the language of the text entry.';
            DataClassification = CustomerContent;
        }

        field(4; Text; Text[1000])
        {
            Caption = 'Text';
            Tooltip = 'Contains the extended text associated with the document.';
            DataClassification = CustomerContent;
        }

        field(5; "Lino No."; Integer)
        {
            Caption = 'Line No.';
            Tooltip = 'Specifies the line number of the extended text entry.';
            DataClassification = CustomerContent;
        }

        field(11; selection; Enum selection)
        {
            Caption = 'Selection';
            Tooltip = 'Indicates whether this is the beginning or end of the text block.';
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
