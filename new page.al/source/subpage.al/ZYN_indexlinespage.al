page 50113 indexlinespage
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = IndexLines;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(Code; Rec.Code) { }
                field(entryno; Rec.entryno) { }
                field(year; Rec.year) { }
                field(percentage; Rec.percentage) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;


}