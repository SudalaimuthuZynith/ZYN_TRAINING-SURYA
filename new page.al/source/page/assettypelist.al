page 50192 AssetTypeListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = AssetTypeTable;
    CardPageId=AssetTypeCardtPage;
    Editable=false;
    InsertAllowed=false;
    layout
    {
        area(Content)
        {
            repeater(general)
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