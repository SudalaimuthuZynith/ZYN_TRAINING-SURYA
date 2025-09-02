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
                    sales_invoice_report: Report sales_invoice_report;
                begin
                    sales_invoice_report.SetTableView(Rec);
                    Report.RunModal(Report::sales_invoice_report, true, true);
                end;
            }
        }
    }
}