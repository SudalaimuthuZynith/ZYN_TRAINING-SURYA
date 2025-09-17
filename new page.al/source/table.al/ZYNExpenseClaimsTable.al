table 50234 ZYNExpenseClaimsTable
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
            trigger OnValidate()
            var
                expcat: Record ZYNExpenseCatagoryTable;
            begin
                expcat.Reset();
                expcat.SetRange(Catagory, Rec."Catagory Name");


                if PAGE.RunModal(Page::ZYNExpenseCatagoryListPage, expcat) = ACTION::LookupOK then
                    Rec."Subtype" := expcat.Name;
            end;

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
            CalcFormula = sum(ZYNExpenseClaimsTable.Amount where("Employee ID" = field("Employee ID"), "Catagory Name" = field("Catagory Name"), Subtype = field(Subtype), Status = const(Approved), "Date Filter" = field("Date Filter")));
        }
        field(13; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(11; "Subtype Limit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Remaining Amount";Decimal)
        {
            DataClassification=ToBeClassified;
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
    }

    keys
    {
        key(Key1; "Expense ID")
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
    var
        Expense: Record ZYNExpenseClaimsTable;
        Lastid: Integer;
    begin
        if "Expense ID" = '' then begin
            if expense.FindLast() then
                Evaluate(lastid, CopyStr(expense."Expense ID", 8))
            else
                lastid := 0;
            Lastid += 1;
            "Expense ID" := 'EXPENSE' + PadStr(Format(lastid), 3, '0');
        end;
    end;

   

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

   






}



enum 50234 claimstatus
{
    value(1; Pending) { }
    value(2; Approved) { }
    value(3; Rejected) { }
    value(4; Cancelled) { }
}