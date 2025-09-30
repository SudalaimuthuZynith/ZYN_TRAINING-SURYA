page 50177 ZYNLeaveCatagoryList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = ZYNLeaveCatagoryCard;
    SourceTable = ZYNLeaveCatagory;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Catagory Name"; Rec."Catagory Name")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("No of days allowed"; Rec."No of days allowed")
                {
                }
            }
        }
    }
}