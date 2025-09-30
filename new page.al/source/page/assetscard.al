page 50175 ZYNAssetsCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNAssetsList;
    Caption = 'Asset Card';

    layout
    {
        area(Content)
        {
            group(general)
            {
                field("Asset type"; Rec."Asset type")
                {

                }
                field("Serial No"; Rec."Serial No")
                {

                }
                field("procured date"; Rec."procured date")
                {

                }
                field("Vendor name"; Rec."Vendor name") 
                {

                 }
                field(Available; Rec.Available) {

                 }
            }
        }
    }
}