page 50176 IncomeCatagoryPage
{
    PageType = List;
    ApplicationArea = All;
    //Editable = false;
    SourceTable = IncomeCatagoryTable;

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
                { }

            }

        }
        area(FactBoxes)
        {
            part(ExpenseFactboxPage; IncomeFactboxPage)
            {
                SubPageLink = Name = field(Name);
            }
        }
    }



    var
        myInt: Integer;
}