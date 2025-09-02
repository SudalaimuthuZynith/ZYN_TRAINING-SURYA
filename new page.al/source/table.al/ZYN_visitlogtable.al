table 50143 Visitlog
{
    DataClassification = ToBeClassified;

    fields
    {

        field(1; Entryno; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; CustomerNo; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            Editable = false;
        }
        field(3; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; purpose; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(5; notes; Text[30])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; Entryno, CustomerNo)
        {
            Clustered = true;
        }

        key(Datepurposenotes; Date, purpose, notes)
        {
            Clustered = false;
        }
    }
}