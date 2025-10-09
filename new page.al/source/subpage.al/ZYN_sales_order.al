page 50142 ZYN_SalesOrderSubpage
{
    PageType = ListPart;
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
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        Sales: Page "Sales Order";
                    begin
                        Sales.SetRecord(Rec);
                        Sales.Run();
                    end;
                }

                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }

                field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                {
                }

                field(Invoice; Rec.Invoice)
                {
                }
            }
        }
    }

    var
        "Sales Header": Record "Sales Header";
}
