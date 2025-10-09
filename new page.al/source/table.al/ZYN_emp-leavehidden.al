table 50159 ZYN_EmpLeaveHiddenTable
{
    Caption = 'Employee Leave Hidden Table';
    DataClassification = ToBeClassified;

    fields
    {
        // Employee unique ID
        field(1; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            ToolTip = 'Specifies the unique ID of the employee.';
            DataClassification = CustomerContent;
        }

        // Employee name
        field(2; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            ToolTip = 'Specifies the name of the employee.';
            DataClassification = CustomerContent;
        }

        // Leave category (ex: Casual Leave, Sick Leave, etc.)
        field(3; Category; Code[20])
        {
            Caption = 'Leave Category';
            ToolTip = 'Specifies the leave category assigned to the employee.';
            DataClassification = CustomerContent;
            TableRelation = ZYNLeaveCatagory."Catagory Name";
        }

        // Remaining leave days for the employee
        field(4; "Remaining Days"; Integer)
        {
            Caption = 'Remaining Leave Days';
            ToolTip = 'Displays the number of remaining leave days available for this employee.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Employee ID", Category)
        {
            Clustered = true;
        }
    }

    // Triggers
    trigger OnInsert()
    begin
        CalcRemainingDays();
    end;

    trigger OnModify()
    begin
        CalcRemainingDays();
    end;

    // ----------------------------------------------------------
    // Calculates remaining leave days for the employee
    // ----------------------------------------------------------
    local procedure CalcRemainingDays()
    var
        LeaveCat: Record ZYNLeaveCatagory;
        LeaveReq: Record ZYNLeaveRequest;
        UsedDays: Integer;
        AllowedDays: Integer;
    begin
        // Get the allowed leave days for the selected category
        if LeaveCat.Get(Category) then
            AllowedDays := LeaveCat."No of days allowed";

        // Filter approved leave requests for the same employee and category
        LeaveReq.SetRange("Employee ID", "Employee ID");
        LeaveReq.SetRange(Catagory, Category);
        LeaveReq.SetRange(Status, LeaveReq.Status::Approved);

        // Sum total used days
        if LeaveReq.FindSet() then
            repeat
                UsedDays += LeaveReq."Total Days";
            until LeaveReq.Next() = 0;

        // Calculate remaining days
        "Remaining Days" := AllowedDays - UsedDays;
    end;
}
