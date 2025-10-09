page 50182 ZYNAssetTypeCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNAssetType;
    Caption = 'Asset  Type Card';

    layout
    {
        area(Content)
        {
            group(general)
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