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

report 50169 "Expense Excel Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Expense; Expenses)
        {
            // No RequestFilterFields because we’re using our own From/To Date
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Filter)
                {
                    field(Category; Category)
                    {
                        ApplicationArea = All;
                        Caption = 'Category';
                        TableRelation = ZYNExpenseCatagory.Name;
                    }
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                    }
                }
            }
        }
    }

    var
        Category: Code[20];
        FromDate: Date;
        ToDate: Date;
        ExcelBuffer: Record "Excel Buffer";
        CatRec: Record ZYNExpenseCatagory;
        ExpenseRec: Record Expenses;
        CompanyInfo: Record "Company Information";
        CompanyName: Text[100];
        UserIdTxt: Text[50];
        TotalAmount: Decimal;   // <-- Add this

    trigger OnPreReport()
    begin
        ExcelBuffer.DeleteAll();

        // --- Add Headers ---
        ExcelBuffer.AddColumn('ExpenseID', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Amount', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Category', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);

        // --- Apply Filters ---
        ExpenseRec.Reset();
        if Category <> '' then
            ExpenseRec.SetRange(Catagory, Category);
        if (FromDate <> 0D) and (ToDate <> 0D) then
            ExpenseRec.SetRange(Date, FromDate, ToDate);

        // --- Write Data Rows ---
        TotalAmount := 0;
        if ExpenseRec.FindSet() then
            repeat
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn(ExpenseRec."Expense ID", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(ExpenseRec.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(ExpenseRec.Amount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

                //if CatRec.Get(ExpenseRec.Catagory) then
                ExcelBuffer.AddColumn(CatRec.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                // else
                //     ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                //ExcelBuffer.AddColumn(ExpenseRec.Date, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(FORMAT(ExpenseRec.Date, 0, '<Month,2>/<Day,2>/<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                // Add to Total
                TotalAmount += ExpenseRec.Amount;
            until ExpenseRec.Next() = 0;

        // --- Add Total Row ---
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TOTAL', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TotalAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        // --- Create Excel ---
        if CompanyInfo.Get() then
            CompanyName := CompanyInfo.Name
        else
            CompanyName := '';
        UserIdTxt := UserId();

        ExcelBuffer.CreateNewBook('Expense List');
        ExcelBuffer.WriteSheet('Expenses', CompanyName, UserIdTxt);
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
    end;

}
