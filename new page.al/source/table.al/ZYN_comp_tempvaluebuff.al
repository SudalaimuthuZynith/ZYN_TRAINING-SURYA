table 50128 ZYN_FieldValueBuffer
{
    DataClassification = ToBeClassified; // Used to temporarily store field values linked to record IDs

    fields
    {
        field(2; "Field Value"; Text[1000])
        {
            Caption = 'Field Value'; // Value stored for a particular field
            ToolTip = 'Specifies the value of the field being temporarily stored for processing.';
            DataClassification = ToBeClassified;
        }

        field(3; "Record ID"; RecordId)
        {
            Caption = 'Record ID'; // Reference to the record this value belongs to
            ToolTip = 'Specifies the record that this field value is associated with.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Field Value")
        {
            Clustered = true; // Ensures each field value entry is unique
        }
    }
}
