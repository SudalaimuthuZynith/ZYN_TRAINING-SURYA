pageextension 50132 postsalesinvext extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Invoice Details")
        {
            field(beginning__text; Rec.beginning_text)
            {
                ApplicationArea = all;
            }
            part(SalesInvoiceTexts; postextentdtext)
            {
                SubPageLink = "Document No." = field("No."), selection = const("begin text");
                ApplicationArea = All;
                Editable = false;
            }
            field(end_text; Rec.end_text)
            {
                ApplicationArea = all;
            }
            part(SalesInvoice; postextentdtext)
            {
                SubPageLink = "Document No." = field("No."), selection = const("end text");
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(PrintCustom)
            {
                ApplicationArea = All;
                Caption = 'Print Custom';
                Image = Print;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    SalesInvoiceHeader.Get(Rec."No.");
                    Report.RunModal(Report::sales_invoice_report, true, true);
                end;
            }
        }
    }
}


enumextension 50135 documenttypeext extends "Sales Document Type"
{
    value(50100; "posted sales invoice") { }
    value(50101; "posted sales credit memo") { }
}
