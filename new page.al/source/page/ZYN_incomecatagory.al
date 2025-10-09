page 50176 ZYN_IncomeCatagory
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = ZYN_IncomeCategoryTable;
    Caption = 'Income Catagory List';

    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(Name; Rec.Name)
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(ExpenseFactboxPage; ZYN_IncomeFactboxPage)
            {
                SubPageLink = Name = field(Name);
            }
        }
    }
}