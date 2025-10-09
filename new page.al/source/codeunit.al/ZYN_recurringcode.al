codeunit 50191 Recurring
{
    Subtype = Normal;

    trigger OnRun()
    var
        ZYNRecurringExpense: Record ZYNRecurringExpense;
    begin
        // Filter recurring expenses for today
        ZYNRecurringExpense.SetRange("Next Cycle Date", WorkDate());

        if ZYNRecurringExpense.FindSet() then begin
            repeat
                ProcessRecurringExpense(ZYNRecurringExpense);
            until ZYNRecurringExpense.Next() = 0;
        end;
    end;

    // =====================================================
    // Local procedure: Process each recurring expense
    // =====================================================
    local procedure ProcessRecurringExpense(var ZYNRecurringExpense: Record ZYNRecurringExpense)
    var
        ZYN_Expenses: Record ZYN_Expenses;
        NextDate: Date;
        CurrentCycleDate: Date;
        BaseDate: Date;
    begin
        // Determine the base date for this cycle
        if ZYNRecurringExpense."Next Cycle Date" = 0D then
            BaseDate := ZYNRecurringExpense." StarDate"
        else
            BaseDate := ZYNRecurringExpense."Next Cycle Date";

        CurrentCycleDate := BaseDate;

        // Calculate next cycle date based on period
        case ZYNRecurringExpense.Period of
            ZYNRecurringExpense.Period::Weekly:
                NextDate := CalcDate('1W', BaseDate);
            ZYNRecurringExpense.Period::Monthly:
                NextDate := CalcDate('1M', BaseDate);
            ZYNRecurringExpense.Period::Quarterly:
                NextDate := CalcDate('3M', BaseDate);
            ZYNRecurringExpense.Period::Half:
                NextDate := CalcDate('6M', BaseDate);
            ZYNRecurringExpense.Period::Yearly:
                NextDate := CalcDate('12M', BaseDate);
        end;

        // Create the expense record for this cycle
        CreateExpense(ZYNRecurringExpense, CurrentCycleDate);

        // Update next cycle date in recurring record
        ZYNRecurringExpense."Next Cycle Date" := NextDate;
        ZYNRecurringExpense.Modify(true);
    end;

    // =====================================================
    // Local procedure: Create expense from recurring record
    // =====================================================
    local procedure CreateExpense(ZYNRecurringExpense: Record ZYNRecurringExpense; CurrentCycleDate: Date)
    var
        ZYN_Expenses: Record ZYN_Expenses;
    begin
        ZYN_Expenses.Init();
        ZYN_Expenses.Category := ZYNRecurringExpense.Catagory;
        ZYN_Expenses.Description := ZYNRecurringExpense.Description;
        ZYN_Expenses.Amount := ZYNRecurringExpense.Amount;
        ZYN_Expenses.Date := CurrentCycleDate;
        ZYN_Expenses.Insert(true);
    end;
}
