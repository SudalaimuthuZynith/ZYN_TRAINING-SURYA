table 50186 ZYNEmployee
{
    Caption = 'Employee';
    DataClassification = ToBeClassified;

    fields
    {
        // Employee unique ID
        field(1; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            ToolTip = 'Unique identifier for the employee.';
            DataClassification = ToBeClassified;
        }

        // Employee full name
        field(2; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            ToolTip = 'Full name of the employee.';
            DataClassification = ToBeClassified;
        }

        // Role of the employee
        field(3; Role; Text[100])
        {
            Caption = 'Role';
            ToolTip = 'Job role or designation of the employee.';
            DataClassification = ToBeClassified;
        }

        // Department of the employee
        field(4; Department; Enum Department)
        {
            Caption = 'Department';
            ToolTip = 'Department to which the employee belongs.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Employee ID")
        {
            Clustered = true; // Ensure Employee ID is unique
        }
    }

    // ----------------------------------------------------------
    // Auto-generate Employee ID if not provided
    // ----------------------------------------------------------
    trigger OnInsert()
    var
        ZYNEmployee: Record ZYNEmployee; // Variable name same as table
        LastID: Integer;
    begin
        if "Employee ID" = '' then begin
            if ZYNEmployee.FindLast() then
                Evaluate(LastID, CopyStr(ZYNEmployee."Employee ID", 4))
            else
                LastID := 0;

            LastID += 1;
            "Employee ID" := 'Emp' + PadStr(Format(LastID), 3, '0');
        end;
    end;
}
enum 50155 Department
{
    Extensible = true; // Allows adding new departments in future

    value(1; Developer)
    {
        Caption = 'Developer'; // Employees in development role
    }

    value(2; HR)
    {
        Caption = 'HR'; // Employees in Human Resources
    }

    value(3; Finance)
    {
        Caption = 'Finance'; // Employees in Finance department
    }
}
