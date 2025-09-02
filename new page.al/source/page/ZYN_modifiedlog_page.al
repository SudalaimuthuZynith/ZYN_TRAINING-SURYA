page 50141 logpage
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = logtable;
    Editable = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field(entryNo; Rec.entryNo) { }
                field(customer_no; Rec.customer_no) { }
                // field(Name; Rec.Name) { }
                field(fieldname; Rec.fieldname) { }
                field(oldvalue; Rec.oldvalue) { }
                field(newvalue; Rec.newvalue) { }
                field(user_id; Rec.user_id) { }


            }
        }
    }

}
