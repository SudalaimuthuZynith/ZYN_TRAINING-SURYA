page 50194 ZYNAssetsList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNAssetsList;
    CardPageId = ZYNAssetsCard;
    Editable = false;
    InsertAllowed = false;
    Caption = 'Asset List';

    layout
    {
        area(Content)
        {
            repeater(general)
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
                field(Available; Rec.Available)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(AssignedAssetsPage; AssignedAssetsPage)
            {
            }
            part(ReturnedAssetsPage; ReturnedAssetsPage)
            {
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(assettype)
            {

                RunObject = page ZYNAssetTypeList;
            }
            action(employeeasset)
            {

                RunObject = page ZYNEmployeeAssetsList;
            }

        }

    }
}