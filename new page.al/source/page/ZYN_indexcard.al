page 50135 IndexPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = IndexTable;

    layout
    {
        area(Content)
        {
            group(details)
            {
                field(Code; Rec.Code)
                {

                }
                field(Description; Rec.Description) { }
                field("percentage increase"; Rec."percentage increase") { }
                field("Start Year"; Rec."Start Year")
                {


                }
                field("End Year"; Rec."End Year") { }
            }
            group(subpage)
            {
                part(indexlinespage; indexlinespage)
                {
                    SubPageLink = Code = field(Code);
                    ApplicationArea = all;

                }
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