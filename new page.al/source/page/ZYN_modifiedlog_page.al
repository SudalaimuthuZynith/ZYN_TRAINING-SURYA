page 50141 ZYNlog
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNlog;
    Editable = false;
    InsertAllowed = false;
    Caption = 'Log List';

    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field(entryNo; Rec.entryNo)
                {
                }
                field(customer_no; Rec.customer_no)
                {
                }
                field(fieldname; Rec.fieldname)
                {
                }
                field(oldvalue; Rec.oldvalue)
                {
                }
                field(newvalue; Rec.newvalue)
                {
                }
                field(user_id; Rec.user_id)
                {
                }
            }
        }
    }
}
