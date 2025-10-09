pageextension 50131 "salesinvoiceext" extends "Sales Invoice"
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
        addlast(General)
        {
            field("From Subscription"; Rec."From Subscription")
            {
                ApplicationArea = All;
            }
        }
    }


}
