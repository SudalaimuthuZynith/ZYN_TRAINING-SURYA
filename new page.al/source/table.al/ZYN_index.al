table 50125 ZYNIndex
{
    Caption = 'ZYN Index';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Index Code';
            Tooltip = 'Specifies the unique code for each index record. Automatically generated if left blank.';
            DataClassification = ToBeClassified;
        }

        field(2; Description; Text[100])
        {
            Caption = 'Description';
            Tooltip = 'Provides a brief description of the index record.';
            DataClassification = ToBeClassified;
        }

        field(3; "Percentage Increase"; Decimal)
        {
            Caption = 'Percentage Increase';
            Tooltip = 'Specifies the annual percentage increase used for index calculations.';
            DataClassification = ToBeClassified;
        }

        field(4; "Start Year"; Integer)
        {
            Caption = 'Start Year';
            Tooltip = 'Specifies the starting year for the index calculation.';
            DataClassification = ToBeClassified;
        }

        field(5; "End Year"; Integer)
        {
            Caption = 'End Year';
            Tooltip = 'Specifies the ending year for the index calculation.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        ZYNIndex: Record ZYNIndex;
        LastId: Integer;
    begin
        // Auto-generate Index Code if not provided manually
        if Code = '' then begin
            if ZYNIndex.FindLast() then
                Evaluate(LastId, CopyStr(ZYNIndex.Code, 6))
            else
                LastId := 0;

            LastId += 1;
            Code := 'INDEX' + PadStr(Format(LastId), 3, '0');
        end;
    end;

    trigger OnModify()
    var
        IndexLines: Record ZYN_IndexLines;
        CurrentPercentage: Decimal;
        EntryNo: Integer;
        YearLoop: Integer;
    begin
        // Remove existing IndexLines entries linked to this index
        IndexLines.SetRange(Code, Code);
        if IndexLines.FindSet() then
            repeat
                IndexLines.Delete();
            until IndexLines.Next() = 0;

        // Rebuild index lines for each year range with calculated percentage
        EntryNo := 1;
        CurrentPercentage := 100;

        for YearLoop := "Start Year" to "End Year" do begin
            IndexLines.Init();
            IndexLines.Code := Code;
            IndexLines.EntryNo := EntryNo;
            IndexLines.Year := YearLoop;
            IndexLines.Percentage := CurrentPercentage;
            IndexLines.Insert();

            // Increment percentage for next year
            CurrentPercentage := CurrentPercentage * (1 + "Percentage Increase" / 100);
            EntryNo += 1;
        end;
    end;

    trigger OnDelete()
    var
        IndexLines: Record ZYN_IndexLines;
    begin
        // Delete all IndexLines linked to this index code
        IndexLines.SetRange(Code, Code);
        if IndexLines.FindSet() then
            repeat
                IndexLines.Delete();
            until IndexLines.Next() = 0;
    end;
}
