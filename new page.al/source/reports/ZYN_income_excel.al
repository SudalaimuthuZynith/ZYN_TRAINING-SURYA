// page 50169 ExpenseFilterPage
// {
//     PageType = Card;
//     ApplicationArea = All;
//     Caption = 'Expense Filter';
//     SourceTable = "Integer"; // Dummy, as we use variables

//     layout
//     {
//         area(Content)
//         {
//             group(Filter)
//             {
//                 field(Category; Category) { ApplicationArea = All; TableRelation = ExpenseCatagoryTable.Name; }
//                 field(FromDate; FromDate) { ApplicationArea = All; }
//                 field(ToDate; ToDate) { ApplicationArea = All; }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ExportAsExcel)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Export as Excel';
//                 trigger OnAction()
//                 var
//                     ExpenseRec: Record Expense;
//                     ExcelBuffer: Record "Excel Buffer";
//                     RowNo: Integer;
//                     CatRec: Record ExpenseCatagoryTable;
//                     CompanyInfo: Record "Company Information";
//                     CompanyName: Text[100];
//                     UserIdTxt: Text[50];
//                 begin
//                     ExcelBuffer.DeleteAll();
//                     RowNo := 1;
//                     // Header
//                     ExcelBuffer.AddColumn('ExpenseID', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
//                     ExcelBuffer.AddColumn('Description', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
//                     ExcelBuffer.AddColumn('Amount', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
//                     ExcelBuffer.AddColumn('Category', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
//                     ExcelBuffer.AddColumn('Date', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

//                     // Filter and add data
//                     ExpenseRec.Reset();
//                     if Category <> '' then
//                         ExpenseRec.SetRange(Catagory,Category);
//                     if FromDate <> 0D then
//                         ExpenseRec.SetRange(Date, FromDate, ToDate);

//                     if ExpenseRec.FindSet() then
//                         repeat
//                             RowNo += 1;
//                             ExcelBuffer.AddColumn(Format(ExpenseRec."Expense ID"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
//                             ExcelBuffer.AddColumn(ExpenseRec.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
//                             ExcelBuffer.AddColumn(Format(ExpenseRec.Amount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
//                             if CatRec.Get(ExpenseRec.Catagory) then
//                                 ExcelBuffer.AddColumn(CatRec.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
//                             else
//                                 ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
//                             ExcelBuffer.AddColumn(Format(ExpenseRec.Date), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
//                         until ExpenseRec.Next() = 0;

//                     if CompanyInfo.Get() then
//                         CompanyName := CompanyInfo.Name
//                     else
//                         CompanyName := '';
//                     UserIdTxt := UserId();

//                     ExcelBuffer.CreateNewBook('Expense List');
//                     ExcelBuffer.WriteSheet('Expenses', CompanyName, UserIdTxt);
//                     ExcelBuffer.CloseBook();
//                     ExcelBuffer.OpenExcel();
//                 end;
//             }
//         }
//     }

//     var
//         Category: Code[20];
//         FromDate: Date;
//         ToDate: Date;
// }

report 50199 ZYN_IncomeExcelReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    // --- Dataset ---
    dataset
    {
        dataitem(Income; ZYN_Income)
        {
            // No RequestFilterFields because we are using custom From/To Date filters
        }
    }

    // --- Request Page for User Filters ---
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Filter)
                {
                    // Filter for Income Category
                    field(Category; Category)
                    {
                        Caption = 'Category';
                        TableRelation = "ZYN Expense Category".Name;
                    }

                    // Filter for starting date
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                    }

                    // Filter for ending date
                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date';
                    }
                }
            }
        }
    }

    // --- Variables ---
    var
        Category: Code[20];                        // Selected Income Category
        FromDate: Date;                             // Start Date filter
        ToDate: Date;                               // End Date filter
        ExcelBuffer: Record "Excel Buffer";        // Handles Excel operations
        CatRec: Record ZYN_IncomeCategoryTable;    // Category record
        IncomeRec: Record ZYN_Income;                  // Income record
        CompanyInfo: Record "Company Information";// Company Info for header
        CompanyName: Text[100];                    // Name of the Company
        UserIdTxt: Text[50];                       // Current User ID
        TotalAmount: Decimal;                       // Total of Amount column

    // --- Trigger executed before generating the report ---
    trigger OnPreReport()
    begin
        // Clear existing data in ExcelBuffer
        ExcelBuffer.DeleteAll();

        // --- Add Header Row ---
        ExcelBuffer.AddColumn('ExpenseID', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Amount', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Category', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);

        // --- Apply Filters to Income ---
        IncomeRec.Reset();
        if Category <> '' then
            IncomeRec.SetRange(Catagory, Category); // Filter by category
        if (FromDate <> 0D) and (ToDate <> 0D) then
            IncomeRec.SetRange(Date, FromDate, ToDate); // Filter by date range

        // --- Write Data Rows to Excel ---
        TotalAmount := 0;
        if IncomeRec.FindSet() then
            repeat
                ExcelBuffer.NewRow();

                // Add individual fields
                ExcelBuffer.AddColumn(IncomeRec."Income ID", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(IncomeRec.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(IncomeRec.Amount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

                // Add Category name
                ExcelBuffer.AddColumn(CatRec.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                // Format Date as Month/Day/Year
                ExcelBuffer.AddColumn(FORMAT(IncomeRec.Date, 0, '<Month,2>/<Day,2>/<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                // Add to TotalAmount
                TotalAmount += IncomeRec.Amount;
            until IncomeRec.Next() = 0;

        // --- Add Total Row ---
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TOTAL', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TotalAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // --- Create Excel File ---
        if CompanyInfo.Get() then
            CompanyName := CompanyInfo.Name
        else
            CompanyName := '';
        UserIdTxt := UserId();

        ExcelBuffer.CreateNewBook('Income List');          // Create new Excel workbook
        ExcelBuffer.WriteSheet('Income', CompanyName, UserIdTxt); // Write sheet with headers
        ExcelBuffer.CloseBook();                            // Close Excel book
        ExcelBuffer.OpenExcel();                             // Open Excel for user
    end;
}
