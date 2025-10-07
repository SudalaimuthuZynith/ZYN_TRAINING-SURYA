pageextension 50109 contactext extends "Contact List"
{
    actions
    {
        modify(Customer)
        {
            trigger OnBeforeAction()
            var
                SingleInstanceMgt: Codeunit Zyn_SingleInstanceManagment;
            begin
                SingleInstanceMgt.SetFromCreateAs();
            end;
        }
        modify(Vendor)
        {
            trigger OnBeforeAction()
            var
                SingleInstanceMgt: Codeunit Zyn_SingleInstanceManagment;
            begin
                SingleInstanceMgt.SetFromCreateAs();
            end;
        }
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
                    PAGE.RunModal(PAGE::"ZYN Customer Contact Temp", tempcustomlist);
                    PAGE.RunModal(PAGE::"ZYN Vendor Contact Temp", tempvendorlist);
                    PAGE.RunModal(PAGE::"ZYN Bank Contact Temp", tempbanklist);
                end;
            }
        }
    }
}