table 50130 technicians
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; tech_id; Code[20])
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2; tech_name; Text[30])
        {
            DataClassification = SystemMetadata;


        }
        field(3; tech_phone_no; code[10])
        {
            DataClassification = SystemMetadata;

        }
        field(4; problems; Enum "problems")
        {
            Caption = 'skills';
            DataClassification = SystemMetadata;

        }
        field(7; count; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(ZYNProblems where(tech_id = field(tech_id)));
        }

    }

    keys
    {
        key(PK; tech_id)
        {
            Clustered = true;
        }
    }

    // fieldgroups
    // {
    //     // Add changes to field groups here
    // }

    // var
    //     myInt: Integer;

    // trigger OnInsert()
    trigger OnInsert()
    var
        LastTech: Record technicians;
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        if tech_id = '' then begin
            if LastTech.FindLast() then begin

                Evaluate(LastId, COPYSTR(LastTech.tech_id, 2));
            end else
                LastId := 0;

            LastId += 1;


            LastIdStr := 'A' + PADSTR(Format(LastId), 3, '0');
            tech_id := LastIdStr;
        end;
    end;


    // trigger OnModify()
    // begin

    // end;

    // trigger OnDelete()
    // begin

    // end;

    // trigger OnRename()
    // begin

    // end;

}
enum 50126 problems
{
    value(0; IT) { }
    value(1; Network) { }
    value(2; Hardware) { }
}