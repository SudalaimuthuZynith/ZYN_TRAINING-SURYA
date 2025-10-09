codeunit 50114 "Last Sold"
{
    // ======================================
    // Event Subscriber
    // ======================================
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', true, true)]
    procedure LastSold(var SalesHeader: Record "Sales Header"; 
                       var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; 
                       SalesShptHdrNo: Code[20]; 
                       RetRcpHdrNo: Code[20]; 
                       SalesInvHdrNo: Code[20]; 
                       SalesCrMemoHdrNo: Code[20]; 
                       CommitIsSuppressed: Boolean; 
                       InvtPickPutaway: Boolean; 
                       var CustLedgerEntry: Record "Cust. Ledger Entry"; 
                       WhseShip: Boolean; 
                       WhseReceiv: Boolean; 
                       PreviewMode: Boolean)
    begin
        UpdateLastSold(SalesInvHdrNo);
    end;

    // ======================================
    // Local Procedures
    // ======================================

    // Update ZYN_LastSold based on the highest unit price from Sales Invoice Lines
    local procedure UpdateLastSold(SalesInvHdrNo: Code[20])
    var
        LastSold: Record ZYN_LastSold;
        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHeader: Record "Sales Invoice Header";
        HighestAmt: Decimal;
    begin
        // Loop through all Sales Invoice Headers
        if SalesInvHeader.FindSet() then
            repeat
                // Reset Sales Invoice Lines for this invoice
                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
                HighestAmt := 0;

                // Loop through Sales Invoice Lines to find highest Unit Price
                if SalesInvLine.FindSet() then
                    repeat
                        if SalesInvLine."Unit Price" > HighestAmt then begin
                            HighestAmt := SalesInvLine."Unit Price";

                            // Check if record exists in ZYN_LastSold
                            LastSold.Reset();
                            LastSold.SetRange("Customer No", SalesInvHeader."Sell-to Customer No.");
                            LastSold.SetRange("Item No", SalesInvLine."No.");

                            if LastSold.FindFirst() then begin
                                // Update existing record
                                LastSold.Validate("Item Price", HighestAmt);
                                LastSold."Posting Date" := SalesInvLine."Posting Date";
                                LastSold.Modify();
                            end else begin
                                // Insert new record
                                LastSold.Init();
                                LastSold."Customer No" := SalesInvLine."Sell-to Customer No.";
                                LastSold.Validate("Item No", SalesInvLine."No.");
                                LastSold.Validate("Item Price", HighestAmt);
                                LastSold."Posting Date" := SalesInvLine."Posting Date";
                                LastSold.Insert();
                            end;
                        end;
                    until SalesInvLine.Next() = 0;
            until SalesInvHeader.Next() = 0;
    end;
}
