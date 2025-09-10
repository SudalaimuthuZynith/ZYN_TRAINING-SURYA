table 50181 ZYN_PlanTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Plan ID"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Name; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Fee; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; status; Enum planstatus)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Plan ID")
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
    var
        plan: Record ZYN_PlanTable;
        Lastid: Integer;
    begin
        if "Plan ID" = '' then begin
            if plan.FindLast() then
                Evaluate(lastid, CopyStr(plan."Plan ID", 5))
            else
                lastid := 0;
            Lastid += 1;
            "Plan ID" := 'PLAN' + PadStr(Format(lastid), 3, '0');
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        sub: Record ZYN_PlanSubscriptionTable;
    begin
        Sub.Reset();
        Sub.SetRange("Plan ID", Rec."Plan ID");

        if Sub.FindSet() then
            repeat
                Sub.substatus := Sub.substatus::InActive;
                Sub.Modify(true);
            until Sub.Next() = 0;

    end;

    trigger OnRename()
    begin

    end;

}
enum 50192 planstatus
{
    value(1; Active) { }
    value(2; InActive) { }
}