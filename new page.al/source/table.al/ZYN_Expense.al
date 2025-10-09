table 50180 ZYN_Expenses
{
    Caption = 'Expenses';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Expense ID"; Code[20])
        {
            Caption = 'Expense ID';
            ToolTip = 'Unique identifier for the expense record.';
            DataClassification = ToBeClassified;
        }

        field(2; Description; Text[30])
        {
            Caption = 'Description';
            ToolTip = 'Brief description of the expense.';
            DataClassification = ToBeClassified;
        }

        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
            ToolTip = 'Amount spent for this expense.';
            DataClassification = ToBeClassified;
        }

        field(5; Date; Date)
        {
            Caption = 'Expense Date';
            ToolTip = 'Date when the expense occurred.';
            DataClassification = ToBeClassified;
        }

        field(16; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            ToolTip = 'Used for filtering expenses in flowfield calculations.';
            FieldClass = FlowFilter;
        }

        field(4; Category; Code[30])
        {
            Caption = 'Category';
            ToolTip = 'Category of the expense (linked to budget).';
            DataClassification = ToBeClassified;
            TableRelation = ZYN_ExpenseCatagoryTable.Name;

            trigger OnValidate()
            var
                Expenses: Record ZYN_Expenses;       // same as table name
                ZYNBudgetTable: Record ZYNBudgetTable; // same as table name
                TotalExpense: Decimal;
                StartDate: Date;
                EndDate: Date;
            begin
                StartDate := CalcDate('<-CM>', WorkDate());
                EndDate := CalcDate('<CM>', WorkDate());

                // Calculate total expenses for the category in current month
                Expenses.Reset();
                Expenses.SetRange(Category, Rec.Category);
                Expenses.SetRange(Date, StartDate, EndDate);
                if Expenses.FindSet() then
                    repeat
                        TotalExpense += Expenses.Amount;
                    until Expenses.Next() = 0;

                // Retrieve corresponding budget and calculate remaining
                ZYNBudgetTable.Reset();
                ZYNBudgetTable.SetRange("From Date", StartDate);
                ZYNBudgetTable.SetRange("To Date", EndDate);
                ZYNBudgetTable.SetRange("Catagory Name", Rec.Category);

                if ZYNBudgetTable.FindFirst() then
                    Rec."Remaining Budget" := ZYNBudgetTable.Amount - TotalExpense
                else
                    Rec."Remaining Budget" := -TotalExpense;
            end;
        }

        field(6; "Remaining Budget"; Decimal)
        {
            Caption = 'Remaining Budget';
            ToolTip = 'Displays the remaining budget for the expense category in the current month.';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Expense ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Category", Date, Amount) { }
    }

    // Auto-generate Expense ID if not provided
    trigger OnInsert()
    var
        Expenses: Record ZYN_Expenses; // variable same as table
        LastID: Integer;
    begin
        if "Expense ID" = '' then begin
            if Expenses.FindLast() then
                Evaluate(LastID, CopyStr(Expenses."Expense ID", 8))
            else
                LastID := 0;

            LastID += 1;
            "Expense ID" := 'EXPENSE' + PadStr(Format(LastID), 3, '0');
        end;
    end;

    // Delete all matching expense records on delete
    trigger OnDelete()
    var
        Expenses: Record ZYN_Expenses; // variable same as table
    begin
        Expenses.SetRange("Expense ID", "Expense ID");
        if Expenses.FindSet() then
            Expenses.DeleteAll();
    end;
}
