table 50182 LeaveCatagoryTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Catagory Name"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "No of days allowed"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        // field(3;Role;Text[100])
        // {
        //     DataClassification=ToBeClassified;
        // }

    }

    keys
    {
        key(Key1; "Catagory Name")
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
    //     employeetable: Record EmployeeTable;

    //     Lastid: Integer;
    // begin
    //     if "Emp = '' then begin
    //         if employeetable.FindLast() then
    //             Evaluate(lastid, CopyStr(employeetable."Employee ID", 4))
    //         else
    //             lastid := 0;
    //         Lastid += 1;
    //         "Employee ID" := 'Emp' + PadStr(Format(lastid), 3, '0');
    //     end;

    //end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}