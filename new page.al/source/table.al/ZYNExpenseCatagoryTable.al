table 50257 ZYN_ExpenseCatagoryTable
{
    Caption = 'Expense Category Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            Tooltip = 'Unique code for the expense category.';
            DataClassification = ToBeClassified;
        }

        field(2; Catagory; Text[20])
        {
            Caption = 'Category';
            Tooltip = 'The category of the expense.';
            DataClassification = ToBeClassified;
        }

        field(3; Name; Text[20])
        {
            Caption = 'Name';
            Tooltip = 'Name or description of the expense category.';
            DataClassification = ToBeClassified;
        }

        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
            Tooltip = 'Amount assigned to this category.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Primary key ensures unique combination of Code, Category, and Name
        key(Key1; Code, Catagory, Name)
        {
            Clustered = true;
        }
    }
}
