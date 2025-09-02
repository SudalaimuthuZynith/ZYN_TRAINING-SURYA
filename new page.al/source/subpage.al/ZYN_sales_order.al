page 50142 sales_order_subpage
{
    PageType = listpart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order));
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
                        sales: Page "Sales Order";
                        
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