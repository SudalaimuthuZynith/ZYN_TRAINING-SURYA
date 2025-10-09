table 50164 "ZYNBudgetTable"
{
    DataClassification = ToBeClassified; // Stores expense budgets for defined date ranges

    fields
    {
        field(1; "From Date"; Date)
        {
            Caption = 'From Date'; // Start date of the budget period
            DataClassification = ToBeClassified;
        }

        field(2; "To Date"; Date)
        {
            Caption = 'To Date'; // End date of the budget period
            DataClassification = ToBeClassified;
        }

        field(3; "Catagory Name"; Code[30])
        {
            Caption = 'Category Name'; // Expense category for the budget
            DataClassification = ToBeClassified;
            TableRelation = "ZYN Expense Category".Name;
        }

        field(4; Amount; Decimal)
        {
            Caption = 'Budget Amount'; // Total budgeted amount for this category and date range
            DataClassification = ToBeClassified;
        }

        field(16; "Date Filter"; Date)
        {
            Caption = 'Date Filter'; // Used for flowfilter calculations
            FieldClass = FlowFilter;
        }

        field(111; "Total Amount Filtered"; Decimal)
        {
            Caption = 'Total Amount (Filtered)'; // Auto-calculated amount filtered by category/date
            FieldClass = FlowField;
            CalcFormula = sum("ZYNBudgetTable".Amount where(
                                "Catagory Name" = field("Catagory Name"),
                                "From Date" = field("Date Filter")));
        }

        // Optional calculation storage fields
        field(70010; "Total Amount Current Month"; Decimal)
        {
            Caption = 'Total Amount (Current Month)'; // Calculated field (to be populated programmatically)
            DataClassification = ToBeClassified;
        }

        field(70011; "Total Amount Current Quarter"; Decimal)
        {
            Caption = 'Total Amount (Current Quarter)';
            DataClassification = ToBeClassified;
        }

        field(70012; "Total Amount Current Half"; Decimal)
        {
            Caption = 'Total Amount (Current Half Year)';
            DataClassification = ToBeClassified;
        }

        field(70013; "Total Amount Current Year"; Decimal)
        {
            Caption = 'Total Amount (Current Year)';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "From Date", "To Date", "Catagory Name")
        {
            Clustered = true; // Ensures unique combination per category and period
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Catagory Name", "From Date", "To Date") { }
    }

    trigger OnInsert()
    begin
        // Automatically assign current month as default date range if not provided
        if "From Date" = 0D then
            "From Date" := CalcDate('<-CM>', WorkDate());
        if "To Date" = 0D then
            "To Date" := CalcDate('<CM>', WorkDate());
    end;
}
