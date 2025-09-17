page 50223 ZYN_ExpenseCatagoryListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_ExpenseCatagoryTable;
    CardPageId = ZYN_ExpenseCatagoryCardPage;
    Editable = false;
    InsertAllowed = false;
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