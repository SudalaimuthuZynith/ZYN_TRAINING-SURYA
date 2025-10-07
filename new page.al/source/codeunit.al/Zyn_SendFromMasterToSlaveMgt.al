codeunit 50108 "Zyn_SendFromMasterToSlaveMgt"
{
    // -------------------------------------------------------------
    // VARIABLE DECLARATION
    // -------------------------------------------------------------
    var
        IsSync: Boolean;

    // -------------------------------------------------------------
    // EVENT SUBSCRIBERS: CUSTOMER AND VENDOR TABLES (MODIFY, INSERT, DELETE)
    // -------------------------------------------------------------

    // -- Customer Modify (Before)
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CustomerOnBeforeModify(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    begin
        HandleOnBeforeModifyCustomer(Rec, xRec, RunTrigger);
    end;

    // -- Vendor Modify (Before)
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeModifyEvent', '', true, true)]
    local procedure VendorOnBeforeModify(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    begin
        HandleOnBeforeModifyVendor(Rec, xRec, RunTrigger);
    end;

    // -- Customer Insert (Before)
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CustomerOnBeforeInsert(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        HandleOnBeforeInsertCustomer(Rec, RunTrigger);
    end;

    // -- Vendor Insert (Before)
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeInsertEvent', '', true, true)]
    local procedure VendorOnBeforeInsert(var Rec: Record Vendor; RunTrigger: Boolean)
    begin
        HandleOnBeforeInsertVendor(Rec, RunTrigger);
    end;

    // -- Customer Delete (Before)
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure PreventDeleteCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        HandleOnBeforeDeleteCustomer(Rec, RunTrigger);
    end;

    // -- Vendor Delete (Before)
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure PreventDeleteVendor(var Rec: Record Vendor; RunTrigger: Boolean)
    begin
        HandleOnBeforeDeleteVendor(Rec, RunTrigger);
    end;

    // -------------------------------------------------------------
    // EVENT SUBSCRIBERS: AFTER MODIFY & DELETE FOR SYNC OPERATIONS
    // -------------------------------------------------------------

    // -- Customer Modify (After)
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterModifyEvent', '', true, true)]
    local procedure CustomerOnAfterModify(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    begin
        HandleOnAfterModifyCustomer(Rec, xRec, RunTrigger);
    end;

    // -- Vendor Modify (After)
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterModifyEvent', '', true, true)]
    local procedure VendorOnAfterModify(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    begin
        HandleOnAfterModifyVendor(Rec, xRec, RunTrigger);
    end;

    // -- Customer Delete (After)
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterDeleteEvent', '', true, true)]
    local procedure CustomerOnAfterDelete(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        HandleOnAfterDeleteCustomer(Rec, RunTrigger);
    end;

    // -- Vendor Delete (After)
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterDeleteEvent', '', true, true)]
    local procedure VendorOnAfterDelete(var Rec: Record Vendor; RunTrigger: Boolean)
    begin
        HandleOnAfterDeleteVendor(Rec, RunTrigger);
    end;

    // -------------------------------------------------------------
    // EVENT: CONTACT BUSINESS RELATION UPDATE HANDLING
    // -------------------------------------------------------------
    [EventSubscriber(ObjectType::Table, Database::"Contact Business Relation", 'OnBeforeUpdateContactBusinessRelation', '', true, true)]
    local procedure OnBeforeUpdateContactBusinessRelation(ContactBusinessRelation: Record "Contact Business Relation"; var IsHandled: Boolean)
    var
        SingleInstanceMgt: Codeunit Zyn_SingleInstanceManagment;
        Contact: Record Contact;
    begin
        // -- Skip update if triggered from Create As Customer/Vendor
        if SingleInstanceMgt.GetFromCreateAs() then
            IsHandled := true;

        // -- Update business relation for contact and linked records
        if ContactBusinessRelation."Contact No." <> '' then
            if Contact.Get(ContactBusinessRelation."Contact No.") then begin
                if Contact.UpdateBusinessRelation() then
                    Contact.Modify();

                Contact.SetFilter("No.", '<>%1', ContactBusinessRelation."Contact No.");
                Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
                if Contact.FindSet(true) then
                    repeat
                        if Contact.UpdateBusinessRelation() then
                            Contact.Modify();
                    until Contact.Next() = 0;
            end;
    end;

    // -------------------------------------------------------------
    // MAIN SYNC LOGICS: CUSTOMER → SLAVE COMPANY
    // -------------------------------------------------------------
    procedure CustomerToSlave(CustomerNo: Code[20]; SlaveCompany: Text[30])
    var
        MasterCustomer: Record Customer;
        SlaveCustomer: Record Customer;
        DummyRecord: Record Customer;
        MasterCompany: Text[30];
        MasterContactRelation: Record "Contact Business Relation";
        SlaveContactRelation: Record "Contact Business Relation";
        SlaveContact: Record Contact;
    begin
        // -- Prevent recursion and same-company sync
        if IsSync or (SlaveCompany = CompanyName()) then
            exit;

        MasterCompany := CompanyName();
        IsSync := true;

        // -- Ensure master customer exists
        if not MasterCustomer.Get(CustomerNo) then begin
            IsSync := false;
            Error(NotFoundCustErr, CustomerNo);
        end;

        // -- Create or update customer in slave
        SlaveCustomer.ChangeCompany(SlaveCompany);
        if not SlaveCustomer.Get(CustomerNo) then begin
            SlaveCustomer.Init();
            SlaveCustomer.TransferFields(MasterCustomer, false);
            SlaveCustomer."No." := MasterCustomer."No.";
            SlaveCustomer.Insert(false);
        end else begin
            if not AreRecordsEqual(MasterCustomer, SlaveCustomer) then begin
                SlaveCustomer.TransferFields(MasterCustomer, false);
                SlaveCustomer.Modify(false);
            end;
        end;

        // -- Replicate Contact Business Relation
        MasterContactRelation.SetRange("No.", MasterCustomer."No.");
        if MasterContactRelation.FindSet() then begin
            repeat
                SlaveContact.ChangeCompany(SlaveCompany);
                if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
                    SlaveContactRelation.ChangeCompany(SlaveCompany);
                    SlaveContactRelation.Reset();
                    SlaveContactRelation.SetRange("Contact No.", SlaveContact."No.");
                    SlaveContactRelation.SetRange("Link to Table", MasterContactRelation."Link to Table"::Customer);
                    SlaveContactRelation.SetRange("No.", MasterCustomer."No.");

                    if not SlaveContactRelation.FindFirst() then begin
                        // -- Insert missing Contact Business Relation in slave
                        SlaveContactRelation.Init();
                        SlaveContactRelation."Contact No." := SlaveContact."No.";
                        SlaveContactRelation."Link to Table" := MasterContactRelation."Link to Table"::Customer;
                        SlaveContactRelation."No." := MasterCustomer."No.";
                        SlaveContactRelation."Business Relation Code" := MasterContactRelation."Business Relation Code";
                        SlaveContactRelation."Business Relation Description" := MasterContactRelation."Business Relation Description";
                        SlaveContactRelation.Insert(false);

                        // -- Update contact in slave
                        SlaveContact.ChangeCompany(SlaveCompany);
                        if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
                            SlaveContact.UpdateBusinessRelation();
                            SlaveContact.Modify(true);
                        end;
                    end;
                end;
            until MasterContactRelation.Next() = 0;
        end;

        // -- Reset context back to master
        if CompanyName() <> MasterCompany then
            DummyRecord.ChangeCompany(MasterCompany);

        IsSync := false;
    end;

    // -------------------------------------------------------------
    // MAIN SYNC LOGICS: VENDOR → SLAVE COMPANY
    // -------------------------------------------------------------
    procedure VendorToSlave(VendorNo: Code[20]; SlaveCompany: Text[30])
    var
        MasterVendor: Record Vendor;
        SlaveVendor: Record Vendor;
        DummyRecord: Record Customer;
        MasterCompany: Text[30];
        MasterContactRelation: Record "Contact Business Relation";
        SlaveContactRelation: Record "Contact Business Relation";
        SlaveContact: Record Contact;
        MasterContact: Record Contact;
    begin
        // -- Prevent recursion and same-company sync
        if IsSync or (SlaveCompany = CompanyName()) then
            exit;

        MasterCompany := CompanyName();
        IsSync := true;

        // -- Ensure master vendor exists
        if not MasterVendor.Get(VendorNo) then begin
            IsSync := false;
            Error(NotFoundVendErr, VendorNo);
        end;

        // -- Create or update vendor in slave
        SlaveVendor.ChangeCompany(SlaveCompany);
        if not SlaveVendor.Get(VendorNo) then begin
            SlaveVendor.Init();
            SlaveVendor.TransferFields(MasterVendor, false);
            SlaveVendor."No." := MasterVendor."No.";
            SlaveVendor.Insert(false);
        end else begin
            if not AreRecordsEqual(MasterVendor, SlaveVendor) then begin
                SlaveVendor.TransferFields(MasterVendor, false);
                SlaveVendor.Modify(false);
            end;
        end;


        // -- Replicate Contact Business Relation
        MasterContactRelation.SetRange("No.", MasterVendor."No.");
        if MasterContactRelation.FindSet() then begin
            repeat
                SlaveContact.ChangeCompany(SlaveCompany);
                if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
                    SlaveContactRelation.ChangeCompany(SlaveCompany);
                    SlaveContactRelation.Reset();
                    SlaveContactRelation.SetRange("Contact No.", SlaveContact."No.");
                    SlaveContactRelation.SetRange("Link to Table", MasterContactRelation."Link to Table"::Vendor);
                    SlaveContactRelation.SetRange("No.", MasterVendor."No.");

                    if not SlaveContactRelation.FindFirst() then begin
                        // -- Insert missing relation in slave
                        SlaveContactRelation.Init();
                        SlaveContactRelation."Contact No." := SlaveContact."No.";
                        SlaveContactRelation."Link to Table" := MasterContactRelation."Link to Table"::Vendor;
                        SlaveContactRelation."No." := MasterVendor."No.";
                        SlaveContactRelation."Business Relation Code" := MasterContactRelation."Business Relation Code";
                        SlaveContactRelation."Business Relation Description" := MasterContactRelation."Business Relation Description";
                        SlaveContactRelation.Insert(false);

                        // -- Update contact in slave
                        SlaveContact.ChangeCompany(SlaveCompany);
                        if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
                            SlaveContact.UpdateBusinessRelation();
                            SlaveContact.Modify(true);
                        end;
                    end;
                end;
            until MasterContactRelation.Next() = 0;
        end;

        // -- Reset context back to master
        if CompanyName() <> MasterCompany then
            DummyRecord.ChangeCompany(MasterCompany);

        IsSync := false;
    end;

    // -------------------------------------------------------------
    // FUNCTION: COMPARE RECORDS BETWEEN MASTER AND SLAVE
    // -------------------------------------------------------------
    local procedure AreRecordsEqual(MasterRecVariant: Variant; SlaveRecVariant: Variant): Boolean
    var
        MasterRef: RecordRef;
        SlaveRef: RecordRef;
        MasterField: FieldRef;
        SlaveField: FieldRef;
        i: Integer;
    begin
        MasterRef.GetTable(MasterRecVariant);
        SlaveRef.GetTable(SlaveRecVariant);
        for i := 1 to MasterRef.FieldCount do begin
            MasterField := MasterRef.FieldIndex(i);

            // Skip system fields and primary keys
            if MasterField.Class <> FieldClass::Normal then
                continue;
            if MasterField.Number in [1] then
                continue;

            SlaveField := SlaveRef.Field(MasterField.Number);
            if MasterField.Value <> SlaveField.Value then
                exit(false);
        end;
        exit(true);
    end;

    // -------------------------------------------------------------
    // BEFORE EVENT HANDLERS (VALIDATION AND BLOCKING IN SLAVE)
    // -------------------------------------------------------------
    local procedure HandleOnBeforeModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_Company;
    begin
        // -- Block user modifications in slave companies
        if RunTrigger then begin
            if ZynCompany.Get(Rec.CurrentCompany) then begin
                if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
                    Error(CustomerModifyingInSlaveErr);
            end;
        end;
    end;

    local procedure HandleOnBeforeModifyVendor(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_Company;
    begin
        // -- Block user modifications in slave companies
        if RunTrigger then begin
            if ZynCompany.Get(Rec.CurrentCompany) then begin
                if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
                    Error(VendorModifyingInSlaveErr);
            end;
        end;
    end;

    local procedure HandleOnBeforeInsertCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_Company;
    begin
        // -- Prevent inserting customer in slave
        if ZynCompany.Get(COMPANYNAME) then begin
            if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
                Error(CreateCustomereInSlaveErr);
        end
    end;

    local procedure HandleOnBeforeInsertVendor(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_Company;
    begin
        // -- Prevent inserting vendor in slave
        if ZynCompany.Get(COMPANYNAME) then begin
            if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
                Error(CreateVendoreInSlaveErr);
        end
    end;

    local procedure HandleOnBeforeDeleteCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_Company;
    begin
        // -- Prevent deleting customer in slave
        if ZynCompany.Get(COMPANYNAME) then begin
            if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
                Error(DeleteCustomerInSlaveErr);
        end
    end;

    local procedure HandleOnBeforeDeleteVendor(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_Company;
    begin
        // -- Prevent deleting vendor in slave
        if ZynCompany.Get(COMPANYNAME) then begin
            if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
                Error(DeleteVendorInSlaveErr);
        end
    end;

    // -------------------------------------------------------------
    // AFTER MODIFY HANDLERS – MASTER → SLAVE REPLICATION
    // -------------------------------------------------------------
    local procedure HandleOnAfterModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)

    var
        MasterCompany: Record ZYN_Company;
        SlaveCompany: Record ZYN_Company;
        SlaveCustomer: Record Customer;
        MasterSlaveMgt: Codeunit "Zyn_SendFromMasterToSlaveMgt";
    begin
        // -- Prevent recursion
        if IsSync then
            exit;

        // -- Ensure current company is master
        if not MasterCompany.Get(CompanyName()) then
            exit;
        if (not MasterCompany.IsMaster) <> (MasterCompany."Master Company Name" <> '') then
            exit;

        IsSync := true;

        // -- Push changes to all slave companies
        SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
        if SlaveCompany.FindSet() then
            repeat
                if SlaveCompany.Name <> CompanyName() then begin
                    SlaveCustomer.ChangeCompany(SlaveCompany.Name);
                    if SlaveCustomer.Get(Rec."No.") then
                        MasterSlaveMgt.CustomerToSlave(Rec."No.", SlaveCompany.Name);
                end;
            until SlaveCompany.Next() = 0;

        IsSync := false;
    end;

    local procedure HandleOnAfterModifyVendor(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_Company;
        SlaveCompany: Record ZYN_Company;
        SlaveCustomer: Record Vendor;
        MasterSlaveMgt: Codeunit "Zyn_SendFromMasterToSlaveMgt";
    begin
        // -- Prevent recursion
        if IsSync then
            exit;

        // -- Ensure current company is master
        if not MasterCompany.Get(CompanyName()) then
            exit;
        if (not MasterCompany.IsMaster) <> (MasterCompany."Master Company Name" <> '') then
            exit;

        IsSync := true;

        // -- Push changes to all slave companies
        SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
        if SlaveCompany.FindSet() then
            repeat
                if SlaveCompany.Name <> CompanyName() then begin
                    SlaveCustomer.ChangeCompany(SlaveCompany.Name);
                    if SlaveCustomer.Get(Rec."No.") then
                        MasterSlaveMgt.CustomerToSlave(Rec."No.", SlaveCompany.Name);
                end;
            until SlaveCompany.Next() = 0;

        IsSync := false;
    end;

    // -------------------------------------------------------------
    // AFTER DELETE HANDLERS – MASTER → SLAVE DELETION SYNC
    // -------------------------------------------------------------
    // -- Customer Delete (After)
    local procedure HandleOnAfterDeleteCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_Company;
        SlaveCompany: Record ZYN_Company;
        SlaveCustomer: Record Customer;
        SlaveContactRel: Record "Contact Business Relation";
    begin
        // -- Prevent recursion
        if IsSync then
            exit;

        // -- Proceed only if current company is master
        if not MasterCompany.Get(CompanyName()) or not MasterCompany.IsMaster then
            exit;

        IsSync := true;

        // -- Loop through all slave companies of this master
        SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
        if SlaveCompany.FindSet() then
            repeat
                if SlaveCompany.Name <> CompanyName() then begin
                    // -- Set context to slave company
                    SlaveCustomer.ChangeCompany(SlaveCompany.Name);
                    SlaveContactRel.ChangeCompany(SlaveCompany.Name);

                    // -- Delete related Contact Business Relation records in slave
                    SlaveContactRel.Reset();
                    SlaveContactRel.SetRange("Link to Table", SlaveContactRel."Link to Table"::Customer);
                    SlaveContactRel.SetRange("No.", Rec."No.");
                    if SlaveContactRel.FindSet() then
                        repeat
                            SlaveContactRel.Delete(true);
                        until SlaveContactRel.Next() = 0;

                    // -- Delete the customer in slave
                    if SlaveCustomer.Get(Rec."No.") then
                        SlaveCustomer.Delete(true);
                end;
            until SlaveCompany.Next() = 0;

        IsSync := false;
    end;

    // -- Vendor Delete (After)
    local procedure HandleOnAfterDeleteVendor(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_Company;
        SlaveCompany: Record ZYN_Company;
        SlaveCustomer: Record Vendor;
        SlaveContactRel: Record "Contact Business Relation";
    begin
        // -- Prevent recursion
        if IsSync then
            exit;

        // -- Proceed only if current company is master
        if not MasterCompany.Get(CompanyName()) or not MasterCompany.IsMaster then
            exit;

        IsSync := true;

        // -- Loop through all slave companies of this master
        SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
        if SlaveCompany.FindSet() then
            repeat
                if SlaveCompany.Name <> CompanyName() then begin
                    // -- Set context to slave company
                    SlaveCustomer.ChangeCompany(SlaveCompany.Name);
                    SlaveContactRel.ChangeCompany(SlaveCompany.Name);

                    // -- Delete related Contact Business Relation records in slave
                    SlaveContactRel.Reset();
                    SlaveContactRel.SetRange("Link to Table", SlaveContactRel."Link to Table"::Vendor);
                    SlaveContactRel.SetRange("No.", Rec."No.");
                    if SlaveContactRel.FindSet() then
                    
                        repeat
                            SlaveContactRel.Delete(true);
                        until SlaveContactRel.Next() = 0;

                    // -- Delete the vendor in slave
                    if SlaveCustomer.Get(Rec."No.") then
                        SlaveCustomer.Delete(true);
                end;
            until SlaveCompany.Next() = 0;

        IsSync := false;
    end;

    // -------------------------------------------------------------
    // LABEL DECLARATIONS – ERRORS
    // -------------------------------------------------------------
    var
        CreateCustomereInSlaveErr: Label 'Cannot create customer in a slave company';
        CustomerModifyingInSlaveErr: Label 'Cannot modify customer in a slave company';
        DeleteCustomerInSlaveErr: Label 'Cannot delete customer in a slave company';
        CreateVendoreInSlaveErr: Label 'Cannot create vendor in a slave company';
        VendorModifyingInSlaveErr: Label 'Cannot modify vendor in a slave company';
        DeleteVendorInSlaveErr: Label 'Cannot delete vendor in a slave company';
        NotFoundCustErr: Label 'Customer %1 not found in Master.';
        NotFoundVendErr: Label 'Vendor %1 not found in Master.';

}




// codeunit 50108 "Zyn_SendFromMasterToSlaveMgt"
// {
//     var
//         IsSync: Boolean;

//     [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeModifyEvent', '', true, true)]
//     local procedure CustomerOnBeforeModify(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
//     begin
//         HandleOnBeforeModifyCustomer(Rec, xRec, RunTrigger);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeModifyEvent', '', true, true)]
//     local procedure VendorOnBeforeModify(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
//     begin
//         HandleOnBeforeModifyVendor(Rec, xRec, RunTrigger);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', true, true)]
//     local procedure CustomerOnBeforeInsert(var Rec: Record Customer; RunTrigger: Boolean)
//     begin
//         HandleOnBeforeInsertCustomer(Rec, RunTrigger);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeInsertEvent', '', true, true)]
//     local procedure VendorOnBeforeInsert(var Rec: Record Vendor; RunTrigger: Boolean)
//     begin
//         HandleOnBeforeInsertVendor(Rec, RunTrigger);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeDeleteEvent', '', false, false)]
//     local procedure PreventDeleteCustomer(var Rec: Record Customer; RunTrigger: Boolean)
//     begin
//         HandleOnBeforeDeleteCustomer(Rec, RunTrigger);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeDeleteEvent', '', false, false)]
//     local procedure PreventDeleteVendor(var Rec: Record Vendor; RunTrigger: Boolean)
//     begin
//         HandleOnBeforeDeleteVendor(Rec, RunTrigger);
//     end;


//     [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterModifyEvent', '', true, true)]
//     local procedure CustomerOnAfterModify(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
//     begin
//         HandleOnAfterModifyCustomer(Rec, xRec, RunTrigger);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterModifyEvent', '', true, true)]
//     local procedure VendorOnAfterModify(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
//     begin
//         HandleOnAfterModifyVendor(Rec, xRec, RunTrigger);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterDeleteEvent', '', true, true)]
//     local procedure CustomerOnAfterDelete(var Rec: Record Customer; RunTrigger: Boolean)
//     begin
//         HandleOnAfterDeleteCustomer(Rec, RunTrigger);
//     end;

//      [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterDeleteEvent', '', true, true)]
//     local procedure VendorOnAfterDelete(var Rec: Record Vendor; RunTrigger: Boolean)
//     begin
//         HandleOnAfterDeleteVendor(Rec, RunTrigger);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::"Contact Business Relation", 'OnBeforeUpdateContactBusinessRelation', '', true, true)]
//     local procedure OnBeforeUpdateContactBusinessRelation(ContactBusinessRelation: Record "Contact Business Relation"; var IsHandled: Boolean)
//     var
//         SingleInstanceMgt: Codeunit Zyn_SingleInstanceManagment;
//         Contact: Record Contact;
//     begin
//         if SingleInstanceMgt.GetFromCreateAs() then
//             IsHandled := true;

//         if ContactBusinessRelation."Contact No." <> '' then
//             if Contact.Get(ContactBusinessRelation."Contact No.") then begin
//                 if Contact.UpdateBusinessRelation() then
//                     Contact.Modify();

//                 Contact.SetFilter("No.", '<>%1', ContactBusinessRelation."Contact No.");
//                 Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
//                 if Contact.FindSet(true) then
//                     repeat
//                         if Contact.UpdateBusinessRelation() then
//                             Contact.Modify();
//                     until Contact.Next() = 0;
//             end;
//     end;

//     procedure CustomerToSlave(CustomerNo: Code[20]; SlaveCompany: Text[30])
//     var
//         MasterCustomer: Record Customer;
//         SlaveCustomer: Record Customer;
//         DummyRecord: Record Customer;
//         MasterCompany: Text[30];
//         MasterContactRelation: Record "Contact Business Relation";
//         SlaveContactRelation: Record "Contact Business Relation";
//         SlaveContact: Record Contact;
//     begin
//         if IsSync or (SlaveCompany = CompanyName()) then
//             exit;
//         MasterCompany := CompanyName();
//         IsSync := true;
//         if not MasterCustomer.Get(CustomerNo) then begin
//             IsSync := false;
//             Error(NotFoundCustErr, CustomerNo);
//         end;
//         SlaveCustomer.ChangeCompany(SlaveCompany);
//         if not SlaveCustomer.Get(CustomerNo) then begin
//             SlaveCustomer.Init();
//             SlaveCustomer.TransferFields(MasterCustomer, false);
//             SlaveCustomer."No." := MasterCustomer."No.";
//             SlaveCustomer.Insert(false);
//         end else begin
//             if not AreRecordsEqual(MasterCustomer, SlaveCustomer) then begin
//                 SlaveCustomer.TransferFields(MasterCustomer, false);
//                 SlaveCustomer.Modify(false);
//             end;
//         end;

//         // replicate Contact Business Relation rows
//         MasterContactRelation.SetRange("No.", MasterCustomer."No.");
//         if MasterContactRelation.FindSet() then begin
//             repeat
//                 SlaveContact.ChangeCompany(SlaveCompany);
//                 if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
//                     SlaveContactRelation.ChangeCompany(SlaveCompany);
//                     // check with Contact No. + Link to Table + No.
//                     SlaveContactRelation.Reset();
//                     SlaveContactRelation.SetRange("Contact No.", SlaveContact."No.");
//                     SlaveContactRelation.SetRange("Link to Table", MasterContactRelation."Link to Table"::Customer);
//                     SlaveContactRelation.SetRange("No.", MasterCustomer."No.");

//                     if not SlaveContactRelation.FindFirst() then begin
//                         SlaveContactRelation.Init();
//                         SlaveContactRelation."Contact No." := SlaveContact."No.";
//                         SlaveContactRelation."Link to Table" := MasterContactRelation."Link to Table"::Customer;
//                         SlaveContactRelation."No." := MasterCustomer."No.";
//                         SlaveContactRelation."Business Relation Code" := MasterContactRelation."Business Relation Code";
//                         SlaveContactRelation."Business Relation Description" := MasterContactRelation."Business Relation Description";
//                         SlaveContactRelation.Insert(false);
//                         SlaveContact.ChangeCompany(SlaveCompany);
//                         if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
//                             SlaveContact.UpdateBusinessRelation();
//                             SlaveContact.Modify(true);
//                         end;
//                     end;
//                 end ;
//             until MasterContactRelation.Next() = 0;
//         end;
//         if CompanyName() <> MasterCompany then
//             DummyRecord.ChangeCompany(MasterCompany);
//         IsSync := false;
//     end;

//     procedure VendorToSlave(VendorNo: Code[20]; SlaveCompany: Text[30])
//     var
//         MasterVendor: Record Vendor;
//         SlaveVendor: Record Vendor;
//         DummyRecord: Record Customer;
//         MasterCompany: Text[30];
//         MasterContactRelation: Record "Contact Business Relation";
//         SlaveContactRelation: Record "Contact Business Relation";
//         SlaveContact: Record Contact;
//         MasterContact: Record Contact;
//     begin
//         if IsSync or (SlaveCompany = CompanyName()) then
//             exit;
//         MasterCompany := CompanyName();
//         IsSync := true;
//         if not MasterVendor.Get(VendorNo) then begin
//             IsSync := false;
//             Error(NotFoundVendErr, VendorNo);
//         end;
//         SlaveVendor.ChangeCompany(SlaveCompany);
//         if not SlaveVendor.Get(VendorNo) then begin
//             SlaveVendor.Init();
//             SlaveVendor.TransferFields(MasterVendor, false);
//             SlaveVendor."No." := MasterVendor."No.";
//             SlaveVendor.Insert(false);
//         end else begin
//             if not AreRecordsEqual(MasterVendor, SlaveVendor) then begin
//                 SlaveVendor.TransferFields(MasterVendor, false);
//                 SlaveVendor.Modify(false);
//             end;
//         end;

//         // replicate Contact Business Relation rows
//         MasterContactRelation.SetRange("No.", MasterVendor."No.");
//         if MasterContactRelation.FindSet() then begin
//             repeat
//                 SlaveContact.ChangeCompany(SlaveCompany);
//                 if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
//                     SlaveContactRelation.ChangeCompany(SlaveCompany);
//                     // check with Contact No. + Link to Table + No.
//                     SlaveContactRelation.Reset();
//                     SlaveContactRelation.SetRange("Contact No.", SlaveContact."No.");
//                     SlaveContactRelation.SetRange("Link to Table", MasterContactRelation."Link to Table"::Vendor);
//                     SlaveContactRelation.SetRange("No.", MasterVendor."No.");
//                     if not SlaveContactRelation.FindFirst() then begin
//                         SlaveContactRelation.Init();
//                         SlaveContactRelation."Contact No." := SlaveContact."No.";
//                         SlaveContactRelation."Link to Table" := MasterContactRelation."Link to Table"::Vendor;
//                         SlaveContactRelation."No." := MasterVendor."No.";
//                         SlaveContactRelation."Business Relation Code" := MasterContactRelation."Business Relation Code";
//                         SlaveContactRelation."Business Relation Description" := MasterContactRelation."Business Relation Description";
//                         SlaveContactRelation.Insert(false);
//                         SlaveContact.ChangeCompany(SlaveCompany);
//                         if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
//                             SlaveContact.UpdateBusinessRelation();
//                             SlaveContact.Modify(true);
//                         end;
//                     end;
//                 end;
//             until MasterContactRelation.Next() = 0;
//         end;

//         if CompanyName() <> MasterCompany then
//             DummyRecord.ChangeCompany(MasterCompany);
//         IsSync := false;
//     end;

//     local procedure AreRecordsEqual(MasterRecVariant: Variant; SlaveRecVariant: Variant): Boolean
//     var
//         MasterRef: RecordRef;
//         SlaveRef: RecordRef;
//         MasterField: FieldRef;
//         SlaveField: FieldRef;
//         i: Integer;
//     begin
//         MasterRef.GetTable(MasterRecVariant);
//         SlaveRef.GetTable(SlaveRecVariant);
//         for i := 1 to MasterRef.FieldCount do begin
//             MasterField := MasterRef.FieldIndex(i);
//             // Skip system fields and primary keys (adjust if needed)
//             if MasterField.Class <> FieldClass::Normal then
//                 continue;
//             if MasterField.Number in [1, 2, 3] then  // No., SystemId, etc.
//                 continue;
//             SlaveField := SlaveRef.Field(MasterField.Number);
//             if MasterField.Value <> SlaveField.Value then
//                 exit(false);
//         end;
//         exit(true);
//     end;



//     local procedure HandleOnBeforeModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
//     var
//         ZynCompany: Record ZYN_Company;
//     begin
//         // Only block user modifications, allow system modifications
//         if RunTrigger then begin
//             // Condition: check company
//             if ZynCompany.Get(Rec.CurrentCompany) then begin
//                 // Validation: prevent modifying contact in slave company
//                 if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
//                     Error(CustomerModifyingInSlaveErr);
//             end;
//         end;
//     end;

//     local procedure HandleOnBeforeModifyVendor(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
//     var
//         ZynCompany: Record ZYN_Company;
//     begin
//         // Only block user modifications, allow system modifications
//         if RunTrigger then begin
//             // Condition: check company
//             if ZynCompany.Get(Rec.CurrentCompany) then begin
//                 // Validation: prevent modifying contact in slave company
//                 if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
//                     Error(VendorModifyingInSlaveErr);
//             end;
//         end;
//     end;

//     local procedure HandleOnBeforeInsertCustomer(var Rec: Record Customer; RunTrigger: Boolean)
//     var
//         ZynCompany: Record ZYN_Company;
//     begin
//         // Condition: check if current company exists
//         if ZynCompany.Get(COMPANYNAME) then begin
//             // Validation: cannot create contacts in slave company
//             if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
//                 Error(CreateCustomereInSlaveErr);
//         end
//     end;

//     local procedure HandleOnBeforeInsertVendor(var Rec: Record Vendor; RunTrigger: Boolean)
//     var
//         ZynCompany: Record ZYN_Company;
//     begin
//         // Condition: check if current company exists
//         if ZynCompany.Get(COMPANYNAME) then begin
//             // Validation: cannot create contacts in slave company
//             if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
//                 Error(CreateVendoreInSlaveErr);
//         end
//     end;

//     local procedure HandleOnBeforeDeleteCustomer(var Rec: Record Customer; RunTrigger: Boolean)
//     var
//         ZynCompany: Record ZYN_Company;
//     begin
//         // Condition: check if current company exists
//         if ZynCompany.Get(COMPANYNAME) then begin
//             // Validation: cannot create contacts in slave company
//             if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
//                 Error(DeleteCustomerInSlaveErr);
//         end
//     end;

//     local procedure HandleOnBeforeDeleteVendor(var Rec: Record Vendor; RunTrigger: Boolean)
//     var
//         ZynCompany: Record ZYN_Company;
//     begin
//         // Condition: check if current company exists
//         if ZynCompany.Get(COMPANYNAME) then begin
//             // Validation: cannot create contacts in slave company
//             if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
//                 Error(DeleteVendorInSlaveErr);
//         end
//     end;

//     local procedure HandleOnAfterModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
//     var
//         MasterCompany: Record ZYN_Company;
//         SlaveCompany: Record ZYN_Company;
//         SlaveCustomer: Record Customer;
//         MasterSlaveMgt: Codeunit "Zyn_SendFromMasterToSlaveMgt";
//     begin
//         // Prevent recursion
//         if IsSync then
//             exit;
//         // Only proceed if we're in master company
//         if not MasterCompany.Get(CompanyName()) then
//             exit;
//         if (not MasterCompany.IsMaster) <> (MasterCompany."Master Company Name" <> '') then
//             exit;
//         IsSync := true;
//         // Find all slave companies linked to this master
//         SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
//         if SlaveCompany.FindSet() then
//             repeat
//                 if SlaveCompany.Name <> CompanyName() then begin
//                     SlaveCustomer.ChangeCompany(SlaveCompany.Name);
//                     //Only update if customer already exists in slave
//                     if SlaveCustomer.Get(Rec."No.") then
//                         MasterSlaveMgt.CustomerToSlave(Rec."No.", SlaveCompany.Name);
//                 end;
//             until SlaveCompany.Next() = 0;
//         IsSync := false;
//     end;

//     local procedure HandleOnAfterModifyVendor(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
//     var
//         MasterCompany: Record ZYN_Company;
//         SlaveCompany: Record ZYN_Company;
//         SlaveCustomer: Record Vendor;
//         MasterSlaveMgt: Codeunit "Zyn_SendFromMasterToSlaveMgt";
//     begin
//         // Prevent recursion
//         if IsSync then
//             exit;
//         // Only proceed if we're in master company
//         if not MasterCompany.Get(CompanyName()) then
//             exit;
//         if (not MasterCompany.IsMaster) <> (MasterCompany."Master Company Name" <> '') then
//             exit;
//         IsSync := true;
//         // Find all slave companies linked to this master
//         SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
//         if SlaveCompany.FindSet() then
//             repeat
//                 if SlaveCompany.Name <> CompanyName() then begin
//                     SlaveCustomer.ChangeCompany(SlaveCompany.Name);
//                     //Only update if customer already exists in slave
//                     if SlaveCustomer.Get(Rec."No.") then
//                         MasterSlaveMgt.CustomerToSlave(Rec."No.", SlaveCompany.Name);
//                 end;
//             until SlaveCompany.Next() = 0;
//         IsSync := false;
//     end;

//     local procedure HandleOnAfterDeleteCustomer(var Rec: Record Customer; RunTrigger: Boolean)
//     var
//         MasterCompany: Record ZYN_Company;
//         SlaveCompany: Record ZYN_Company;
//         SlaveCustomer: Record Customer;
//         SlaveContactRel: Record "Contact Business Relation";
//     begin
//         if IsSync then
//             exit;
//         if not MasterCompany.Get(CompanyName()) or not MasterCompany.IsMaster then
//             exit;
//         IsSync := true;
//         SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
//         if SlaveCompany.FindSet() then
//             repeat
//                 if SlaveCompany.Name <> CompanyName() then begin
//                     SlaveCustomer.ChangeCompany(SlaveCompany.Name);
//                     SlaveContactRel.ChangeCompany(SlaveCompany.Name);
//                     SlaveContactRel.Reset();
//                     SlaveContactRel.SetRange("Link to Table", SlaveContactRel."Link to Table"::Customer);
//                     SlaveContactRel.SetRange("No.", Rec."No.");
//                     if SlaveContactRel.FindSet() then
//                         repeat
//                             SlaveContactRel.Delete(true);
//                         until SlaveContactRel.Next() = 0;
//                     if SlaveCustomer.Get(Rec."No.") then
//                         SlaveCustomer.Delete(true);
//                 end;
//             until SlaveCompany.Next() = 0;
//         IsSync := false;
//     end;

//     local procedure HandleOnAfterDeleteVendor(var Rec: Record Vendor; RunTrigger: Boolean)
//     var
//         MasterCompany: Record ZYN_Company;
//         SlaveCompany: Record ZYN_Company;
//         SlaveCustomer: Record Vendor;
//         SlaveContactRel: Record "Contact Business Relation";
//     begin
//         if IsSync then
//             exit;
//         if not MasterCompany.Get(CompanyName()) or not MasterCompany.IsMaster then
//             exit;
//         IsSync := true;
//         SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
//         if SlaveCompany.FindSet() then
//             repeat
//                 if SlaveCompany.Name <> CompanyName() then begin
//                     SlaveCustomer.ChangeCompany(SlaveCompany.Name);
//                     SlaveContactRel.ChangeCompany(SlaveCompany.Name);
//                     SlaveContactRel.Reset();
//                     SlaveContactRel.SetRange("Link to Table", SlaveContactRel."Link to Table"::Customer);
//                     SlaveContactRel.SetRange("No.", Rec."No.");
//                     if SlaveContactRel.FindSet() then
//                         repeat
//                             SlaveContactRel.Delete(true);
//                         until SlaveContactRel.Next() = 0;
//                     if SlaveCustomer.Get(Rec."No.") then
//                         SlaveCustomer.Delete(true);
//                 end;
//             until SlaveCompany.Next() = 0;
//         IsSync := false;
//     end;

//     var
//         CreateCustomereInSlaveErr: Label 'Cannot create customer in a slave company';
//         CustomerModifyingInSlaveErr: Label 'Cannot modify customer in a slave company';
//         DeleteCustomerInSlaveErr: Label 'Cannot delete customer in a slave company';
//         CreateVendoreInSlaveErr: Label 'Cannot create vendor in a slave company';
//         VendorModifyingInSlaveErr: Label 'Cannot modify vendor in a slave company';
//         DeleteVendorInSlaveErr: Label 'Cannot delete vendor in a slave company';
//         NotFoundCustErr:Label 'Customer %1 not found in Master.';
//         NotFoundVendErr:Label 'Vendor %1 not found in Master.';
// }

 