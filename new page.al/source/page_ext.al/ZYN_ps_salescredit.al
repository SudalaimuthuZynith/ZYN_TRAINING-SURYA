pageextension 50133 "salescrediteext" extends "Sales Credit Memo"
{
    layout
    {
        addafter(General)
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

                part(SalesInvoiceTexts; extentdtext)
                {
                    SubPageLink = "Document No." = field("No."), selection = const("begin text");
                    ApplicationArea = All;
                }
                part(SalesInvoice; extentdtext)
                {
                    SubPageLink = "Document No." = field("No."), selection = const("end text");
                    ApplicationArea = All;
                }
            }
        }
    }
}
