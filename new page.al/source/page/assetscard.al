page 50175 AssetsCardtPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = AssetsListTable;
    
    layout
    {
        area(Content)
        {
            group(general)
            {
                field("Asset type";Rec."Asset type")
                {
                    
                }
                field("Serial No";Rec."Serial No")
                {
                    
                }
                field("procured date";Rec."procured date")
                {
                    
                }
                field("Vendor name";Rec."Vendor name"){}
                field(Available;Rec.Available){}
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                
                trigger OnAction()
                begin
                    
                end;
            }
        }
    }
    
    var
        myInt: Integer;
}