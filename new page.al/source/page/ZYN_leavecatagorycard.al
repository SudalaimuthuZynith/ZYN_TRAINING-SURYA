page 50159 ZYNLeaveCatagoryCard
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = ZYNLeaveCatagory;
    Caption = 'Leave Catagory List';

    layout
    {
        area(Content)
        {
            group(Group)
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