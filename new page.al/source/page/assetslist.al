page 50194 AssetsListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = AssetsListTable;
    CardPageId=AssetsCardtPage;
    Editable=false;
    InsertAllowed=false;
    layout
    {
        area(Content)
        {
            repeater(general)
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
        area(FactBoxes)
        {
            part(AssignedAssetsPage;AssignedAssetsPage)
            {
                ApplicationArea = all;
                
            }
            part(ReturnedAssetsPage;ReturnedAssetsPage){ApplicationArea=all;}
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(assettype)
            {

                RunObject = page AssetTypeListPage;
            }
            action(employeeasset)
            {

                RunObject = page EmployeeAssetsListPage;
            }
            
        }

    }
    
    var
        myInt: Integer;
}