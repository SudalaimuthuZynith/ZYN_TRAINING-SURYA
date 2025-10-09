tableextension 50129 postedsalescrediteext extends "Sales Cr.Memo Header"
{
    Caption = 'Posted Sales Credit Memo Extension';

    fields
    {
        field(1; beginning_text; Code[20])
        {
            Caption = 'Beginning Text';
            Tooltip = 'Code of the standard text to display at the beginning of the credit memo.';
            DataClassification = CustomerContent;
            TableRelation = "Standard Text".Code;
            Editable = false;
        }

        field(2000; end_text; Code[20])
        {
            Caption = 'End Text';
            Tooltip = 'Code of the standard text to display at the end of the credit memo.';
            DataClassification = CustomerContent;
            TableRelation = "Standard Text".Code;
            Editable = false;
        }
    }
}
