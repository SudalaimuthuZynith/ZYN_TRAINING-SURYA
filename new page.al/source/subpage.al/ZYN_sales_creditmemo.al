page 50149 sales_creditmemo_subpage
{
    PageType = listpart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const("Credit Memo"));
    layout
    {
        area(Content)
        {
            repeater(group)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        sales: Page "Sales Credit Memo";

                    begin
                        sales.SetRecord(Rec);
                        sales.Run();
                    end;
                }

                field("Sell-to Customer Name"; Rec."Sell-to Customer Name") { }

                field("Sell-to Contact No."; Rec."Sell-to Contact No.") { }

                field(Invoice; Rec.Invoice) { }

            }
        }
    }


}