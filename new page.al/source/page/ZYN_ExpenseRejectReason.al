page 50200 ZYN_ExpenseRejectReason
{
    PageType = StandardDialog;
    Caption = 'Enter Rejection Reason';

    layout
    {
        area(Content)
        {
            field(Reason; ReasonText)
            {
                ApplicationArea = All;
                Caption = 'Reason';
            }
        }
    }

    var
        ReasonText: Text[250];

    procedure GetReason(): Text[250]
    begin
        exit(ReasonText);
    end;
}
