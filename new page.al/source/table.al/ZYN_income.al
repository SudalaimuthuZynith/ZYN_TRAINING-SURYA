table 50179 ZYN_Income
{
    Caption = 'Income';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Income ID"; Code[20])
        {
            Caption = 'Income ID';
            Tooltip = 'Specifies the unique identifier for each income entry.';
            DataClassification = ToBeClassified;
        }

        field(2; Description; Text[30])
        {
            Caption = 'Description';
            Tooltip = 'Provides a short description of the income source.';
            DataClassification = ToBeClassified;
        }

        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
            Tooltip = 'Specifies the total income amount received.';
            DataClassification = ToBeClassified;
        }

        field(5; Date; Date)
        {
            Caption = 'Date';
            Tooltip = 'Specifies the date when the income was recorded.';
            DataClassification = ToBeClassified;
        }

        field(4; Catagory; Code[30])
        {
            Caption = 'Category';
            Tooltip = 'Specifies the category to which this income belongs.';
            DataClassification = ToBeClassified;
            TableRelation = ZYN_IncomeCategoryTable.Name;
        }
    }

    keys
    {
        key(Key1; "Income ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Income ID", Description, Amount)
        {
            // Displays key income details in lookup dropdowns
        }
    }

    trigger OnInsert()
    var
        Income: Record ZYN_Income;
        LastID: Integer;
    begin
        // Auto-generate a unique Income ID if not manually entered
        if "Income ID" = '' then begin
            if Income.FindLast() then
                Evaluate(LastID, CopyStr(Income."Income ID", 8))
            else
                LastID := 0;

            LastID += 1;
            "Income ID" := 'INCOMEE' + PadStr(Format(LastID), 3, '0');
        end;
    end;

    trigger OnDelete()
    var
        Income: Record ZYN_Income;
    begin
        // Delete all records matching the same Income ID
        Income.SetRange("Income ID", "Income ID");
        if Income.FindSet() then
            Income.DeleteAll();
    end;
}
