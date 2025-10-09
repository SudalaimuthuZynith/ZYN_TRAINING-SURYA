report 50138 ZYN_SalesInvoiceReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Sales Invoice Report';

    // --- Dataset ---
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            // Only process Invoices
            DataItemTableView = where("Document Type" = const(Invoice));

            // Fields available on request page for filtering
            RequestFilterFields = "No.", "Sell-to Customer Name", "Posting Date";

            // --- Trigger executed after each record is processed ---
            trigger OnPostDataItem()
            var
                SalesPost: Codeunit "Sales-Post"; // Codeunit to post the invoice
            begin
                SalesPost.Run("Sales Header"); // Post the invoice
                Message('Invoice %1 posted successfully.', "Sales Header"."No."); // Confirmation message
            end;
        }
    }
}
