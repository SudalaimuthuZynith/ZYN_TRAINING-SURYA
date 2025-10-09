pageextension 50137 "salesquoteeext" extends "Sales Quote"
{
    layout
    {
        addafter("Invoice Details")
        {
            group("Standard Texts")
            {
                field(beginning; Rec.beginning)
                {
                    ApplicationArea = All;

                }
                field(ending; Rec.ending)
                {
                    ApplicationArea = All;

                }

                part(SalesInvoiceTexts; ZYNextentdtext)
                {
                    SubPageLink = "Document No." = field("No."), selection = const("begin text");
                    ApplicationArea = All;
                }
                part(SalesInvoice; ZYNextentdtext)
                {
                    SubPageLink = "Document No." = field("No."), selection = const("end text");
                    ApplicationArea = All;
                }
            }
        }
    }
}
