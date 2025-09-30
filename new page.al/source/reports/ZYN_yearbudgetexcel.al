report 50161 "Export Budget vs Actual"
{
    Caption = 'Export Budget vs Actual';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(content)
            {
                field(SelectedYear; SelectedYear)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Enter the year (e.g., 2025) to export Actuals vs Budget per Category, per Month.';
                }
            }
        }
    }

    var
        SelectedYear: Integer;
        StartDate: Date;
        EndDate: Date;
        ExcelBuf: Record "Excel Buffer" temporary;
        Expense: Record Expenses;
        Budget: Record ZYNBudgetTable;
        Category: Record ZYNExpenseCatagory;
        income: Record income;
        MonthStart: Date;
        MonthEnd: Date;
        MonthNo: Integer;
        TotalExpense: Decimal;
        BudgetAmount: Decimal;
        Total: Decimal;
        TotalIncome: Decimal;
        Savings: Decimal;

    trigger OnPostReport()
    begin
        if SelectedYear = 0 then
            Error('Please enter a valid Year.');

        StartDate := DMY2DATE(1, 1, SelectedYear);
        EndDate := DMY2DATE(31, 12, SelectedYear);

        Clear(ExcelBuf);

        // Header row
        ExcelBuf.AddColumn('Month', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Category', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Budget', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Expense', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Total Expense', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Income', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Savings', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;

        for MonthNo := 1 to 12 do begin
            MonthStart := DMY2DATE(1, MonthNo, SelectedYear);
            MonthEnd := CalcDate('<CM>', MonthStart);
            ExcelBuf.AddColumn(Format(MonthStart, 0, '<Month Text>'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.NewRow();
            if Category.FindSet() then
                repeat
                    BudgetAmount := 0;
                    Budget.Reset();
                    Budget.SetRange("Catagory Name", Category.Name);
                    Budget.SetRange("From Date", MonthStart, MonthEnd);
                    if Budget.FindFirst() then
                        BudgetAmount := Budget.Amount;
                    TotalIncome := 0;
                    income.Reset();
                    income.SetRange(Date, MonthStart, MonthEnd);
                    if income.FindSet() then
                        repeat
                            TotalIncome += income.Amount;
                        until income.Next() = 0;
                    TotalExpense := 0;
                    Expense.Reset();
                    Expense.SetRange(Catagory, Category.Name);
                    Expense.SetRange(Date, MonthStart, MonthEnd);
                    if Expense.FindSet() then
                        repeat
                            TotalExpense += Expense.Amount;
                        until Expense.Next() = 0;
                    Total := 0;
                    Expense.Reset();
                    Expense.SetRange(Date, MonthStart, MonthEnd);
                    if Expense.FindSet() then
                        repeat
                            Total += Expense.Amount;
                        until Expense.Next() = 0;
                    Savings := TotalIncome - Total;
                    ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Category.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(BudgetAmount, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(TotalExpense, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.NewRow;
                until Category.Next() = 0;
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(Total, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(TotalIncome, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(Savings, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.NewRow;

        end;

        ExcelBuf.CreateNewBook('Budget vs Actual Report');
        ExcelBuf.WriteSheet('Report', CompanyName, UserId);
        ExcelBuf.CloseBook;
        ExcelBuf.SetFriendlyFilename(StrSubstNo('BudgetVsActual_%1.xlsx', SelectedYear));
        ExcelBuf.OpenExcel;
    end;
}
