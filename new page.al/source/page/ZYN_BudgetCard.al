page 50166 BudgetCardPage
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = BudgetTable;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("From Date"; Rec."From Date")
                {

                }
                field("To Date"; Rec."To Date")
                {

                }
                field("Catagory Name"; Rec."Catagory Name") { }
                field(Amount; Rec.Amount) { }
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
    // trigger OnOpenPage()
    // var
    // //budget: Record BudgetTable;
    // begin
    //     // budget."From Date" := CalcDate('<-CM>', WorkDate());
    //     // budget."To Date" := CalcDate('<-CM>', WorkDate());
    //     if rec."From Date" = 0D then
    //         rec."From Date" := CalcDate('<-CM>', WorkDate());
    //     IF rec."To Date" = 0D then
    //         rec."To Date" := CalcDate('<CM>', WorkDate());
    //     if (Rec."From Date" <> 0D) and (Rec."To Date" <> 0D) then
    //         Rec.Modify();
    // end;
    // trigger OnOpenPage()
    // begin
    //     if not Rec.Get(CalcDate('<-CM>', WorkDate()), CalcDate('<CM>', WorkDate())) then begin
    //         Rec.Init();
    //         Rec."From Date" := CalcDate('<-CM>', WorkDate());
    //         Rec."To Date" := CalcDate('<CM>', WorkDate());

    //         Rec.Insert();
    //     end;
    // end;

    var
        myInt: Integer;
}