table 50197 ZYNAssetsList
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Asset type"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = ZYNAssetType.Name;
        }
        field(2; "Serial No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "procured date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Vendor name"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Available"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Asset type", "Serial No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    // trigger OnInsert()
    // var
    //     assettype: Record AssetsListTable;
    //     Lastid: Integer;
    // begin
    //     if "Serial No" = '' then begin
    //         if assettype.FindLast() then
    //             Evaluate(lastid, CopyStr(assettype."Serial No", 4))
    //         else
    //             lastid := 0;
    //         Lastid += 1;
    //         "Serial No" := 'SER' + PadStr(Format(lastid), 3, '0');
    //     end;
    // end;




    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}