table 50234 ZYN_ExpenseClaimsTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Expense ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee ID"; Code[20])
        {
            TableRelation = EmployeeTable;
            DataClassification = ToBeClassified;

        }
        field(3; "Catagory Name"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Subtype"; Text[20])
        {

        }

        field(10; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Claimed Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum(ZYN_ExpenseClaimsTable.Amount where("Employee ID" = field("Employee ID"), "Catagory Name" = field("Catagory Name"), Subtype = field(Subtype), Status = const(Approved), "Date Filter" = field("Date Filter")));
        }
        field(13; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(11; "Subtype Limit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Remaining Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Claim Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Bill Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Bill"; Blob) // <--- Upload field
        {
            SubType = Bitmap;   // allows file (image/pdf) upload
            DataClassification = CustomerContent;

        }
        field(7; "Remarks"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; Enum claimstatus)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Rejection Reason"; Text[250])
        {
            Caption = 'Rejection Reason';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
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
        //Automaticlly increments expense id
        if "Expense ID" = '' then begin
            if ZYN_ExpenseClaimsTable.FindLast() then
                Evaluate(lastid, CopyStr(ZYN_ExpenseClaimsTable."Expense ID", 8))
            else
                lastid := 0;
            Lastid += 1;
            "Expense ID" := 'EXPENSE' + PadStr(Format(lastid), 3, '0');
        end;
    end;
}



