table 50187 AssetTypeTable
{
    DataClassification = ToBeClassified;
    
    fields
    {
        field(10;"catagory id";Code[20])
        {
            DataClassification=ToBeClassified;
        }
        field(1;"Catagory";Enum "asset catagory" )
        {
            DataClassification = ToBeClassified; 
        }
        field(2;"Name";Text[30])
        {
            DataClassification=ToBeClassified;
        }
        
    }
    
    keys
    {
        key(Key1; "catagory id",Name)
        {
            Clustered = true;
        }
    }
    
    fieldgroups
    {
        fieldgroup(name;Name){}
    }
    
    var
        myInt: Integer;
    
    trigger OnInsert()
   var
        assettype: Record AssetTypeTable;
        Lastid: Integer;
    begin
        if "catagory id" = '' then begin
            if assettype.FindLast() then
                Evaluate(lastid, CopyStr(assettype."catagory id", 4))
            else
                lastid := 0;
            Lastid += 1;
            "catagory id" := 'CAT' + PadStr(Format(lastid), 3, '0');
        end;
    end;
    
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
enum 50189 "asset catagory"
{
    value(1;Infrastructure){}
    value(2;Electronics){}
    value(3;Documents){}
}