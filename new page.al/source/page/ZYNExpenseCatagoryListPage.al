page 50223 ZYNExpenseCatagoryListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNExpenseCatagoryTable;
    CardPageId = ZYNExpenseCatagoryCardPage;
    Editable=false;
    InsertAllowed=false;
    layout
    {
        area(Content)
        {
            repeater(Catagories)
            {
                field(Code; Rec.Code) { }
                field(Catagory; Rec.Catagory) { }
                field(Name; Rec.Name) { }
                field(Amount; Rec.Amount) { }
            }
        }
    }


}