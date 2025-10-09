table 50175 ZYN_IncomeCategoryTable
{
    Caption = 'Income Category';
    DataClassification = ToBeClassified;

    fields
    {
        field(8; Name; Code[30])
        {
            Caption = 'Category Name';
            Tooltip = 'Specifies the name of the income category.';
            DataClassification = ToBeClassified;
        }

        field(9; Description; Text[30])
        {
            Caption = 'Description';
            Tooltip = 'Provides a short description of the income category.';
            DataClassification = ToBeClassified;
        }

        field(5; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Tooltip = 'Specifies a date range filter used for calculating totals.';
            FieldClass = FlowFilter;
        }

        field(1; "Total Amount Filtered"; Decimal)
        {
            Caption = 'Total Amount (Filtered)';
            Tooltip = 'Displays the total income amount filtered by category and date.';
            FieldClass = FlowField;
            CalcFormula = Sum(ZYN_Income.Amount WHERE(
                                Catagory = FIELD(Name),
                                Date = FIELD("Date Filter")
                              ));
        }

        field(70010; "Total Amount CurrentMonth"; Decimal)
        {
            Caption = 'Total Amount (Current Month)';
            Tooltip = 'Shows the total income amount for the current month.';
            DataClassification = ToBeClassified;
        }

        field(70011; "Total Amount CurrentQuarter"; Decimal)
        {
            Caption = 'Total Amount (Current Quarter)';
            Tooltip = 'Shows the total income amount for the current quarter.';
            DataClassification = ToBeClassified;
        }

        field(70012; "Total Amount CurrentHalf"; Decimal)
        {
            Caption = 'Total Amount (Current Half-Year)';
            Tooltip = 'Shows the total income amount for the current half-year.';
            DataClassification = ToBeClassified;
        }

        field(70013; "Total Amount CurrentYear"; Decimal)
        {
            Caption = 'Total Amount (Current Year)';
            Tooltip = 'Shows the total income amount for the current year.';
            DataClassification = ToBeClassified;
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
        fieldgroup(DropDown; Name)
        {
            // Displays category name in lookup dropdowns
        }
    }

    trigger OnDelete()
    var
        IncomeCatagoryTable: Record ZYN_IncomeCategoryTable;
    begin
        // Deletes all records having the same category name
        IncomeCatagoryTable.SetRange(Name, Name);
        if IncomeCatagoryTable.FindSet() then
            IncomeCatagoryTable.DeleteAll();
    end;
}
