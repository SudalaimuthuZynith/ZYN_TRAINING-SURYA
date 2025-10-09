table 50234 ZYN_ExpenseClaimsTable
{
    Caption = 'Expense Claims';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Expense ID"; Code[20])
        {
            Caption = 'Expense ID';
            Tooltip = 'Unique identifier for each expense claim.';
            DataClassification = ToBeClassified;
        }

        field(2; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            Tooltip = 'Employee who submitted the expense claim.';
            TableRelation = ZYNEmployee;
            DataClassification = ToBeClassified;
        }

        field(3; "Catagory Name"; Text[20])
        {
            Caption = 'Category Name';
            Tooltip = 'Category of the claimed expense.';
            DataClassification = ToBeClassified;
        }

        field(4; "Subtype"; Text[20])
        {
            Caption = 'Subtype';
            Tooltip = 'Subtype of the claimed expense.';
        }

        field(10; Amount; Decimal)
        {
            Caption = 'Amount';
            Tooltip = 'Amount claimed for this expense.';
            DataClassification = ToBeClassified;
        }

        field(12; "Claimed Amount"; Decimal)
        {
            Caption = 'Claimed Amount';
            Tooltip = 'Total claimed amount filtered by employee, category, subtype, and date.';
            FieldClass = FlowField;
            CalcFormula = sum(
                ZYN_ExpenseClaimsTable.Amount
                where("Employee ID" = field("Employee ID"),
                      "Catagory Name" = field("Catagory Name"),
                      Subtype = field(Subtype),
                      Status = const(Approved),
                      "Date Filter" = field("Date Filter"))
            );
        }

        field(13; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Tooltip = 'Filter field for FlowFields calculations.';
            FieldClass = FlowFilter;
        }

        field(11; "Subtype Limit Amount"; Decimal)
        {
            Caption = 'Subtype Limit Amount';
            Tooltip = 'Maximum allowed amount for this subtype.';
            DataClassification = ToBeClassified;
        }

        field(14; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            Tooltip = 'Remaining amount that can be claimed.';
            DataClassification = ToBeClassified;
        }

        field(5; "Claim Date"; Date)
        {
            Caption = 'Claim Date';
            Tooltip = 'Date when the expense was claimed.';
            DataClassification = ToBeClassified;
        }

        field(6; "Bill Date"; Date)
        {
            Caption = 'Bill Date';
            Tooltip = 'Date on the bill submitted with the claim.';
            DataClassification = ToBeClassified;
        }

        field(9; "Bill"; Blob)
        {
            Caption = 'Bill';
            Tooltip = 'Upload field for supporting bill (image/pdf).';
            SubType = Bitmap;
            DataClassification = CustomerContent;
        }

        field(7; "Remarks"; Text[30])
        {
            Caption = 'Remarks';
            Tooltip = 'Additional remarks for the claim.';
            DataClassification = ToBeClassified;
        }

        field(8; Status; Enum claimstatus)
        {
            Caption = 'Status';
            Tooltip = 'Current status of the claim.';
            DataClassification = ToBeClassified;
        }

        field(20; "Rejection Reason"; Text[250])
        {
            Caption = 'Rejection Reason';
            Tooltip = 'Reason for claim rejection, if applicable.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Primary key ensures unique expense claim
        key(Key1; "Expense ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        ZYN_ExpenseClaimsTable: Record ZYN_ExpenseClaimsTable;
        Lastid: Integer;
    begin
        // Automatically generates Expense ID if empty
        if "Expense ID" = '' then begin
            if ZYN_ExpenseClaimsTable.FindLast() then
                Evaluate(Lastid, CopyStr(ZYN_ExpenseClaimsTable."Expense ID", 8))
            else
                Lastid := 0;
            Lastid += 1;
            "Expense ID" := 'EXPENSE' + PadStr(Format(Lastid), 3, '0');
        end;
    end;
}
