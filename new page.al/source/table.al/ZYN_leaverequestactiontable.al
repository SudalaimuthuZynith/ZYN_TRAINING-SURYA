table 50183 LeaveRequestTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(12; "entry no"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(1; "Employee ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = EmployeeTable."Employee ID";
            trigger OnValidate()
            var
                emp: Record EmployeeTable;
            begin
                UpdateHiddenTable();
                emp.SetRange("Employee ID", Rec."Employee ID");
                if emp.FindFirst() then
                    Rec."Employee Name" := emp."Employee Name";
            end;
        }
        field(9; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            // TableRelation = EmployeeTable."Employee Name";
        }
        field(2; "Catagory"; Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = LeaveCatagoryTable."Catagory Name";
            trigger OnValidate()
            begin
                UpdateHiddenTable();
            end;
        }
        field(11; Reason; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                if ("Start Date" <> 0D) and ("End Date" <> 0D) then
                    Rec."total days" := "End Date" - "Start Date";
            end;
        }
        field(22; "total days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Remaining leave days"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(EmpLeaveHiddenTable."Remaining Days" where("Employee ID" = field("Employee ID"), catagory = field(Catagory)));
        }

        field(7; Status; Enum status)
        {
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

    trigger OnInsert()
    begin

    end;

    // var
    //     employeetable: Record LeaveRequestTable;

    //     Lastid: Integer;
    // begin
    //     if "Leave Req ID" = '' then begin
    //         if employeetable.FindLast() then
    //             Evaluate(lastid, CopyStr(employeetable."Leave Req ID", 4))
    //         else
    //             lastid := 0;
    //         Lastid += 1;
    //         "Leave Req ID" := 'LID' + PadStr(Format(lastid), 3, '0');
    //     end;

    //end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        if (Status.AsInteger() = 2) or (Status.AsInteger() = 3) then
            Error('This type cant be deeted');

    end;

    trigger OnRename()
    begin

    end;

    local procedure UpdateHiddenTable()
    var
        Hidden: Record EmpLeaveHiddenTable;
    begin
        if ("Employee ID" = '') or (Catagory = '') then
            exit;

        if Hidden.Get("Employee ID", Catagory) then begin
            Hidden."Employee Name" := "Employee Name";
            Hidden.Modify(true);
        end else begin
            Hidden.Init();
            Hidden."Employee ID" := "Employee ID";
            Hidden."Employee Name" := "Employee Name";
            Hidden.Catagory := Catagory;
            Hidden.Insert(true);
        end;
    end;

}
enum 50191 status
{
    value(1; Pending) { }
    value(2; Approved) { }
    value(3; Rejected) { }
}