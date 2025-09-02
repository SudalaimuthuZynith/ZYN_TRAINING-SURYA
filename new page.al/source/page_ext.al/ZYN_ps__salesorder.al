pageextension 50139 "salesorderext" extends "Sales Order"
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
                field("begin order"; Rec."begin order")
                {
                    ApplicationArea = all;
                }
                field("end order"; Rec."end order")
                {
                    ApplicationArea = all;
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
        addlast(General)
        {
            field(lastsoldprice; lastsoldprice)
            {
                ApplicationArea = all;

            }
        }

    }
    var
        lastsoldprice: Decimal;

    trigger OnAfterGetRecord()
    var
        lastprice: Record "last sold";
        latestDate: Date;
        maxPrice: Decimal;
    begin
        Clear(lastsoldprice);
        if (Rec."Sell-to Contact No." <> '') then begin
            lastprice.Reset();
            lastprice.SetCurrentKey("Posting Date");
            lastprice.SetRange("Customer No", Rec."Sell-to Customer No.");
            if lastprice.FindLast() then
                latestDate := lastprice."Posting Date";
            lastprice.Reset();
            lastprice.SetRange("Customer No", Rec."Sell-to Customer No.");
            lastprice.SetRange("Posting Date", latestDate);
            maxPrice := 0;
            if lastprice.FindSet() then
                repeat
                    if lastprice."Item Price" > maxPrice then 
                        maxPrice := lastprice."Item Price";
                until lastprice.Next() = 0;
            lastsoldprice := maxPrice;
        end;
    end;
}
