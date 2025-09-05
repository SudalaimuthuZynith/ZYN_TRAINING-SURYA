table 50198 PlanSubscriptionTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Subscription ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer ID"; Code[20])

        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger OnValidate()
            begin
                CreateInvoiceAutomatically();
            end;
        }
        field(3; "Plan ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = PlanTable."Plan ID";
            trigger OnValidate()
            begin
                CreateInvoiceAutomatically();
            end;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Rec."Start Date" <> 0D then begin

                    Rec."Next Billing Date" := CalcDate('<+1M>', Rec."Start Date");


                end;
            end;
        }
        field(5; Duration; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Rec.Duration > 0 then
                    Rec."End Date" := CalcDate('<+' + Format(Rec.Duration) + 'M>', Rec."Start Date")
                else
                    Rec."End Date" := Rec."Start Date";


                if Rec."Start Date" <> 0D then
                    Rec."Next Billing Date" := CalcDate('<+1M>', Rec."Start Date");
            end;
        }

        field(6; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Next Billing Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; substatus; Enum subscriptionstatus)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Invoice Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Subscription ID")
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


    procedure CreateInvoiceAutomatically()
    var
        Plan: Record PlanTable;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        
    begin
        if "Invoice Created" then
            exit;

        if "Customer ID" = '' then
            exit;

        if "Plan ID" = '' then
            exit;
        Plan.Get("Plan ID");


        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.Validate("Sell-to Customer No.", "Customer ID");
        

        SalesHeader.Validate("Document Date", WorkDate());
        SalesHeader.Insert(true);


        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice);
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", 'SUB001');
        SalesLine.Description := 'Subscription Fee for Plan ' + "Plan ID";
        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", Plan.Fee);

        SalesLine.Insert(true);

        "Invoice Created" := true;

        SalesHeader."From Subscription" := true;
        SalesHeader.Modify(true);
    end;

}
enum 50190 subscriptionstatus
{
    value(1; Active) { }
    value(2; InActive) { }
    value(3; Expired) { }
}