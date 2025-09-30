// codeunit 50107 "Zyn_ContactMaster-SlaveSync"
// {
//     var
//         IsSyncing: Boolean;
//     [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeInsertEvent', '', true, true)]
//     local procedure ContactOnBeforeInsert(var Rec: Record Contact; RunTrigger: Boolean)
//     var
//         ZynCompany: Record ZYN_Company;

//     begin
//         if ZynCompany.Get(COMPANYNAME) then begin
//             if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
//                 Error(CreateContacteInSlaveErr);
//         end 
//     end;

//    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeModifyEvent', '', true, true)]
// local procedure ContactOnBeforeModify(var Rec: Record Contact; var xRec: Record Contact; RunTrigger: Boolean)
// var
//     ZynCompany: Record ZYN_Company;
// begin
//     // Only block user modifications, allow system modifications
//     if RunTrigger then begin
//         if ZynCompany.Get(Rec."Company Name") then begin
//             if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
//                 Error(ContactModifyingInSlaveErr);
//         end;
//     end;
// end;
//      [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeDeleteEvent', '', false, false)]
//     local procedure PreventDelete(var Rec: Record Contact; RunTrigger: Boolean)
//     var
//         ZYN_Company: Record ZYN_Company;
//         SlaveCompany: Record ZYN_Company;
//         ContactBusRel: Record "Contact Business Relation";
//         SalesHeader: Record "Sales Header";
//         PurchHeader: Record "Purchase Header";
//     begin
//          if ZYN_Company.Get(COMPANYNAME) then begin
//             if (not ZYN_Company.IsMaster) and (ZYN_Company."Master Company Name" <> '') then
//                 Error(DeleteContactInSlaveErr);
//         end;
//         if not ZYN_Company.Get(CompanyName()) then
//             exit;
//         if not IsMasterCompany() then
//             exit;
//         SlaveCompany.SetRange(IsMaster, false);
//         SlaveCompany.SetFilter("Master Company Name", '%1', ZYN_Company.Name);

//         if SlaveCompany.FindSet() then
//             repeat
//                 // Switch context to slave company
//                 ContactBusRel.ChangeCompany(SlaveCompany.Name);
//                 SalesHeader.ChangeCompany(SlaveCompany.Name);
//                 PurchHeader.ChangeCompany(SlaveCompany.Name);

//                 // Check relation for the contact
//                 ContactBusRel.Reset();
//                 ContactBusRel.SetRange("Contact No.", Rec."No.");
//                 if ContactBusRel.FindSet() then
//                     repeat
//                         case ContactBusRel."Link to Table" of
//                             ContactBusRel."Link to Table"::Customer
//                             :
//                                 begin
//                                     SalesHeader.Reset();
//                                     SalesHeader.SetRange("Sell-to Customer No.", ContactBusRel."No.");
//                                     SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
//                                     SalesHeader.SetFilter(Status,'%1|%2', SalesHeader.Status::Open,SalesHeader.Status::Released);
//                                     if SalesHeader.FindFirst() then
//                                         Error(OpenSalesInvoiceError,Rec."No.", SlaveCompany.Name);   
//                                 end;

//                             ContactBusRel."Link to Table"::Vendor:
//                                 begin
//                                     PurchHeader.Reset();
//                                     PurchHeader.SetRange("Buy-from Vendor No.", ContactBusRel."No.");
//                                     PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
//                                     PurchHeader.SetFilter(Status,'%1|%2', SalesHeader.Status::Open,SalesHeader.Status::Released);
//                                     if PurchHeader.FindFirst() then
//                                         Error(OpenPurchaseInvoiceError,Rec."No.", SlaveCompany.Name);
//                                 end;
//                         end;

//                     until ContactBusRel.Next() = 0;

//             until SlaveCompany.Next() = 0;
//     end;


//   local procedure IsMasterCompany(): Boolean
//     var
//         MyCompany: Record ZYN_Company;
//     begin
//         if MyCompany.Get(CompanyName()) then
//             exit(MyCompany.IsMaster); 
//         exit(false);
//     end;

