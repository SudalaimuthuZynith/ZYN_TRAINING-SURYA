table 50129 ZYNlog
{
    Caption = 'ZYN Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(9; entryNo; Integer)
        {
            Caption = 'Entry No.';
            Tooltip = 'Unique sequential number for each log entry.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(1; customer_no; Code[20])
        {
            Caption = 'Customer No.';
            Tooltip = 'Specifies the customer related to this log entry.';
            DataClassification = ToBeClassified;
        }

        // field(2; Name; Text[20])
        // {
        //     DataClassification = ToBeClassified;
        // }

        field(3; fieldname; Text[250])
        {
            Caption = 'Field Name';
            Tooltip = 'Specifies the name of the field that was changed.';
            DataClassification = ToBeClassified;
        }

        field(4; oldvalue; Text[250])
        {
            Caption = 'Old Value';
            Tooltip = 'Stores the previous value of the field before the change.';
            DataClassification = ToBeClassified;
        }

        field(5; newvalue; Text[250])
        {
            Caption = 'New Value';
            Tooltip = 'Stores the new value of the field after the change.';
            DataClassification = ToBeClassified;
        }

        field(6; user_id; Code[10])
        {
            Caption = 'User ID';
            Tooltip = 'Specifies the ID of the user who made the change.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PRK; entryNo)
        {
            Clustered = true;
        }
    }
}
