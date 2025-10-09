table 50176 ZYNRecurringExpense
{
    Caption = 'Recurring Expense';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Recurring ID"; Code[20])
        {
            Caption = 'Recurring ID';
            Tooltip = 'Unique identifier for each recurring expense.';
            DataClassification = ToBeClassified;
        }

        field(2; Description; Text[30])
        {
            Caption = 'Description';
            Tooltip = 'Description of the recurring expense.';
            DataClassification = ToBeClassified;
        }

        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
            Tooltip = 'Amount for each recurrence.';
            DataClassification = ToBeClassified;
        }

        field(10; "Period"; Enum duration)
        {
            Caption = 'Period';
            Tooltip = 'Recurrence period (Weekly, Monthly, etc.).';
        }

        field(5; " StarDate"; Date)
        {
            Caption = 'Start Date';
            Tooltip = 'Start date of the recurring expense. Automatically calculates next cycle date based on the period.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ZYNRecurringExpense: Record ZYNRecurringExpense;
            begin
                // Calculate Next Cycle Date based on selected period
                if Period = Period::Weekly then
                    ZYNRecurringExpense."Next Cycle Date" := CalcDate('1W', " StarDate");
                if Period = Period::Monthly then
                    ZYNRecurringExpense."Next Cycle Date" := CalcDate('1M', " StarDate");
                if Period = Period::Quarterly then
                    ZYNRecurringExpense."Next Cycle Date" := CalcDate('3M', " StarDate");
                if Period = Period::Half then
                    ZYNRecurringExpense."Next Cycle Date" := CalcDate('6M', " StarDate");
                if Period = Period::Yearly then
                    ZYNRecurringExpense."Next Cycle Date" := CalcDate('12M', " StarDate");
            end;
        }

        field(11; "Next Cycle Date"; Date)
        {
            Caption = 'Next Cycle Date';
            Tooltip = 'Next scheduled date for this recurring expense.';
        }

        field(4; Catagory; Code[30])
        {
            Caption = 'Category';
            Tooltip = 'Category of the recurring expense.';
            DataClassification = ToBeClassified;
            TableRelation = "ZYN Expense Category".Name;
        }

        // Uncomment and use this FlowField if you want to display Category Name
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

    var
        myInt: Integer;

    trigger OnInsert()
    var
        ZYNRecurringExpense: Record ZYNRecurringExpense;
        Lastid: Integer;
    begin
        // Auto-generate Recurring ID if empty
        if "Recurring ID" = '' then begin
            if ZYNRecurringExpense.FindLast() then
                Evaluate(Lastid, CopyStr(ZYNRecurringExpense."Recurring ID", 10))
            else
                Lastid := 0;

            Lastid += 1;
            "Recurring ID" := 'RECURRING' + PadStr(Format(Lastid), 3, '0');
        end;
    end;

    trigger OnDelete()
    var
        ZYNRecurringExpense: Record ZYNRecurringExpense;
    begin
        // Delete all entries with the same Recurring ID
        ZYNRecurringExpense.SetRange("Recurring ID", "Recurring ID");
        if ZYNRecurringExpense.FindSet() then
            ZYNRecurringExpense.DeleteAll();
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