//     [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterDeleteEvent', '', true, true)]
// local procedure MasterSlaveDelete(var Rec: Record Contact; RunTrigger: Boolean)
// var
//     MasterCompany: Record ZYN_Company;
//     SlaveCompany: Record ZYN_Company;
//     SlaveContact: Record Contact;
//     SlaveCustomer: Record Customer;
//     SlaveVendor: Record Vendor;
//     SlaveCBT: Record "Contact Business Relation";
// begin
//     // Ensure current company is a master company
//     if not MasterCompany.Get(CompanyName()) then
//         exit;
//     if not MasterCompany.IsMaster then
//         exit;

//     // Find all slave companies for this master
//     SlaveCompany.SetRange(IsMaster, false);
//     SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);

//     if SlaveCompany.FindSet() then
//         repeat
//             SlaveContact.ChangeCompany(SlaveCompany.Name);
//             SlaveCustomer.ChangeCompany(SlaveCompany.Name);
//             SlaveVendor.ChangeCompany(SlaveCompany.Name);
//             SlaveCBT.ChangeCompany(SlaveCompany.Name);

//             // --- Step 1: Delete all relations for this contact ---
//             SlaveCBT.SetRange("Contact No.", Rec."No.");
//             if SlaveCBT.FindSet() then
//                 repeat
//                     case SlaveCBT."Link to Table" of
//                         SlaveCBT."Link to Table"::Customer:
//                             if SlaveCustomer.Get(SlaveCBT."No.") then
//                                 SlaveCustomer.Delete();

//                         SlaveCBT."Link to Table"::Vendor:
//                             if SlaveVendor.Get(SlaveCBT."No.") then
//                                 SlaveVendor.Delete();
//                     end;

//                     SlaveCBT.Delete();
//                 until SlaveCBT.Next() = 0;

//             // --- Step 2: Delete the Contact itself ---
//             if SlaveContact.Get(Rec."No.") then
//                 SlaveContact.Delete();

//         until SlaveCompany.Next() = 0;
// end;

//    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterInsertEvent', '', true, true)]
//     local procedure ContactOnAfterInsert(var Rec: Record Contact; RunTrigger: Boolean)
//     var
//         MasterCompany: Record ZYN_Company;
//         SlaveCompany: Record ZYN_Company;
//         NewContact: Record Contact;

//     begin
//         if IsSyncing then
//             exit;
//         IsSyncing := true;
//         // Get the current company as master company
//         if MasterCompany.Get(COMPANYNAME) then begin
//             // Only replicate if this is a master company
//             if MasterCompany.IsMaster then begin
//                 // Find all slave companies linked to this master
//                 SlaveCompany.Reset();
//                 SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
//                 if SlaveCompany.FindSet() then
//                     repeat
//                         NewContact.ChangeCompany(SlaveCompany.Name);
//                         if not NewContact.Get(Rec."No.") then begin
//                             NewContact.Init();
//                             NewContact.TransferFields(Rec, true);   
//                             NewContact.Insert(true);
//                         end;
//                     until SlaveCompany.Next() = 0;
//                 exit;
//             end;
//         end;
//         IsSyncing := false;
//     end;

//     [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterModifyEvent', '', true, true)]
//     local procedure ContactOnAfterModify(var Rec: Record Contact; var xRec: Record Contact; RunTrigger: Boolean)
//     var
//         MasterCompany: Record ZYN_Company;
//         SlaveCompany: Record ZYN_Company;
//         SlaveContact: Record Contact;
//         MasterRef: RecordRef;
//         SlaveRef: RecordRef;
//         Field: FieldRef;
//         SlaveField: FieldRef;
//         i: Integer;
//         IsDifferent: Boolean;
//         slavebusinessrelation:Enum "Contact Business Relation";
//         ZynCompany: Record ZYN_Company;
//     begin
//         if IsSyncing then
//             exit;
//         if MasterCompany.Get(COMPANYNAME) then begin
//             if MasterCompany.IsMaster then begin
//                 SlaveCompany.Reset();
//                 SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
//                 if SlaveCompany.FindSet() then
//                     repeat
//                         SlaveContact.ChangeCompany(SlaveCompany.Name);
//                         if SlaveContact.Get(Rec."No.") then begin

