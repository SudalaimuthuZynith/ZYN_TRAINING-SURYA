// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

table 50211 ZYN_Company
{
    Caption = 'Company';
    DataPerCompany = false;
    ReplicateData = false;

    fields
    {
        field(1; Name; Text[30])
        {
            Caption = 'Name';
            ToolTip = 'Please enter name of your company';
            trigger OnValidate()
            begin
                if xRec.Name <> '' then
                    Error(NameErr);
            end;
        }
        field(2; "Evaluation Company"; Boolean)
        {
            Caption = 'Evaluation Company';
            ToolTip = 'Please enter a Evaluation Company';
        }
        field(3; "Display Name"; Text[250])
        {
            Caption = 'Display Name';
            ToolTip = 'Please enter display name for your compnany';
        }
        field(8000; Id; Guid)
        {
            Caption = 'Id';
            ToolTip = 'Please enter valid Id';
        }
        field(8005; "Business Profile Id"; Text[250])
        {
            Caption = 'Business Profile Id';
            ToolTip = 'Please enter valid Business Profile Id';
        }
        field(4; "IsMaster"; Boolean)
        {
            Caption = 'IsMaster';
            ToolTip = 'Tell whether it is a master';

            trigger OnValidate()
            var
                MasterRec: Record ZYN_Company; // Replace MyTable with your actual table name
            begin
                if IsMaster then begin
                    MasterRec.SetRange(IsMaster, true);
                    if MasterRec.FindFirst() and (MasterRec.Name <> Rec.Name) then
                        Error(MasterExistsErr); // Only one master allowed
                end;
            end;
        }

        field(5; "Master Company Name"; Text[100])
        {
            Caption = 'Master Company Name';
            ToolTip = 'Please enter a master company name';
            TableRelation = ZYN_Company.Name WHERE(IsMaster = const(true));
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    var
        NameErr: Label 'Primary key field cannot be modified.';
        MasterExistsErr: Label 'Master company already exists';
}

