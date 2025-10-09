table 50187 "ZYNAssetType"
{
    DataClassification = ToBeClassified; // Data classification to be reviewed

    fields
    {
        field(10; "catagory id"; Code[20])
        {
            Caption = 'Category ID'; // Auto-generated unique ID (e.g., CAT001)
            DataClassification = ToBeClassified;
        }

        field(1; "Catagory"; Enum "asset catagory")
        {
            Caption = 'Category'; // Asset category type
            DataClassification = ToBeClassified;
        }

        field(2; "Name"; Text[30])
        {
            Caption = 'Asset Type Name'; // Descriptive name for the asset type
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "catagory id", Name)
        {
            Clustered = true; // Primary key ensuring unique category entries
        }
    }

    fieldgroups
    {
        fieldgroup(Name; Name) { } // Used for lookups
    }

    trigger OnInsert()
    var
        assetType: Record "ZYNAssetType";
        lastId: Integer;
    begin
        // Auto-generate unique Category ID (e.g., CAT001, CAT002)
        if "catagory id" = '' then begin
            if assetType.FindLast() then
                Evaluate(lastId, CopyStr(assetType."catagory id", 4))
            else
                lastId := 0;

            lastId += 1;
            "catagory id" := 'CAT' + PadStr(Format(lastId), 3, '0');
        end;
    end;
}
enum 50189 "asset catagory"
{
    Extensible = true; // Allows adding new categories in the future

    value(1; Infrastructure)
    {
        Caption = 'Infrastructure'; // Physical setup assets
    }

    value(2; Electronics)
    {
        Caption = 'Electronics'; // Electronic devices like laptops, printers
    }

    value(3; Documents)
    {
        Caption = 'Documents'; // Files, agreements, and paper assets
    }
}
