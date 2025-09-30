page 50148 "ZYN Bank Contact Temp"
{
    PageType = List;
    SourceTable = Contact;
    SourceTableTemporary = true;
    ApplicationArea = All;
    Caption = 'bank Contacts (Temp)';
    
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
