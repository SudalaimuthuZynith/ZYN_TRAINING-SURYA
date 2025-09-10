codeunit 50291 "ZYN_Subscription"
{
    Subtype = Normal;

    trigger OnRun()
    var
        Sub: Record ZYN_PlanSubscriptionTable;
        Plan: Record ZYN_PlanTable;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NextDate: Date;
        //NoSeriesMgt: Codeunit NoSeriesManagement;

        NoSeriesMgt: Codeunit "No. Series";
        NoSeriesCode: Code[20];
    begin
        Sub.SetRange("Next Billing Date", WorkDate());

        if Sub.FindSet() then
            repeat
                Plan.Get(Sub."Plan ID");
                NoSeriesCode := 'SUBINV';

                SalesHeader.Init();
                SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
                SalesHeader."No." := NoSeriesMgt.GetNextNo(NoSeriesCode, WorkDate(), true);
                SalesHeader.Validate("Sell-to Customer No.", Sub."Customer ID");
                SalesHeader.Validate("Document Date", WorkDate());
                SalesHeader."From Subscription" := true;
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

                NextDate := CalcDate('<+1M>', Sub."Next Billing Date");
                if (Sub."End Date" <> 0D) and (NextDate > Sub."End Date") then
                    Sub.substatus := Sub.substatus::Expired
                else
                    Sub."Next Billing Date" := NextDate;
                Sub.Modify(true);
            until Sub.Next() = 0;
    end;

}


