pageextension 50136 postsalescreditext extends "Posted Sales Credit Memo"
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
}


// enumextension 50135 documenttypeext extends "Sales Document Type"
// {
//     value(50100; "posted sales invoice") { }
// }
