page 50167 ZYN_IncomeList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_Income;
    CardPageId = ZYNIncomeCard;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field("Expense ID"; Rec."Income ID")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(Date; Rec.Date)
                {
                }
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

                RunObject = page ZYN_IncomeCatagory;
            }
            action(ExportReport)
            {
                RunObject = report ZYN_IncomeExcelReport;
            }
        }
    }
}