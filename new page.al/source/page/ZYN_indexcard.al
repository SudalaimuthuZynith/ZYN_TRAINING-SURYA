page 50135 ZYNIndex
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNIndex;
    Caption = 'Index Card';

    layout
    {
        area(Content)
        {
            group(details)
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
            group(subpage)
            {
                part(indexlinespage; ZYN_IndexLinesPage)
                {
                    SubPageLink = Code = field(Code);
                    ApplicationArea = all;
                }
            }
        }
    }
}