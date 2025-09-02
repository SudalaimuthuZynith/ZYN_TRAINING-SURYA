table 50179 income
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Income ID"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(5; Date; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(4; Catagory; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = IncomeCatagoryTable.Name;

        }
        // field(6; "Category Name"; Text[100])
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = lookup(ExpenseCatagoryTable.Name where("Catagory ID" = field(Catagory)));
        // }

    }

    keys
    {
        key(Key1; "Income ID")
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
        Expense: Record income;
        
        Lastid: Integer;
    begin
        if "Income ID" = '' then begin
            if expense.FindLast() then
                Evaluate(lastid, CopyStr(expense."Income ID", 8))
            else
                lastid := 0;
            Lastid += 1;
            "Income ID" := 'INCOMEE' + PadStr(Format(lastid), 3, '0');
        end;
        
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()

    var
        Expense: Record income;
    begin
        Expense.SetRange("Income ID", "Income ID");
        if Expense.FindSet() then
            Expense.DeleteAll();

    end;

    trigger OnRename()
    begin

    end;

}