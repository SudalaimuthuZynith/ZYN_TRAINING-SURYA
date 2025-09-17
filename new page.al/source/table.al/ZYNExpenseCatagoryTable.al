table 50257 ZYNExpenseCatagoryTable
{
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1;Code; Code[20])
        {
            DataClassification = ToBeClassified;  
        }
        field(2;Catagory;Text[20])
        {
            DataClassification=ToBeClassified;
        }
        field(3;Name;Text[20])
        {
            DataClassification=ToBeClassified;
        }
        field(4;Amount;Decimal)
        {
            DataClassification=ToBeClassified;
        }
    }
    
    keys
    {
        key(Key1;Code,Catagory,Name)
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
    
    trigger OnInsert()
    begin
        
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