//                             slavebusinessrelation:=SlaveContact."Contact Business Relation";
//                             // Open RecordRefs
//                             MasterRef.GetTable(Rec);
//                             SlaveRef.GetTable(SlaveContact);
//                             IsDifferent := false;
//                             // Loop through all fields
//                             for i := 1 to MasterRef.FieldCount do begin
//                                 Field := MasterRef.FieldIndex(i);
//                                 // Skip FlowFields or non-normal fields
//                                 if Field.Class <> FieldClass::Normal then
//                                     continue;
//                                 // Skip primary key fields (like "No.")
//                                 if Field.Number in [1] then
//                                     continue;
//                                 SlaveField := SlaveRef.Field(Field.Number);
//                                 if SlaveField.Value <> Field.Value then begin
//                                     IsDifferent := true;
//                                     break; // no need to check further
//                                 end;
//                             end;
//                             // Only transfer fields if there is a difference
//                             if IsDifferent then begin
//                                 IsSyncing := true;
//                                 SlaveContact.TransferFields(Rec, false);
//                                 SlaveContact."Contact Business Relation":=slavebusinessrelation;
//                                 SlaveContact."No." := Rec."No."; // restore PK
//                                 SlaveContact.Modify(true);
//                                 IsSyncing := false;
//                             end;
//                         end;
//                     until SlaveCompany.Next() = 0;

//             end else begin
//                 if ZynCompany.Get(Rec."Company Name") then begin

//         if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
//             Error(CreateContacteInSlaveErr); 

//     end else begin    
//         if not RunTrigger then
//             exit;
//         if Rec."Contact Business Relation" <> xRec."Contact Business Relation" then
//             exit;   
//         Error(CreateContacteInSlaveErr);
//     end;
//             end;
//         end;
//     end;

//     var
//         CreateContacteInSlaveErr: Label 'Cannot create contacts in a slave company';
//         ContactModifyingInSlaveErr: Label 'Cannot modify contacts in a slave company';
//         DeleteContactInSlaveErr:Label 'Cannot delete contacts in a slave company';
//         ContactDeletingInSlaveErr: Label 'Cannot delete contacts in a slave company';
//         OpenSalesInvoiceError:Label 'Contact %1 cannot be deleted because it has open or released Sales Invoices in company %2.';
//         OpenPurchaseInvoiceError:Label 'Contact %1 cannot be deleted because it has open or released Purchase Invoices in company %2.';
// }


