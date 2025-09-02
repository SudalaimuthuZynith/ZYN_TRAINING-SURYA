table 50105 ExpenseCatagoryTable
{
    DataClassification = ToBeClassified;

    fields
    {

        field(8; Name; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }

        // One FlowField, reused
        field(1; "Total Amount Filtered"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum(Expenses.Amount where(
                                Catagory = field(Name),
                                Date = field("Date Filter")
                              ));
        }
        field(11;"Remaining Budget";Decimal)
        {
            DataClassification=ToBeClassified;
        }

        // Normal fields to store calculated values
        field(70010; "Total Amount CurrentMonth"; Decimal)
        {}
        field(70011; "Total Amount CurrentQuarter"; Decimal) 
        { }
        field(70012; "Total Amount CurrentHalf"; Decimal) { }
        field(70013; "Total Amount CurrentYear"; Decimal) 
        {
        //     FieldClass=FlowField;
        //     CalcFormula = sum(Expenses.Amount 
        // where(Date=filter(CalcDate('-CY', WorkDate)..CalcDate('CY', WorkDate))));
         }
        

    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Name) { }
    }
    var
        myInt: Integer;



    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        catagory: Record ExpenseCatagoryTable;
    begin
        catagory.SetRange(Name, Name);
        if catagory.FindSet() then
            catagory.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}