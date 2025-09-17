page 50213 ZYN_ExpenseCatagoryCardPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_ExpenseCatagoryTable;

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