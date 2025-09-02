table 50159 EmpLeaveHiddenTable
{
  DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(2; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(3; Catagory; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = LeaveCatagoryTable."Catagory Name";
        }

        field(4; "Remaining Days"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false; 
        }
    }

    keys
    {
        key(PK; "Employee ID", Catagory)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        CalcRemainingDays();
    end;

    trigger OnModify()
    begin
        CalcRemainingDays();
    end;

    local procedure CalcRemainingDays()
    var
    
        LeaveCat: Record LeaveCatagoryTable;
        LeaveReq: Record LeaveRequestTable;
        used: Integer;
        allowed: Integer;
    begin
       
        if LeaveCat.Get(Catagory) then
            allowed := LeaveCat."No of days allowed";

        LeaveReq.SetRange("Employee ID", "Employee ID");
        LeaveReq.SetRange(Catagory, Catagory);
        LeaveReq.SetRange(Status, LeaveReq.Status::Approved);

        if LeaveReq.FindSet() then
            repeat
                used += LeaveReq."Total Days";
            until LeaveReq.Next() = 0;

        "Remaining Days" := allowed - used;
    end;

}
