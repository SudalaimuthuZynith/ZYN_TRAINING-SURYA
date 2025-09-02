codeunit 50191 Recurring
{
    Subtype = Normal;

    trigger OnRun()
    var
        recurr: Record recurring_expense;
        expense: Record Expenses;
        NextDate: Date;
        CurrentCycleDate: Date;
        BaseDate: Date;
    begin
        recurr.SetRange("Next Cycle Date", WorkDate());
        if recurr.FindSet() then begin
           repeat
            if recurr."Next Cycle Date" = 0D then
                BaseDate := recurr." StarDate"
            else
                BaseDate := recurr."Next Cycle Date";

            CurrentCycleDate := BaseDate;

            case recurr.Period of
                recurr.Period::Weekly:
                    NextDate := CalcDate('1W', BaseDate);
                recurr.Period::Monthly:
                    NextDate := CalcDate('1M', BaseDate);
                recurr.Period::Quarterly:
                    NextDate := CalcDate('3M', BaseDate);
                recurr.Period::Half:
                    NextDate := CalcDate('6M', BaseDate);
                recurr.Period::Yearly:
                    NextDate := CalcDate('12M', BaseDate);
            end;

            Clear(expense);
            expense.Init();
            expense.Catagory := recurr.Catagory;
            expense.Description := recurr.Description;
            expense.Amount := recurr.Amount;
            expense.Date := CurrentCycleDate;
            expense.Insert(true);

            recurr."Next Cycle Date" := NextDate;
            recurr.Modify(true);
           until recurr.Next()=0;
        end;
    end;
}

