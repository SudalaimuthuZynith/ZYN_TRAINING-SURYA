table 50134 ZYN_IndexLines
{
    Caption = 'Index Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Index Code';
            Tooltip = 'Specifies the code of the index this line belongs to.';
            DataClassification = ToBeClassified;
        }

        field(2; entryno; Integer)
        {
            Caption = 'Entry No.';
            Tooltip = 'Sequential number of the index line.';
            DataClassification = ToBeClassified;
        }

        field(3; year; Integer)
        {
            Caption = 'Year';
            Tooltip = 'The year corresponding to this index line.';
            DataClassification = ToBeClassified;
        }

        field(4; percentage; Decimal)
        {
            Caption = 'Percentage';
            Tooltip = 'The percentage value for this index line.';
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
}
