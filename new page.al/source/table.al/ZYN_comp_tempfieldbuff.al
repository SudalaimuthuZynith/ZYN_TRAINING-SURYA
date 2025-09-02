table 50126 "Field Buffer Storage"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Table No."; Integer) { }
        field(2; "Field Name"; Text[250]) { }
    }

    keys
    {
        key(PK; "Field Name") { Clustered = true; }
    }
}