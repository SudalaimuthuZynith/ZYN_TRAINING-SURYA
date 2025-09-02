page 50167 IncomeListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = income;
    CardPageId = IncomeCardPage;
    InsertAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field("Expense ID"; Rec."Income ID") { }
                field(Description; Rec.Description) { }
                field(Amount; Rec.Amount) { }
                field(Date; Rec.Date) { }
                field("Category Name"; Rec.Catagory)
                {

                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(catagories)
            {

                RunObject = page IncomeCatagoryPage;
            }
            action(ExportReport)
            {
                RunObject = report "  Income Excel Report"
                
                
                
                ;
            }
        }
    }

   
}