codeunit 50107 "Zyn_ContactMaster-SlaveSync"
{
    var
        IsSyncing: Boolean;

    // ───────────────────────────────
    // Event Subscribers
    // ───────────────────────────────

    // Procedure: ContactOnBeforeInsert
    // Purpose: Event subscriber for Contact OnBeforeInsertEvent, delegates logic to handler
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeInsertEvent', '', true, true)]
    local procedure ContactOnBeforeInsert(var Rec: Record Contact; RunTrigger: Boolean)
    begin
        HandleOnBeforeInsert(Rec, RunTrigger);
    end;

    // Procedure: ContactOnBeforeModify
    // Purpose: Event subscriber for Contact OnBeforeModifyEvent, delegates logic to handler
   [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeModifyEvent', '', true, true)]
    local procedure ContactOnBeforeModify(var Rec: Record Contact; var xRec: Record Contact; RunTrigger: Boolean)
    begin
        HandleOnBeforeModify(Rec, xRec, RunTrigger);
    end;

    // Procedure: PreventDelete
    // Purpose: Event subscriber for Contact OnBeforeDeleteEvent, delegates logic to handler
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure PreventDelete(var Rec: Record Contact; RunTrigger: Boolean)
    begin
        HandleOnBeforeDelete(Rec, RunTrigger);
    end;

    // Procedure: MasterSlaveDelete
    // Purpose: Event subscriber for Contact OnAfterDeleteEvent, delegates logic to handler
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterDeleteEvent', '', true, true)]
    local procedure MasterSlaveDelete(var Rec: Record Contact; RunTrigger: Boolean)
    begin
        HandleOnAfterDelete(Rec, RunTrigger);
    end;

    // Procedure: ContactOnAfterInsert
    // Purpose: Event subscriber for Contact OnAfterInsertEvent, delegates logic to handler
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterInsertEvent', '', true, true)]
    local procedure ContactOnAfterInsert(var Rec: Record Contact; RunTrigger: Boolean)
    begin
        HandleOnAfterInsert(Rec, RunTrigger);
    end;

    // Procedure: ContactOnAfterModify
    // Purpose: Event subscriber for Contact OnAfterModifyEvent, delegates logic to handler
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterModifyEvent', '', true, true)]
    local procedure ContactOnAfterModify(var Rec: Record Contact; var xRec: Record Contact; RunTrigger: Boolean)
    begin
        HandleOnAfterModify(Rec, xRec, RunTrigger);
    end;


    // ───────────────────────────────
    // Handler Procedures
    // ───────────────────────────────

    // Procedure: HandleOnBeforeInsert
    // Purpose: Validates that contact cannot be created in a slave company
    local procedure HandleOnBeforeInsert(var Rec: Record Contact; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_Company;
    begin
        // Condition: check if current company exists
        if ZynCompany.Get(COMPANYNAME) then begin
            // Validation: cannot create contacts in slave company
            if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
                Error(CreateContacteInSlaveErr);
        end
    end;

    // Procedure: HandleOnBeforeModify
    // Purpose: Prevent modification in slave companies when triggered by user
    local procedure HandleOnBeforeModify(var Rec: Record Contact; var xRec: Record Contact; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_Company;
    begin
        // Only block user modifications, allow system modifications
        if RunTrigger then begin
            // Condition: check company
            if ZynCompany.Get(Rec."Company Name") then begin
                // Validation: prevent modifying contact in slave company
                if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
                    Error(ContactModifyingInSlaveErr);
            end;
        end;
    end;

    // Procedure: HandleOnBeforeDelete
    // Purpose: Prevent deletion of contacts in slave companies and check for open invoices
    local procedure HandleOnBeforeDelete(var Rec: Record Contact; RunTrigger: Boolean)
    var
        ZYN_Company: Record ZYN_Company;
        SlaveCompany: Record ZYN_Company;
        ContactBusRel: Record "Contact Business Relation";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
    begin
        // Validation: Prevent delete in slave company
        if ZYN_Company.Get(COMPANYNAME) then begin
            if (not ZYN_Company.IsMaster) and (ZYN_Company."Master Company Name" <> '') then
                Error(DeleteContactInSlaveErr);
        end;

        // Validation: Skip if company not found
        if not ZYN_Company.Get(CompanyName()) then
            exit;

        // Validation: Skip if not master
        if not IsMasterCompany() then
            exit;

        // Set filter: find slave companies linked to this master
        SlaveCompany.SetRange(IsMaster, false);
        SlaveCompany.SetFilter("Master Company Name", '%1', ZYN_Company.Name);

        // Loop: iterate through all slave companies
        if SlaveCompany.FindSet() then
            repeat
                // Context switch to slave company
                ContactBusRel.ChangeCompany(SlaveCompany.Name);
                SalesHeader.ChangeCompany(SlaveCompany.Name);
                PurchHeader.ChangeCompany(SlaveCompany.Name);

                // Set filter: check relations for this contact
                ContactBusRel.Reset();
                ContactBusRel.SetRange("Contact No.", Rec."No.");

                // Loop: iterate through all contact relations
                if ContactBusRel.FindSet() then
                    repeat
                        // Condition: relation linked to Customer
                        case ContactBusRel."Link to Table" of
                            ContactBusRel."Link to Table"::Customer:
                                begin
                                    // Set filter: Sales invoices for this customer
                                    SalesHeader.Reset();
                                    SalesHeader.SetRange("Sell-to Customer No.", ContactBusRel."No.");
                                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                                    SalesHeader.SetFilter(Status, '%1|%2', SalesHeader.Status::Open, SalesHeader.Status::Released);

                                    // Validation: block delete if open sales invoices exist
                                    if SalesHeader.FindFirst() then
                                        Error(OpenSalesInvoiceError, Rec."No.", SlaveCompany.Name);
                                end;

                            // Condition: relation linked to Vendor
                            ContactBusRel."Link to Table"::Vendor:
                                begin
                                    // Set filter: Purchase invoices for this vendor
                                    PurchHeader.Reset();
                                    PurchHeader.SetRange("Buy-from Vendor No.", ContactBusRel."No.");
                                    PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
                                    PurchHeader.SetFilter(Status, '%1|%2', SalesHeader.Status::Open, SalesHeader.Status::Released);

                                    // Validation: block delete if open purchase invoices exist
                                    if PurchHeader.FindFirst() then
                                        Error(OpenPurchaseInvoiceError, Rec."No.", SlaveCompany.Name);
                                end;
                        end;
                    until ContactBusRel.Next() = 0; // Loop ends

            until SlaveCompany.Next() = 0; // Loop ends
    end;

    // Procedure: HandleOnAfterDelete
    // Purpose: Deletes corresponding contacts and relations in all slave companies
    local procedure HandleOnAfterDelete(var Rec: Record Contact; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_Company;
        SlaveCompany: Record ZYN_Company;
        SlaveContact: Record Contact;
        SlaveCustomer: Record Customer;
        SlaveVendor: Record Vendor;
        SlaveCBT: Record "Contact Business Relation";
    begin
        // Validation: Ensure current company is a master company
        if not MasterCompany.Get(CompanyName()) then
            exit;
        if not MasterCompany.IsMaster then
            exit;

        // Set filter: find slave companies for this master
        SlaveCompany.SetRange(IsMaster, false);
        SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);

        // Loop: iterate all slave companies
        if SlaveCompany.FindSet() then
            repeat
                SlaveContact.ChangeCompany(SlaveCompany.Name);
                SlaveCustomer.ChangeCompany(SlaveCompany.Name);
                SlaveVendor.ChangeCompany(SlaveCompany.Name);
                SlaveCBT.ChangeCompany(SlaveCompany.Name);

                // Set filter: all relations for this contact
                SlaveCBT.SetRange("Contact No.", Rec."No.");

                // Loop: delete all relations in slave
                if SlaveCBT.FindSet() then
                    repeat
                        // Condition: relation linked to Customer
                        case SlaveCBT."Link to Table" of
                            SlaveCBT."Link to Table"::Customer:
                                if SlaveCustomer.Get(SlaveCBT."No.") then
                                    SlaveCustomer.Delete();

                            // Condition: relation linked to Vendor
                            SlaveCBT."Link to Table"::Vendor:
                                if SlaveVendor.Get(SlaveCBT."No.") then
                                    SlaveVendor.Delete();
                        end;

                        // Delete relation itself
                        SlaveCBT.Delete();
                    until SlaveCBT.Next() = 0; // Loop ends

                // Delete the contact itself
                if SlaveContact.Get(Rec."No.") then
                    SlaveContact.Delete();

            until SlaveCompany.Next() = 0; // Loop ends
    end;

    // Procedure: HandleOnAfterInsert
    // Purpose: Replicates newly inserted contact from master to all slave companies
    local procedure HandleOnAfterInsert(var Rec: Record Contact; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_Company;
        SlaveCompany: Record ZYN_Company;
        NewContact: Record Contact;
    begin
        // Validation: prevent recursive sync
        if IsSyncing then
            exit;
        IsSyncing := true;

        // Condition: get current company
        if MasterCompany.Get(COMPANYNAME) then begin
            // Validation: only replicate if master
            if MasterCompany.IsMaster then begin
                // Set filter: find all slave companies for master
                SlaveCompany.Reset();
                SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);

                // Loop: iterate all slave companies
                if SlaveCompany.FindSet() then
                    repeat
                        NewContact.ChangeCompany(SlaveCompany.Name);

                        // Condition: create new contact if not exist
                        if not NewContact.Get(Rec."No.") then begin
                            NewContact.Init();
                            NewContact.TransferFields(Rec, true);
                            NewContact.Insert(true);
                        end;
                    until SlaveCompany.Next() = 0; // Loop ends
                exit;
            end;
        end;
        IsSyncing := false;
    end;

    // Procedure: HandleOnAfterModify
    // Purpose: Syncs modifications of contact from master to slave companies
    local procedure HandleOnAfterModify(var Rec: Record Contact; var xRec: Record Contact; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_Company;
        SlaveCompany: Record ZYN_Company;
        SlaveContact: Record Contact;
        MasterRef: RecordRef;
        SlaveRef: RecordRef;
        Field: FieldRef;
        SlaveField: FieldRef;
        i: Integer;
        IsDifferent: Boolean;
        slavebusinessrelation: Enum "Contact Business Relation";
        ZynCompany: Record ZYN_Company;
    begin
        // Validation: prevent recursive sync
        if IsSyncing then
            exit;

        // Condition: master company exists
        if MasterCompany.Get(COMPANYNAME) then begin
            // Validation: only replicate if master
            if MasterCompany.IsMaster then begin
                // Set filter: find slave companies for this master
                SlaveCompany.Reset();
                SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);

                // Loop: iterate slave companies
                if SlaveCompany.FindSet() then
                    repeat
                        SlaveContact.ChangeCompany(SlaveCompany.Name);

                        // Condition: contact exists in slave
                        if SlaveContact.Get(Rec."No.") then begin
                            slavebusinessrelation := SlaveContact."Contact Business Relation";

                            // Open RecordRefs for comparison
                            MasterRef.GetTable(Rec);
                            SlaveRef.GetTable(SlaveContact);
                            IsDifferent := false;

                            // Loop: compare all fields
                            for i := 1 to MasterRef.FieldCount do begin
                                Field := MasterRef.FieldIndex(i);

                                // Condition: skip non-normal or primary key fields
                                if Field.Class <> FieldClass::Normal then
                                    continue;
                                if Field.Number in [1] then
                                    continue;

                                SlaveField := SlaveRef.Field(Field.Number);

                                // Validation: check difference
                                if SlaveField.Value <> Field.Value then begin
                                    IsDifferent := true;
                                    break; // exit loop if different
                                end;
                            end;

                            // Condition: only transfer fields if different
                            if IsDifferent then begin
                                IsSyncing := true;
                                SlaveContact.TransferFields(Rec, true);
                                SlaveContact."Contact Business Relation" := slavebusinessrelation;
                                SlaveContact."No." := Rec."No."; // restore PK
                                SlaveContact.Modify(true);
                                IsSyncing := false;
                            end;
                        end;
                    until SlaveCompany.Next() = 0; // Loop ends

            end else begin
                // Condition: handle non-master companies
                if ZynCompany.Get(Rec."Company Name") then begin
                    if (not ZynCompany.IsMaster) and (ZynCompany."Master Company Name" <> '') then
                        Error(CreateContacteInSlaveErr);
                end else begin
                    if not RunTrigger then
                        exit;
                    if Rec."Contact Business Relation" <> xRec."Contact Business Relation" then
                        exit;
                    Error(CreateContacteInSlaveErr);
                end;
            end;
        end;
    end;


    // ───────────────────────────────
    // Helper
    // ───────────────────────────────

    // Procedure: IsMasterCompany
    // Purpose: Returns true if current company is master
    local procedure IsMasterCompany(): Boolean
    var
        MyCompany: Record ZYN_Company;
    begin
        if MyCompany.Get(CompanyName()) then
            exit(MyCompany.IsMaster);
        exit(false);
    end;

//    [EventSubscriber(ObjectType::Table, Database::"Contact Business Relation", 'OnBeforeUpdateContactBusinessRelation', '', true, true)]
//     local procedure OnBeforeUpdateContactBusinessRelation(ContactBusinessRelation: Record "Contact Business Relation"; var IsHandled: Boolean)
//     var
//         SingleInstanceMgt: Codeunit "Single Instance Management";
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


    // ───────────────────────────────
    // Labels
    // ───────────────────────────────
    var
        CreateContacteInSlaveErr: Label 'Cannot create contacts in a slave company';
        ContactModifyingInSlaveErr: Label 'Cannot modify contacts in a slave company';
        DeleteContactInSlaveErr: Label 'Cannot delete contacts in a slave company';
        ContactDeletingInSlaveErr: Label 'Cannot delete contacts in a slave company';
        OpenSalesInvoiceError: Label 'Contact %1 cannot be deleted because it has open or released Sales Invoices in company %2.';
        OpenPurchaseInvoiceError: Label 'Contact %1 cannot be deleted because it has open or released Purchase Invoices in company %2.';
}
