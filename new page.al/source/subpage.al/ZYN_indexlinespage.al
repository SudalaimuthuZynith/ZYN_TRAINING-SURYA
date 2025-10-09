page 50113 ZYN_IndexLinesPage
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_IndexLines;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(Code; Rec.Code)
                {
                }
                field(entryno; Rec.entryno)
                {
                }
                field(year; Rec.year)
                {
                }
                field(percentage; Rec.percentage)
                {
                }
            }
        }
    }

    var
        IndexLines: Record ZYN_IndexLines;
        myInt: Integer;
}
