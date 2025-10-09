page 50144 ZYNextentdtext
{
    PageType = ListPart;
    SourceTable = ZYN_ExtendedTextTable;
    ApplicationArea = All;

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
