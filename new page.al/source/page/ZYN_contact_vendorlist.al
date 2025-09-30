page 50133 "ZYN Vendor Contact Temp"
{
    PageType = List;
    SourceTable = Contact;
    SourceTableTemporary = true;
    ApplicationArea = All;
    Caption = 'vendor Contacts (Temp)';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                }
                field("Contact relation"; rec."Contact Business Relation")
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
            }
        }
    }
}
