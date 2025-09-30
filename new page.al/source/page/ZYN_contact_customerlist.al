page 50122 "ZYN Customer Contact Temp"
{
    PageType = List;
    SourceTable = Contact;
    SourceTableTemporary = true;
    ApplicationArea = All;
    Caption = 'Customer Contacts (Temp)';

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
