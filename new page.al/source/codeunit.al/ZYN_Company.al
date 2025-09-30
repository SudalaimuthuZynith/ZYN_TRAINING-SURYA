codeunit 50223 ZYN_CompanySubscriber
{
    var
        UpdatingContacts: Boolean;

    [EventSubscriber(ObjectType::Table, Database::ZYN_Company, 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertCompanyRecord(var Rec: Record ZYN_Company)
    var
        Company: Record Company;
    begin
        if not Company.Get(Rec.Name) then begin
            Company.Init();
            Company.Name := Rec.Name;
            Company."Evaluation Company" := Rec."Evaluation Company";
            Company."Display Name" := Rec."Display Name";
            Company."Business Profile Id" := Rec."Business Profile Id";
            Company.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertZYNCompanyRecord(var Rec: Record Company)
    var
        ZYN_Company: Record ZYN_Company;
    begin
        if not ZYN_Company.Get(Rec.Name) then begin
            ZYN_Company.Init();
            ZYN_Company.Name := Rec.Name;
            ZYN_Company."Evaluation Company" := Rec."Evaluation Company";
            ZYN_Company."Display Name" := Rec."Display Name";
            ZYN_Company."Business Profile Id" := Rec."Business Profile Id";
            ZYN_Company.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::ZYN_Company, 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifyCompanyFromZYN(var Rec: Record ZYN_Company)
    var
        Company: Record Company;
    begin
        if not Company.Get(Rec.Name) then
            exit;

        Company."Evaluation Company" := Rec."Evaluation Company";
        Company."Display Name" := Rec."Display Name";
        Company."Business Profile Id" := Rec."Business Profile Id";
        Company.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifyZYNCompanyRecord(var Rec: Record Company)
    var
        MyCompany: Record ZYN_Company;
        Changed: Boolean;
    begin
        if MyCompany.Get(Rec.Name) then begin
            Changed := HasChanges(Rec, MyCompany);
            if Changed then begin
                MyCompany.TransferFields(Rec, false);
                MyCompany.Modify(false);
            end;
        end;
    end;

    local procedure HasChanges(SourceRec: Variant; TargetRec: Variant): Boolean
    var
        SourceRef: RecordRef;
        TargetRef: RecordRef;
        SourceField: FieldRef;
        TargetField: FieldRef;
        i: Integer;
    begin
        SourceRef.GetTable(SourceRec);
        TargetRef.GetTable(TargetRec);

        for i := 1 to SourceRef.FieldCount do begin
            SourceField := SourceRef.FieldIndex(i);
            if TargetRef.FieldExist(SourceField.Number) then begin
                TargetField := TargetRef.Field(SourceField.Number);
                if SourceField.Value <> TargetField.Value then
                    exit(true);
            end;
        end;
        exit(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::ZYN_Company, 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteCompanyRecord(var Rec: Record ZYN_Company)
    var
        Company: Record Company;
    begin
        if Company.Get(Rec.Name) then
            Company.Delete();
    end;

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteZynCompanyRecord(var Rec: Record Company)
    var
        ZYN_Company: Record ZYN_Company;
    begin
        if ZYN_Company.Get(Rec.Name) then
            ZYN_Company.Delete();
    end;

    // var
    //     IsContactSyncing: Boolean;

    // local procedure SyncMasterContact(ContactRec: Record Contact)
    // var
    //     CompanyRecord: Record Zyn_Company;
    //     SlaveCompany: Record Zyn_Company;
    //     ContactCopy: Record Contact;
    // begin
    //     if IsContactSyncing then
    //         exit;

    //     if not IsMasterCompany() then
    //         exit;

    //     IsContactSyncing := true;

    //     if not CompanyRecord.Get(COMPANYNAME) then begin
    //         IsContactSyncing := false;
    //         exit;
    //     end;

    //     SlaveCompany.SetRange(IsMaster, false);
    //     SlaveCompany.SetFilter("Master Company Name", '<>%1', '');

    //     if SlaveCompany.FindSet() then
    //         repeat

    //             ContactCopy.ChangeCompany(SlaveCompany.Name);

    //             if not ContactCopy.Get(ContactRec."No.") then begin
    //                 // Insert new contact in slave
    //                 ContactCopy := ContactRec;
    //                 ContactCopy.Insert(true);
    //             end else begin
    //                 // Update existing contact using TRANSFERFIELDS
    //                 ContactCopy.TRANSFERFIELDS(ContactRec, true);
    //                 ContactCopy.Modify(true);
    //             end;

    //         until SlaveCompany.Next() = 0;

    //     IsContactSyncing := false;
    // end;




    // local procedure IsMasterCompany(): Boolean
    // var
    //     CompanyRecord: Record Zyn_Company;
    // begin
    //     if not CompanyRecord.Get(COMPANYNAME) then
    //         exit(false);

    //     exit(CompanyRecord.IsMaster);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterInsertEvent', '', true, true)]
    // local procedure InsertContactRecord(var Rec: Record Contact)
    // // var
    // //     CurrentCompany: Record ZYN_Company;
    // //     DependentCompany: Record ZYN_Company;
    // //     TargetContact: Record Contact;
    // begin
    //     SyncMasterContact(Rec);
    //     //     if not CurrentCompany.Get(CompanyName()) then
    //     //         exit;

    //     //     if not CurrentCompany.IsMaster then
    //     //         exit;

    //     //     DependentCompany.Reset();
    //     //     DependentCompany.SetRange("Master Company Name", CurrentCompany.Name);

    //     //     if DependentCompany.FindSet() then
    //     //         repeat
    //     //             if DependentCompany."Master Company Name" <> '' then begin

    //     //                 TargetContact.ChangeCompany(DependentCompany.Name);

    //     //                 if not TargetContact.Get(Rec."No.") then begin
    //     //                     TargetContact.Init();
    //     //                     TargetContact.TransferFields(Rec);
    //     //                     TargetContact.Insert(true);
    //     //                 end;
    //     //             end;
    //     //         until DependentCompany.Next() = 0;
    // end;


    // [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterModifyEvent', '', true, true)]
    // local procedure ContactOnAfterModify(var Rec: Record Contact; var xRec: Record Contact; RunTrigger: Boolean)
    // var
    //     MasterCompany: Record ZYN_Company;
    //     SlaveCompany: Record ZYN_Company;
    //     SlaveContact: Record Contact;
    //     MasterRef: RecordRef;
    //     SlaveRef: RecordRef;
    //     Field: FieldRef;
    //     SlaveField: FieldRef;
    //     i: Integer;
    //     IsDifferent: Boolean;
    // begin
    //     if IsContactSyncing then
    //         exit;
    //     if MasterCompany.Get(COMPANYNAME) then begin
    //         if MasterCompany.IsMaster then begin
    //             SlaveCompany.Reset();
    //             SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
    //             if SlaveCompany.FindSet() then
    //                 repeat
    //                     SlaveContact.ChangeCompany(SlaveCompany.Name);
    //                     if SlaveContact.Get(Rec."No.") then begin
    //                         // Open RecordRefs
    //                         MasterRef.GetTable(Rec);
    //                         SlaveRef.GetTable(SlaveContact);
    //                         IsDifferent := false;
    //                         // Loop through all fields
    //                         for i := 1 to MasterRef.FieldCount do begin
    //                             Field := MasterRef.FieldIndex(i);
    //                             // Skip FlowFields or non-normal fields
    //                             if Field.Class <> FieldClass::Normal then
    //                                 continue;
    //                             // Skip primary key fields (like "No.")
    //                             if Field.Number in [1] then
    //                                 continue;
    //                             SlaveField := SlaveRef.Field(Field.Number);
    //                             if SlaveField.Value <> Field.Value then begin
    //                                 IsDifferent := true;
    //                                 break; // no need to check further
    //                             end;
    //                         end;
    //                         // Only transfer fields if there is a difference
    //                         if IsDifferent then begin
    //                             IsContactSyncing := true;
    //                             SlaveContact.TransferFields(Rec, false);
    //                             SlaveContact."No." := Rec."No."; // restore PK
    //                             SlaveContact.Modify(true);
    //                             IsContactSyncing := false;
    //                         end;
    //                     end;
    //                 until SlaveCompany.Next() = 0;
    //         end;
    //     end;
    // end;


    // // [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterInsertEvent', '', true, true)]
    // // local procedure InsertContactRecord(var Rec: Record Contact)
    // // var
    // //     CurrentCompany: Record ZYN_Company;
    // //     DependentCompany: Record ZYN_Company;
    // //     TargetContact: Record Contact;
    // // begin
    // //     // Guard against recursion
    // //     if UpdatingContacts then
    // //         exit;

    // //     UpdatingContacts := true;

    // //     if not CurrentCompany.Get(CompanyName()) then
    // //         exit;

    // //     if not CurrentCompany.IsMaster then
    // //         exit;

    // //     DependentCompany.Reset();
    // //     DependentCompany.SetRange("Master Company Name", CurrentCompany.Name);

    // //     if DependentCompany.FindSet() then
    // //         repeat
    // //             if DependentCompany."Master Company Name" <> '' then begin
    // //                 TargetContact.ChangeCompany(DependentCompany.Name);

    // //                 if not TargetContact.Get(Rec."No.") then begin
    // //                     TargetContact.Init();
    // //                     TargetContact.TransferFields(Rec);
    // //                     TargetContact.Insert(true);
    // //                 end;
    // //             end;
    // //         until DependentCompany.Next() = 0;

    // //     UpdatingContacts := false;
    // // end;


    // // [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterModifyEvent', '', true, true)]
    // // local procedure ModifyContactRecord(var Rec: Record Contact)
    // // var
    // //     CurrentCompany: Record ZYN_Company;
    // //     DependentCompany: Record ZYN_Company;
    // //     TargetContact: Record Contact;
    // // begin
    // //     // Guard against recursion
    // //     if UpdatingContacts then
    // //         exit;

    // //     UpdatingContacts := true;

    // //     if not CurrentCompany.Get(CompanyName()) then
    // //         exit;

    // //     if not CurrentCompany.IsMaster then
    // //         exit;

    // //     DependentCompany.Reset();
    // //     DependentCompany.SetRange("Master Company Name", CurrentCompany.Name);

    // //     if DependentCompany.FindSet() then
    // //         repeat
    // //             if (DependentCompany.Name <> CurrentCompany.Name) and (DependentCompany."Master Company Name" <> '') then begin
    // //                 TargetContact.ChangeCompany(DependentCompany.Name);

    // //                 if TargetContact.Get(Rec."No.") then begin
    // //                     if HasChanges(Rec, TargetContact) then begin
    // //                         TargetContact.TransferFields(Rec, false);
    // //                         TargetContact.Modify(false);
    // //                     end;
    // //                 end else begin
    // //                     TargetContact.Init();
    // //                     TargetContact.TransferFields(Rec);
    // //                     TargetContact.Insert(true);
    // //                 end;
    // //             end;

    // //         until DependentCompany.Next() = 0;

    // //     UpdatingContacts := false;
    // //end;


    // // var
    // // InsertingFromMaster: Boolean;
    // // ModifyingFromMaster: Boolean;


    // // [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterInsertEvent', '', true, true)]
    // // local procedure InsertContactRecord(var Rec: Record Contact)
    // // var
    // // CurrentCompany: Record ZYN_Company;
    // // DependentCompany: Record ZYN_Company;
    // // TargetContact: Record Contact;
    // // begin
    // // if not CurrentCompany.Get(CompanyName()) then
    // // exit;
    // // if not CurrentCompany.IsMaster then
    // // exit;
    // // DependentCompany.Reset();
    // // DependentCompany.SetRange("Master Company Name", CurrentCompany.Name);
    // // if DependentCompany.FindSet() then
    // // repeat
    // // if DependentCompany."Master Company Name" <> '' then begin
    // // TargetContact.ChangeCompany(DependentCompany.Name);
    // // if not TargetContact.Get(Rec."No.") then begin
    // // TargetContact.Init();
    // // TargetContact.TransferFields(Rec);
    // // TargetContact.Insert(true);
    // // end;
    // // end;
    // // until DependentCompany.Next() = 0;
    // // end;

    // //     [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterModifyEvent', '', true, true)]
    // //     local procedure ContactOnAfterModify(var Rec: Record Contact; RunTrigger: Boolean)
    // //     var
    // //         SlaveCompany: Record ZYN_Company;
    // //         IsSync:Boolean;
    // //     begin
    // //         if IsSync then exit;
    // //         if not IsMasterCompany() then exit;

    // //         IsSync := true; // Prevent recursion

    // //         SlaveCompany.Reset();
    // //         SlaveCompany.SetRange("Master Company Name", CompanyName());
    // //         if SlaveCompany.FindSet() then
    // //             repeat
    // //                 UpdateContactInSlaveCompany(Rec, SlaveCompany.Name);
    // //             until SlaveCompany.Next() = 0;

    // //         IsSync := false; // Release replication lock
    // //     end;


    // //    local procedure UpdateContactInSlaveCompany(SourceContact: Record Contact; TargetCompany: Text)
    // //     var
    // //         ContactSlave: Record Contact;
    // //     begin
    // //         ContactSlave.ChangeCompany(TargetCompany);
    // //         if ContactSlave.Get(SourceContact."No.") then
    // //             ContactSlave.Delete(true); // Delete existing contact to avoid recursion

    // //         // Insert updated contact
    // //         ContactSlave.Init();
    // //         ContactSlave.TransferFields(SourceContact, true);
    // //         ContactSlave.Insert(true);


    // //     end;

    // // local procedure HasChangesVariant(SourceRec: Variant; TargetRec: Variant): Boolean
    // // var
    // // SourceRef: RecordRef;
    // // TargetRef: RecordRef;
    // // SourceField: FieldRef;
    // // TargetField: FieldRef;
    // // i: Integer;
    // // begin
    // // SourceRef.GetTable(SourceRec);
    // // TargetRef.GetTable(TargetRec);

    // // for i := 1 to SourceRef.FieldCount do begin
    // // SourceField := SourceRef.FieldIndex(i);

    // // Skip system fields by name
    // // if (SourceField.Name = 'Timestamp') or
    // //    (SourceField.Name = 'Created Date') or
    // //    (SourceField.Name = 'Last Modified') then
    // // continue;

    // // if not TargetRef.FieldExist(SourceField.Number) then
    // // continue;

    // // TargetField := TargetRef.Field(SourceField.Number);

    // // case SourceField.Type of
    // // FieldType::Boolean,
    // // FieldType::Integer,
    // // FieldType::BigInteger,
    // // FieldType::Decimal,
    // // FieldType::Text,
    // // FieldType::Code,
    // // FieldType::Option,
    // // FieldType::Date,
    // // FieldType::Time,
    // // FieldType::DateTime:
    // // if SourceField.Value <> TargetField.Value then
    // // exit(true);
    // // end;
    // // end;

    // // exit(false);
    // // end;


}










