codeunit 50208 "Zyn_SendFromMasterToSlaveMgt"
{
    var
        IsSync: Boolean;

    procedure MirrorCustomerToSlave(CustomerNo: Code[20]; SlaveCompany: Text[30])
    var
        MasterCustomer: Record Customer;
        SlaveCustomer: Record Customer;
        DummyRecord: Record Customer;
        MasterContact: Record Contact;
        MasterCompany: Text[30];
        MasterContactRelation: Record "Contact Business Relation";
        SlaveContactRelation: Record "Contact Business Relation";
        SlaveContact: Record Contact;
    begin
        if IsSync or (SlaveCompany = CompanyName()) then
            exit;
        MasterCompany := CompanyName();
        IsSync := true;
        if not MasterCustomer.Get(CustomerNo) then begin
            IsSync := false;
            Error('Customer %1 not found in Master.', CustomerNo);
        end;
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




        // replicate Contact Business Relation rows
        MasterContactRelation.SetRange("No.", MasterCustomer."No.");
        if MasterContactRelation.FindSet() then begin
            repeat
                SlaveContact.ChangeCompany(SlaveCompany);
                if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
                    SlaveContactRelation.ChangeCompany(SlaveCompany);
                    // check with Contact No. + Link to Table + No.
                    SlaveContactRelation.Reset();
                    SlaveContactRelation.SetRange("Contact No.", SlaveContact."No.");
                    SlaveContactRelation.SetRange("Link to Table", MasterContactRelation."Link to Table"::Customer);
                    SlaveContactRelation.SetRange("No.", MasterCustomer."No.");

                    if not SlaveContactRelation.FindFirst() then begin
                        SlaveContactRelation.Init();
                        SlaveContactRelation."Contact No." := SlaveContact."No.";
                        SlaveContactRelation."Link to Table" := MasterContactRelation."Link to Table"::Customer;
                        SlaveContactRelation."No." := MasterCustomer."No.";
                        SlaveContactRelation."Business Relation Code" := MasterContactRelation."Business Relation Code";
                        SlaveContactRelation."Business Relation Description" := MasterContactRelation."Business Relation Description";
                        SlaveContactRelation.Insert(false);
                    end;
                end else
                    Message('Contact %1 not found in slave company %2. Relation for Customer %3 skipped.',
                        MasterContactRelation."Contact No.", SlaveCompany, MasterCustomer."No.");
            until MasterContactRelation.Next() = 0;
        end;
        if CompanyName() <> MasterCompany then
            DummyRecord.ChangeCompany(MasterCompany);
        IsSync := false;
    end;

    procedure MirrorVendorToSlave(VendorNo: Code[20]; SlaveCompany: Text[30])
    var
        MasterVendor: Record Vendor;
        SlaveVendor: Record Vendor;
        DummyRecord: Record Customer;
        MasterCompany: Text[30];
        MasterContactRelation: Record "Contact Business Relation";
        SlaveContactRelation: Record "Contact Business Relation";
        SlaveContact: Record Contact;
    begin
        if IsSync or (SlaveCompany = CompanyName()) then
            exit;
        MasterCompany := CompanyName();
        IsSync := true;
        if not MasterVendor.Get(VendorNo) then begin
            IsSync := false;
            Error('Vendor %1 not found in Master.', VendorNo);
        end;
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

        // replicate Contact Business Relation rows
        MasterContactRelation.SetRange("No.", MasterVendor."No.");
        if MasterContactRelation.FindSet() then begin
            repeat
                SlaveContact.ChangeCompany(SlaveCompany);
                if SlaveContact.Get(MasterContactRelation."Contact No.") then begin
                    SlaveContactRelation.ChangeCompany(SlaveCompany);
                    // check with Contact No. + Link to Table + No.
                    SlaveContactRelation.Reset();
                    SlaveContactRelation.SetRange("Contact No.", SlaveContact."No.");
                    SlaveContactRelation.SetRange("Link to Table", MasterContactRelation."Link to Table"::Vendor);
                    SlaveContactRelation.SetRange("No.", MasterVendor."No.");
                    if not SlaveContactRelation.FindFirst() then begin
                        SlaveContactRelation.Init();
                        SlaveContactRelation."Contact No." := SlaveContact."No.";
                        SlaveContactRelation."Link to Table" := MasterContactRelation."Link to Table"::Vendor;
                        SlaveContactRelation."No." := MasterVendor."No.";
                        SlaveContactRelation."Business Relation Code" := MasterContactRelation."Business Relation Code";
                        SlaveContactRelation."Business Relation Description" := MasterContactRelation."Business Relation Description";
                        SlaveContactRelation.Insert(false);
                    end;
                end else
                    Message('Contact %1 not found in slave company %2. Relation for Vendor %3 skipped.',
                        MasterContactRelation."Contact No.", SlaveCompany, MasterVendor."No.");
            until MasterContactRelation.Next() = 0;
        end;

        if CompanyName() <> MasterCompany then
            DummyRecord.ChangeCompany(MasterCompany);
        IsSync := false;
    end;

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
            // Skip system fields and primary keys (adjust if needed)
            if MasterField.Class <> FieldClass::Normal then
                continue;
            if MasterField.Number in [1, 2, 3] then  // No., SystemId, etc.
                continue;
            SlaveField := SlaveRef.Field(MasterField.Number);
            if MasterField.Value <> SlaveField.Value then
                exit(false);
        end;
        exit(true);
    end;
}


