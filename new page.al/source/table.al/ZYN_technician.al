table 50130 ZYN_technicians
{
    Caption = 'Technicians';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; tech_id; Code[20])
        {
            Caption = 'Technician ID';
            Tooltip = 'Unique identifier for each technician.';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(2; tech_name; Text[30])
        {
            Caption = 'Technician Name';
            Tooltip = 'Full name of the technician.';
            DataClassification = SystemMetadata;
        }

        field(3; tech_phone_no; Code[10])
        {
            Caption = 'Phone Number';
            Tooltip = 'Contact phone number of the technician.';
            DataClassification = SystemMetadata;
        }

        field(4; problems; Enum problems)
        {
            Caption = 'Skills';
            Tooltip = 'Primary skill area of the technician (IT, Network, Hardware).';
            DataClassification = SystemMetadata;
        }

        field(7; count; Integer)
        {
            Caption = 'Assigned Problem Count';
            Tooltip = 'Number of problems assigned to the technician.';
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

    trigger OnInsert()
    var
        LastTech: Record ZYN_technicians;
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        // Auto-generate Technician ID if empty
        if tech_id = '' then begin
            if LastTech.FindLast() then
                Evaluate(LastId, CopyStr(LastTech.tech_id, 2))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'A' + PadStr(Format(LastId), 3, '0');
            tech_id := LastIdStr;
        end;
    end;
}

enum 50126 problems
{
    value(0; IT) { }
    value(1; Network) { }
    value(2; Hardware) { }
}
