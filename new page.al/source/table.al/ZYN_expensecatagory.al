table 50105 "ZYN Expense Category"
{
    DataClassification = ToBeClassified;
    Caption = 'Expense Category';

    fields
    {
        field(8; Name; Code[30])
        {
            Caption = 'Category Name';
            Tooltip = 'Specifies the name of the expense category.';
            DataClassification = ToBeClassified;
        }

        field(9; Description; Text[30])
        {
            Caption = 'Description';
            Tooltip = 'Provides a short description of the expense category.';
            DataClassification = ToBeClassified;
        }

        field(5; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Tooltip = 'Specifies a date filter to calculate filtered totals.';
            FieldClass = FlowFilter;
        }

        field(1; "Total Amount Filtered"; Decimal)
        {
            Caption = 'Total Amount (Filtered)';
            Tooltip = 'Displays the total expense amount based on applied category and date filter.';
            FieldClass = FlowField;
            CalcFormula = Sum(ZYN_Expenses.Amount WHERE(
                                Category = FIELD(Name),
                                Date = FIELD("Date Filter")
                              ));
        }

        field(11; "Remaining Budget"; Decimal)
        {
            Caption = 'Remaining Budget';
            Tooltip = 'Specifies the remaining budget available for this category.';
            DataClassification = ToBeClassified;
        }

        field(70010; "Total Amount CurrentMonth"; Decimal)
        {
            Caption = 'Total Amount (Current Month)';
            Tooltip = 'Shows the total expense amount for the current month.';
            DataClassification = ToBeClassified;
        }

        field(70011; "Total Amount CurrentQuarter"; Decimal)
        {
            Caption = 'Total Amount (Current Quarter)';
            Tooltip = 'Shows the total expense amount for the current quarter.';
            DataClassification = ToBeClassified;
        }

        field(70012; "Total Amount CurrentHalf"; Decimal)
        {
            Caption = 'Total Amount (Current Half-Year)';
            Tooltip = 'Shows the total expense amount for the current half-year.';
            DataClassification = ToBeClassified;
        }

        field(70013; "Total Amount CurrentYear"; Decimal)
        {
            Caption = 'Total Amount (Current Year)';
            Tooltip = 'Shows the total expense amount for the current year.';
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
            // Displays category name in lookup drop-downs
        }
    }

    trigger OnDelete()
    var
        ZYNExpenseCatagory: Record "ZYN Expense Category";
    begin
        // Delete all records with same category name if present
        ZYNExpenseCatagory.SetRange(Name, Name);
        if ZYNExpenseCatagory.FindSet() then
            ZYNExpenseCatagory.DeleteAll();
    end;
}
