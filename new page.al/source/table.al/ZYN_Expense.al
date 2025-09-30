table 50180 Expenses
{
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Expense ID"; code[20])
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
        field(16; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(4; Catagory; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = ZYNExpenseCatagory.Name;
            trigger OnValidate()
            var
                budget: Record ZYNBudgetTable;
                expense: Record Expenses;
                totalexpense: Decimal;
                startDate: Date;
                endDate: Date;
            begin
                startDate := CalcDate('<-CM>', WorkDate());
                endDate := CalcDate('<CM>', WorkDate());


                expense.Reset();
                expense.SetRange(Catagory, Rec.Catagory);
                expense.SetRange(Date, startDate, endDate);
                if expense.FindSet() then
                    repeat
                        totalexpense += expense.Amount;
                    until expense.Next() = 0;


                budget.Reset();
                budget.SetRange("From Date", startDate);
                budget.SetRange("To Date", endDate);
                budget.SetRange("Catagory Name", Rec.Catagory);

                if budget.FindFirst() then
                    Rec."Remaining Budget" := budget.Amount - totalexpense
                else
                    Rec."Remaining Budget" -= totalexpense;
            end;



        }
        field(6; "Remaining Budget"; Decimal)
        {
            Editable = false;
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
        Expense: Record Expenses;
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

    trigger OnModify()
    begin

    end;

    trigger OnDelete()

    var
        Expense: Record Expenses;
    begin
        Expense.SetRange("Expense ID", "Expense ID");
        if Expense.FindSet() then
            Expense.DeleteAll();

    end;

    trigger OnRename()
    begin

    end;

}