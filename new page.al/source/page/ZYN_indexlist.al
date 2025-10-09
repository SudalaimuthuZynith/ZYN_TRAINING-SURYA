page 50132 ZYN_IndexList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNIndex;
    CardPageId = ZYNIndex;
    InsertAllowed = false;
    Editable = false;
    Caption = 'Index List';

    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("percentage increase"; Rec."percentage increase")
                {
                }
                field("Start Year"; Rec."Start Year")
                {
                }
                field("End Year"; Rec."End Year")
                {
                }
            }
        }
    }
}