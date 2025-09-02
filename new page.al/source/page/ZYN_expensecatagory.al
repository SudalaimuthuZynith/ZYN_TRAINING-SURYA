page 50106 ExpenseCatagoryPage
{
    PageType = List;
    ApplicationArea = All;

    SourceTable = ExpenseCatagoryTable;

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
            part(ExpenseFactboxPage; ExpenseFactboxPage)
            {
                SubPageLink = Name = field(Name);
            }
            part(BudgetFactboxPage; BudgetFactboxPage)
            {
                ApplicationArea = all;
                SubPageLink = "Catagory Name" = field(Name);
            }
        }
    }


    // trigger OnAfterGetRecord()
    // var
    //     budget:Record BudgetTable;
    //     start:Date;
    //     endin:Date;
    //     expense:Record Expenses;
    //     begin
    //         start:=CalcDate('<-CM>',WorkDate());
    //         endin:=CalcDate('<CM>',WorkDate());
    //         expense.Reset();
    //         expense.SetRange(Catagory,);
    //     end;
}