page 50149 ZYN_SalesCreditMemoSubpage
{
    PageType = ListPart;
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
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        Sales: Page "Sales Credit Memo";
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
}
