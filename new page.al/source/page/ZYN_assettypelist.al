page 50192 ZYNAssetTypeList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNAssetType;
    CardPageId = ZYNAssetTypeCard;
    Editable = false;
    InsertAllowed = false;
    Caption = 'Asset Type List';
    
    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field("catagory id"; Rec."catagory id")
                {
                }
                field(Catagory; Rec.Catagory)
                {
                }
                field(Name; Rec.Name)
                {
                }
            }
        }
    }
}