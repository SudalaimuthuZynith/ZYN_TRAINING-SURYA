table 50175 IncomeCatagoryTable
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
            CalcFormula = sum(income.Amount where(
                                Catagory = field(Name),
                                Date = field("Date Filter")
                              ));
        }

        // Normal fields to store calculated values
        field(70010; "Total Amount CurrentMonth"; Decimal)
        {
        }
        field(70011; "Total Amount CurrentQuarter"; Decimal) { }
        field(70012; "Total Amount CurrentHalf"; Decimal) { }
        field(70013; "Total Amount CurrentYear"; Decimal) { }

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
        catagory: Record IncomeCatagoryTable;
    begin
        catagory.SetRange(Name, Name);
        if catagory.FindSet() then
            catagory.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}