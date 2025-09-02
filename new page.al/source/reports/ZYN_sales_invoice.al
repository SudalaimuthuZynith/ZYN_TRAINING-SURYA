report 50138 sales_invoice_report
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'sales invoice report';
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Invoice));
            RequestFilterFields = "No.", "Sell-to Customer Name", "Posting Date";
            trigger OnPostDataItem()
            var
                salespost: Codeunit "Sales-Post";
            begin
                salespost.Run("Sales Header");
                Message('Invoice %1 posted successfully.', "Sales Header"."No.");
            end;
        }
    }
}
