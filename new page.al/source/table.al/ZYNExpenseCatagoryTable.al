table 50257 ZYN_ExpenseCatagoryTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Catagory; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Name; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Code, Catagory, Name)
        {
            Clustered = true;
        }
    }



}