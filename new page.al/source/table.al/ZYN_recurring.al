table 50176 recurring_expense
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Recurring ID"; code[20])
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
        field(10; "Period"; Enum duration)
        {

        }
        field(5; " StarDate"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Recurr: Record "Recurring_Expense";
            begin
                if Period = Period::Weekly then begin
                    Rec."Next Cycle Date" := CalcDate('1W', " StarDate")
                end;
                if Period = Period::Monthly then begin
                    Rec."Next Cycle Date" := CalcDate('1M', " StarDate")
                end;
                if Period = Period::Quarterly then begin
                    Rec."Next Cycle Date" := CalcDate('3M', " StarDate")
                end;
                if Period = Period::Half then begin
                    Rec."Next Cycle Date" := CalcDate('6M', " StarDate")
                end;
                if Period = Period::Yearly then begin
                    Rec."Next Cycle Date" := CalcDate('12M', " StarDate")
                end;
            end;


        }
        field(11; "Next Cycle Date"; Date)
        {

        }
        field(4; Catagory; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = ExpenseCatagoryTable.Name;

        }
        // field(6; "Category Name"; Text[100])
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = lookup(ExpenseCatagoryTable.Name where("Catagory ID" = field(Catagory)));
        // }

    }

    keys
    {
        key(Key1; "Recurring ID")
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
        Expense: Record recurring_expense;

        Lastid: Integer;
    begin
        if "Recurring ID" = '' then begin
            if expense.FindLast() then
                Evaluate(lastid, CopyStr(expense."Recurring ID", 10))
            else
                lastid := 0;
            Lastid += 1;
            "Recurring ID" := 'RECURRING' + PadStr(Format(lastid), 3, '0');
        end;

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()

    var
        Expense: Record recurring_expense;
    begin
        Expense.SetRange("Recurring ID", "Recurring ID");
        if Expense.FindSet() then
            Expense.DeleteAll();

    end;

    trigger OnRename()
    begin

    end;

}

enum 50188 duration
{
    value(1; Weekly) { }
    value(2; Monthly) { }
    value(3; Quarterly) { }
    value(4; Half) { }
    value(5; Yearly) { }
}