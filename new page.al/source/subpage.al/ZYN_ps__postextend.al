page 50117 "postextentdtext"
{
    PageType = ListPart;
    SourceTable = ExtendedTextTable;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Lino No."; Rec."Lino No.")
                {
                    ApplicationArea = All;
                }
                field("Language code"; Rec."Language code")
                {
                    ApplicationArea = All;
                }
                field(Text; Rec.Text)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

