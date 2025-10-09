report 50133 ZYN_NEWREPORT
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'NEWREPORT';

    // --- Dataset ---
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            // Only open Orders
            DataItemTableView = where("Document Type" = const(Order), Status = const(Open));

            // --- Trigger executed for each record ---
            trigger OnAfterGetRecord()
            var
                SalesHeader: Record "Sales Header"; // Local record variable
            begin
                // Update Posting Date
                SalesHeader."Posting Date" := newdate;
                SalesHeader.Modify();
                
                // Increment counter
                counter += 1;
            end;

            // --- Trigger executed after all records are processed ---
            trigger OnPostDataItem()
            begin
                // Display message with total updated records
                Message('%1 Sales Orders were updated with new Posting Date.', counter);
            end;
        }
    }

    // --- Request Page for User Input ---
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    // Field to select new Posting Date
                    field(newdate; newdate)
                    {
                        Caption = 'New Posting Date';
                    }
                }
            }
        }
    }

    // --- Variables ---
    var
        counter: Integer;   // Counts updated records
        newdate: Date;      // New Posting Date entered by user
}
