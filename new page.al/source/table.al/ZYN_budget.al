table 50164 ZYNBudgetTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Catagory Name"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = ZYNExpenseCatagory.Name;
        }
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        // field(29;"Budget Month";Date)
        // {

        // }
        field(111; "Total Amount Filtered"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum(ZYNBudgetTable.Amount where(
                                "Catagory Name" = field("Catagory Name"),
                                "From Date" = field("Date Filter")
                              ));
        }
        // field(11;"Remaining Budget";Decimal)
        // {
        //     DataClassification=ToBeClassified;
        // }

        // Normal fields to store calculated values
        field(70010; "Total Amount CurrentMonth"; Decimal)
        { }
        field(70011; "Total Amount CurrentQuarter"; Decimal)
        { }
        field(70012; "Total Amount CurrentHalf"; Decimal) { }
        field(70013; "Total Amount CurrentYear"; Decimal) { }
    }

    keys
    {
        key(Key1; "From Date", "To Date", "Catagory Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Catagory Name") { }
    }


    trigger OnInsert()
    var
    //budget: Record BudgetTable;
    begin
        // budget."From Date" := CalcDate('<-CM>', WorkDate());
        // budget."To Date" := CalcDate('<-CM>', WorkDate());
        if "From Date" = 0D then
            "From Date" := CalcDate('<-CM>', WorkDate());
        IF "To Date" = 0D then
            "To Date" := CalcDate('<CM>', WorkDate());

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}