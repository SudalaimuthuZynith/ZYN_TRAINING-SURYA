table 50197 "ZYNAssetsList"
{
    DataClassification = ToBeClassified; // Data classification to be reviewed for compliance and security

    fields
    {
        field(1; "Asset type"; Text[30])
        {
            Caption = 'Asset Type'; // Caption shown in UI pages
            DataClassification = ToBeClassified;
            TableRelation = ZYNAssetType.Name; // Lookup relation to Asset Type table for consistency
            // Represents the type/category of the asset (e.g., Laptop, Printer, etc.)
        }

        field(2; "Serial No"; Code[20])
        {
            Caption = 'Serial Number'; // Caption shown in UI pages
            DataClassification = ToBeClassified;
            // Unique serial number or identifier for the asset
        }

        field(3; "procured date"; Date)
        {
            Caption = 'Procured Date'; // Caption shown in UI pages
            DataClassification = ToBeClassified;
            // The date on which the asset was purchased or acquired
        }

        field(4; "Vendor name"; Text[20])
        {
            Caption = 'Vendor Name'; // Caption shown in UI pages
            DataClassification = ToBeClassified;
            // The name of the vendor or supplier from whom the asset was procured
        }

        field(5; "Available"; Boolean)
        {
            Caption = 'Available'; // Caption shown in UI pages
            DataClassification = ToBeClassified;
            // Indicates whether the asset is currently available (TRUE) or in use (FALSE)
        }
    }

    keys
    {
        key(Key1; "Asset type", "Serial No")
        {
            Clustered = true;
            // Primary key combination ensuring unique asset entries by type and serial number
        }
    }
}
