pageextension 50109 contactext extends "Contact List"
{
    actions
    {
        addlast(processing)
        {
            action(tempcontactlist)
            {
                ApplicationArea = all;
                Caption = 'listss';
                Image = View;
                trigger OnAction()
                var
                    contactlist: record Contact;
                    tempcustomlist: Record Contact temporary;
                    tempvendorlist: Record Contact temporary;
                    tempbanklist: Record Contact temporary;
                begin
                    if contactlist.FindSet() then
                        repeat
                            case
                                contactlist."Contact Business Relation" of
                                contactlist."Contact Business Relation"::Customer:
                                    begin
                                        tempcustomlist.Init();
                                        tempcustomlist.TransferFields(contactlist);
                                        tempcustomlist.Insert();
                                    end;
                                contactlist."Contact Business Relation"::Vendor:
                                    begin
                                        tempvendorlist.Init();
                                        tempvendorlist.TransferFields(contactlist);
                                        tempvendorlist.Insert();
                                    end;
                                contactlist."Contact Business Relation"::"Bank Account":
                                    begin
                                        tempbanklist.Init();
                                        tempbanklist.TransferFields(contactlist);
                                        tempbanklist.Insert();
                                    end;

                            end;
                        until contactlist.Next() = 0;
                    PAGE.RunModal(PAGE::"Customer Contact Temp List", tempcustomlist);
                    PAGE.RunModal(PAGE::"Vendor Contact Temp List", tempvendorlist);
                    PAGE.RunModal(PAGE::"Bank Contact Temp List", tempbanklist);
                end;
            }
        }
    }
}