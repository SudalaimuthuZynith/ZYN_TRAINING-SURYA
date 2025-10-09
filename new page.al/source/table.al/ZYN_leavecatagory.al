table 50182 ZYNLeaveCatagory
{
    Caption = 'Leave Category';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Catagory Name"; Text[20])
        {
            Caption = 'Category Name';
            Tooltip = 'Specifies the name of the leave category.';
            DataClassification = ToBeClassified;
        }

        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
            Tooltip = 'Provides a description for the leave category.';
            DataClassification = ToBeClassified;
        }

        field(4; "No of days allowed"; Integer)
        {
            Caption = 'Number of Days Allowed';
            Tooltip = 'Specifies the number of leave days allowed for this category.';
            DataClassification = ToBeClassified;
        }

        // field(3;Role;Text[100])
        // {
        //     DataClassification=ToBeClassified;
        // }
    }

    keys
    {
        key(Key1; "Catagory Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    // Variable declarations
    var
        myInt: Integer;
}
