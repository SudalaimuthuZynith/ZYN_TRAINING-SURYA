table 50129 ZYNlog
{
    DataClassification = ToBeClassified;

    fields
    {
        field(9; entryNo; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(1; customer_no; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        // field(2; Name; Text[20])
        // {
        //     DataClassification = ToBeClassified;

        // }
        field(3; fieldname; Text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(4; oldvalue; Text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(5; newvalue; Text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(6; user_id; Code[10])
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(PRK; entryNo)
        {
            Clustered = true;
        }
    }





}
