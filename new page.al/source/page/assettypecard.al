page 50182 AssetTypeCardtPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = AssetTypeTable;
    
    layout
    {
        area(Content)
        {
            group(general)
            {
                field("catagory id";Rec."catagory id")
                {
                    
                }
                field(Catagory;Rec.Catagory)
                {
                    
                }
                field(Name;Rec.Name)
                {
                    
                }
                
                
                

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