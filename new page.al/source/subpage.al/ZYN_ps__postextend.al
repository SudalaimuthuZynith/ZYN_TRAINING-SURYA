page 50117 ZYN_PostExtenddText
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = ZYN_ExtendedTextTable;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Lino No."; Rec."Lino No.")
                {
                }
                field("Language code"; Rec."Language code")
                {
                }
                field(Text; Rec.Text)
                {
                }
            }
        }
    }
}
