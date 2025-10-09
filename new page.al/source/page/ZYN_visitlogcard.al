page 50105 ZYN_VisitLogCard
{
    PageType = Card;
    ApplicationArea = All;

    SourceTable = ZYN_Visitlog;

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