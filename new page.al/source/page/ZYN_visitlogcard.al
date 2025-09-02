page 50105 "Visit Log Card"
{
    PageType = Card;
    ApplicationArea = All;

    SourceTable = Visitlog;

    layout
    {
        area(Content)
        {
            group(general)
            {

                field(CustomerNo; Rec.CustomerNo) { ApplicationArea = All; }
                field(Date; Rec.Date) { ApplicationArea = All; }
                field(purpose; Rec.purpose) { ApplicationArea = All; }
                field(notes; Rec.notes) { ApplicationArea = All; }
            }
        }
    }



}