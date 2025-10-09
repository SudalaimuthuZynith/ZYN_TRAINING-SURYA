report 50132 ZYN_RDLCReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'RDLCReport.RDL';
    DefaultLayout = RDLC;

    // --- Dataset ---
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            // Columns for Sales Invoice Header
            column(No_; "No.")
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {
            }
            column(Posting_Date; Format("Posting Date"))
            {
            }
            column(Document_Date; Format("Document Date"))
            {
            }
            column(totalamount; totalamount)
            {
            }
            column(CompanyName; CompanyName)
            {
            }
            column(companyrlogo; companyrecord.Picture)
            {
            }
            column(companyaddress; companyrecord.Address)
            {
            }

            // --- Sales Invoice Line dataitem ---
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Amount; Amount)
                {
                }
                column(Line_No_; "Line No.")
                {
                }
            }

            // --- Extended Text Table dataitem ---
            dataitem(ExtendedBegin; ZYN_ExtendedTextTable)
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");

                column(textline; Text)
                {
                }
                column(texttype; selection)
                {
                }
            }

            // --- Customer Ledger Entry dataitem ---
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No."), "Customer No." = field("Sell-to Customer No.");

                column(Descrledger; Description)
                {
                }
                column(Amtledger; Amount)
                {
                }
                column(Remaining_Amount; "Remaining Amount")
                {
                }
            }

            // --- Optional logic commented out ---
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

    // --- Trigger executed before report runs ---
    trigger OnPreReport()
    begin
        // Get company record and calculate Picture field
        companyrecord.Get();
        companyrecord.CalcFields(Picture);
    end;

    // --- Variables ---
    var
        totalamount: Decimal;                        // Total Amount for invoice
        companyrecord: Record "Company Information"; // Company Info for report
}
