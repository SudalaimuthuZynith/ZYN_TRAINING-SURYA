page 50213 ZYNExpenseCatagoryCardPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNExpenseCatagoryTable;

    layout
    {
        area(Content)
        {
            group(Catagories)
            {
                field(Code; Rec.Code) { }
                field(Catagory; Rec.Catagory) { }
                field(Name; Rec.Name) { }
                field(Amount; Rec.Amount) { }
            }
        }
    }


}