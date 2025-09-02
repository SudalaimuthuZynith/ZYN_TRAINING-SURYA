report 50132 "RDLCReport"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'RDLCReport.RDL';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            column(No_; "No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Posting_Date; Format("Posting Date")) { }
            column(Document_Date; Format("Document Date")) { }
            column(totalamount; totalamount) { }
            column(CompanyName; CompanyName) { }
            column(companyrlogo; companyrecord.Picture) { }
            column(companyaddress; companyrecord.Address) { }


            dataitem("Sales Invoice Line"; "Sales Invoice Line")

            {
                DataItemLink = "Document No." = field("No.");
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Amount; Amount) { }
                column(Line_No_; "Line No.") { }
            }
            dataitem(ExtendedBegin; ExtendedTextTable)
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                column(textline; Text) { }
                column(texttype; selection) { }
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No."), "Customer No." = field("Sell-to Customer No.");
                column(Descrledger; Description) { }
                column(Amtledger; Amount) { }
                column(Remaining_Amount; "Remaining Amount") { }
            }


            // trigger OnAfterGetRecord()
            // var
            //     SalesLine: Record "Sales Invoice Line";
            // begin
            //     totalamount := 0;
            //     SalesLine.SetRange("Document No.", "No.");
            //     if SalesLine.FindSet() then
            //         repeat
            //             totalamount += SalesLine.Amount;
            //         until SalesLine.Next() = 0;
            // end;
        }
       
    }

    // labels
    // {
    //     NoLabel = 'Invoice No';
    //     Sell_to_Customer_NameLabel = 'Customer Name';
    //     Sell_to_Customer_No_Label = 'Customer No';
    //     Posting_DateLabel = 'Posting Date';
    //     Document_DateLabel = 'Document Date';
    //     DescriptionLabel = 'Description';
    //     QuantityLabel = 'Quantity';
    //     AmountLabel = 'Amount';
    //     TotalAmountLabel = 'Total Amount';

    // }
    trigger OnPreReport()
    begin
        companyrecord.Get();
        companyrecord.CalcFields(Picture);
    end;

    var
        totalamount: Decimal;
        companyrecord: Record "Company Information";


}
