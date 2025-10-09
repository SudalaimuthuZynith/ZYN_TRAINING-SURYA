table 50112 ZYN_LastSold
{
    Caption = 'Last Sold';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No"; Code[20])
        {
            Caption = 'Customer No.';
            Tooltip = 'Specifies the unique number of the customer who purchased the item.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No."; // Optional: Link to Customer table
        }

        field(2; "Item No"; Code[20])
        {
            Caption = 'Item No.';
            Tooltip = 'Specifies the unique number of the item sold.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No."; // Optional: Link to Item table
        }

        field(3; "Item Price"; Decimal)
        {
            Caption = 'Item Price';
            Tooltip = 'Specifies the price at which the item was sold.';
            DataClassification = ToBeClassified;
        }

        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Tooltip = 'Specifies the date when the item was posted as sold.';
            DataClassification = ToBeClassified;
        }

        field(5; "Document No"; Code[20])
        {
            Caption = 'Document No.';
            Tooltip = 'Specifies the document number related to this sale, such as an invoice number.';
            DataClassification = ToBeClassified;
        }

        field(6; "Entry No"; Integer)
        {
            Caption = 'Entry No.';
            Tooltip = 'Specifies the unique sequential number of the record.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(PK; "Customer No", "Item No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Customer No", "Item No", "Item Price", "Posting Date")
        {
            // Shows key fields in lookups for quick identification
        }
    }
}
