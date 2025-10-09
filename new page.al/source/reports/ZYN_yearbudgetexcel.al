report 50161 ZYN_ExportBudgetvsActual
{
    Caption = 'Export Budget vs Actual';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    // --- Request Page for Year Input ---
    requestpage
    {
        layout
        {
            area(content)
            {
                field(SelectedYear; SelectedYear)
                {
                    Caption = 'Year';
                    ToolTip = 'Enter the year (e.g., 2025) to export Actuals vs Budget per Category, per Month.';
                }
            }
        }
    }

    // --- Variables ---
    var
        SelectedYear: Integer;              // Year entered by user
        StartDate: Date;                    // First day of the year
        EndDate: Date;                      // Last day of the year
        ExcelBuf: Record "Excel Buffer" temporary; // Excel buffer for export
        Expense: Record ZYN_Expenses;           // Expense records
        Budget: Record ZYNBudgetTable;      // Budget records
        Category: Record "ZYN Expense Category"; // Categories
        income: Record ZYN_Income;              // Income records
        MonthStart: Date;                   // Start date of month
        MonthEnd: Date;                     // End date of month
        MonthNo: Integer;                   // Month counter
        TotalExpense: Decimal;              // Expense total per category
        BudgetAmount: Decimal;              // Budget amount per category
        Total: Decimal;                     // Total expense for month
        TotalIncome: Decimal;               // Total income for month
        Savings: Decimal;                   // Savings = TotalIncome - Total

    // --- Trigger executed after report runs ---
    trigger OnPostReport()
    begin
        // Validate Year
        if SelectedYear = 0 then
            Error('Please enter a valid Year.');

        StartDate := DMY2DATE(1, 1, SelectedYear);
        EndDate := DMY2DATE(31, 12, SelectedYear);

        Clear(ExcelBuf);

        // --- Header Row ---
        ExcelBuf.AddColumn('Month', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Category', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Budget', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Expense', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Total Expense', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Income', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Savings', false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;

        // --- Loop through each month ---
        for MonthNo := 1 to 12 do begin
            MonthStart := DMY2DATE(1, MonthNo, SelectedYear);
            MonthEnd := CalcDate('<CM>', MonthStart);

            ExcelBuf.AddColumn(Format(MonthStart, 0, '<Month Text>'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.NewRow();

            // Loop through each Category
            if Category.FindSet() then
                repeat
                    // Get Budget Amount
                    BudgetAmount := 0;
                    Budget.Reset();
                    Budget.SetRange("Catagory Name", Category.Name);
                    Budget.SetRange("From Date", MonthStart, MonthEnd);
                    if Budget.FindFirst() then
                        BudgetAmount := Budget.Amount;

                    // Calculate Total Income for Month
                    TotalIncome := 0;
                    income.Reset();
                    income.SetRange(Date, MonthStart, MonthEnd);
                    if income.FindSet() then
                        repeat
                            TotalIncome += income.Amount;
                        until income.Next() = 0;

                    // Calculate Total Expense for Category
                    TotalExpense := 0;
                    Expense.Reset();
                    Expense.SetRange(Category, Category.Name);
                    Expense.SetRange(Date, MonthStart, MonthEnd);
                    if Expense.FindSet() then
                        repeat
                            TotalExpense += Expense.Amount;
                        until Expense.Next() = 0;

                    // Calculate Total Expense for Month
                    Total := 0;
                    Expense.Reset();
                    Expense.SetRange(Date, MonthStart, MonthEnd);
                    if Expense.FindSet() then
                        repeat
                            Total += Expense.Amount;
                        until Expense.Next() = 0;

                    // Calculate Savings
                    Savings := TotalIncome - Total;

                    // Add row to Excel
                    ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Category.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(BudgetAmount, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(TotalExpense, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.NewRow;
                until Category.Next() = 0;

            // --- Add Monthly Totals Row ---
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(Total, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(TotalIncome, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(Savings, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.NewRow;
        end;

        // --- Export to Excel ---
        ExcelBuf.CreateNewBook('Budget vs Actual Report');
        ExcelBuf.WriteSheet('Report', CompanyName, UserId);
        ExcelBuf.CloseBook;
        ExcelBuf.SetFriendlyFilename(StrSubstNo('BudgetVsActual_%1.xlsx', SelectedYear));
        ExcelBuf.OpenExcel;
    end;
}
