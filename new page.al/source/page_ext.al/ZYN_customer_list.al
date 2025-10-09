pageextension 50138 CustomerListExt extends "Customer List"
{
    layout
    {
        addfirst(factboxes)
        {
            part(cutomer; ZYN_Factbox)
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
            }
            // part("INVOICECOUNT"; "INVOICECOUNT")
            // {
            //     ApplicationArea = all;
            // }
            part(CustomerSubscriptionsPage; ZYN_CustomerSubscriptionsPage)
            {
                SubPageLink = "Customer ID" = field("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("SendToSlave")
            {
                ApplicationArea = All;
                Caption = 'Send to Slave';
                Image = SendTo;

                trigger OnAction()
                var
                    sendfrommaster: Codeunit Zyn_SendFromMasterToSlaveMgt;
                    SelectedCompany: Record ZYN_Company;
                    NewCustomer: Record Customer;
                begin
                    SelectedCompany.SetRange(IsMaster, false);
                    // Step 1: Select the slave company
                    if PAGE.RunModal(PAGE::ZYN_Company, SelectedCompany) = ACTION::LookupOK then begin
                        if SelectedCompany.FindSet() then begin
                            sendfrommaster.CustomerToSlave(Rec."No.", SelectedCompany.Name);
                        end;
                        // Step 2: Initialize new customer record
                    end;
                end;
            }
        }
    }


}
