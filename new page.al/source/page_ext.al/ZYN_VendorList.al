pageextension 50238 VendorListExt extends "Vendor List"
{

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
                    NewVendor: Record Vendor;
                begin
                    SelectedCompany.SetRange(IsMaster, false);
                    // Step 1: Select the slave company
                    if PAGE.RunModal(PAGE::ZYN_Company, SelectedCompany) = ACTION::LookupOK then begin
                        if SelectedCompany.FindSet() then begin
                            sendfrommaster.VendorToSlave(Rec."No.", SelectedCompany.Name);
                        end;
                        // Step 2: Initialize new customer record
                    end;
                end;
            }
        }
    }


}
