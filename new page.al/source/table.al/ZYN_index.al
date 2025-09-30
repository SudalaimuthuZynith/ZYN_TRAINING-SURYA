table 50125 ZYNIndex
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "percentage increase"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Start Year"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "End Year"; Integer)
        {
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
        LastId: Integer;
        TempRec: Record ZYNIndex;
    begin

        if Code = '' then begin
            if TempRec.FindLast() then
                Evaluate(LastId, COPYSTR(TempRec.Code, 6))
            else
                LastId := 0;

            LastId += 1;
            Code := 'INDEX' + PADSTR(Format(LastId), 3, '0');
        end;
    end;

    trigger OnModify()

    var
        LineRec: Record IndexLines;
        CurrentPercentage: Decimal;
        EntryNo: Integer;
        YearLoop: Integer;
    begin
        LineRec.SetRange(Code, Code);
        if LineRec.FindSet() then
            repeat
                LineRec.Delete();
            until LineRec.Next() = 0;

        EntryNo := 1;
        CurrentPercentage := 100;

        for YearLoop := "Start Year" to "End Year" do begin

            LineRec.Init();
            LineRec.Code := Code;
            LineRec.entryno := EntryNo;
            LineRec.year := YearLoop;
            LineRec.percentage := CurrentPercentage;
            LineRec.Insert();
            CurrentPercentage := CurrentPercentage * (1 + "Percentage Increase" / 100);
            EntryNo += 1;
        end;
    end;


    trigger OnDelete()
    var
        LineRec: Record IndexLines;
    begin
        LineRec.SetRange(Code, Code);
        if LineRec.FindSet() then
            repeat
                LineRec.Delete();
            until LineRec.Next() = 0;
    end;

    trigger OnRename()
    begin

    end;


}