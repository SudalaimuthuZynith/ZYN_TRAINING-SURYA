codeunit 50291 "Subscription"
{
    Subtype = Normal;

    trigger OnRun()
    var
        Sub: Record PlanSubscriptionTable;
        Plan: Record PlanTable;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NextDate: Date;
    begin
        Sub.SetRange("Next Billing Date", WorkDate());

        if Sub.FindSet() then
            repeat
                Plan.Get(Sub."Plan ID");

                SalesHeader.Init();
                SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
                SalesHeader.Validate("Sell-to Customer No.", Sub."Customer ID");
                SalesHeader.Validate("Document Date", WorkDate());
                SalesHeader.Insert(true);

                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice);
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", 'SUB001');
                SalesLine.Description := 'Subscription Fee for Plan ' + Sub."Plan ID";
                SalesLine.Validate(Quantity, 1);
                SalesLine.Validate("Unit Price", Plan.Fee);
                SalesLine.Insert(true);

                // Calculate next billing date
                NextDate := CalcDate('<+1M>', Sub."Next Billing Date");

                if (Sub."End Date" <> 0D) and (NextDate > Sub."End Date") then
                    Sub.substatus := Sub.substatus::Expired
                else
                    Sub."Next Billing Date" := NextDate;
                SalesHeader."From Subscription" := true;
                Sub.Modify(true);
            until Sub.Next() = 0;
    end;
}
