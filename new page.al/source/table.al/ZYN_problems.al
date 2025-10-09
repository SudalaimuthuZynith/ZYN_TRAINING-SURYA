table 50120 ZYNProblems
{
    Caption = 'Customer Problems';
    DataClassification = ToBeClassified;

    fields
    {
        field(9; entryno; Integer)
        {
            Caption = 'Entry No.';
            Tooltip = 'Unique sequential number for each problem record.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(1; cust_id; Code[20])
        {
            Caption = 'Customer ID';
            Tooltip = 'Specifies the customer reporting the problem.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            Editable = false;
        }

        field(2; cust_name; Text[20])
        {
            Caption = 'Customer Name';
            Tooltip = 'Name of the customer reporting the problem.';
            DataClassification = ToBeClassified;
        }

        field(3; phone_no; Code[20])
        {
            Caption = 'Phone No.';
            Tooltip = 'Phone number of the customer.';
            DataClassification = ToBeClassified;
        }

        field(4; problems; Enum problems)
        {
            Caption = 'Problem Type';
            Tooltip = 'Specifies the type of problem reported.';
            DataClassification = ToBeClassified;
        }

        field(5; description; Text[100])
        {
            Caption = 'Description';
            Tooltip = 'Detailed description of the problem reported.';
            DataClassification = ToBeClassified;
        }

        field(6; tech_id; Code[20])
        {
            Caption = 'Technician ID';
            Tooltip = 'ID of the technician assigned to solve the problem.';
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
}
