page 50102 ZYN_VisitLoglist
{
    PageType = List;
    ApplicationArea = All;
    CardPageId = ZYN_VisitLogCard;
    SourceTable = ZYN_Visitlog;
    InsertAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field(CustomerNo; Rec.CustomerNo) { }
                field(Date; Rec.Date) { }
                field(purpose; Rec.purpose) { }
                field(notes; Rec.notes) { }
            }
        }
    }




}