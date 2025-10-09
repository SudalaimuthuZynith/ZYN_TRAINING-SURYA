table 50183 ZYNLeaveRequest
{
    Caption = 'Leave Request';
    DataClassification = ToBeClassified;

    fields
    {
        field(12; "entry no"; Integer)
        {
            Caption = 'Entry No.';
            Tooltip = 'Unique sequential number for each leave request.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(1; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            Tooltip = 'Specifies the employee requesting leave.';
            DataClassification = ToBeClassified;
            TableRelation = ZYNEmployee."Employee ID";
            trigger OnValidate()
            var
                ZYNEmployee: Record ZYNEmployee;
            begin
                UpdateHiddenTable();
                ZYNEmployee.SetRange("Employee ID", Rec."Employee ID");
                if ZYNEmployee.FindFirst() then
                    Rec."Employee Name" := ZYNEmployee."Employee Name";
            end;
        }

        field(9; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Tooltip = 'Displays the name of the employee requesting leave.';
            DataClassification = ToBeClassified;
            // TableRelation = EmployeeTable."Employee Name";
        }

        field(2; "Catagory"; Text[20])
        {
            Caption = 'Leave Category';
            Tooltip = 'Specifies the leave category for this request.';
            DataClassification = ToBeClassified;
            TableRelation = ZYNLeaveCatagory."Catagory Name";
            trigger OnValidate()
            begin
                UpdateHiddenTable();
            end;
        }

        field(11; Reason; Text[100])
        {
            Caption = 'Reason';
            Tooltip = 'Reason provided by the employee for requesting leave.';
            DataClassification = ToBeClassified;
        }

        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
            Tooltip = 'Start date of the leave.';
            DataClassification = ToBeClassified;
        }

        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
            Tooltip = 'End date of the leave. Automatically calculates total days.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if ("Start Date" <> 0D) and ("End Date" <> 0D) then
                    Rec."total days" := "End Date" - "Start Date";
            end;
        }

        field(22; "total days"; Integer)
        {
            Caption = 'Total Days';
            Tooltip = 'Total number of leave days calculated from start and end date.';
            DataClassification = ToBeClassified;
        }

        field(23; "Remaining leave days"; Integer)
        {
            Caption = 'Remaining Leave Days';
            Tooltip = 'Displays remaining leave days for the employee in this category.';
            FieldClass = FlowField;
            CalcFormula = Lookup(ZYN_EmpLeaveHiddenTable."Remaining Days" WHERE("Employee ID" = FIELD("Employee ID"), Category = FIELD(Catagory)));
        }

        field(7; Status; Enum Status)
        {
            Caption = 'Status';
            Tooltip = 'Current approval status of the leave request.';
            InitValue = Pending;
            Editable = false;
        }

        // field(3;Role;Text[100])
        // {
        //     DataClassification=ToBeClassified;
        // }
    }

    keys
    {
        key(Key1; "entry no", "Employee ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnDelete()
    begin
        if (Status.AsInteger() = 2) or (Status.AsInteger() = 3) then
            Error('This type can''t be deleted');
    end;

    local procedure UpdateHiddenTable()
    var
        EmpLeaveHiddenTable: Record ZYN_EmpLeaveHiddenTable;
    begin
        if ("Employee ID" = '') or (Catagory = '') then
            exit;

        if EmpLeaveHiddenTable.Get("Employee ID", Catagory) then begin
            EmpLeaveHiddenTable."Employee Name" := "Employee Name";
            EmpLeaveHiddenTable.Modify(true);
        end else begin
            EmpLeaveHiddenTable.Init();
            EmpLeaveHiddenTable."Employee ID" := "Employee ID";
            EmpLeaveHiddenTable."Employee Name" := "Employee Name";
            EmpLeaveHiddenTable.Category := Catagory;
            EmpLeaveHiddenTable.Insert(true);
        end;
    end;
}

enum 50191 Status
{
    value(1; Pending) { }
    value(2; Approved) { }
    value(3; Rejected) { }
}
