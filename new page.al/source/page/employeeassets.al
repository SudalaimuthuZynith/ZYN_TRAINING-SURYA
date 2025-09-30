page 50195 ZYNEmployeeAssetsList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNEmployeeAssetList;
    CardPageId = ZYNEmployeeAssetsCard;
    Editable = false;
    InsertAllowed = false;
    Caption = 'Employee Asset List';
    
    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(Employee; Rec.Employee)
                {
                }
                field("serial no"; Rec."serial no")
                {
                }
                field("Asset Type"; Rec."Asset Type")
                {
                }
                field(status; Rec.status)
                {
                }
                field("Assigned date"; Rec."Assigned date")
                {
                }
                field("Returned date date"; Rec."Returned date date")
                {
                }
                field("Lost date"; Rec."Lost date")
                {
                }
            }
        }
    }
}