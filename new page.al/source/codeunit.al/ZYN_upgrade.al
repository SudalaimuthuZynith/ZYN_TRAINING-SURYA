codeunit 50121 Upgrades
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        lastsold: Record ZYN_LastSold;
        salesinvline: Record "Sales Invoice Line";
        SalesInvHeader: Record "Sales Invoice Header";
        highestamt: Decimal;
        tagname: code[20];
        upgrade: codeunit "Upgrade Tag";
    begin
        tagname := 'Last Sold V1';

        if not upgrade.HasUpgradeTag(tagname) then begin
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
            upgrade.SetUpgradeTag(tagname);
        end;
    end;
}
