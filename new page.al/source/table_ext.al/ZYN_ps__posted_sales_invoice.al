tableextension 50128 postedsalesinvoiceext extends "Sales Invoice Header"
{
    fields
    {
        field(1; beginning_text; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Standard Text".Code;
            Editable = false;
        }
        field(2000; end_text; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Standard Text".Code;
            Editable = false;
        }

    }
}