table 50188 "ZYNEmployeeAssetList"
{
    DataClassification = ToBeClassified; // Table stores asset assignment details for employees

    fields
    {
        field(1; "Employee"; Code[200])
        {
            Caption = 'Employee ID'; // Employee who owns/uses the asset
            DataClassification = ToBeClassified;
            TableRelation = ZYNEmployee."Employee ID";
        }

        field(2; "Serial No"; Code[20])
        {
            Caption = 'Serial Number'; // Asset serial number assigned to the employee
            DataClassification = ToBeClassified;
            TableRelation = ZYNAssetsList."Serial No";

            trigger OnValidate()
            var
                asset: Record ZYNAssetsList;
            begin
                // When Serial No is validated, auto-fill Asset Type from the asset list
                asset.SetRange("Serial No", Rec."Serial No");
                if asset.FindFirst() then
                    Rec."Asset Type" := asset."Asset type";
            end;
        }

        field(55; "Asset Type"; Text[30])
        {
            Caption = 'Asset Type'; // Type of the asset (e.g., Laptop, Printer)
            DataClassification = ToBeClassified;
        }

        field(3; Status; Enum assetstatus)
        {
            Caption = 'Asset Status'; // Current status of the asset
            DataClassification = ToBeClassified;
        }

        field(4; "Assigned Date"; Date)
        {
            Caption = 'Assigned Date'; // Date when the asset was assigned
            DataClassification = ToBeClassified;
        }

        field(5; "Returned Date"; Date)
        {
            Caption = 'Returned Date'; // Date when the asset was returned
            DataClassification = ToBeClassified;
        }

        field(6; "Lost Date"; Date)
        {
            Caption = 'Lost Date'; // Date when the asset was reported lost
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee", "Serial No", Status)
        {
            Clustered = true; // Unique record combination per employee, serial, and status
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Employee", "Serial No", "Asset Type", Status) { }
    }
}
enum 50169 "assetstatus"
{
    Extensible = true; // Allows adding more statuses later if required

    value(1; Assigned)
    {
        Caption = 'Assigned'; // Asset currently assigned to employee
    }

    value(2; Returned)
    {
        Caption = 'Returned'; // Asset returned to inventory
    }

    value(3; Lost)
    {
        Caption = 'Lost'; // Asset reported lost
    }
}
