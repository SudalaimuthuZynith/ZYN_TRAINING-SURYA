page 50102 "Visit Log list"
{
    PageType = List;
    ApplicationArea = All;
    CardPageId = "Visit Log Card";
    SourceTable = Visitlog;
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