table 50128 "Field Value Buffer"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(2; "Field Value"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(3; recordid; RecordId)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Field Value") { Clustered = true; }
    }
}

