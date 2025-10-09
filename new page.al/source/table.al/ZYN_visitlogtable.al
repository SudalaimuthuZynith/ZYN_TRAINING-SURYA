table 50143 ZYN_Visitlog
{
    Caption = 'Visit Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Entryno; Integer)
        {
            Caption = 'Entry No.';
            Tooltip = 'Unique entry number for each visit log record.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(2; CustomerNo; Code[10])
        {
            Caption = 'Customer No.';
            Tooltip = 'Customer associated with this visit log entry.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            Editable = false;
        }

        field(3; Date; Date)
        {
            Caption = 'Visit Date';
            Tooltip = 'Date when the visit took place.';
            DataClassification = ToBeClassified;
        }

        field(4; purpose; Text[30])
        {
            Caption = 'Purpose';
            Tooltip = 'Purpose of the visit.';
            DataClassification = ToBeClassified;
        }

        field(5; notes; Text[30])
        {
            Caption = 'Notes';
            Tooltip = 'Additional notes regarding the visit.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Primary key: ensures unique entry per customer
        key(PK; Entryno, CustomerNo)
        {
            Clustered = true;
        }

        // Secondary key for reporting or filtering by date, purpose, and notes
        key(Datepurposenotes; Date, purpose, notes)
        {
            Clustered = false;
        }
    }
}
