page 50133 "Vendor Contact Temp List"
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
                    ApplicationArea = All;
                }
                field("Contact relation"; rec."Contact Business Relation")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                // Add more fields as you want
            }
        }
    }
}
