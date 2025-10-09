pageextension 50122 salesinvoicelistext extends "Sales Invoice List"
{
    actions
    {
        addlast(processing)
        {
            action("bulk posting")
            {
                ApplicationArea = all;
                Caption = 'bulk posting';
                Image = Post;
                trigger OnAction()
                var
                    sales_invoice_report: Report ZYN_SalesInvoiceReport;
                begin
                    sales_invoice_report.SetTableView(Rec);
                    Report.RunModal(Report::ZYN_SalesInvoiceReport, true, true);
                end;
            }
        }
    }
}