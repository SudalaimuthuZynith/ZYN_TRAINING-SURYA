table 50126 "ZYN Field Buffer Storage"
{
    DataClassification = ToBeClassified; // Used to temporarily store field-related data (e.g., table-field mapping)

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table Number'; // Table identification number
            ToolTip = 'Specifies the internal number of the table to which this field belongs.';
            DataClassification = ToBeClassified;
        }

        field(2; "Field Name"; Text[250])
        {
            Caption = 'Field Name'; // Name of the field from the specified table
            ToolTip = 'Specifies the name of the field being stored in this temporary buffer.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Field Name")
        {
            Clustered = true; // Ensures each field name is unique in this table
        }
    }
}
