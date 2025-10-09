codeunit 50114 "last sold"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', true, true)]
    procedure lastsold(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)

    var
        lastsold: Record ZYN_LastSold;
        salesinvline: Record "Sales Invoice Line";
        SalesInvHeader: Record "Sales Invoice Header";
        highestamt: Decimal;

    begin
        if SalesInvHeader.FindSet() then
            repeat
                salesinvline.Reset();
                salesinvline.SetRange("Document No.", SalesInvHeader."No.");
                highestamt := 0;

                if salesinvline.FindSet() then
                    repeat
                        if salesinvline."Unit Price" > highestamt then begin
                            highestamt := salesinvline."Unit Price";
                            lastsold.Reset();
                            lastsold.SetRange("Customer No", SalesInvHeader."Sell-to Customer No.");
                            lastsold.SetRange("Item No", salesinvline."No.");

                            if lastsold.FindFirst() then begin
                                lastsold.Validate("Item Price", highestamt);
                                lastsold."Posting Date" := salesinvline."Posting Date";
                                lastsold.Modify();
                            end else begin
                                lastsold.Init();
                                lastsold."Customer No" := salesinvline."Sell-to Customer No.";
                                lastsold.Validate("Item No", salesinvline."No.");
                                lastsold.Validate("Item Price", highestamt);
                                lastsold."Posting Date" := salesinvline."Posting Date";
                                lastsold.Insert();
                            end;
                        end;
                    until salesinvline.Next() = 0;
            until SalesInvHeader.Next() = 0;
    end;
}