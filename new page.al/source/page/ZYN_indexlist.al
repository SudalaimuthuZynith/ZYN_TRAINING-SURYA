page 50132 IndexListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = IndexTable;
    CardPageId = IndexPage;
    InsertAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(Code; Rec.Code) { }
                field(Description; Rec.Description) { }
                field("percentage increase"; Rec."percentage increase") { }
                field("Start Year"; Rec."Start Year") { }
                field("End Year"; Rec."End Year") { }
            }
            // group(subpage)
            // {
            //     part(indexlinespage; indexlinespage)
            //     {
            //         SubPageLink = Code = field(Code);
            //         ApplicationArea = all;
            //         Editable = false;
            //     }
            // }
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